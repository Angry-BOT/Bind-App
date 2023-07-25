import 'package:bind_app/ui/root.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../../../utils/labels.dart';
import '../../../components/big_button.dart';
import '../../../components/icons.dart';
import '../../../components/my_choice_chip.dart';
import '../providers/write_address_view_model_provider.dart';

class AddressBottomSheet extends ConsumerWidget {
  const AddressBottomSheet(
      {Key? key, this.fromSelector = false, this.forEdit = false})
      : super(key: key);
  final bool fromSelector;
  final bool forEdit;
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final style = theme.textTheme;
    final model = ref.watch(writeAddressViewModelProvider);
    return Stack(
      children: [
        ListView(
          shrinkWrap: true,
          padding: EdgeInsets.fromLTRB(
              24, 48, 24, 48.0 + MediaQuery.of(context).viewInsets.bottom),
          children: [
            Text(
              model.address!.location,
              style: style.titleMedium,
            ),
            SizedBox(height: 8),
            Text(
              model.address!.formated,
              style: style.bodySmall!.copyWith(color: style.bodyLarge!.color),
            ),
            SizedBox(height: 24),
            TextFormField(
              initialValue: model.address!.number,
              decoration: InputDecoration(hintText: Labels.houseFlatBlockNo),
              onChanged: (v) => model.number = v,
              textCapitalization: TextCapitalization.characters,
            ),
            SizedBox(height: 16),
            TextFormField(
              initialValue: model.address!.landmark,
              decoration: InputDecoration(hintText: Labels.landmark),
              onChanged: (v) => model.landmark = v,
              textCapitalization: TextCapitalization.words,
            ),
            SizedBox(height: 24),
            Row(
              children: [
                SizedBox(width: 24),
                Text(Labels.type),
                SizedBox(width: 16),
                model.needStoreAddress
                    ? MyChoiceChip(
                        onSelected: (v) {},
                        lable: Labels.store,
                        selected: true,
                        icon: AppIcons.home,
                      )
                    : !model.homeAddressExists
                        ? MyChoiceChip(
                            onSelected: (v) => model.type = v,
                            lable: Labels.home,
                            selected: model.type == Labels.home,
                            icon: AppIcons.home,
                          )
                        : SizedBox(),
            if(model.needStoreAddress|| (!model.homeAddressExists))   SizedBox(width: 16),
                if (!model.needStoreAddress)
                  MyChoiceChip(
                    onSelected: (v) => model.other = true,
                    lable: Labels.other,
                    selected: model.other,
                    icon: AppIcons.direction,
                  ),
              ],
            ),
            model.other
                ? Padding(
                    padding: const EdgeInsets.only(top: 12),
                    child: TextFormField(
                      initialValue: model.type,
                      decoration: InputDecoration(hintText: Labels.giveItAname),
                      onChanged: (v) => model.type = v,
                      textCapitalization: TextCapitalization.words,
                    ),
                  )
                : SizedBox(),
            SizedBox(height: 24),
            model.loading
                ? Center(
                    child: CircularProgressIndicator(),
                  )
                : BigButton(
                    child: Text(Labels.continueButton),
                    onPressed: model.isReady
                        ? ()  {
                             model.addAddress(
                              onDone: () {
                                if (model.needStoreAddress) {
                                  Navigator.pushAndRemoveUntil(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => Root(),
                                      ),
                                      (route) => false);
                                } else {
                                  Navigator.pop(context);
                                }
                              },
                            );
                          }
                        : null,
                  ),
          ],
        ),
        Positioned(
          right: 8,
          top: 8,
          child: IconButton(
            onPressed: () => Navigator.pop(context),
            icon: Icon(
              Icons.keyboard_arrow_down,
            ),
          ),
        )
      ],
    );
  }
}
