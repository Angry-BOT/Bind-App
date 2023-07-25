import 'package:bind_app/utils/constants.dart';
import 'package:url_launcher/url_launcher_string.dart';


import '../../components/icons.dart';
import '../../components/my_appbar.dart';
import '../../../utils/labels.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class HelpPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final style = theme.textTheme;
    return Scaffold(
      appBar: MyAppBar(
        title: Text(Labels.help),
      ),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          children: [
            Spacer(),
            Center(
              child: RichText(
                textAlign: TextAlign.center,
                text: TextSpan(
                  text: Labels.reachOutToUsAt,
                  style: style.titleMedium!.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                  children: [
                    TextSpan(
                      text: " ${Constants.supportEmail}",
                      style: style.titleMedium,
                    )
                  ],
                ),
              ),
            ),
            SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                MaterialButton(
                  color: theme.primaryColor,
                  onPressed: () {
                    launchUrlString('mailto:${Constants.supportEmail}');
                  },
                  child: Row(
                    children: [
                      Icon(
                        Icons.email_outlined,
                        size: 18,
                      ),
                      SizedBox(width: 4),
                      Text(Labels.emailUs),
                    ],
                  ),
                ),
                MaterialButton(
                  color: theme.primaryColor,
                  onPressed: () {
                    ////TODO:
                    launch('https://wa.me/${Constants.supportContact}');
                    // launchUrlString('https://wa.me/+919284103047');
                  },
                  child: Row(
                    children: [
                      AppIcons.whatsapp,
                      SizedBox(width: 4),
                      Text(Labels.whatsapp),
                    ],
                  ),
                ),
              ],
            ),
            Spacer(flex: 6),
          ],
        ),
      ),
    );
  }
}
