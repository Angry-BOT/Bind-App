import 'package:flutter/material.dart';

import '../theme/app_colors.dart';

class SmallGrayButton extends StatelessWidget {
  final VoidCallback? onPressed;
  final String lable;

  const SmallGrayButton({Key? key, this.onPressed, required this.lable}) : super(key: key);
  @override
  Widget build(BuildContext context) {
        final theme = Theme.of(context);
    final style = theme.textTheme;
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Material(
        borderRadius: BorderRadius.circular(4),
        clipBehavior: Clip.antiAlias,
        color: AppColors.lightGrayButtonColor,
        child: InkWell(
          onTap:onPressed,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  lable,
                  style: style.bodySmall,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
