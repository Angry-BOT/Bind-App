import 'widgets/my_navi_bar.dart';
import '../pages/favorites/favorites_page.dart';
import '../pages/home/home_page.dart';
import '../pages/profile/profile_page.dart';
import '../../utils/labels.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../root.dart';

final indexProvider = StateProvider<int>((ref) => 0);

class Dashboard extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final index = ref.watch(indexProvider.state);
    return Scaffold(
      body: [
        HomePage(),
        StoreRoot(),
        FavoritesPage(),
        ProfilePage(),
      ][index.state],
      bottomNavigationBar: MyNavibar(
        index: index.state,
        onSelect: (i) => index.state = i,
        items: [
          MyNaviItem(
            icon: Icon(Icons.home_outlined),
            label: "Home",
          ),
          MyNaviItem(
            icon: Icon(Icons.store_outlined),
            label: "My Store",
          ),
          MyNaviItem(
            icon: Icon(Icons.favorite_outline),
            label: Labels.favorites,
          ),
          MyNaviItem(
            icon: Icon(Icons.person_outline),
            label: "Profile",
          ),
        ],
      ),
    );
  }
}
