import '../../../../repository/geo_repository.dart';
import '../../../components/loading.dart';
import '../write_address_page.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../providers/search_state_provider.dart';
import '../providers/searches_provider.dart';
import '../providers/write_address_view_model_provider.dart';

class SearchView extends ConsumerWidget {
  final bool fromSelector;
  final bool home;
  SearchView({this.fromSelector = false,this.home = false});
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final searches = ref.watch(searchViewModelProvider);
    final addressModel = ref.read(writeAddressViewModelProvider);
    final searchState = ref.read(searchStateProvider.state);
    final repo = ref.read(geoReposioryProvider);
    return WillPopScope(
      onWillPop: () async => searchState.state = false,
      child: Material(
        color: theme.cardColor,
        child: ListView(
          padding: EdgeInsets.all(8),
          children: <Widget>[
                SizedBox(height: 56)
              ] +
              (searches.loading
                  ? [
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Loading(),
                      )
                    ]
                  : searches.results
                      .map(
                        (e) => Column(
                          children: [
                            Divider(),
                            ListTile(
                              onTap: () async {
                                addressModel.address =
                                    await repo.getAddressById(e.id);
                                searchState.state = false;
                                if (fromSelector) {
                                  if(home){
                                    addressModel.homeAddressExists = true;
                                  }
                                 await Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => WriteAddressPage(
                                          fromSelector: fromSelector),
                                    ),
                                  );
                                  addressModel.clear();
                                }
                              },
                              title: Text(e.title),
                              subtitle: Text(e.subtitle),
                            ),
                          ],
                        ),
                      )
                      .toList()),
        ),
      ),
    );
  }
}
