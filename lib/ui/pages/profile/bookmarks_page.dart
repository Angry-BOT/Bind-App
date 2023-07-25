import '../../components/my_appbar.dart';
import '../posts/widgets/feed_card.dart';
import '../posts/providers/post_provider.dart';
import '../../../utils/labels.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import 'providers/profile_provider.dart';

class BookmarksPage extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final bookmarks = ref.watch(profileProvider).value!.bookmarks;
    return Scaffold(
      appBar: MyAppBar(
        title: Text(Labels.bookmarks),
      ),
      body: ListView(
        padding: EdgeInsets.all(8),
        children: bookmarks
            .map(
              (e) => ref.watch(postProvider(e)).when(
                    data: (post) => Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: AspectRatio(
                        aspectRatio: 0.9,
                        child: FeedCard(post: post),
                      ),
                    ),
                    loading: () => SizedBox(),
                    error: (e, s) => SizedBox(),
                  ),
            )
            .toList(),
      ),
    );
  }
}
