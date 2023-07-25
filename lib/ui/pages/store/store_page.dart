import 'package:bind_app/ui/pages/enquiry/providers/enquire_view_model_provider.dart';
import 'package:bind_app/ui/pages/store/products/product_page.dart';
import 'package:bind_app/ui/pages/store/providers/manage_viewed_stores_provider.dart';
import 'package:firebase_core/firebase_core.dart';

import '../home/providers/home_view_model_provider.dart';

import '../../../model/store.dart' as models;
import '../../../repository/profile_repository.dart';
import '../../components/big_button.dart';
import '../../components/loading.dart';
import '../../components/my_appbar.dart';
import '../profile/providers/profile_provider.dart';
import 'products/providers/products_provider.dart';
import 'search_page.dart';
import '../enquiry/send_enquiry_page.dart';
import 'widgets/store_banner.dart';
import '../../../utils/labels.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import 'providers/review_view_model_provider.dart';
import 'share_page.dart';
import 'widgets/about_reviews_tabbar.dart';
import 'widgets/product_card.dart';
import 'widgets/review_card.dart';

class StorePage extends HookConsumerWidget {
  final models.Store store;

  const StorePage({Key? key, required this.store}) : super(key: key);
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final width = MediaQuery.of(context).size.width;
    ref.read(manageViewedStoresProvider(store.id));
    final aboutReviewController = useTabController(initialLength: 2);
    final productsAsync = ref.watch(productsProvider(store.id));
    final profile = ref.watch(profileProvider).value!;
    final favorites = profile.favorites;
    final canAdd = profile.id != store.id &&
        store.active &&
        store.isRelevant(ref.read(homeViewModelProvider).address!.point);
    return Scaffold(
      appBar: MyAppBar(
        title: Text(Labels.store),
        actions: [
          IconButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => SharePage(store: store),
                ),
              );
            },
            icon: Icon(Icons.share_outlined),
          ),
          IconButton(
            onPressed: () {
              ref.read(profileRepositoryProvider).toggleFavorite(id: store.id);
            },
            icon: Icon(favorites.contains(store.id)
                ? Icons.favorite
                : Icons.favorite_outline),
          ),
        ],
      ),
      bottomNavigationBar: canAdd
          ? Consumer(
              builder: (context, ref, child) {
                final adder = ref.watch(enquireViewModelProvider(store.id));
                adder.setStore(store);
                return BigButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => SendEnquiryPage(store: store),
                      ),
                    );
                  },
                  child: Text(
                      "${Labels.enquire}${adder.products.isNotEmpty ? " (${adder.products.length})" : ""}"),
                  bottomFlat: true,
                );
              },
            )
          : SizedBox(),
      body: NestedScrollView(
        headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
          return <Widget>[
            SliverAppBar(
              automaticallyImplyLeading: false,
              elevation: 0,
              expandedHeight: (width / 2.75) + 50,
              floating: true,
              pinned: true,
              flexibleSpace: FlexibleSpaceBar(
                collapseMode: CollapseMode.pin,
                background: Column(
                  children: [StoreBanner(store: store)],
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
                      trailing: productsAsync.asData != null
                          ? IconButton(
                              onPressed: () {
                                showSearch(
                                  context: context,
                                  delegate:
                                      SearchProductPage(productsAsync.value!),
                                );
                              },
                              icon: Icon(Icons.search),
                            )
                          : SizedBox(),
                    ),
                    Divider(height: 1),
                  ] +
                  productsAsync.when(
                    data: (products) => store.products
                        .map((e) => products
                            .where((element) => element.name == e)
                            .first)
                        .map(
                          (e) => ProductCard(
                            product: e,
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => ProductPage(
                                    product: e,
                                    canAdd: canAdd,
                                  ),
                                ),
                              );
                            },
                          ),
                        )
                        .toList(),
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
                    },
                  ),
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
      ),
    );
  }
}
