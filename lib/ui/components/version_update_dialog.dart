import 'package:bind_app/utils/constants.dart';
import 'package:bind_app/utils/labels.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class VersionUpdateDialog extends StatelessWidget {
  const VersionUpdateDialog({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return AlertDialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
      title: Text(Labels.heyThere),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.pop(context);
          },
          child: Text(Labels.later),
        ),
        MaterialButton(
          color: theme.primaryColor,
          onPressed: () {
            launch(defaultTargetPlatform == TargetPlatform.iOS
                ? Constants.appLinkIos
                : Constants.appLink);
            Navigator.pop(context);
          },
          child: Text(Labels.update),
        ),
      ],
    );
  }
}

class ForceVersionUpdateDialog extends StatelessWidget {
  const ForceVersionUpdateDialog({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return WillPopScope(
      onWillPop: () async {
        return false;
      },
      child: AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
        title: Text(Labels.urghhYou),
        content: MaterialButton(
          color: theme.primaryColor,
          onPressed: () {
            launch(defaultTargetPlatform == TargetPlatform.iOS
                ? Constants.appLinkIos
                : Constants.appLink);
          },
          child: Text(Labels.update),
        ),
      ),
    );
  }
}
