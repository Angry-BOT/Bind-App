
import 'providers/searches_provider.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../../utils/labels.dart';
import '../../components/big_button.dart';
import '../../components/icons.dart';
import '../../components/my_appbar.dart';
import '../../theme/app_colors.dart';
import 'providers/location_service_status_provider.dart';
import 'providers/search_state_provider.dart';
import 'providers/write_address_view_model_provider.dart';
import 'widgets/address_bottom_sheet.dart';
import 'widgets/search_view.dart';

class WriteAddressPage extends ConsumerWidget {
  final bool fromSelector;
  final bool forEdit;
  WriteAddressPage({this.fromSelector = false, this.forEdit = false});
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final style = theme.textTheme;
    final model = ref.watch(writeAddressViewModelProvider);
    final locationStatusAsync = ref.watch(locationStatusProvider);
    final searchState = ref.watch(searchStateProvider.state);

    return Scaffold(
      appBar: MyAppBar(
        underline: false,
        title: Text(model.needStoreAddress
            ? Labels.addStoreAddress
            : Labels.addYourHomeAddress),
        leading: model.needStoreAddress ? BackButton() : null,
      ),
      backgroundColor: theme.colorScheme.background,
      body: Stack(
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: GoogleMap(
                  onMapCreated: (controller) =>
                      model.mapController = controller,
                  initialCameraPosition: CameraPosition(
                    target: model.latLng,
                    zoom: 14,
                  ),
                  markers: model.markers,
                  onTap: (point) => model.markerPosition = point,
                ),
              ),
              locationStatusAsync.asData != null
                  ? Material(
                      color: locationStatusAsync.value!
                          ? AppColors.green
                          : theme.colorScheme.error,
                      child: ListTile(
                        onTap: () =>
                            model.handleLocateMe(locationStatusAsync.value!),
                        contentPadding: EdgeInsets.symmetric(horizontal: 24),
                        dense: true,
                        title: Text(
                          Labels.locateMe +
                              (locationStatusAsync.value!
                                  ? ""
                                  : Labels.turnOnLocationServices),
                          style: TextStyle(color: theme.cardColor),
                        ),
                        trailing: IconButton(
                          onPressed: () {},
                          icon: ImageIcon(AppIcons.direction.image),
                        ),
                      ),
                    )
                  : SizedBox(),
              Padding(
                padding: EdgeInsets.fromLTRB(24, 24, 24, 48.0),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      model.address?.location ?? '',
                      style: style.titleMedium,
                    ),
                    SizedBox(height: 8),
                    Text(
                      model.address?.formated ?? '',
                      style: style.bodySmall!
                          .copyWith(color: style.bodyLarge!.color),
                    ),
                    SizedBox(height: 24),
                    BigButton(
                      child: Text(Labels.continueButton),
                      onPressed: model.address != null
                          ? () async {
                              await showModalBottomSheet(
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.only(
                                    topLeft: Radius.circular(16),
                                    topRight: Radius.circular(16),
                                  ),
                                ),
                                context: context,
                                isScrollControlled: true,
                                builder: (context) => AddressBottomSheet(
                                    fromSelector: fromSelector,
                                    forEdit: forEdit),
                              );
                              if (fromSelector || forEdit) {
                                Navigator.pop(context);
                              }
                            }
                          : null,
                    ),
                  ],
                ),
              )
            ],
          ),
          searchState.state ? SearchView() : SizedBox(),
          Padding(
            padding: EdgeInsets.symmetric(
              vertical: 4,
              horizontal: 20,
            ),
            child: Card(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
              child: TextField(
                onTap: () => searchState.state = true,
                onChanged: (v) =>
                    ref.read(searchViewModelProvider).debouncer.value != v
                        ? ref.read(searchViewModelProvider).debouncer.value = v
                        : null,
                decoration: InputDecoration(
                  border: searchState.state ? null : InputBorder.none,
                  hintText: Labels.searchForAreaCityOrStreet,
                ),
                onSubmitted: (v) {
                  if (v.isEmpty) {
                    searchState.state = false;
                  }
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}
