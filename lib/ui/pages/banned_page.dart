import 'package:bind_app/utils/constants.dart';

import 'package:flutter/gestures.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:url_launcher/url_launcher.dart';

import '../components/my_appbar.dart';
import 'auth/providers/auth_view_model_provider.dart';
import '../root.dart';
import '../../utils/assets.dart';
import '../../utils/labels.dart';
import 'package:flutter/material.dart';

class BannedPage extends ConsumerWidget {
  @override
  Widget build(BuildContext context,WidgetRef ref) {
    final style = Theme.of(context).textTheme;
    return Scaffold(
      appBar: MyAppBar(
        underline: false,
        actions: [
          IconButton(
            onPressed: () async {
              await ref.read(authViewModelProvider).signOut(onDone: () {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                    builder: (context) => Root(),
                  ),
                );
              });
            },
            icon: Icon(Icons.logout),
          )
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Image.asset(Assets.banned),
            ),
            RichText(
              text: TextSpan(
                text: Labels.yourAccessDisabled,
                style: style.titleLarge,
                children: [
                  TextSpan(
                      text: "${Constants.supportEmail} ",
                      style: style.titleLarge!.copyWith(
                        decoration: TextDecoration.underline,
                      ),
                      recognizer: TapGestureRecognizer()
                        ..onTap = () {
                          launch("mailto:${Constants.supportEmail}");
                        }),
                  TextSpan(
                    text: " for more information.",
                    style: style.titleLarge,
                  ),
                ],
              ),
              textAlign: TextAlign.center,
            ),
            SizedBox(),
            SizedBox(),
          ],
        ),
      ),
    );
  }
}
