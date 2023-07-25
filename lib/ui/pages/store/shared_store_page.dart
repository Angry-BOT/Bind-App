import '../../components/loading.dart';
import '../favorites/providers/store_provider.dart';
import 'store_page.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class SharedStorePageRoot extends ConsumerWidget {
  const SharedStorePageRoot({Key? key, required this.id}) : super(key: key);
  final String id;
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final storeAsync = ref.watch(storeProvider(id));
    return Scaffold(
      body: storeAsync.when(
        data: (store) => StorePage(store: store),
        loading: () => Loading(),
        error: (e, s) => Text(
          e.toString(),
        ),
      ),
    );
  }
}
