import '../../utils/labels.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';

class MessageDialog extends StatelessWidget {
  const MessageDialog({
    Key? key,
    required this.message,
    this.onView,
  }) : super(key: key);
  final VoidCallback? onView;
  final RemoteMessage message;
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
      title: Text(message.notification?.title ?? ''),
      content: Text(message.notification?.body ?? ''),
      actions: onView != null
          ? [
              MaterialButton(
                color: Theme.of(context).primaryColor,
                onPressed: onView,
                child: Text(Labels.view),
              ),
            ]
          : null,
    );
  }
}
