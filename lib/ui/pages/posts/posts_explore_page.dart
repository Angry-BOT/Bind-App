import 'providers/posts_categories_provider.dart';

import '../../../model/post/post.dart';
import '../../components/my_appbar.dart';
import 'providers/further_posts_provider.dart';
import 'widgets/feed_card.dart';
import '../profile/bookmarks_page.dart';
import '../../../utils/labels.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

final selectedCategoryProvider = StateProvider<String>((ref) => Labels.all);

class PostsExplorePage extends ConsumerWidget {
  final List<Post> initial;

  PostsExplorePage({required this.initial});
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final categories = ref.watch(postCategoriesProvider).asData?.value ?? [];
    final furtherPosts = ref.watch(furtherPostsProvider).asData?.value ?? [];
    final selectedCategory = ref.watch(selectedCategoryProvider.state);
    final list = initial + furtherPosts;
    return Scaffold(
      appBar: MyAppBar(
        title: Text(Labels.feed),
        actions: [
          IconButton(
            onPressed: () => Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => BookmarksPage(),
              ),
            ),
            icon: Icon(Icons.bookmark_border_outlined),
          ),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: () async {
          ref.refresh(postCategoriesProvider);
          ref.refresh(furtherPostsProvider);
        },
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SingleChildScrollView(
              padding: EdgeInsets.symmetric(horizontal: 8),
              scrollDirection: Axis.horizontal,
              child: Row(
                children: ([Labels.all] + categories)
                    .map(
                      (e) => Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 8),
                        child: ChoiceChip(
                          selectedColor: theme.primaryColor,
                          labelStyle: TextStyle(),
                          label: Text(e),
                          selected: e == selectedCategory.state,
                          onSelected: (v) => selectedCategory.state = e,
                        ),
                      ),
                    )
                    .toList(),
              ),
            ),
            Divider(height: 0.5),
            Expanded(
              child: ListView(
                padding: EdgeInsets.all(8),
                children: list
                    .where((element) => selectedCategory.state == Labels.all
                        ? true
                        : element.category == selectedCategory.state)
                    .map(
                      (e) => Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: FeedCard(post: e),
                      ),
                    )
                    .toList(),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
