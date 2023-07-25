import '../../../../utils/assets.dart';
import '../../../../utils/labels.dart';
import 'package:flutter/material.dart';

class BuildAndBuyBanner extends StatelessWidget {
  const BuildAndBuyBanner({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final style = theme.textTheme;
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: 16,
        vertical: 8,
      ),
      child: AspectRatio(
        aspectRatio: 2,
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    Labels.buildAndBuyOnBIND,
                    style: style.titleLarge!.copyWith(
                      color: theme.primaryColor,
                    ),
                  ),
                  // Text(
                  //   Labels.termsAndConditions,
                  //   style: style.overline,
                  // ),
                ],
              ),
            ),
            Expanded(
              child: Image.asset(Assets.welcome),
            ),
          ],
        ),
      ),
    );
  }
}
