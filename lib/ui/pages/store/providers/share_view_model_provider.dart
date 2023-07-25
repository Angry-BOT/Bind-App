import 'package:bind_app/providers/keys_provider.dart';

import '../../auth/providers/auth_view_model_provider.dart';

import '../../../../model/store.dart';

import '../../../../utils/labels.dart';
import 'package:firebase_dynamic_links/firebase_dynamic_links.dart';
import 'package:flutter/cupertino.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:share_plus/share_plus.dart';

final shareViewModelProvider =
    ChangeNotifierProvider((ref) => ShareViewModel(ref));

class ShareViewModel extends ChangeNotifier {
  final Ref _ref;
  ShareViewModel(this._ref);

  bool _loading = false;
  bool get loading => _loading;
  set loading(bool loading) {
    _loading = loading;
    notifyListeners();
  }

  String get uid => _ref.read(authViewModelProvider).user!.uid;

  void share(Store store) async {
    loading = true;
    try {
      final DynamicLinkParameters parameters = DynamicLinkParameters(
        uriPrefix: 'https://${_ref.read(keysProvider).pagelink}',
        link: Uri.parse(
            'https://play.google.com/store/apps/details?id=com.bind.store/${uid == store.id ? '*' : ''}${store.id}'),
        androidParameters: AndroidParameters(
          packageName: 'com.bind.store',
          minimumVersion: 1,
        ),
        iosParameters: IOSParameters(
          bundleId: 'com.bind.store',
          minimumVersion: '1.0.1',
          appStoreId: '1609553004',
        ),
        socialMetaTagParameters: SocialMetaTagParameters(
          title: '${store.name} by ${store.username}',
          description: store.products.join(', '),
          imageUrl: Uri.parse(store.logo),
        ),
      );

      final dynamicLink =
          await FirebaseDynamicLinks.instance.buildShortLink(parameters);

      final Uri shortUrl = dynamicLink.shortUrl;
      print(shortUrl);
      await Share.share(
        '${uid == store.id ? Labels.exploreMyBindStore : Labels.iRecommendThisBindStore} $shortUrl',
        sharePositionOrigin: Rect.fromCenter(
          center: Offset(100, 300),
          width: 500,
          height: 500,
        ),
      );
    } catch (e) {
      print(e);
    }
    loading = false;
  }
}
