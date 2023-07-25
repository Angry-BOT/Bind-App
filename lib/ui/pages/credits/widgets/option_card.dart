import '../../../../model/order.dart';

import '../../../../model/option.dart';
import '../../../theme/app_colors.dart';
import '../../../../utils/formats.dart';
import '../../../../utils/labels.dart';
import 'package:flutter/material.dart';

import '../../orders/order_checkout_page.dart';
import 'credit.dart';

class OptionCard extends StatelessWidget {
  const OptionCard({Key? key, required this.option, required this.price})
      : super(key: key);
  final Option option;
  final double price;
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final style = theme.textTheme;
    return Padding(
      padding: const EdgeInsets.all(4),
      child: Column(
        children: [
          Text(
            option.name,
            style: style.labelSmall!.copyWith(color: AppColors.green),
          ),
          GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => OrderCheckoutPage(
                    amount: option.amount(price, option.quantity),
                    quantity: option.quantity,
                    productName: Labels.bindCredits,
                    type: OrderType.credits,
                    extra: option.extra,
                    price: price,
                    discount: option.discount,
                    name: option.name,
                  ),
                ),
              );
            },
            child: Container(
              height: 90,
              width: 120,
              clipBehavior: Clip.antiAlias,
              margin: EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: theme.cardColor,
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                    color: theme.shadowColor,
                    blurRadius: 8,
                  ),
                ],
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  SizedBox(),
                  SizedBox(),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Credit(size: 32),
                        Text(
                          "${option.quantity}",
                          style: style.titleLarge!.copyWith(fontSize: 22),
                        ),
                      ],
                    ),
                  ),
                  RichText(
                    text: TextSpan(
                        text: Labels.youPay,
                        style: TextStyle(
                            fontSize: 8, color: style.bodyLarge!.color),
                        children: [
                          TextSpan(
                            text:
                                ' ${Labels.rupee}${option.amount(price, option.quantity)}',
                            style: style.labelSmall,
                          )
                        ]),
                  ),
                  Container(
                    width: 56,
                    height: 2,
                    decoration: BoxDecoration(
                      color: theme.primaryColor,
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(2),
                        topRight: Radius.circular(2),
                      ),
                    ),
                  )
                ],
              ),
            ),
          ),
          option.endTime != null
              ? StreamBuilder<DateTime>(
                  initialData: DateTime.now(),
                  stream: Stream.periodic(
                      Duration(minutes: 1), (v) => DateTime.now()),
                  builder: (context, snap) {
                    final duration = option.endTime!.difference(snap.data!);
                    return Text(
                      '${Labels.endsIn} ${Formats.duration(duration.inMinutes)}',
                      style: TextStyle(
                        fontSize: 10,
                      ),
                    );
                  },
                )
              : Text(
                  '',
                  style: TextStyle(fontSize: 10),
                )
        ],
      ),
    );
  }
}
