import '../../../enums/payment_status.dart';
import '../../components/loading.dart';
import '../../components/my_appbar.dart';
import '../../theme/app_colors.dart';
import '../../../utils/formats.dart';
import '../../../utils/labels.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import 'providers/order_provider.dart';

class RefOrderPage extends ConsumerWidget {
  const RefOrderPage({Key? key, required this.id}) : super(key: key);
  final String id;
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final style = theme.textTheme;
    final orderStream = ref.watch(orderProvider(id));
    return Scaffold(
      appBar: MyAppBar(
        title:
            Text('${Labels.order} #${orderStream.asData?.value.orderId ?? ''}'),
      ),
      body: orderStream.when(
        data: (order) => ListView(
          padding: EdgeInsets.all(16),
          children: [
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
                                      style: style.labelSmall!
                                          .copyWith(color: style.labelLarge!.color),
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
