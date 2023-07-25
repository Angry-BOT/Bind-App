import 'package:flutter/material.dart';

class MyAppBar extends StatelessWidget implements PreferredSizeWidget {
  const MyAppBar({
    Key? key,
    this.title,
    this.leading,
    this.actions,
    this.underline = true,
    this.titleSpacing,
    this.topSpace = 0,
  }) : super(key: key);
  final Widget? title;
  final Widget? leading;
  final List<Widget>? actions;
  final bool underline;
  final double? titleSpacing;
  final double topSpace;
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding:  EdgeInsets.only(top: topSpace),
      child: AppBar(
        titleSpacing: titleSpacing,
        leading: leading,
        elevation: 0,
        title: title,
        actions: actions,
        bottom: underline
            ? PreferredSize(
                child: Divider(
                  height: 1,
                  thickness: 1,
                ),
                preferredSize: Size.fromHeight(1),
              )
            : null,
      ),
    );
  }

  @override
  Size get preferredSize =>
      Size.fromHeight((underline ? 57 : 56) + topSpace);
}
