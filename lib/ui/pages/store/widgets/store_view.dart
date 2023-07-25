import 'package:bind_app/ui/pages/store/providers/about_review_index_provider.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../../../../model/store.dart' as models;
import '../../../components/big_button.dart';
import '../../../components/loading.dart';
import '../products/product_page.dart';
import '../products/providers/products_provider.dart';
import '../products/providers/write_product_view_model_provider.dart';
import '../products/write_product_page.dart';
import '../providers/review_view_model_provider.dart';
import 'product_card.dart';
import 'review_card.dart';
import '../write_store_page.dart';
import '../../../../utils/labels.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../search_page.dart';
import 'about_reviews_tabbar.dart';
import 'store_banner.dart';

class StoreView extends HookConsumerWidget {
  final models.Store store;

  StoreView({required this.store});
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final width = MediaQuery.of(context).size.width;
    final aboutReviewController = useTabController(
        initialLength: 2,
        initialIndex: ref.watch(aboutReviewIndexProvider.state).state);
    final productsStream = ref.watch(productsProvider(store.id));
    return NestedScrollView(
      headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
        return <Widget>[
          SliverAppBar(
            backgroundColor: theme.scaffoldBackgroundColor,
            automaticallyImplyLeading: false,
            elevation: 0,
            expandedHeight: (width / 2.75) + 56 + 50 + 16,
            floating: true,
            pinned: true,
            flexibleSpace: FlexibleSpaceBar(
              collapseMode: CollapseMode.pin,
              background: Column(
                children: [
                  ListTile(
                    title: Text(Labels.manageStore),
                    subtitle: Text(Labels.editAndManageYourStore),
                    trailing: MaterialButton(
                      padding: EdgeInsets.symmetric(
                        horizontal: 32,
                      ),
                      color: theme.primaryColor,
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => WriteStorePage(),
                          ),
                        );
                      },
                      child: Text(Labels.edit),
                    ),
                  ),
                  Divider(height: 1),
                  StoreBanner(
                    store: store,
                    showShareButton:
                        (productsStream.asData?.value ?? []).isNotEmpty,
                  ),
                ],
              ),
            ),
            bottom: PreferredSize(
              child: AboutTabBar(
                tabLabels: ["About", "Reviews (${store.ratingCount})"],
                controller: aboutReviewController,
              ),
              preferredSize: Size.fromHeight(50),
            ),
          ),
        ];
      },
      body: TabBarView(
        controller: aboutReviewController,
        children: [
          ListView(
            physics: BouncingScrollPhysics(),
            children: [
                  Padding(
                    padding: const EdgeInsets.all(16),
                    child: Text(
                      store.description,
                    ),
                  ),
                  Divider(height: 1),
                  ListTile(
                    title: Text(Labels.productsOrServices),
                    trailing: productsStream.asData != null
                        ? IconButton(
                            onPressed: () {
                              showSearch(
                                context: context,
                                delegate:
                                    SearchProductPage(productsStream.value!),
                              );
                            },
                            icon: Icon(Icons.search),
                          )
                        : SizedBox(),
                  ),
                  Divider(height: 1),
                ] +
                productsStream.when(
                    data: (products) {
                      if (store.products.isEmpty) {
                        return [
                          Padding(
                            padding: const EdgeInsets.all(24),
                            child: BigButton(
                              child: Text(Labels.addProductsOrServices),
                              onPressed: () async {
                                await Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => WriteProductPage(),
                                  ),
                                );
                                ref.read(writeProductViewModelProvider).clear();
                              },
                            ),
                          ),
                        ];
                      } else {
                        return store.products.map((e) {
                          final filetred =
                              products.where((element) => element.name == e);
                          if (filetred.isNotEmpty) {
                            return ProductCard(
                              product: filetred.first,
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => ProductPage(
                                      product: filetred.first,
                                      canAdd: false,
                                    ),
                                  ),
                                );
                              },
                            );
                          } else {
                            return SizedBox();
                          }
                        }).toList();
                      }
                    },
                    loading: () => [
                          Padding(
                            padding: const EdgeInsets.all(24),
                            child: Loading(),
                          )
                        ],
                    error: (e, s) {
                      if (e is FirebaseException) {
                        print(e.code);
                        if (e.code == "permission-denied") {
                          ref.refresh(productsProvider(store.id));
                        }
                      }
                      return [
                        Padding(
                          padding: const EdgeInsets.all(24),
                          child: Text(
                            e.toString(),
                          ),
                        ),
                      ];
                    }),
          ),
          Consumer(builder: (context, ref, child) {
            final model = ref.watch(reviewsViewModelProvider(store.id));
            return NotificationListener<ScrollNotification>(
              onNotification: (notification) {
                if (!model.busy &&
                    notification.metrics.pixels ==
                        notification.metrics.maxScrollExtent) {
                  model.loadMore();
                }
                return true;
              },
              child: RefreshIndicator(
                onRefresh: () async =>
                    ref.refresh(reviewsViewModelProvider(store.id)),
                child: CustomScrollView(
                  slivers: [
                    SliverList(
                      delegate: SliverChildListDelegate(
                        model.reviews
                            .map((e) => ReviewCard(
                                  rate: e,
                                  isAdmin: true,
                                  username: store.username,
                                ))
                            .toList(),
                      ),
                    ),
                    SliverToBoxAdapter(
                      child: Center(
                        child: model.loading && model.reviews.length > 4
                            ? Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: CircularProgressIndicator(),
                              )
                            : SizedBox(),
                      ),
                    ),
                  ],
                ),
              ),
            );
          })
        ],
      ),
    );
  }
}
