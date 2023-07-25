import 'package:bind_app/ui/theme/app_colors.dart';
import 'package:flutter/material.dart';



class StarsBackground extends StatelessWidget {
  const StarsBackground({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Stack(
        children: [
          Positioned(
            left: 16,
            top: 80,
            child: Icon(
              Icons.star,
              color: AppColors.primary,
              size: 26,
            ),
          ),
          Positioned(
            left: 100,
            top: 0,
            child: Icon(
              Icons.star,
              color: AppColors.primary,
              size: 18,
            ),
          ),
          Positioned(
            right: 100,
            top: 24,
            child: Icon(
              Icons.star,
              color: AppColors.primary,
              size: 18,
            ),
          ),
          Positioned(
            right: 16,
            top: 72,
            child: Icon(
              Icons.star,
              color: AppColors.primary,
              size: 16,
            ),
          ),
        ],
      );
  }
}
