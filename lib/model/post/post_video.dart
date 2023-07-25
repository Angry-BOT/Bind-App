import 'post_type.dart';

class PostVideo {
  final String value;
  PostVideo({
    required this.value,
  });

  PostVideo copyWith({
    String? value,
  }) {
    return PostVideo(
      value: value ?? this.value,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'value': value,
      'type': PostType.video,
    };
  }

  factory PostVideo.fromMap(Map<String, dynamic> map) {
    return PostVideo(
      value: map['value'],
    );
  }

  factory PostVideo.empty() {
    return PostVideo(
      value: '',
    );
  }
}
