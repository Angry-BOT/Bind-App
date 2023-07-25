import '../../../../enums/survicableRadius.dart';
import '../../../../model/store.dart';
import '../../../../repository/products_repository.dart';
import '../../../../repository/store_repository.dart';
import '../../../components/loading.dart';
import '../products/providers/products_provider.dart';
import '../products/providers/write_product_view_model_provider.dart';
import '../products/write_product_page.dart';
import 'product_card.dart';
import '../../../../utils/labels.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

final productsStateProivder = StateProvider<int>((ref) => 0);

class ProductsView extends ConsumerWidget {
  final Store store;

  ProductsView({required this.store});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final state = ref.watch(productsStateProivder.state);
    final productsStream = ref.watch(productsProvider(store.id));
    return Column(children: <Widget>[
      ListTile(
        title: Text(Labels.manageProducts),
        subtitle: Text(Labels.addOrEditProductsOrServices),
        trailing: MaterialButton(
          padding: EdgeInsets.symmetric(
            horizontal: 32,
          ),
          color: theme.primaryColor,
          onPressed: () async {
            await Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => WriteProductPage(),
              ),
            );
            ref.read(writeProductViewModelProvider).clear();
          },
          child: Text(Labels.add),
        ),
      ),
      Divider(height: 1),
      Expanded(
        child: productsStream.when(
          data: (products) => ReorderableListView(
            onReorder: (int oldindex, int newindex) {
              if (newindex > oldindex) {
                newindex -= 1;
              }
              final items = store.products.removeAt(oldindex);
              store.products.insert(newindex, items);
              state.state++;
              ref
                  .read(storeRepositoryProvider)
                  .saveProducts(names: store.products, id: store.id);
            },
            children: store.products
                .map(
                    (e) => products.where((element) => element.name == e).first)
                .map(
                  (e) => Dismissible(
                    direction: DismissDirection.startToEnd,
                    background: Material(
                      color: theme.colorScheme.error,
                      child: Row(
                        children: [
                          AspectRatio(
                            aspectRatio: 1,
                            child: Center(
                              child: Icon(
                                Icons.delete,
                                color: theme.cardColor,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    confirmDismiss: (v) async {
                      return await showDialog(
                        context: context,
                        builder: (context) => AlertDialog(
                          title: Text(Labels.areYouSureDeleteProduct),
                          actions: [
                            TextButton(
                              onPressed: () {
                                Navigator.pop(context);
                              },
                              child: Text(Labels.no),
                            ),
                            MaterialButton(
                              color: theme.colorScheme.error,
                              onPressed: () {
                                Navigator.pop(context, true);
                              },
                              child: Text(Labels.yes),
                            ),
                          ],
                        ),
                      );
                    },
                    onDismissed: (v) {
                      ref.read(productsRepositoryProvider).deleteProduct(
                          id: e.id,
                          name: e.name,
                          storeId: e.storeId,
                          isPanIndia: store.survicableRadius ==
                              SurvicableRadius.panIndia);
                    },
                    key: ValueKey(e.name),
                    child: ProductCard(
                      product: e,
                      onTap: () async {
                        final writer = ref.read(writeProductViewModelProvider);
                        writer.inital = e;
                        await Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => WriteProductPage(),
                          ),
                        );
                        writer.clear();
                      },
                    ),
                  ),
                )
                .toList(),
          ),
          loading: () => Padding(
            padding: const EdgeInsets.all(24),
            child: Loading(),
          ),
          error: (e, s) => Padding(
            padding: const EdgeInsets.all(24),
            child: Text(
              e.toString(),
            ),
          ),
        ),
      ),
    ]);
  }
}
