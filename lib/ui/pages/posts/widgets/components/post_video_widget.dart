import '../../../../../model/post/post_video.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';
import 'package:flutter/material.dart';

final playerProvider = Provider.family<YoutubePlayerController, String>(
  (ref, id) => YoutubePlayerController(
    initialVideoId: id,
    flags: YoutubePlayerFlags(
      autoPlay: false,
    ),
  ),
);

class PostVideoWidget extends ConsumerWidget {
  final PostVideo postVideo;

  const PostVideoWidget({Key? key, required this.postVideo}) : super(key: key);

  @override
  Widget build(BuildContext context,WidgetRef ref) {
    final controller = ref.read(playerProvider(postVideo.value));
    return Material(
      color: Theme.of(context).cardColor,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 16),
        child: YoutubePlayer(
          controller: controller,
        ),
      ),
    );
  }
}

typedef VideoBuilder<S> = Widget Function(Widget child);

class VideoPlayer extends ConsumerWidget {
  const VideoPlayer({Key? key, required this.builder, this.id})
      : super(key: key);
  final VideoBuilder builder;
  final String? id;
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    if (id == null) {
      return builder(SizedBox());
    } else {
      final controller = ref.read(playerProvider(id!));
      return YoutubePlayerBuilder(
        player: YoutubePlayer(controller: controller),
        builder: (context, player) => builder(player),
      );
    }
  }
}
