
import 'package:bind_app/ui/components/multi_drop_dow_field.dart';
import 'package:bind_app/ui/components/my_files.dart';
import 'package:bind_app/ui/pages/auth/add_document_page.dart';
import 'package:bind_app/ui/pages/auth/providers/add_documents_view_model_provider.dart';

import '../../../../enums/bussiness_type.dart';
import '../../../../model/address.dart';
import '../../../../model/store.dart' as models;
import '../../../components/big_button.dart';
import '../../../components/drop_down_field.dart';
import '../../../components/progess_loader.dart';
import '../../../components/small_gray_button.dart';
import '../../home/providers/categories_provider.dart';
import '../../home/providers/sub_categories_provider.dart';
import '../../profile/providers/profile_provider.dart';
import '../providers/settings_view_model_provider.dart';
import '../providers/admin_store_provider.dart';
import '../../../theme/app_colors.dart';
import '../../../../utils/labels.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class SettingsView extends HookConsumerWidget {
  final models.Store store;

  SettingsView({Key? key, required this.store}) : super(key: key);
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final style = theme.textTheme;
    final profile = ref.read(profileProvider).value!;
    final Address address = profile.addresses
        .where((element) => element.name == Labels.store)
        .first;
    final model = ref.watch(settingsViewModelProvider);
    final aadharController = useTextEditingController();
    final store = ref.read(adminStoreProvider).value!;
    final matchedCategories = ref
        .read(categoriesProvider)
        .value!
        .where((element) => element.id == profile.category);
    final subcategoriesAsync = ref.watch(subcategoriesProvider(store.category));

    return ProgressLoader(
      isLoading: model.loading,
      child: Form(
        key: _formKey,
        child: ListView(
          padding: EdgeInsets.all(24),
          children: [
            Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(Labels.store),
                      SizedBox(height: 4),
                      Text(
                        Labels.startStopTakingOrders,
                        style: style.labelSmall,
                      ),
                    ],
                  ),
                ),
                CupertinoButton(
                  color: store.active ? AppColors.green : AppColors.red,
                  child: Column(
                    children: [
                      Text(
                        store.active ? Labels.open : Labels.close,
                        style: style.labelSmall!.copyWith(
                            color: theme.cardColor,
                            fontWeight: FontWeight.w600),
                      ),
                      Text(
                        store.active ? Labels.tapToClose : Labels.tapToOpen,
                        style: style.labelSmall!.copyWith(
                          color: theme.cardColor,
                        ),
                      ),
                    ],
                  ),
                  onPressed: () {
                    model.setActive(!store.active);
                  },
                  padding: EdgeInsets.symmetric(horizontal: 24),
                ),
              ],
            ),
           if(profile.aadharId==null) ListTile(
              contentPadding: EdgeInsets.zero,
              title: RichText(
                text: TextSpan(
                  text: '',
                  style: style.bodyMedium,
                  children: Labels.applyForGreenTick(Icon(
                    Icons.check_circle_outline,
                    size: 16,
                    color: AppColors.green,
                  ))
                      .map((e) => e is String
                          ? TextSpan(text: e)
                          : WidgetSpan(child: e))
                      .toList(),
                ),
              ),
              subtitle: Text(
                Labels.verifyYourBusinessWithUs,
                style: style.labelSmall,
              ),
              trailing: OutlinedButton(
                onPressed: () {
                  ref.read(addDocumentsViewModelProvider).profile = profile;
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => AddDocumentPage(),
                    ),
                  );
                },
                child: Text(Labels.apply),
              ),
            ),
            SizedBox(height: 24),
            Stack(
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    RichText(
                      text: TextSpan(
                        text: Labels.mainBusinessCategory,
                        style: style.bodyMedium,
                        children: [
                          TextSpan(
                            text: " ${Labels.contactSupportToChange}",
                            style: style.labelSmall!
                                .copyWith(color: Colors.blueGrey.shade800),
                          )
                        ],
                      ),
                    ),
                    SizedBox(height: 12),
                    TextFormField(
                      initialValue: matchedCategories.isNotEmpty
                          ? matchedCategories.first.name
                          : null,
                    ),
                  ],
                ),
                Positioned(
                  top: 0,
                  bottom: 0,
                  left: 0,
                  right: 0,
                  child: Material(
                    color: theme.colorScheme.background.withOpacity(0.5),
                  ),
                ),
              ],
            ),
            SizedBox(height: 24),
            Text(Labels.subCategory),
            SizedBox(height: 12),
            subcategoriesAsync.when(
              data: (subs) {
                subs.sort((a, b) => a.index.compareTo(b.index));

                final controller = useTextEditingController(
                    text: profile.subCategories!
                        .map((e) {
                          final filtered =
                              subs.where((element) => element.id == e);
                          return filtered.isEmpty ? null : filtered.first.name;
                        })
                        .where((element) => element != null)
                        .map((e) => e!)
                        .toList()
                        .join(", "));
                return MuliDropDownField(
                  controller: controller,
                  selectedValues: profile.subCategories!
                      .map((e) {
                        final filtered =
                            subs.where((element) => element.id == e);
                        return filtered.isEmpty ? null : filtered.first.name;
                      })
                      .where((element) => element != null)
                      .map((e) => e!)
                      .toList(),
                  values: subs.map((e) => e.name).toList(),
                  onSelect: (v) => model.saveSubcategories(v
                      .map((e) =>
                          subs.where((element) => element.name == e).first.id)
                      .toList()),
                );
              },
              loading: () => SizedBox(),
              error: (e, s) => Text(
                e.toString(),
              ),
            ),
            Stack(
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(height: 24),
                    Text(Labels.whatAreYouSelling),
                    SizedBox(height: 12),
                    DropDownField<String?>(
                      value: profile.type!.length == 2
                          ? describeEnum(BussinessType.Both)
                          : describeEnum(profile.type!.first),
                      values: BussinessType.values
                          .map((e) => describeEnum(e))
                          .toList(),
                      onSelect: (v) {},
                    ),
                    SizedBox(height: 24),
                    Text(Labels.serviceableRadius),
                    SizedBox(height: 6),
                    Text(
                      Labels.getOrdersFromCustomersWithin,
                      style: style.labelSmall,
                    ),
                    SizedBox(height: 12),
                    DropDownField<String?>(
                      value: profile.survicableRadius,
                      values: ["10 kms", "35 kms", "Pan India"],
                      onSelect: (v) {},
                    ),
                  ],
                ),
                Positioned(
                  top: 0,
                  bottom: 0,
                  left: 0,
                  right: 0,
                  child: Material(
                    color: theme.colorScheme.background.withOpacity(0.5),
                  ),
                ),
              ],
            ),
            SizedBox(height: 24),
            Text(Labels.storeAddress),
            SizedBox(height: 12),
            Text(
              "${address.number}, ${address.landmark}, ${address.formated}",
              style: style.bodySmall,
            ),
            Center(
              child: Padding(
                padding: const EdgeInsets.all(24),
                child: Text(
                  Labels.emailUsOn,
                  textAlign: TextAlign.center,
                ),
              ),
            ),
            Stack(
              children: [
                Column(
                  children: [
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.baseline,
                      textBaseline: TextBaseline.alphabetic,
                      children: [
                        Text(Labels.udyogAadharNumber),
                        Text(
                          " (" + Labels.optional + ")",
                          style: style.labelSmall,
                        ),
                      ],
                    ),
                    SizedBox(height: 6),
                    Text(
                      Labels.havingUdyogAadhar,
                      style: style.labelSmall,
                    ),
                    SizedBox(height: 12),
                    TextFormField(
                      initialValue: profile.udyogAadharNumber,
                      maxLength: 11,
                      onChanged: (v) => model.udyogAadharNumber = v,
                      textCapitalization: TextCapitalization.characters,
                      validator: (v) =>
                          v!.isNotEmpty ? model.udyogAadharValidator(v) : null,
                    ),
                    profile.udyogAadharNumber == null &&
                            model.udyogAadharNumber != null &&
                            model.udyogAadharNumber!.isNotEmpty
                        ? Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              SizedBox(height: 24),
                              Row(
                                crossAxisAlignment: CrossAxisAlignment.baseline,
                                textBaseline: TextBaseline.alphabetic,
                                children: [
                                  Text(Labels.uploadUdyogAadhar),
                                  SizedBox(width: 8),
                                  Expanded(
                                    child: Text(
                                      "${Labels.maxUploadSize4mb}- ${Labels.pdf}, ${Labels.jpgPng}",
                                      style: style.labelSmall,
                                    ),
                                  ),
                                ],
                              ),
                              SizedBox(height: 12),
                              TextField(
                                readOnly: true,
                                controller: aadharController,
                                decoration: InputDecoration(
                                  suffixIcon: SmallGrayButton(
                                    onPressed: () async {
                                      final file =
                                          await MyImages.pickDocument(context);
                                      if (file != null) {
                                        aadharController.text =
                                            file.path.split('/').last;
                                        model.udyogAadhar = file;
                                      }
                                    },
                                    lable: Labels.select,
                                  ),
                                ),
                              ),
                            ],
                          )
                        : SizedBox(),
                    SizedBox(height: 24),
                    profile.udyogAadharNumber == null && model.isReady
                        ? BigButton(
                            child: Text(Labels.save),
                            onPressed: () {
                              if (_formKey.currentState!.validate()) {
                                model.addUdyogAadhar();
                              }
                            },
                          )
                        : SizedBox(),
                  ],
                ),
                profile.udyogAadharNumber != null
                    ? Positioned(
                        top: 0,
                        bottom: 0,
                        right: 0,
                        left: 0,
                        child: Material(
                          color: theme.colorScheme.background.withOpacity(0.5),
                        ),
                      )
                    : SizedBox(),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
