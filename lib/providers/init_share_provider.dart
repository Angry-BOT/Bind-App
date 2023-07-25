import 'pref_provider.dart';
import '../repository/credits_repository_provider.dart';
import '../ui/pages/posts/shared_post_page_root.dart';
import '../ui/pages/profile/providers/profile_provider.dart';
import '../ui/pages/store/shared_store_page.dart';
import '../utils/constants.dart';
import 'package:firebase_dynamic_links/firebase_dynamic_links.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

final linksProvider =
    Provider<FirebaseDynamicLinks>((ref) => FirebaseDynamicLinks.instance);

final initShareProvider = FutureProvider<String>((ref) async {
  final pref = ref.read(prefProvider).value!;
  final links = ref.read(linksProvider);

  links.onLink.listen((event) {
    final Uri deepLink = event.link;
      final String id = deepLink.toString().split('/').last;
      pref.setString(
          Constants.clickedId, '$deepLink'.contains('post') ? "#$id" : id);
    
  });

  final data = await links.getInitialLink();
  final Uri? deepLink = data?.link;
  if (deepLink != null) {
    final String id = deepLink.toString().split('/').last;
    pref.setString(
        Constants.clickedId, '$deepLink'.contains('post') ? "#$id" : id);
  }
  return '';
});

final initShareNavigate =
    Provider.family<void, BuildContext>((ref, context) async {
  ref.watch(initShareProvider).whenData((value) async {
    await Future.delayed(Duration(microseconds: 100));
    final pref = ref.read(prefProvider).value!;
    final id = pref.getString(Constants.clickedId);
    if (id != null) {
      await ShareHandler.navigate(context, ref.read, id);
      pref.remove(Constants.clickedId);
    }
    ref.read(linksProvider).onLink.listen((event) async {
      final Uri deepLink = event.link;
        final String id = deepLink.toString().split('/').last;
        print("Listned");
        await Future.delayed(Duration(microseconds: 100));
        await ShareHandler.navigate(
            context, ref.read, '$deepLink'.contains('post') ? "#$id" : id);
        pref.remove(Constants.clickedId);
    });
  });
});

class ShareHandler {
  static Future<void> navigate(
      BuildContext context, Reader reader, String id) async {
    print(id);
    if (id.startsWith('#')) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => SharedPostPageRoot(id: id.split('#').last),
        ),
      );
      return;
    } else {
      if (id.startsWith('*')) {
        final profile = reader(profileProvider).value!;
        final String uid = profile.id;
        final List<String> stores = profile.storeIds ?? [];
        final storeId = id.split('*').last;
        if (storeId != uid && !stores.contains(storeId)) {
          try {
            reader(creditsRepositoryProvider).addCreditsFromShare(
              uid: uid,
              storeId: storeId,
              firstTime: profile.storeIds == null,
            );
          } catch (e) {
            print(e);
          }
        }
      }
      await Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => SharedStorePageRoot(
              id: id.startsWith('*') ? id.split('*').last : id),
        ),
      );
    }
  }
}
