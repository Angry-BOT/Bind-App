import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

class ImageDialog extends StatelessWidget {
  final String url;

  const ImageDialog({Key? key, required this.url}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Dialog(
      child: Stack(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: AspectRatio(
              child: CachedNetworkImage(
                imageUrl: url,
                fit: BoxFit.cover,
              ),
              aspectRatio: 1,
            ),
          ),
          Positioned(
            child: CloseButton(),
            right: 0,
          ),
        ],
      ),
    );
  }
}
