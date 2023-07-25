import '../../../theme/app_colors.dart';
import '../../../../utils/assets.dart';
import 'package:flutter/material.dart';

class Credit extends StatelessWidget {
  const Credit({
    Key? key,
    required this.size,
  }) : super(key: key);
  final double size;
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: size,
      width: size,
      child: Material(
        shape: CircleBorder(),
        clipBehavior: Clip.antiAlias,
        elevation: 8,
        shadowColor: AppColors.grey,
        child: Image.asset(Assets.credits),
      ),
    );
  }
}
