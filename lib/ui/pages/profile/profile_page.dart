import 'package:bind_app/build_config.dart';
import 'package:bind_app/ui/pages/profile/widgets/edit_username_sheet.dart';
import 'package:cached_network_image/cached_network_image.dart';

import '../../components/my_appbar.dart';
import '../assistance/assistance_root.dart';
import '../auth/providers/auth_view_model_provider.dart';
import '../faq/faq_categories_page.dart';
import '../help/help_page.dart';
import 'edit_profile_page.dart';
import 'my_addresses_page.dart';
import 'my_enquires_page.dart';
import 'providers/profile_provider.dart';
import 'seller_profile_page.dart';
import '../store/providers/admin_store_provider.dart';
import '../../../utils/labels.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../root.dart';

class ProfilePage extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final style = theme.textTheme;
    final profile = ref.watch(profileProvider).value!;
    return Scaffold(
      appBar: MyAppBar(
        title: Text(Labels.myProfile),
      ),
      body: ListView(
        padding: EdgeInsets.all(8),
        children: [
          SizedBox(height: 8),
          Center(
            child: CircleAvatar(
              radius: 64,
              backgroundImage: profile.image != null
                  ? CachedNetworkImageProvider(profile.image!)
                  : null,
            ),
          ),
          SizedBox(height: 16),
          Text(
            "${profile.firstName} ${profile.lastName}",
            textAlign: TextAlign.center,
            style: style.titleSmall,
          ),
          SizedBox(height: 4),
          profile.isEntrepreneur
              ? Consumer(builder: (context, ref, child) {
                  final storeAsync = ref.watch(adminStoreProvider);
                  return storeAsync.when(
                    data: (store) => Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              store.username,
                              textAlign: TextAlign.center,
                              style: TextStyle(color: style.bodySmall!.color),
                            ),
                            SizedBox(width: 8),
                            SizedBox(
                              height: 24,
                              width: 24,
                              child: RawMaterialButton(
                                onPressed: () {
                                  showModalBottomSheet(
                                    context: context,
                                    isScrollControlled: true,
                                    builder: (context) => EditUsernameSheet(
                                      initial: store.username,
                                      id: store.id,
                                    ),
                                  );
                                },
                                fillColor: theme.primaryColor,
                                shape: CircleBorder(),
                                child: Icon(
                                  Icons.edit,
                                  size: 16,
                                ),
                              ),
                            )
                          ],
                        ),
                        SizedBox(height: 16),
                        Center(
                          child: MaterialButton(
                            color: theme.primaryColor,
                            onPressed: () => Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => SellerProfilePage(
                                  store: store,
                                ),
                              ),
                            ),
                            child: Text(Labels.view),
                          ),
                        ),
                      ],
                    ),
                    loading: () => SizedBox(),
                    error: (e, s) => SizedBox(),
                  );
                })
              : SizedBox(),
          MenuTile(
            label: Labels.editProfile,
            child: EditProfilePage(),
          ),
          Divider(height: 0.5),
          MenuTile(
            label: Labels.myAddresses,
            child: MyAddressesPage(),
          ),
          Divider(height: 0.5),
          MenuTile(
            label: Labels.myEnquiries,
            child: MyEnquiresPage(),
          ),
          Divider(height: 0.5),
          profile.isEntrepreneur
              ? MenuTile(
                  label: Labels.bindAssistance,
                  child: AssistanceRoot(),
                )
              : SizedBox(),
          profile.isEntrepreneur ? Divider(height: 0.5) : SizedBox(),
          MenuTile(
            label: Labels.help,
            child: HelpPage(),
          ),
          Divider(height: 0.5),
          MenuTile(
            label: Labels.fAQ,
            child: FaqCategoriesPage(),
          ),
          SizedBox(height: 16),
          Center(
            child: OutlinedButton(
              style: ButtonStyle(
                  padding:
                      MaterialStateProperty.all(theme.buttonTheme.padding)),
              onPressed: () async {
                await ref.read(authViewModelProvider).signOut(onDone: () {
                  Navigator.pushAndRemoveUntil(
                    context,
                    MaterialPageRoute(
                      builder: (context) => Root(),
                    ),
                    (route) => false,
                  );
                });
              },
              child: Text(Labels.logout),
            ),
          ),
          SizedBox(height: 16),
          Text(
            BuildConfig.versionText,
            textAlign: TextAlign.center,
            style: TextStyle(color: style.bodySmall!.color),
          ),
          SizedBox(height: 16),
        ],
      ),
    );
  }
}

class MenuTile extends StatelessWidget {
  const MenuTile({
    Key? key,
    required this.child,
    required this.label,
  }) : super(key: key);
  final String label;
  final Widget child;
  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => child,
          ),
        );
      },
      title: Text(label),
    );
  }
}
