import 'package:flutter/material.dart';

class GrayLabel extends StatelessWidget {
  const GrayLabel({
    Key? key,
    required this.label,
  }) : super(key: key);
  final String label;
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    // final style = theme.textTheme;
    return Material(
      shape: StadiumBorder(),
      color: theme.dividerColor,
      child: Padding(
        padding: const EdgeInsets.all(4),
        child: Text(
          label,
          style: TextStyle(
            fontSize: 8,
          ),
        ),
      ),
    );
  }
}