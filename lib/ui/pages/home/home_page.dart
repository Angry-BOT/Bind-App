import 'package:bind_app/ui/pages/home/providers/near_by_stores_provider.dart';

import '../../../providers/init_share_provider.dart';
import '../posts/providers/initial_posts_providers.dart';
import '../profile/providers/profile_provider.dart';

import '../../components/loading.dart';
import '../address/select_address_page.dart';
import '../auth/providers/search_state_provider.dart';
import '../credits/widgets/credits_icon.dart';
import '../posts/posts_explore_page.dart';
import 'providers/categories_provider.dart';
import 'providers/home_view_model_provider.dart';
import 'providers/recommended_stores_view_provider.dart';
import 'widgets/posts_view.dart';
import 'widgets/store_card.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../../utils/labels.dart';
import '../../components/my_appbar.dart';
import 'widgets/build_and_buy_banner.dart';
import 'widgets/categories_grid_view.dart';
import 'widgets/home_search_view.dart';
import 'widgets/view_all_button.dart';

class HomePage extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final style = theme.textTheme;
    final model = ref.read(homeViewModelProvider);
    final searchState = ref.watch(searchStateProvider.state);
    final postsAsync = ref.watch(initialPostsProvider);
    final recommended = ref.watch(recommendedStoresViewModelProvider);
    ref.read(initShareNavigate(context));
    final profile = ref.watch(profileProvider).value!;
    return WillPopScope(
      onWillPop: () async {
        if (searchState.state) {
          searchState.state = false;
          return false;
        } else {
          return true;
        }
      },
      child: Scaffold(
        appBar: MyAppBar(
          titleSpacing: -16,
          leading: Icon(
            Icons.location_pin,
            color: theme.primaryColor,
          ),
          actions: [CreditsIcon()],
          title: ListTile(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => SelectAddressPage(fromHome: true),
                ),
              );
            },
            title: Text(model.address!.name == Labels.store &&
                    profile.addresses
                        .where((element) => element.name == Labels.home)
                        .isEmpty
                ? Labels.home
                : model.address!.name),
            subtitle: Text(
              model.address!.customFormat,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ),
        // bottomSheet: StatusBanner(),
        body: RefreshIndicator(
          onRefresh: () async {
            ref.refresh(categoriesProvider);
            ref.refresh(initialPostsProvider);
            ref.refresh(nearByStoresProvider);
            ref.refresh(recommendedStoresViewModelProvider);
          },
          child: ListView(
            physics: BouncingScrollPhysics(),
            children: <Widget>[
                  HomeSearchView(),
                ] +
                (searchState.state
                    ? []
                    : [
                          Padding(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 16,
                              vertical: 8,
                            ),
                            child: Text(
                              Labels.categories,
                              style: style.titleLarge,
                            ),
                          ),
                          CategoriesGridView(),
                          SizedBox(height: 16),
                          Padding(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 16,
                              vertical: 8,
                            ),
                            child: Text(
                              Labels.recommendedEntrepreneurs,
                              style: style.titleLarge,
                            ),
                          ),
                        ] +
                        recommended.stores5
                            .map((e) => StoreCard(store: e))
                            .toList() +
                        [
                          recommended.stores.length > 5
                              ? ViewAllButton()
                              : SizedBox(),
                          SizedBox(height: 16),
                          Padding(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 16,
                              vertical: 8,
                            ),
                            child: RichText(
                              text: TextSpan(
                                text: Labels.happening + ' ',
                                style: style.titleLarge,
                                children: [
                                  TextSpan(
                                    text: Labels.atTheRate,
                                    style: style.titleLarge!
                                        .apply(color: theme.primaryColor),
                                  ),
                                  TextSpan(
                                    text: Labels.bind,
                                    style: style.titleLarge,
                                  ),
                                ],
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 16,
                              vertical: 8,
                            ),
                            child: Text(
                              Labels.peekIntoKnowledge,
                              style: TextStyle(
                                color: style.bodySmall!.color,
                              ),
                            ),
                          ),
                          postsAsync.when(
                            data: (posts) => PostsView(posts: posts),
                            loading: () => Loading(),
                            error: (e, s) => Text(
                              e.toString(),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(8),
                            child: Center(
                              child: MaterialButton(
                                color: theme.primaryColor,
                                onPressed: () => Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => PostsExplorePage(
                                      initial: postsAsync.asData?.value ?? [],
                                    ),
                                  ),
                                ),
                                child: Text(Labels.exploreFeed),
                              ),
                            ),
                          ),
                          BuildAndBuyBanner()
                        ]),
          ),
        ),
      ),
    );
  }
}
