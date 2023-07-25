import 'package:bind_app/ui/root.dart';
import 'package:bind_app/utils/assets.dart';
import 'package:bind_app/utils/constants.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import 'set_username_page.dart';
import '../../../utils/labels.dart';
import 'package:flutter/material.dart';

class MessagePage extends ConsumerWidget {
   final bool created;

  MessagePage({ this.created = false});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final style = theme.textTheme;
    final message = ref.read(messageProvider);
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Spacer(
              flex: 3,
            ),
            Expanded(
              flex: 8,
              child: Padding(
                padding: const EdgeInsets.all(24),
                child: message.type == Constants.success
                    ? Image.asset(Assets.check)
                    : Image.asset(Assets.close),
              ),
            ),
            Spacer(
              flex: 1,
            ),
            Text(
              message.message,
              style: style.titleSmall,
              textAlign: TextAlign.center,
            ),
            if (message.description != null) SizedBox(height: 24),
            if (message.description != null)
              Text(
                message.description!,
                textAlign: TextAlign.center,
                style: style.bodyLarge!.copyWith(
                  color: style.bodySmall!.color,
                ),
              ),
            SizedBox(height: 48),
            Center(
              child: MaterialButton(
                color: theme.primaryColor,
                onPressed: () {
                  if (message.value) {
                    message.remove();
                  } else {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => SetUserNamePage(),
                      ),
                    );
                  }
                },
                child: Text(created
                    ? Labels.visitYourVirtualStore
                    : Labels.createYourVirtualStore),
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
