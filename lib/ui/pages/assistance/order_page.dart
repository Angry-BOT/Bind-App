import 'package:bind_app/ui/components/stars_background.dart';

import '../../../enums/payment_status.dart';
import '../../../model/order.dart';
import '../orders/providers/order_checkout_view_model_provider.dart';
import 'package:flutter/gestures.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../components/my_appbar.dart';
import '../../components/progess_loader.dart';
import '../../theme/app_colors.dart';
import '../../../utils/formats.dart';
import '../../../utils/labels.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class OrderPage extends ConsumerWidget {
  final Order assistance;

  const OrderPage({Key? key, required this.assistance}) : super(key: key);
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final style = theme.textTheme;
    final model = ref.watch(orderCheckoutViewModelProvider);
    return Scaffold(
      appBar: MyAppBar(
        title: Text('${Labels.order} #${assistance.orderId}'),
      ),
      body: ProgressLoader(
        isLoading: model.loading,
        child: ListView(
          padding: EdgeInsets.all(16),
          children: [
            AspectRatio(
              aspectRatio: 1.25,
              child: Stack(
                alignment: Alignment.center,
                children: [
                  assistance.paymentStatus == PaymentStatus.success
                      ? StarsBackground()
                      : SizedBox(),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Text(
                        assistance.paymentStatus == PaymentStatus.success
                            ? Labels.aBindStoreExpert
                            : "${Labels.bindAssistanceFailed} ${assistance.paymentStatus.toLowerCase()}.",
                        style: style.titleLarge,
                        textAlign: TextAlign.center,
                      ),
                      MaterialButton(
                        color: theme.primaryColor,
                        onPressed: () {
                          if (assistance.paymentStatus ==
                              PaymentStatus.success) {
                            Navigator.pop(context);
                          } else {
                            model.pay(
                              onDone: (id) {},
                              amount: assistance.amount,
                              idd: assistance.id,
                              productName: assistance.productName,
                              quantity: assistance.quantity,
                              type: assistance.type,
                              price: assistance.price,
                              name: assistance.name,
                            );
                          }
                        },
                        child: Text(
                            assistance.paymentStatus == PaymentStatus.success
                                ? Labels.backToHome
                                : Labels.pay),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            assistance.createdAt
                    .add(Duration(days: 15))
                    .isBefore(DateTime.now())
                ? RichText(
                    text: TextSpan(
                        text:
                            'To avail BIND Assistance service again for your store, write to us at ',
                        style: style.bodyMedium,
                        children: [
                          TextSpan(
                            text: 'support@bindapp.co',
                            style: style.titleSmall!.copyWith(
                              decoration: TextDecoration.underline,
                            ),
                            recognizer: TapGestureRecognizer()
                              ..onTap = () {
                                launch('mailto:support@bindapp.co');
                              },
                          )
                        ]),
                  )
                : SizedBox(),
            SizedBox(height: 16),
            Divider(height: 0.5),
            SizedBox(height: 16),
            Text(
              Labels.order,
              style: style.titleSmall,
            ),
            SizedBox(height: 16),
            Container(
              decoration: BoxDecoration(
                color: theme.cardColor,
                borderRadius: BorderRadius.circular(8),
                boxShadow: [
                  BoxShadow(color: theme.shadowColor, blurRadius: 8),
                ],
              ),
              padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 8),
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          Formats.dateTime(assistance.createdAt),
                          style: style.bodySmall,
                        ),
                        Material(
                          borderRadius: BorderRadius.circular(2),
                          color:
                              assistance.paymentStatus == PaymentStatus.success
                                  ? AppColors.green
                                  : theme.colorScheme.error,
                          child: Padding(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 8, vertical: 4),
                            child: Text(
                              assistance.paymentStatus.toUpperCase(),
                              style: style.bodySmall!.copyWith(
                                color: theme.cardColor,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      children: [
                        Expanded(
                          flex: 2,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "${Labels.bindAssistance} 1",
                                style: style.titleMedium,
                              ),
                              SizedBox(height: 4),
                              RichText(
                                text: TextSpan(
                                  text: Labels.amount,
                                  style: style.titleMedium,
                                  children: [
                                    TextSpan(
                                      text: "  ${Labels.rupee}",
                                      style: style.labelSmall!
                                          .copyWith(color: style.labelLarge!.color),
                                    ),
                                    TextSpan(
                                      text: " ${assistance.amount.toInt()}",
                                      style: style.titleMedium,
                                    ),
                                  ],
                                ),
                              ),
                              SizedBox(height: 8),
                              Text(
                                "${Labels.paidVia} ${assistance.paymentMethod}",
                                style: style.labelSmall,
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  )
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
