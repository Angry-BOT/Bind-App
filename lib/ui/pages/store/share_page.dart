import 'package:bind_app/ui/pages/profile/providers/seller_profile_provider.dart';
import 'package:cached_network_image/cached_network_image.dart';

import '../../components/progess_loader.dart';

import '../../../model/store.dart';
import '../../components/big_button.dart';
import '../../components/my_appbar.dart';
import 'providers/share_view_model_provider.dart';
import '../../theme/app_colors.dart';
import '../../../utils/assets.dart';
import '../../../utils/labels.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class SharePage extends ConsumerWidget {
  final Store store;

  const SharePage({Key? key, required this.store}) : super(key: key);
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final style = theme.textTheme;
    final model = ref.watch(shareViewModelProvider);
    return Scaffold(
      appBar: MyAppBar(
        title: Text(Labels.share),
      ),
      body: ProgressLoader(
        isLoading: model.loading,
        child: ListView(
          padding: EdgeInsets.all(20),
          children: [
            SizedBox(height: 20),
            Card(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
              color: theme.primaryColor,
              child: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      AppColors.yellow1,
                      AppColors.yellow2,
                    ],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                ),
                child: Stack(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        children: [
                          SizedBox(height: 16),
                          Container(
                            height: 108,
                            width: 108,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(12),
                              image: DecorationImage(
                                  image: CachedNetworkImageProvider(store.logo),
                                  fit: BoxFit.cover),
                            ),
                          ),
                          SizedBox(height: 16),
                          Text(
                            store.name,
                            style: style.titleMedium,
                          ),
                          SizedBox(height: 28),
                          Text(
                            model.uid == store.id
                                ? Labels.exploreMyBindStore
                                : Labels.iRecommendThisBindStore,
                            style: style.titleLarge!.copyWith(
                              color: AppColors.purple,
                            ),
                            textAlign: TextAlign.center,
                          ),
                          SizedBox(height: 16),
                          Text(
                            store.products.join(', '),
                            textAlign: TextAlign.center,
                            style: style.titleMedium,
                          ),
                          SizedBox(height: 48),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Consumer(builder: (context, ref, child) {
                                return ref
                                    .watch(sellerProfileProvider(store.id))
                                    .when(
                                      data: (profile) => profile.image != null
                                          ? CircleAvatar(
                                              backgroundImage:
                                                  CachedNetworkImageProvider(
                                                      profile.image!),
                                            )
                                          : SizedBox(),
                                      loading: () => SizedBox(),
                                      error: (e, s) => SizedBox(),
                                    );
                              }),
                              SizedBox(width: 8),
                              Text(
                                "${Labels.by} ${store.username}",
                                style: style.titleMedium,
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    Positioned(
                      top: 16,
                      left: 24,
                      child: SizedBox(
                        height: 48,
                        width: 24,
                        child: Image.asset(Assets.logo),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(height: 48),
            Padding(
              padding: const EdgeInsets.all(4),
              child: BigButton(
                child: Text(Labels.share),
                arrow: true,
                onPressed: () {
                  model.share(store);
                },
              ),
            )
          ],
        ),
      ),
    );
  }
}
