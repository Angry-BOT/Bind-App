import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import 'post_type.dart';

class PostImage {
  final String value;
  final double aspectRatio;
  final BoxFit fit;
  final Alignment alignment;

  PostImage({
    required this.value,
    required this.aspectRatio,
    required this.fit,
    required this.alignment,
  });

  PostImage copyWith({
    String? value,
    double? aspectRatio,
    BoxFit? fit,
    Alignment? alignment,
  }) {
    return PostImage(
      value: value ?? this.value,
      aspectRatio: aspectRatio ?? this.aspectRatio,
      fit: fit ?? this.fit,
      alignment: alignment ?? this.alignment,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'value': value,
      'aspectRatio': aspectRatio,
      'fit': describeEnum(fit),
      'alignment': describeEnum(alignment),
      'type': PostType.image,
    };
  }

  factory PostImage.fromMap(Map<String, dynamic> map) {
    return PostImage(
      value: map['value'],
      aspectRatio: map['aspectRatio'],
      fit: getBoxFit(map['fit']),
      alignment: getAlign(map['alignment']),
    );
  }

  factory PostImage.empty() => PostImage(
        value: '',
        aspectRatio: 1,
        fit: BoxFit.contain,
        alignment: Alignment.center,
      );
}

Alignment getAlign(String value) {
  switch (value) {
    case 'centerLeft':
      return Alignment.centerLeft;
    case 'centerRight':
      return Alignment.centerRight;
    default:
      return Alignment.center;
  }
}

BoxFit getBoxFit(String value) {
  switch (value) {
    case 'cover':
      return BoxFit.cover;
    case 'fitHeight':
      return BoxFit.fitHeight;
    case 'fitWidth':
      return BoxFit.fitWidth;
    default:
      return BoxFit.contain;
  }
}
