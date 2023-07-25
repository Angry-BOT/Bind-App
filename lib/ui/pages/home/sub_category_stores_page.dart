import '../../../enums/survicableRadius.dart';
import '../../../model/subcategory.dart';
import '../../components/loading.dart';
import '../../components/my_appbar.dart';
import 'providers/near_by_stores_provider.dart';
import 'providers/sub_category_products_provider.dart';
import 'sub_category_search_page.dart';
import 'widgets/store_card.dart';
import '../../../utils/assets.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class SubCategoryStoresPage extends ConsumerWidget {
  final Subcategory subCategory;

  SubCategoryStoresPage(this.subCategory);
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final storesAsync = ref.watch(subCategoryStoresProvider(subCategory.id));
    final nearStores = ref
        .read(nearByStoresProvider).value!
        .where((element) =>
            element.subCategories.contains(subCategory.id) &&
            element.survicableRadius != SurvicableRadius.panIndia)
        .toList();
    return Scaffold(
      appBar: MyAppBar(
        underline: false,
        title: Text(subCategory.name),
        actions: [
          IconButton(
            onPressed: () {
              final stores = storesAsync.asData?.value ?? [];
              final list = stores +
                  nearStores.where((element) => element.canBeRec).toList();
              list.sort((a, b) => b.rating.compareTo(a.rating));
              final list2 = nearStores
                  .where((element) => element.canBeRec != true)
                  .toList();
              list2.sort((a, b) => b.rating.compareTo(a.rating));
              final list3 = list + list2;
              showSearch(context: context, delegate: SearchStorePage(list3));
            },
            icon: Icon(Icons.search),
          ),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: () async {
          ref.refresh(subCategoryStoresProvider(subCategory.id));
        },
        child: storesAsync.when(
          data: (stores) {
            final list = stores +
                nearStores.where((element) => element.canBeRec).toList();
            list.sort((a, b) => b.rating.compareTo(a.rating));
            final list2 = nearStores
                .where((element) => element.canBeRec != true)
                .toList();
            list2.sort((a, b) => b.rating.compareTo(a.rating));
            final list3 = list + list2;
            return list3.isEmpty
                ? ListView(
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(32),
                        child: Image.asset(Assets.noStores),
                      ),
                    ],
                  )
                : ListView(
                    padding: EdgeInsets.symmetric(vertical: 8),
                    children: list3
                        .map(
                          (e) => StoreCard(store: e),
                        )
                        .toList(),
                  );
          },
          loading: () => Loading(),
          error: (e, s) => Text(
            e.toString(),
          ),
        ),
      ),
    );
  }
}
