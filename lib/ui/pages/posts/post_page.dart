import 'package:cached_network_image/cached_network_image.dart';

import '../../components/progess_loader.dart';

import '../../../model/post/post.dart';
import '../../../model/post/post_image.dart';
import '../../../model/post/post_text.dart';
import '../../../model/post/post_video.dart';
import '../../../repository/profile_repository.dart';
import '../../components/my_appbar.dart';
import '../profile/providers/profile_provider.dart';
import '../../../utils/labels.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import 'providers/post_share_view_model_provider.dart';
import 'widgets/components/post_image_widget.dart';
import 'widgets/components/post_text_widget.dart';
import 'widgets/components/post_video_widget.dart';

class PostPage extends ConsumerWidget {
  final Post post;

  const PostPage({Key? key, required this.post}) : super(key: key);
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final style = theme.textTheme;
    final likes = ref.watch(profileProvider).value!.likes;
    final bookmarks = ref.watch(profileProvider).value!.bookmarks;
    final repo = ref.read(profileRepositoryProvider);
    final videos = post.components
        .where((element) => element is PostVideo)
        .map((e) => e as PostVideo);
    final model = ref.watch(postShareViewModelProvider);
    return ProgressLoader(
      isLoading: model.loading,
      child: VideoPlayer(
        id: videos.isNotEmpty ? videos.first.value : null,
        builder: (player) {
          final widgets = <Widget>[];
          for (var item in post.components) {
            if (item is PostText) {
              widgets.add(
                PostTextWidget(
                  text: item,
                ),
              );
            } else if (item is PostImage) {
              widgets.add(
                PostImageWidget(
                  image: item,
                ),
              );
            } else if (item is PostVideo) {
              widgets.add(
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: player,
                ),
              );
            }
          }

          return Scaffold(
            appBar: MyAppBar(
              title: Text(Labels.post),
            ),
            body: SingleChildScrollView(
              child: Container(
                margin:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
                clipBehavior: Clip.antiAlias,
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
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                            SizedBox(
                              height: 16,
                            ),
                            Padding(
                              padding: const EdgeInsets.all(4.0),
                              child: Row(
                                children: [
                                  Expanded(
                                    child: Padding(
                                      padding: const EdgeInsets.all(4.0),
                                      child: Text(
                                        post.title,
                                        style: style.titleSmall,
                                      ),
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.all(4.0),
                                    child: Text(
                                      post.dateLabel,
                                      style: style.bodySmall,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(8),
                                child: CachedNetworkImage(
                                  imageUrl: post.image,
                                  fit: BoxFit.cover,
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
                                  Expanded(child: SizedBox()),
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
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text(
                                post.content,
                                key: ValueKey('1'),
                                style: TextStyle(
                                  color: style.bodySmall!.color,
                                ),
                                textAlign: TextAlign.justify,
                              ),
                            ),
                          ] +
                          widgets,
                    ),
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
