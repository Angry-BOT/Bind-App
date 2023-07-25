import 'package:cached_network_image/cached_network_image.dart';

import '../providers/post_share_view_model_provider.dart';

import '../../../../model/post/post.dart';
import '../../../../repository/profile_repository.dart';
import '../post_page.dart';
import '../../profile/providers/profile_provider.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../../../utils/labels.dart';

class FeedCard extends ConsumerWidget {
  const FeedCard({Key? key, required this.post}) : super(key: key);
  final Post post;
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final style = theme.textTheme;
    final likes = ref.watch(profileProvider).value!.likes;
    final bookmarks = ref.watch(profileProvider).value!.bookmarks;
    final repo = ref.read(profileRepositoryProvider);
    final model = ref.watch(postShareViewModelProvider);

    return GestureDetector(
      onTap: () => Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => PostPage(post: post),
        ),
      ),
      child: Container(
        clipBehavior: Clip.antiAlias,
        margin: EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: theme.cardColor,
          borderRadius: BorderRadius.circular(20),
          
          boxShadow: [
            BoxShadow(
              color: theme.shadowColor,
              blurRadius: 8,
            ),
          ],
        ),
        child: Material(
          color: theme.cardColor,
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                SizedBox(
                  height: 16,
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(8, 8, 8, 0),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.baseline,
                    textBaseline: TextBaseline.alphabetic,
                    children: [
                      Expanded(
                        child: Text(
                          post.title + "\n",
                          style: style.titleSmall,
                          maxLines: 2,
                        ),
                      ),
                      SizedBox(width: 8),
                      Text(
                        post.dateLabel,
                        style: style.bodySmall,
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(8, 0, 8, 8),
                  child: Text(
                    post.content,
                    style: TextStyle(
                      color: style.bodySmall!.color,
                    ),
                    maxLines: 3,
                    overflow: TextOverflow.ellipsis,
                    textAlign: TextAlign.justify,
                  ),
                ),
                AspectRatio(
                  aspectRatio: 1,
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(8),
                      child: CachedNetworkImage(
                        imageUrl: post.image,
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  height: 32,
                  child: Row(
                    children: [
                      IconButton(
                        onPressed: () async {
                          if (likes.contains(post.id)) {
                            post.likes--;
                          } else {
                            post.likes++;
                          }
                          repo.toggleLike(id: post.id);
                        },
                        icon: Icon(
                          likes.contains(post.id)
                              ? Icons.favorite
                              : Icons.favorite_outline,
                          size: 20,
                        ),
                      ),
                      Text(
                        "${post.likes} ${Labels.likes}",
                        style: style.bodySmall,
                      ),
                      Spacer(),
                      IconButton(
                        onPressed: () {
                          model.share(post);
                        },
                        icon: Icon(
                          Icons.share_outlined,
                          size: 20,
                        ),
                      ),
                      IconButton(
                        onPressed: () {
                          repo.toggleBookmark(id: post.id);
                        },
                        icon: Icon(
                          bookmarks.contains(post.id)
                              ? Icons.bookmark_outlined
                              : Icons.bookmark_border,
                          size: 20,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
