import 'package:cached_network_image/cached_network_image.dart';

import '../../../../../model/post/post_image.dart';
import 'package:flutter/material.dart';

class PostImageWidget extends StatelessWidget {
  final PostImage image;

  const PostImageWidget({Key? key, required this.image}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Material(
      color: Theme.of(context).cardColor,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: AspectRatio(
          aspectRatio: image.aspectRatio,
          child: CachedNetworkImage(
        imageUrl:
            image.value,
            alignment: image.alignment,
            fit: image.fit,
          ),
        ),
      ),
    );
  }
}
