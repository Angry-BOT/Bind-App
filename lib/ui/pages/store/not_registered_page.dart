import 'package:bind_app/ui/pages/auth/add_details_page.dart';
import 'package:bind_app/ui/pages/auth/providers/write_address_view_model_provider.dart';
import 'package:bind_app/ui/pages/home/providers/home_view_model_provider.dart';
import 'package:bind_app/utils/assets.dart';

import '../../../utils/labels.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../components/app_info_tooltip.dart';

class NotRegisteredPage extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final style = theme.textTheme;
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Spacer(
              flex: 3,
            ),
            Text(
              Labels.unleashTheEntrepreneur,
              style: style.titleLarge,
              textAlign: TextAlign.center,
            ),
            Spacer(flex: 1),
            Expanded(
              flex: 8,
              child: Image.asset(
                Assets.getStartedEntrepreneur,
              ),
            ),
            SizedBox(height: 32),
            RichText(
              text: TextSpan(
                  text: Labels.getStartedWithYourOwn,
                  style: style.titleLarge,
                  children: [
                    WidgetSpan(
                      child: AppInfoToolTip(message: Labels.bindAssists),
                    )
                  ]),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 12),
            Text(
              Labels.sellAndEarnMoney,
              textAlign: TextAlign.center,
              style: style.titleMedium!.copyWith(
                color: style.bodySmall!.color,
              ),
            ),
            SizedBox(height: 32),
            Center(
              child: MaterialButton(
                color: theme.primaryColor,
                onPressed: () {
                  ref.read(writeAddressViewModelProvider).address =
                      ref.read(homeViewModelProvider).address;
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => AddDetailsPage(),
                    ),
                  );
                },
                child: Text(Labels.getStarted),
              ),
            ),
            Spacer(
              flex: 3,
            ),
          ],
        ),
      ),
    );
  }
}
