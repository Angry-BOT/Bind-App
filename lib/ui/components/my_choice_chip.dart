import 'package:flutter/material.dart';

import '../theme/app_colors.dart';

class MyChoiceChip extends StatelessWidget {
  const MyChoiceChip(
      {Key? key,
      required this.lable,
      this.icon,
      required this.selected,
      required this.onSelected})
      : super(key: key);

  final Widget? icon;
  final String lable;
  final bool selected;
  final Function(String) onSelected;
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return ChoiceChip(
      backgroundColor: Colors.transparent,
      onSelected: (v) => onSelected(lable),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(6),
      ),
      avatar: icon,
      side: BorderSide(
        color: selected ? theme.primaryColor : AppColors.choiceChipBorderColor,
      ),
      label: Text(lable),
      selected: false,
    );
  }
}
