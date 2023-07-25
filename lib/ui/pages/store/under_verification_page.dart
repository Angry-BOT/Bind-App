import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../dash_board/dash_board.dart';
import '../../../utils/labels.dart';
import 'package:flutter/material.dart';

class UnderVerificationPage extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final style = theme.textTheme;
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              Labels.thankYouForAppling,
              style: style.titleLarge,
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 24),
            Text(
              Labels.youCanStartAddingYourProducts,
              textAlign: TextAlign.center,
              style: style.titleMedium!.copyWith(
                color: style.bodySmall!.color,
              ),
            ),
            SizedBox(height: 48),
            Center(
              child: MaterialButton(
                color: theme.primaryColor,
                onPressed: () {
                  ref.read(indexProvider.state).state = 0;
                },
                child: Text(Labels.home),
              ),
            )
          ],
        ),
      ),
    );
  }
}
