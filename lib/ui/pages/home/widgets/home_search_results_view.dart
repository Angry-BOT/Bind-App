import 'package:bind_app/enums/survicableRadius.dart';
import 'package:bind_app/ui/pages/favorites/providers/store_provider.dart';
import 'package:bind_app/ui/pages/home/providers/home_search_view_model_provider.dart';
import 'package:bind_app/ui/pages/home/providers/near_by_stores_provider.dart';
import 'package:bind_app/ui/pages/home/widgets/store_card.dart';

import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class HomeSearchResultsView extends ConsumerWidget {
  const HomeSearchResultsView({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final style = theme.textTheme;
    final model = ref.watch(homeSearchViewModelProvider);
    final stores = ref.read(nearByStoresProvider).value!;
    return Column(children: <Widget>[
      SizedBox(
        height: 56 + 16,
      ),
      model.loading
          ? Center(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: CircularProgressIndicator(),
              ),
            )
          : model.debouncer.value.length > 2
              ? Column(
                  children: model.results
                          .map(
                            (e) => ref.watch(storeProvider(e.id)).when(
                                  data: (store) => StoreCard(
                                    store: store,
                                    match: model.debouncer.value,
                                  ),
                                  error: (e, s) => SizedBox(),
                                  loading: () => SizedBox(),
                                ),
                          )
                          .toList() +
                      stores
                          .where((element) =>
                              element.survicableRadius !=
                              SurvicableRadius.panIndia)
                          .where(
                            (element) => (element.name +
                                    element.username +
                                    element.products.toString())
                                .toLowerCase()
                                .contains(model.debouncer.value.toLowerCase()),
                          )
                          .map(
                            (e) => StoreCard(
                              store: e,
                              match: model.debouncer.value,
                            ),
                          )
                          .toList())
              : SizedBox(),
    ]);
  }
}
