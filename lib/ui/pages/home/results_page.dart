import '../../../enums/survicableRadius.dart';
import '../../../model/search_key.dart';
import '../../components/loading.dart';
import '../../components/my_appbar.dart';
import 'providers/home_search_results_providers.dart';
import 'providers/near_by_stores_provider.dart';
import 'widgets/store_card.dart';
import '../store/store_page.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class StoreResultsRoot extends StatelessWidget {
  final SearchKey searchKey;

  const StoreResultsRoot({Key? key, required this.searchKey}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return searchKey.type == KeyType.Store
        ? _StoreResultsPage(searchKey: searchKey.key)
        : _StoreResultsByPruductNamePage(searchKey: searchKey.key);
  }
}

class _StoreResultsPage extends ConsumerWidget {
  final String searchKey;

  const _StoreResultsPage({Key? key, required this.searchKey})
      : super(key: key);
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final storesAsync = ref.watch(storeSearchResultsProvider(searchKey));
    return storesAsync.when(
      data: (panStores) {
        final localStores = ref
            .read(nearByStoresProvider).value!
            .where((element) =>
                element.survicableRadius != SurvicableRadius.panIndia)
            .where((element) => element.name == searchKey)
            .toList();
        final stores = panStores + localStores;
        if (stores.length == 1) {
          return StorePage(store: stores.first);
        } else {
          return Scaffold(
            appBar: MyAppBar(
              title: Text(searchKey),
            ),
            body: ListView(
              padding: EdgeInsets.symmetric(
                vertical: 8,
              ),
              children: stores.map((e) => StoreCard(store: e)).toList(),
            ),
          );
        }
      },
      loading: () => Scaffold(
        body: Loading(),
      ),
      error: (e, s) {
        print(e);
        return Scaffold(
          body: Text(e.toString()),
        );
      },
    );
  }
}

class _StoreResultsByPruductNamePage extends ConsumerWidget {
  final String searchKey;

  const _StoreResultsByPruductNamePage({Key? key, required this.searchKey})
      : super(key: key);
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final storesAsync =
        ref.watch(storeSearchResultsByProductNameProvider(searchKey));
    return storesAsync.when(
      data: (panStores) {
        final localStores = ref
            .read(nearByStoresProvider).value!
            .where((element) =>
                element.survicableRadius != SurvicableRadius.panIndia)
            .where((element) => element.products.contains(searchKey))
            .toList();
        final stores = panStores + localStores;
        final list1 = stores.where((element) => element.canBeRec).toList();
        final list2 =
            stores.where((element) => element.canBeRec != true).toList();
        list1.sort((a, b) => a.rating.compareTo(b.rating));
        list2.sort((a, b) => a.rating.compareTo(b.rating));
        final list3 = list1 + list2;
        return Scaffold(
          appBar: MyAppBar(
            title: Text(searchKey),
          ),
          body: ListView(
            padding: EdgeInsets.symmetric(
              vertical: 8,
            ),
            children: list3.map((e) => StoreCard(store: e)).toList(),
          ),
        );
      },
      loading: () => Scaffold(
        body: Loading(),
      ),
      error: (e, s) {
        print(e);
        return Scaffold(
          body: Text(e.toString()),
        );
      },
    );
  }
}
