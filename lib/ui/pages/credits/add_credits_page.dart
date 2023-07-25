import 'package:bind_app/ui/components/loading.dart';
import 'package:bind_app/ui/pages/credits/providers/master_data_provider.dart';
import 'package:flutter/services.dart';

import '../../../model/order.dart';

import '../../components/big_button.dart';
import '../../components/my_appbar.dart';
import 'providers/add_credits_view_model_provider.dart';
import '../../theme/app_colors.dart';
import '../../../utils/labels.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../orders/order_checkout_page.dart';
import 'widgets/credit.dart';
import 'widgets/option_card.dart';

class AddCreditsPage extends ConsumerWidget {
  AddCreditsPage({Key? key}) : super(key: key);
  final _formKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final style = theme.textTheme;
    final model = ref.watch(addCreditsViewModelProvider);
    return Scaffold(
      appBar: MyAppBar(
        title: Text(Labels.addCredits),
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.fromLTRB(24, 8, 24, 48),
        child: BigButton(
          child: RichText(
            text: TextSpan(
              text: Labels.pay,
              style: style.labelLarge,
              children: [
                TextSpan(
                  text: "  ${Labels.rupee}",
                  style: style.labelSmall!.copyWith(color: style.labelLarge!.color),
                ),
                TextSpan(
                  text: " ${model.amount ?? ""}",
                  style: style.labelLarge,
                ),
              ],
            ),
          ),
          onPressed: model.amount != null && model.credits != null
              ? () {
                  if (_formKey.currentState!.validate()) {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => OrderCheckoutPage(
                          amount: model.amount!,
                          quantity: model.credits!,
                          productName: Labels.bindCredits,
                          type: OrderType.credits,
                          extra: model.extra,
                          price: model.masterData.price,
                          discount: model.discount,
                          name: model.applied?.formatedName ??
                              '${model.credits!} credits buy',
                        ),
                      ),
                    );
                  }
                }
              : null,
        ),
      ),
      body: ListView(
        children: [
          Padding(
            padding: const EdgeInsets.all(24),
            child: Text(
              Labels.quickBuy,
              style: style.titleMedium,
            ),
          ),
          SingleChildScrollView(
            physics: BouncingScrollPhysics(),
            scrollDirection: Axis.horizontal,
            child: Padding(
              padding: const EdgeInsets.all(12),
              child: Row(
                children: model.options
                    .map((e) => OptionCard(
                          option: e,
                          price: model.masterData.price,
                        ))
                    .toList(),
              ),
            ),
          ),
          SizedBox(height: 16),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
            child: Text(Labels.buyCredits),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: Form(
              key: _formKey,
              child: TextFormField(
                style: style.titleLarge,
                decoration: InputDecoration(
                  prefixIcon: Padding(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    child: Credit(size: 32),
                  ),
                ),
                onChanged: (v) => model.credits = int.tryParse(v),
                keyboardType: const TextInputType.numberWithOptions(
                    signed: true, decimal: true),
                textInputAction: TextInputAction.done,
                textAlign: TextAlign.center,
                inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                validator: (v) =>
                    int.parse(v!) < 10 ? Labels.minimum10Coins : null,
              ),
            ),
          ),
          SizedBox(height: 8),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
            child: Text(
              Labels.minimum10Coins,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 12,
              ),
            ),
          ),
          model.applied != null
              ? Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.check,
                        size: 16,
                        color: AppColors.green,
                      ),
                      SizedBox(width: 8),
                      Text(
                        '${model.applied!.name}',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 10,
                          color: AppColors.green,
                        ),
                      ),
                    ],
                  ),
                )
              : SizedBox(),
          model.may != null
              ? Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                  child: Text(
                    '${model.may!.name} on loading ${model.may!.quantity}+ credits',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 10,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                )
              : SizedBox(),
        ],
      ),
    );
  }
}

class AddCreditsPageRoot extends ConsumerWidget {
  const AddCreditsPageRoot({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return ref.watch(masterDataProvider).when(
          data: (_) {
            return AddCreditsPage();
          },
          loading: () => Scaffold(
            body: Loading(),
          ),
          error: (e, s) => Scaffold(
            body: Center(
              child: Text('$e'),
            ),
          ),
        );
  }
}
