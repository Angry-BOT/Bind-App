import '../../components/my_appbar.dart';
import 'providers/store_provider.dart';
import '../home/widgets/store_card.dart';
import '../profile/providers/profile_provider.dart';
import '../../../utils/labels.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class FavoritesPage extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final favorites = ref.read(profileProvider).value!.favorites;
    return Scaffold(
      appBar: MyAppBar(
        title: Text(Labels.favorites),
      ),
      body: ListView(
        padding: EdgeInsets.symmetric(
          vertical: 8,
        ),
        children: favorites
            .map(
              (e) => ref.watch(storeProvider(e)).when(
                    data: (store) => StoreCard(store: store),
                    loading: () => SizedBox(),
                    error: (e, s) => SizedBox(),
                  ),
            )
            .toList(),
      ),
    );
  }
}
