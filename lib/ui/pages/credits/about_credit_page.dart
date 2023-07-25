import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../components/my_appbar.dart';
import '../../theme/app_colors.dart';
import '../../../utils/assets.dart';
import '../../../utils/labels.dart';
import 'package:flutter/material.dart';

import 'providers/master_data_provider.dart';

class AboutCreditPage extends ConsumerWidget {
  const AboutCreditPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final style = theme.textTheme;
    final masterdata = ref.watch(masterDataProvider);

    return Scaffold(
      appBar: MyAppBar(
        title: Text(Labels.aboutBindCredits),
      ),
      body: ListView(
        padding: EdgeInsets.all(24),
        children: [
          AspectRatio(
            aspectRatio: 3 / 2,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                SizedBox(
                  height: 100,
                  width: 100,
                  child: Material(
                    elevation: 16,
                    shadowColor: AppColors.grey,
                    shape: CircleBorder(),
                    clipBehavior: Clip.antiAlias,
                    child: Image.asset(Assets.credits),
                  ),
                ),
                masterdata.when(
                    data: (data) => Text(
                          '1 ${Labels.coin} = ${Labels.rupee}${data.price}',
                          style: style.titleMedium,
                        ),
                    loading: () => SizedBox(),
                    error: (e, s) => Text(e.toString())),
              ],
            ),
          ),
          Text(
            'What are BIND Credit Coins?',
            style: style.titleMedium!.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: 12),
          Text(
            'BIND credit coins are BIND\'s exclusive currency. Its main purpose is to allow you to view user enquiries. When you pay using BIND credit coins, you can get access to the details of your user and their enquiry for your product or service.\n\nPlease note BIND credit coins are no way associated by any sort of cryptocurrency.',
            style: TextStyle(
              color: style.bodySmall!.color,
            ),
            textAlign: TextAlign.justify,
          ),
        ],
      ),
    );
  }
}
