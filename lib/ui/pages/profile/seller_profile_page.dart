import 'package:cached_network_image/cached_network_image.dart';

import '../../../model/store.dart';
import '../../components/loading.dart';
import '../../components/my_appbar.dart';
import '../home/widgets/store_card.dart';
import 'providers/profile_provider.dart';
import 'providers/seller_profile_provider.dart';
import '../../theme/app_colors.dart';
import '../../../utils/labels.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class SellerProfilePage extends ConsumerWidget {
  final Store store;

  const SellerProfilePage({Key? key, required this.store}) : super(key: key);
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final myProfile = ref.read(profileProvider).value!;
    final profileStream = store.id == myProfile.id
        ? ref.watch(profileProvider)
        : ref.watch(sellerProfileProvider(store.id));
    final theme = Theme.of(context);
    final style = theme.textTheme;
    return Scaffold(
      appBar: MyAppBar(
        underline: true,
        title: Text(Labels.sellerProfile),
      ),
      body: profileStream.when(
        data: (profile) => ListView(
          children: [
            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  SizedBox(height: 16),
                  CircleAvatar(
                    radius: 48,
                    backgroundImage: profile.image != null
                        ? CachedNetworkImageProvider(profile.image!)
                        : null,
                  ),
                  SizedBox(height: 16),
                  Text(
                    "${profile.firstName} ${profile.lastName}",
                    style: style.titleMedium,
                  ),
                  Text(
                    "@${store.username}",
                    style: TextStyle(color: style.bodySmall!.color),
                  ),
                  SizedBox(height: 32),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      [Labels.storeVisits, "${store.views}"],
                      [Labels.totalEnquiries, "${store.enquiries}"],
                    ]
                        .map(
                          (e) => Expanded(
                            child: Column(
                              children: [
                                Text(e.first),
                                SizedBox(height: 12),
                                Text(
                                  e.last,
                                  style: TextStyle(
                                    fontWeight: FontWeight.w600,
                                    color: AppColors.choiceChipBorderColor,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        )
                        .toList(),
                  ),
                  SizedBox(height: 32),
                  profile.about != null
                      ? Row(
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  Labels.aboutMe,
                                  style: style.titleSmall,
                                ),
                                SizedBox(height: 12),
                                Text(
                                  profile.about!,
                                  style: TextStyle(color: style.bodySmall!.color),
                                )
                              ],
                            ),
                          ],
                        )
                      : SizedBox(),
                ],
              ),
            ),
            SizedBox(height: 32),
            Divider(height: 1),
            Padding(
              padding: const EdgeInsets.all(16),
              child: Text(
                Labels.myStore,
                style: style.titleSmall,
              ),
            ),
            Divider(height: 1),
            SizedBox(height: 8),
            StoreCard(store: store),
            SizedBox(height: 8),
          ],
        ),
        loading: () => Loading(),
        error: (e, s) => Center(
          child: Text(
            e.toString(),
          ),
        ),
      ),
    );
  }
}
