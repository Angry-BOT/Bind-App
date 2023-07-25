import 'package:bind_app/ui/pages/auth/add_document_page.dart';


import '../../../enums/survicableRadius.dart';
import '../../../model/subcategory.dart';
import '../home/providers/categories_provider.dart';
import '../home/providers/sub_categories_provider.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../../enums/bussiness_type.dart';
import '../../../utils/labels.dart';
import '../../components/big_button.dart';
import '../../components/drop_down_field.dart';
import '../../components/multi_drop_dow_field.dart';
import '../../components/my_appbar.dart';
import 'providers/add_details_view_model.dart';

class AddDetailsPage extends HookConsumerWidget {
  final _formKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final style = theme.textTheme;
    final model = ref.watch(addDetailsViewModelProvider);
    final categories = ref.watch(categoriesProvider).asData?.value ?? [];
    categories.sort((a, b) => a.index.compareTo(b.index));
    final list = categories.where((element) => element.id == model.category);

    final controller = useTextEditingController();
    return Scaffold(
      appBar: MyAppBar(
        underline: false,
        title: Text(Labels.virtualStoreSetup),
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.fromLTRB(24, 8, 24, 48),
        child: BigButton(
          child: Text(Labels.next),
          onPressed: model.isReady
              ? () {
                  if (_formKey.currentState!.validate()) {
                    model.update();
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => AddDocumentPage(),
                      ),
                    );
                  }
                }
              : null,
        ),
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: EdgeInsets.all(24),
          children: [
            Text(Labels.mainBusinessCategory),
            SizedBox(height: 12),
            DropDownField<String?>(
              value: list.isNotEmpty ? list.first.name : null,
              values: categories.map((e) => e.name).toList(),
              onSelect: (v) {
                model.category =
                    categories.where((element) => element.name == v).first.id;
                model.subCategories = [];
                controller.text = '';
              },
            ),
            SizedBox(height: 24),
            Row(
              crossAxisAlignment: CrossAxisAlignment.baseline,
              textBaseline: TextBaseline.alphabetic,
              children: [
                Text(Labels.subCategory),
                Text(
                  " (" + Labels.selectMultipleOptions + ")",
                  style: style.labelSmall,
                ),
              ],
            ),
            SizedBox(height: 12),
            Consumer(builder: (context, ref, child) {
              final List<Subcategory> subcategories = model.category != null
                  ? ref
                          .watch(subcategoriesProvider(model.category!))
                          .asData
                          ?.value ??
                      []
                  : [];
              subcategories.sort((a, b) => a.index.compareTo(b.index));
              return MuliDropDownField(
                controller: controller,
                selectedValues: model.subCategories,
                values: subcategories.map((e) => e.name).toList(),
                onSelect: (v) => model.subCategories = v,
              );
            }),
            SizedBox(height: 24),
            Text(Labels.whatAreYouSelling),
            SizedBox(height: 12),
            DropDownField<String?>(
              value: model.type != null ? describeEnum(model.type!) : null,
              values: BussinessType.values.map((e) => describeEnum(e)).toList(),
              onSelect: (v) => model.type = getBussinessType(v!),
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
              value: model.survicableRadius,
              values: SurvicableRadius.values,
              onSelect: (v) => model.survicableRadius = v,
            ),
          ],
        ),
      ),
    );
  }
}
