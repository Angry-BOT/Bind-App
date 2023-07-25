import '../providers/wallet_provider.dart';
import '../../../theme/app_colors.dart';
import '../../../../utils/assets.dart';
import '../../../../utils/labels.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../credits_page.dart';

class CreditsIcon extends ConsumerWidget {
  const CreditsIcon({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final style = theme.textTheme;
    final walletStream = ref.watch(walletProvider);
    return walletStream.when(
      data: (wallet) => GestureDetector(
        onTap: () {
          Navigator.push(
              context, MaterialPageRoute(builder: (context) => CreditsPage()));
        },
        child: Stack(
          alignment: Alignment.centerLeft,
          children: [
            Container(
              margin: EdgeInsets.all(12),
              decoration: ShapeDecoration(
                shape: StadiumBorder(),
                color: AppColors.lightOrange,
              ),
              child: Row(
                children: [
                  AspectRatio(aspectRatio: 1),
                  Padding(
                    padding: const EdgeInsets.only(left: 6, right: 10),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          "${wallet.credits}",
                          style: style.bodySmall!.copyWith(
                            fontSize: 10,
                          ),
                        ),
                        Text(
                          Labels.credits,
                          style: style.labelSmall!.copyWith(
                            fontSize: 6,
                          ),
                        ),
                      ],
                    ),
                  )
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(12),
              child: Material(
                elevation: 4,
                shadowColor: Colors.deepOrange,
                clipBehavior: Clip.antiAlias,
                shape: CircleBorder(),
                child: Image.asset(Assets.credits),
              ),
            ),
          ],
        ),
      ),
      loading: () => SizedBox(),
      error: (e, s) {
        return SizedBox();
      },
    );
  }
}
