import '../../../model/order.dart';
import '../../components/loading.dart';
import '../credits/providers/master_data_provider.dart';
import '../orders/order_checkout_page.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../components/big_button.dart';
import '../../components/my_appbar.dart';
import '../../../utils/assets.dart';
import '../../../utils/labels.dart';
import 'package:flutter/material.dart';

class AssistancePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final style = theme.textTheme;
    return Scaffold(
      appBar: MyAppBar(
        title: Text(Labels.bindAssistance),
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.fromLTRB(24, 8, 24, 48),
        child: Consumer(builder: (context, ref, child) {
          final masterData = ref.watch(masterDataProvider);
          return masterData.when(
            data: (data) => BigButton(
              child:
                  Text('${Labels.getStarted_}${data.assistancePrice.toInt()}'),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => OrderCheckoutPage(
                      quantity: 1,
                      amount: data.assistancePrice,
                      productName: Labels.bindAssistance,
                      type: OrderType.assistance,
                      price: data.assistancePrice,
                      name: Labels.bINDAssistance,
                    ),
                  ),
                );
              },
            ),
            loading: () => Loading(),
            error: (e, s) => Center(
              child: Text('Something Error!'),
            ),
          );
        }),
      ),
      body: ListView(
        padding: EdgeInsets.all(24),
        children: [
          AspectRatio(
            aspectRatio: 1.25,
            child: Image.asset(Assets.assistance),
          ),
          SizedBox(height: 16),
          Text(
            Labels.getTheMaxOut,
            style: style.titleLarge,
            textAlign: TextAlign.center,
          ),
          SizedBox(height: 16),
          Text(
            Labels.weAreHereTo,
            textAlign: TextAlign.center,
            style: TextStyle(
              color: style.bodySmall!.color,
            ),
          ),
        ],
      ),
    );
  }
}
