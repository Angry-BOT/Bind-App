import '../../../model/address.dart';
import '../../../repository/profile_repository.dart';
import '../../components/icons.dart';
import '../../components/my_appbar.dart';
import '../auth/providers/write_address_view_model_provider.dart';
import '../auth/write_address_page.dart';
import 'providers/profile_provider.dart';
import '../../../utils/labels.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class MyAddressesPage extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final profile = ref.watch(profileProvider).value!;
    return Scaffold(
      appBar: MyAppBar(
        title: Text(Labels.myAddresses),
        actions: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: ElevatedButton(
              onPressed: () async {
                final model = ref.read(writeAddressViewModelProvider);
                model.homeAddressExists = profile.homeAddressExist;
                await Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => WriteAddressPage(fromSelector: true),
                  ),
                );
                model.clear();
              },
              child: Text("Add New"),
            ),
          )
        ],
      ),
      body: ListView(
        children: <Widget>[] +
            profile.addresses
                .where((element) =>
                    element.name == Labels.store || element.name == Labels.home)
                .map((e) {
              final name = e.name == Labels.store &&
                      profile.addresses
                          .where((element) => element.name == Labels.home)
                          .isEmpty
                  ? Labels.home
                  : e.name;

              return Column(
                children: [
                  MyAddressTile(
                    e: e,
                    name: name,
                  ),
                  Divider(height: 0.5),
                ],
              );
            }).toList() +
            [
              ListTile(
                leading: SizedBox(),
                minLeadingWidth: 0,
                title: Text(Labels.others),
              ),
              Divider(height: 0.5),
            ] +
            profile.addresses
                .where((element) =>
                    element.name != Labels.store && element.name != Labels.home)
                .map(
                  (e) => Column(
                    children: [
                      MyAddressTile(e: e, name: e.name),
                      Divider(height: 0.5),
                    ],
                  ),
                )
                .toList(),
      ),
    );
  }
}

class MyAddressTile extends ConsumerWidget {
  const MyAddressTile({
    Key? key,
    required this.name,
    required this.e,
  }) : super(key: key);

  final Address e;
  final String name;
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final style = theme.textTheme;
    final profile = ref.read(profileProvider).value!;
    final repo = ref.read(profileRepositoryProvider);
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  children: [
                    name == Labels.store || e.name == Labels.home
                        ? Icon(
                            name == Labels.store
                                ? Icons.storefront_outlined
                                : Icons.home_outlined,
                            size: 20,
                          )
                        : AppIcons.direction,
                    SizedBox(width: 8),
                    Text(name),
                  ],
                ),
              ),
              Spacer(),
              e.name != Labels.store
                  ? SizedBox(
                      height: 28,
                      child: OutlinedButton(
                        style: ButtonStyle(
                          textStyle: MaterialStateProperty.all(style.bodySmall),
                        ),
                        onPressed: () async {
                          final model = ref.read(writeAddressViewModelProvider);
                          model.address = e;
                          model.deletableAddress = e;
                          model.type = e.name;
                          if (e.name != Labels.home) {
                            model.homeAddressExists = profile.homeAddressExist;
                          }
                          try {
                            await Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) =>
                                    WriteAddressPage(forEdit: true),
                              ),
                            );
                            model.clear();
                          } catch (e) {
                            print(e);
                          }

                         
                        },
                        child: Text(Labels.edit),
                      ),
                    )
                  : SizedBox(),
              SizedBox(width: 8),
              profile.addresses.length > 1 && e.name != Labels.store
                  ? SizedBox(
                      height: 28,
                      child: OutlinedButton(
                        style: ButtonStyle(
                          textStyle: MaterialStateProperty.all(style.bodySmall),
                        ),
                        onPressed: () {
                          showDialog(
                            context: context,
                            builder: (context) => AlertDialog(
                              title: Text(
                                  "Are you sure you want to delete this address?"),
                              actions: [
                                TextButton(
                                  onPressed: () {
                                    Navigator.pop(context);
                                  },
                                  child: Text("NO"),
                                ),
                                MaterialButton(
                                  color: theme.colorScheme.error,
                                  onPressed: () {
                                    repo.deleteAddress(e);
                                    Navigator.pop(context);
                                  },
                                  child: Text("YES"),
                                ),
                              ],
                            ),
                          );
                        },
                        child: Text(Labels.delete),
                      ),
                    )
                  : SizedBox(),
              SizedBox(width: 8),
            ],
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              e.customFormat,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }
}
