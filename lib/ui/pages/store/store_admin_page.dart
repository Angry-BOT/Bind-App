import 'package:hooks_riverpod/hooks_riverpod.dart';

import 'providers/store_initial_tab_index_provider.dart';

import '../../components/loading.dart';
import '../../components/my_appbar.dart';
import 'providers/admin_store_provider.dart';
import 'widgets/enquries_view.dart';
import 'widgets/products_view.dart';
import 'widgets/settings_view.dart';
import 'widgets/store_view.dart';
import '../../../utils/labels.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

import 'widgets/store_tabbar.dart';

class StoreAdminPage extends HookConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final tabController = useTabController(
      initialLength: 4,
      initialIndex: ref.watch(storeInitialTabIndexProvider.state).state,
    );
    final storeStream = ref.watch(adminStoreProvider);
    return Scaffold(
      appBar: MyAppBar(
        title: Text(Labels.store),
      ),
      body: storeStream.when(
        data: (store) => Column(
          children: [
            StoreTabBar(
              tabController: tabController,
            ),
            Expanded(
              child: TabBarView(
                controller: tabController,
                children: [
                  StoreView(store: store),
                  ProductsView(store: store),
                  EnquriesView(store: store),
                  SettingsView(store: store),
                ],
              ),
            ),
          ],
        ),
        loading: () => Loading(),
        error: (e, s) => Text(
          e.toString(),
        ),
      ),
    );
  }
}
