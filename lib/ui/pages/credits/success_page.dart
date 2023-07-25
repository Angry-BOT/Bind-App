import 'package:bind_app/ui/components/stars_background.dart';

import '../../../enums/payment_status.dart';

import '../../components/loading.dart';
import '../../components/my_appbar.dart';
import '../../components/progess_loader.dart';
import '../orders/providers/order_checkout_view_model_provider.dart';
import 'providers/order_provider.dart';
import 'widgets/credit.dart';
import '../../theme/app_colors.dart';
import '../../../utils/formats.dart';
import '../../../utils/labels.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class SuccessPage extends ConsumerWidget {
  final String id;

  SuccessPage(this.id);
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final style = theme.textTheme;
    final model = ref.watch(orderCheckoutViewModelProvider);
    final orderStream = ref.watch(orderProvider(id));
    return Scaffold(
      appBar: MyAppBar(
        title:
            Text('${Labels.order} #${orderStream.asData?.value.orderId ?? ''}'),
      ),
      body: orderStream.when(
        data: (order) => ProgressLoader(
          isLoading: model.loading,
          child: ListView(
            padding: EdgeInsets.all(16),
            children: [
              AspectRatio(
                aspectRatio: 1.25,
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    order.paymentStatus == PaymentStatus.success
                        ? StarsBackground()
                        : SizedBox(),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        order.paymentStatus == PaymentStatus.success
                            ? Column(
                                children: [
                                  Text(
                                    Labels.hoorayYouHaveLoaded,
                                    style: style.titleLarge,
                                    textAlign: TextAlign.center,
                                  ),
                                  SizedBox(height: 12),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Credit(size: 32),
                                      SizedBox(width: 8),
                                      Text(
                                        '${order.quantity} ${Labels.credits.toLowerCase()}',
                                        style: style.headlineSmall!.copyWith(
                                          fontWeight: FontWeight.bold,
                                        ),
                                      )
                                    ],
                                  )
                                ],
                              )
                            : Text(
                                "Bind credits checkout failed.",
                                style: style.titleLarge,
                                textAlign: TextAlign.center,
                              ),
                        MaterialButton(
                          color: theme.primaryColor,
                          onPressed: () {
                            if (order.paymentStatus == PaymentStatus.success) {
                              Navigator.pop(context);
                              Navigator.pop(context);
                            } else {
                              model.pay(
                                onDone: (id) {},
                                amount: order.amount,
                                idd: id,
                                productName: order.productName,
                                quantity: order.quantity,
                                type: order.type,
                                price: order.price,
                                name: order.name,
                              );
                            }
                          },
                          child: Text(
                            order.paymentStatus == PaymentStatus.success
                                ? Labels.backToWallet
                                : Labels.pay,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
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
                padding:
                    const EdgeInsets.symmetric(vertical: 16, horizontal: 8),
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            Formats.dateTime(order.createdAt),
                            style: style.bodySmall,
                          ),
                          Material(
                            borderRadius: BorderRadius.circular(2),
                            color: order.paymentStatus == PaymentStatus.success
                                ? AppColors.green
                                : theme.colorScheme.error,
                            child: Padding(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 8, vertical: 4),
                              child: Text(
                                order.paymentStatus.toUpperCase(),
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
                                  "${Labels.credits} ${order.quantity}",
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
                                        style: style.labelSmall!.copyWith(
                                            color: style.labelLarge!.color),
                                      ),
                                      TextSpan(
                                        text: "${order.amount}",
                                        style: style.titleMedium,
                                      ),
                                    ],
                                  ),
                                ),
                                SizedBox(height: 8),
                                Text(
                                  "${Labels.paidVia} ${order.paymentMethod}",
                                  style: style.labelSmall,
                                ),
                              ],
                            ),
                          ),
                          // order.paymentStatus == PaymentStatus.success
                          //     ? ElevatedButton(
                          //         onPressed: () {},
                          //         child: Text("    ${Labels.view}    "),
                          //       )
                          //     : SizedBox(),
                        ],
                      ),
                    )
                  ],
                ),
              )
            ],
          ),
        ),
        loading: () => Loading(),
        error: (e, s) => Center(
          child: Text(
            "$e",
          ),
        ),
      ),
    );
  }
}
