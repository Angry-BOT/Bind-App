import '../../../model/order.dart';

import '../../components/big_button.dart';
import '../../components/my_appbar.dart';
import '../../components/progess_loader.dart';
import 'providers/order_checkout_view_model_provider.dart';
import '../credits/success_page.dart';
import '../credits/widgets/credit.dart';
import '../../../utils/labels.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class OrderCheckoutPage extends ConsumerWidget {
  final int quantity;
  final double amount;
  final String productName;
  final String type;
  final int? extra;
  final double price;
  final double? discount;
  final String name;

  OrderCheckoutPage(
      {required this.quantity,
      required this.amount,
      required this.productName,
      required this.type,
      required this.price,
      required this.name,
      this.discount,
      this.extra});
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final style = theme.textTheme;
    final model = ref.watch(orderCheckoutViewModelProvider);
    return ProgressLoader(
      isLoading: model.loading,
      child: Scaffold(
        appBar: MyAppBar(
          title: Text(Labels.checkout),
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
                    text: " $amount",
                    style: style.labelLarge,
                  ),
                ],
              ),
            ),
            onPressed: () {
              model.pay(
                onDone: (id) {
                  if (type == OrderType.assistance) {
                    Navigator.pop(context);
                  } else {
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                        builder: (context) => SuccessPage(id),
                      ),
                    );
                  }
                },
                quantity: quantity,
                amount: amount,
                productName: productName,
                type: type,
                extra: extra,
                price: price,
                discount: discount,
                name: name,
              );
            },
          ),
        ),
        body: ListView(
          padding: const EdgeInsets.all(8),
          children: [
            SizedBox(height: 24),
            ListTile(
              minLeadingWidth: 0,
              leading: type == OrderType.credits ? Credit(size: 32) : null,
              title: Text(
                productName,
                style: style.titleSmall,
              ),
              trailing: Text(
                '$quantity',
                style: TextStyle(fontSize: 20),
              ),
            ),
            Divider(height: 0.5),
            ListTile(
              title: Text(Labels.amountPayable),
              trailing: RichText(
                text: TextSpan(
                  text: Labels.rupee,
                  style: style.bodyLarge,
                  children: [
                        TextSpan(
                          text: " $amount",
                          style: TextStyle(fontSize: 20),
                        ),
                      ] +
                      (type == OrderType.assistance
                          ? [
                              TextSpan(
                                text: " (inclusive of GST)",
                                style: style.bodySmall!
                                    .copyWith(color: style.bodyLarge!.color),
                              )
                            ]
                          : []),
                ),
              ),
            ),
            Divider(height: 0.5),
          ],
        ),
      ),
    );
  }
}
