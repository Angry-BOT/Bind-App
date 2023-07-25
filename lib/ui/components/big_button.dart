import 'package:flutter/material.dart';

import 'icons.dart';

class BigButton extends StatelessWidget {
  const BigButton({
    Key? key,
    required this.child,
    this.arrow = false,
    this.onPressed,
    this.bottomFlat = false,
    this.color
  }) : super(key: key);
  final Widget child;
  final bool arrow;
  final Function()? onPressed;
  final bool bottomFlat;
  final Color? color;
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return MaterialButton(
      color: color?? theme.primaryColor,
      onPressed: onPressed,
      disabledColor: theme.disabledColor,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          SizedBox(width: 18),
          child,
          arrow ? AppIcons.arrowForword : SizedBox(width: 18),
        ],
      ),
      padding: EdgeInsets.all(24),
      shape: RoundedRectangleBorder(
        borderRadius: bottomFlat
            ? BorderRadius.only(
                topLeft: Radius.circular(8),
                topRight: Radius.circular(8),
              )
            : BorderRadius.circular(8),
      ),
    );
  }
}
