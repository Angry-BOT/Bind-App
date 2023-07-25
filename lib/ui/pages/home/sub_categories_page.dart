import 'package:cached_network_image/cached_network_image.dart';

import '../../../model/category.dart';
import '../../components/loading.dart';
import '../../components/my_appbar.dart';
import 'providers/sub_categories_provider.dart';
import 'sub_category_stores_page.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class SubcategoriesPage extends ConsumerWidget {
  final StoreCategory category;

  const SubcategoriesPage({Key? key, required this.category}) : super(key: key);
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final subcategoriesAsync = ref.watch(subcategoriesProvider(category.id));
    return Scaffold(
      appBar: MyAppBar(
        title: Text(category.name),
      ),
      body: RefreshIndicator(
        onRefresh: () async {
          ref.refresh(subcategoriesProvider(category.id));
        },
        child: subcategoriesAsync.when(
          data: (subcategories) {
            subcategories.sort((a, b) => a.index.compareTo(b.index));
            return ListView(
              padding: EdgeInsets.all(8),
              children: subcategories
                  .map((e) => Column(
                        children: [
                          ListTile(
                            contentPadding: EdgeInsets.symmetric(
                                horizontal: 16, vertical: 8),
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) =>
                                      SubCategoryStoresPage(e),
                                ),
                              );
                            },
                            leading: SizedBox(
                              height: 48,
                              width: 48,
                              child: CachedNetworkImage(imageUrl: e.image),
                            ),
                            title: Text(e.name),
                          ),
                          Divider(
                            height: 0.5,
                          ),
                        ],
                      ))
                  .toList(),
            );
          },
          loading: () => Loading(),
          error: (e, s) => Center(
            child: Text(
              e.toString(),
            ),
          ),
        ),
      ),
    );
  }
}
