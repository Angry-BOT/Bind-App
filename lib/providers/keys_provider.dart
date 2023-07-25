import 'package:bind_app/build_config.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

final keysProvider = Provider((ref) => Keys());

class Keys {
  late String razorpayKey;
  late String razrorpaySecret;

  late String pagelink;
  late String algoliaIndex;

  void init() {
    if (BuildConfig.type == BuildType.Dev) {
      razorpayKey = 'rzp_test_4oXNQf3X0f5a5B';
      razrorpaySecret = '15cAuO72CIFtcTGNJVpomoxN';
      pagelink = 'binddev.page.link';
      algoliaIndex = "stores-dev";
    } else {
      razorpayKey = 'rzp_live_uY2eiqApn6DU76';
      razrorpaySecret = '2gBfV2FwJl6DlFt5n7dhqJrk';
      pagelink = 'bindconnect.page.link';
      algoliaIndex = "stores";
    }
  }
}
