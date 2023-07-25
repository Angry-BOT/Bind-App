import 'package:cached_network_image/cached_network_image.dart';

import '../../components/big_button.dart';
import '../../components/loading.dart';
import '../../components/my_appbar.dart';
import 'providers/enquire_view_model_provider.dart';
import '../store/products/providers/products_provider.dart';
import '../../../utils/labels.dart';
import 'package:flutter/material.dart';
import '../../../model/store.dart' as models;
import 'package:hooks_riverpod/hooks_riverpod.dart';

class ProductSelectionPage extends ConsumerWidget {
  final models.Store store;

  const ProductSelectionPage({Key? key, required this.store}) : super(key: key);
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final productsAsync = ref.watch(productsProvider(store.id));
    final model = ref.watch(enquireViewModelProvider(store.id));
    return Scaffold(
      appBar: MyAppBar(
        title: Text(Labels.selection),
      ),
      bottomNavigationBar: BigButton(
        child: Text(Labels.done),
        bottomFlat: true,
        onPressed:
            model.products.isNotEmpty ? () => Navigator.pop(context) : null,
      ),
      body: productsAsync.when(
        data: (products) => ListView(
          children: store.products
              .map((e) => products.where((element) => element.name == e).first)
              .map(
                (e) => Column(
                  children: [
                    ListTile(
                      contentPadding: EdgeInsetsDirectional.all(16),
                      onTap: () {
                        model.toggle(e.name);
                      },
                      leading: SizedBox(
                        height: 56,
                        width: 56,
                        child: CachedNetworkImage(imageUrl: e.image),
                      ),
                      trailing: Icon(
                        model.products.contains(e.name)
                            ? Icons.check_circle
                            : Icons.check_circle_outline,
                        color: model.products.contains(e.name)
                            ? theme.iconTheme.color
                            : null,
                      ),
                      title: Text(e.name),
                    ),
                    Divider(height: 0.5),
                  ],
                ),
              )
              .toList(),
        ),
        loading: () => Loading(),
        error: (e, s) => Text(
          e.toString(),
        ),
      ),
    );
  }
}
