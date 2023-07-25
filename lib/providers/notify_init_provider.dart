import 'package:bind_app/build_config.dart';
import 'package:bind_app/providers/pref_provider.dart';
import 'package:bind_app/repository/profile_repository.dart';
import 'package:bind_app/ui/components/rate_dialog.dart';
import 'package:bind_app/ui/components/version_update_dialog.dart';
import 'package:bind_app/ui/pages/credits/add_credits_page.dart';
import 'package:bind_app/ui/pages/credits/providers/master_data_provider.dart';
import 'package:bind_app/ui/pages/posts/shared_post_page_root.dart';
import 'package:bind_app/ui/pages/profile/providers/profile_provider.dart';
import 'package:bind_app/ui/pages/store/providers/about_review_index_provider.dart';
import 'package:bind_app/ui/root.dart';
import 'package:bind_app/utils/constants.dart';
import 'package:flutter/foundation.dart';

import '../model/message_data.dart';
import '../ui/components/message_dialog.dart';
import '../ui/dash_board/dash_board.dart';
import '../ui/pages/credits/credits_page.dart';
import '../ui/pages/profile/my_enquiry_page.dart';
import '../ui/pages/store/providers/store_initial_tab_index_provider.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

final messagingProvider =
    Provider<FirebaseMessaging>((ref) => FirebaseMessaging.instance);

final doneProvider = Provider<Done>((ref) => Done());

class Done {
  bool seen = false;

  final List<String> ids = [];
}

final notifiyInitProivder = Provider.family<void, BuildContext>((ref, context) {
  final done = ref.read(doneProvider);
  final value = ref.read(profileProvider).value!;
  final _repository = ref.read(profileRepositoryProvider);
  final _messaging = ref.read(messagingProvider);
  if (defaultTargetPlatform == TargetPlatform.iOS) {
    _messaging.getNotificationSettings().then((value) {
      if (value.authorizationStatus == AuthorizationStatus.notDetermined) {
        _messaging.requestPermission(sound: true);
      }
    });
  }
  _messaging.subscribeToTopic('posts');
  if (value.isEntrepreneur) {
    _messaging.subscribeToTopic('offers');
  }
  _messaging.getToken().then((token) {
    if (value.token == null || value.token != token) {
      if (token != null) {
        _repository.saveToken(token);
      }
    }
  });

  _messaging.onTokenRefresh.listen((token) {
    _repository.saveToken(token);
  });

  MyMessageHandler.handle(context: context, reader: ref.read);

  final subscription =
      FirebaseMessaging.onMessage.listen((RemoteMessage message) {
    showDialog(
      context: context,
      builder: (context) => MessageDialog(
        message: message,
        onView: () {
          Navigator.pop(context);
          MyMessageHandler.navigate(context, ref.read, message);
        },
      ),
    );
  });

  ref.onDispose(() {
    subscription.cancel();
  });

  if (done.seen) {
    return;
  } else {
    done.seen = true;
  }

  final pref = ref.read(prefProvider).value!;
  final rated = pref.getBool(Constants.rated);
  print("rated: $rated");
  if (!(rated ?? false)) {
    final views = pref.getInt(Constants.views) ?? 0;
    print(views);
    if (views > 1) {
      Future.delayed(Duration(microseconds: 100), () {
        showDialog(
          context: context,
          builder: (context) => RateDialog(),
        );
      });
      pref.setInt(Constants.views, 0);
    } else {
      pref.setInt(Constants.views, views + 1);
    }
  }
  ref.read(masterDataProvider.stream).listen((masterData) {
    if (defaultTargetPlatform == TargetPlatform.android
        ? masterData.versionCode > BuildConfig.versionCode
        : masterData.versionCodeIos > BuildConfig.versionCodeIos) {
      showDialog(
        barrierDismissible: defaultTargetPlatform == TargetPlatform.android
            ? !masterData.forceUpdate
            : !masterData.forceUpdateIos,
        context: context,
        builder: (context) => (defaultTargetPlatform == TargetPlatform.android
                ? masterData.forceUpdate
                : masterData.forceUpdateIos)
            ? ForceVersionUpdateDialog()
            : VersionUpdateDialog(),
      );
    }
  });
});

class MyMessageHandler {
  static handle({required BuildContext context, required Reader reader}) async {
    final _messaging = reader(messagingProvider);
    print("Handling");
    final RemoteMessage? message = await _messaging.getInitialMessage();
    if (message != null) {
      navigate(context, reader, message);
    }
  }

  static navigate(BuildContext context, Reader reader, RemoteMessage message) {
    final done = reader(doneProvider);
    if (done.ids.contains(message.messageId!)) {
      return;
    } else {
      done.ids.add(message.messageId!);
    }
    final data = MessageData.fromMap(message.data);
    Widget? widget;
    switch (data.type) {
      case MessageType.credits:
        widget = CreditsPage();
        break;
      case MessageType.enquiryCustomer:
        widget = MyEnquiryRoot(id: data.refId!);
        break;
      case MessageType.offers:
        widget = AddCreditsPageRoot();
        break;
      case MessageType.posts:
        widget = SharedPostPageRoot(id: data.refId!);
        break;
      case MessageType.reviews:
        Navigator.pushAndRemoveUntil(context,
            MaterialPageRoute(builder: (context) => Root()), (route) => false);
        reader(aboutReviewIndexProvider.state).state = 1;
        reader(indexProvider.state).state = 1;
        break;
      case MessageType.enquiryStore:
        Navigator.pushAndRemoveUntil(context,
            MaterialPageRoute(builder: (context) => Root()), (route) => false);
        reader(storeInitialTabIndexProvider.state).state = 2;
        reader(indexProvider.state).state = 1;
        break;
      case MessageType.aadhaar:
        final model = reader(messageProvider);
        model.show();
        model.type = data.refId ?? '';
        model.message = (message.notification?.title ?? '') +
            "\n" +
            (message.notification?.body ?? '');
        if (reader(indexProvider) == 1) {
          model.update();
        } else {
          reader(indexProvider.state).state = 1;
        }
        break;
    }
    if (widget != null) {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => widget!),
      );
    }
  }
}
