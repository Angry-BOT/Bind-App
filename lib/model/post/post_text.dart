
import 'post_type.dart';

class PostText {
  final String value;
  final String type;

  PostText({
    required this.value,
    required this.type,
  });

  PostText copyWith({
    String? value,
    String? type,
  }) {
    return PostText(
      value: value ?? this.value,
      type: type ?? this.type,
    );
  }

  factory PostText.fromMap(Map<String, dynamic> map) {
    return PostText(value: map['value'], type: map['textType']);
  }

  Map<String, dynamic> toMap() => {
        'value': value,
        'textType': type,
        'type': PostType.text,
      };

  factory PostText.empty() => PostText(
        value: '',
        type: TextType.normal,
      );
}
