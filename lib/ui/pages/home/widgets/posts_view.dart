import 'package:bind_app/model/post/post.dart';
import 'package:bind_app/ui/pages/posts/widgets/feed_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

final postIndexProvider = StateProvider<int>((ref) => 0);

class PostsView extends HookConsumerWidget {
  const PostsView({Key? key, required this.posts}) : super(key: key);
  final List<Post> posts;
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final width = MediaQuery.of(context).size.width;
    final postWidth = width * (17 / 20) + 16;
    final postIndex = ref.watch(postIndexProvider.state);
    final controller = useScrollController();
    controller.addListener(() {
      postIndex.state = (controller.offset + postWidth / 2) ~/ postWidth;
    });
    return Column(
      children: [
        SingleChildScrollView(
          controller: controller,
          scrollDirection: Axis.horizontal,
          padding: EdgeInsets.symmetric(horizontal: 8),
          child: Row(
            children: posts
                .map(
                  (e) => SizedBox(
                    width: postWidth,
                    child: FeedCard(post: e),
                  ),
                )
                .toList(),
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(8),
          child: Center(
            child: Container(
              clipBehavior: Clip.antiAlias,
              height: 4,
              width: 80,
              decoration: ShapeDecoration(
                color: theme.dividerColor,
                shape: StadiumBorder(),
              ),
              child: Consumer(
                builder: (context, ref, child) {
                  final index = ref.watch(postIndexProvider.state);
                  return Stack(
                    children: [
                      Positioned(
                        right: 80 -
                            (80 / posts.length) -
                            ((80 / posts.length) * index.state),
                        top: 0,
                        bottom: 0,
                        left: (80 / posts.length) * index.state,
                        child: Container(
                          width: 80 / posts.length,
                          color: theme.primaryColor,
                        ),
                      ),
                    ],
                  );
                },
              ),
            ),
          ),
        ),
      ],
    );
  }
}
