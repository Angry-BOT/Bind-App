
import 'package:flutter/material.dart';

import '../theme/app_colors.dart';

class AppInfoToolTip extends StatelessWidget {
  const AppInfoToolTip({
    Key? key,
    required this.message
  }) : super(key: key);

  
  final String message;

  @override
  Widget build(BuildContext context) {
        final theme = Theme.of(context);
    final style = theme.textTheme;
    return Padding(
      padding: const EdgeInsets.all(2),
      child: Tooltip(
        textStyle: style.bodyMedium,
        verticalOffset: 6,
        decoration: ShapeDecoration(
          color: AppColors.grey,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8)
          )
        ),
        child: Icon(
          Icons.info,
          size: 16,
          color: theme.primaryColor,
        ),
        message: message,
        triggerMode: TooltipTriggerMode.tap,
        showDuration: Duration(seconds: 30),
        margin: EdgeInsets.fromLTRB(32, 0, 32, 32),
        padding: EdgeInsets.all(16),
      ),
    );
  }
}

