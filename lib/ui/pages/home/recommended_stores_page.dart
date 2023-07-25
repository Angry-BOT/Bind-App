import '../../components/my_appbar.dart';
import 'providers/recommended_stores_view_provider.dart';
import 'widgets/store_card.dart';
import '../../../utils/labels.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class RecommendedStoresPage extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final model = ref.watch(recommendedStoresViewModelProvider);
    return Scaffold(
      appBar: MyAppBar(
        underline: false,
        title: Text(Labels.recommended),
      ),
      body: NotificationListener<ScrollNotification>(
        onNotification: (notification) {
          if (!model.busy &&
              notification.metrics.pixels ==
                  notification.metrics.maxScrollExtent) {
            model.getStoresMore();
          }
          return true;
        },
        child: RefreshIndicator(
          onRefresh: () async =>
              ref.refresh(recommendedStoresViewModelProvider),
          child: CustomScrollView(
            slivers: [
              SliverPadding(
                padding: EdgeInsets.symmetric(vertical: 8),
                sliver: SliverList(
                  delegate: SliverChildListDelegate(
                    model.stores.map((e) => StoreCard(store: e)).toList(),
                  ),
                ),
              ),
              SliverToBoxAdapter(
                child: Center(
                  child: model.loading && model.stores.length > 4
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
      ),
    );
  }
}
