import 'package:cached_network_image/cached_network_image.dart';

import '../../../components/loading.dart';
import '../providers/categories_provider.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../sub_categories_page.dart';

class CategoriesGridView extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final categoriesAsync = ref.watch(categoriesProvider);
    return categoriesAsync.when(
      data: (categories) {
        categories.sort((a, b) => a.index.compareTo(b.index));
        return GridView.count(
          padding: EdgeInsets.symmetric(
            horizontal: 16,
            vertical: 8,
          ),
          shrinkWrap: true,
          physics: NeverScrollableScrollPhysics(),
          crossAxisCount: 4,
          children: categories
              .map(
                (e) => GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => SubcategoriesPage(category: e),
                      ),
                    );
                  },
                  child: Material(
                    color: theme.scaffoldBackgroundColor,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        SizedBox(
                          height: 32,
                          width: 32,
                          child: CachedNetworkImage(imageUrl: e.image),
                        ),
                        Text(
                          e.name,
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                  ),
                ),
              )
              .toList(),
        );
      },
      loading: () => Loading(),
      error: (e, s) => Text(
        e.toString(),
      ),
    );
  }
}
