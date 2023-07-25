import '../../components/icons.dart';
import '../../components/loading.dart';
import '../../components/my_appbar.dart';
import '../auth/providers/location_service_status_provider.dart';
import '../auth/providers/search_state_provider.dart';
import '../auth/providers/searches_provider.dart';
import '../auth/providers/write_address_view_model_provider.dart';
import '../auth/widgets/search_view.dart';
import '../auth/write_address_page.dart';
import '../home/providers/home_view_model_provider.dart';
import '../profile/providers/profile_provider.dart';
import '../../theme/app_colors.dart';
import '../../../utils/labels.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class SelectAddressPage extends ConsumerWidget {
  final bool fromHome;

  SelectAddressPage({this.fromHome = false});
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final style = theme.textTheme;
    final model = ref.watch(homeViewModelProvider);
    final locationStatusAsync = ref.watch(locationStatusProvider);
    final profile = ref.watch(profileProvider).value!;
    final searchState = ref.watch(searchStateProvider.state);

    return model.loading
        ? Scaffold(
            body: Loading(),
          )
        : Scaffold(
            appBar: MyAppBar(
              title: Text(Labels.deliveryAddress),
            ),
            body: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.all(24),
                      child: TextField(
                        onTap: () => searchState.state = true,
                        onChanged: (v) =>
                            ref.read(searchViewModelProvider).debouncer.value !=
                                    v
                                ? ref
                                    .read(searchViewModelProvider)
                                    .debouncer
                                    .value = v
                                : null,
                        decoration: InputDecoration(
                          hintText: Labels.searchForAreaCityOrStreet,
                        ),
                        onSubmitted: (v) {
                          if (v.isEmpty) {
                            searchState.state = false;
                          }
                        },
                      ),
                    )
                  ] +
                  (searchState.state
                      ? [
                          Expanded(
                            child: SearchView(
                              home: profile.homeAddressExist,
                              fromSelector: true,
                            ),
                          )
                        ]
                      : [
                          Expanded(
                              child: ListView(
                            children: [
                              locationStatusAsync.asData != null
                                  ? Material(
                                      color: locationStatusAsync.value!
                                          ? AppColors.green
                                          : theme.colorScheme.error,
                                      child: ListTile(
                                        onTap: () async {
                                          final model = ref.read(
                                              writeAddressViewModelProvider);
                                          model.homeAddressExists =
                                              profile.homeAddressExist;
                                          model.handleLocateMe(
                                              locationStatusAsync.value!);
                                          await Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                              builder: (context) =>
                                                  WriteAddressPage(
                                                      fromSelector: true),
                                            ),
                                          );
                                          model.clear();
                                        },
                                        contentPadding: EdgeInsets.symmetric(
                                            horizontal: 24),
                                        dense: true,
                                        title: Text(
                                          Labels.locateMe +
                                              (locationStatusAsync.value!
                                                  ? ""
                                                  : Labels
                                                      .turnOnLocationServices),
                                          style:
                                              TextStyle(color: theme.cardColor),
                                        ),
                                        trailing: IconButton(
                                          onPressed: () {},
                                          icon: ImageIcon(
                                              AppIcons.direction.image),
                                        ),
                                      ),
                                    )
                                  : SizedBox(),
                              Padding(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 24, vertical: 16),
                                child: Text(
                                  Labels.selectAddress,
                                  style: style.titleMedium,
                                ),
                              ),
                              Divider(height: 0.5),
                              Column(
                                children: profile.addresses.map((e) {
                                  final name = e.name == Labels.store &&
                                          profile.addresses
                                              .where((element) =>
                                                  element.name == Labels.home)
                                              .isEmpty
                                      ? Labels.home
                                      : e.name;
                                  return Column(
                                    children: [
                                      InkWell(
                                        onTap: () {
                                          model.address = e;
                                          if (fromHome) {
                                            Navigator.pop(context);
                                          }
                                        },
                                        child: Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Padding(
                                                padding:
                                                    const EdgeInsets.all(8.0),
                                                child: Row(
                                                  children: [
                                                    e.name == Labels.store ||
                                                            e.name ==
                                                                Labels.home
                                                        ? Icon(
                                                            name == Labels.store
                                                                ? Icons
                                                                    .storefront_outlined
                                                                : Icons
                                                                    .home_outlined,
                                                            size: 20,
                                                          )
                                                        : AppIcons.direction,
                                                    SizedBox(width: 8),
                                                    Text(name),
                                                  ],
                                                ),
                                              ),
                                              Padding(
                                                padding:
                                                    const EdgeInsets.all(8.0),
                                                child: Text(
                                                  e.customFormat,
                                                  maxLines: 2,
                                                  overflow:
                                                      TextOverflow.ellipsis,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                      Divider(height: 0.5),
                                    ],
                                  );
                                }).toList(),
                              )
                            ],
                          ))
                        ]),
            ),
          );
  }
}
