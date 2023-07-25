
import '../../../../../model/post/post_text.dart';
import '../../../../../model/post/post_type.dart';
import 'package:flutter/material.dart';


class PostTextWidget extends StatelessWidget {
  final PostText text;
  const PostTextWidget({Key? key, required this.text}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final style = theme.textTheme;
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Text(
        text.value,
        style: text.type == TextType.title
            ? style.titleSmall
            : TextStyle(
                color: text.type == TextType.subtitle
                    ? null
                    : style.bodySmall!.color,
              ),
      ),
    );
  }
}
