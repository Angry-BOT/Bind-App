import 'package:bind_app/providers/pref_provider.dart';
import 'package:bind_app/utils/constants.dart';
import 'package:bind_app/utils/labels.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:url_launcher/url_launcher.dart';

class RateDialog extends ConsumerWidget {
  const RateDialog({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);

    return AlertDialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
      title: Text(Labels.helpUsIn),
      content: Text(Labels.bindExists),
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
            final pref = ref.read(prefProvider).value!;
            pref.setBool(Constants.rated, true);
            Navigator.pop(context);
            launch(Constants.appLink);
          },
          child: Text(Labels.rateNow),
        ),
      ],
    );
  }
}
