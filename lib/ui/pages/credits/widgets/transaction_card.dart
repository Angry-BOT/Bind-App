import '../../../../enums/payment_status.dart';
import '../enquiry_root.dart';
import '../ref_order_page.dart';

import '../../../../model/transaction.dart';
import '../../../../utils/formats.dart';
import 'package:flutter/material.dart';

class TransactionCard extends StatelessWidget {
  const TransactionCard({
    Key? key,
    required this.transaction,
  }) : super(key: key);

  final CreditTransaction transaction;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final style = theme.textTheme;
    return ListTile(
      onTap: transaction.type == TransactionType.deducted ||
              transaction.type == TransactionType.load
          ? () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) =>
                      transaction.type == TransactionType.deducted
                          ? AdminEnquiryRoot(id: transaction.refId)
                          : RefOrderPage(id: transaction.refId),
                ),
              );
            }
          : null,
      leading: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            transaction.type == TransactionType.deducted
                ? Icons.remove
                : Icons.add,
            color: transaction.status == PaymentStatus.success
                ? (transaction.type == TransactionType.deducted
                    ? Colors.red
                    : Colors.green)
                : Colors.orange,
          ),
        ],
      ),
      title: Row(
        children: [
          Text(
            Formats.date(transaction.createdAt),
            style: style.bodySmall,
          ),
          SizedBox(width: 8),
          Material(
            shape: StadiumBorder(),
            color: transaction.status == PaymentStatus.success
                ? Colors.green
                : Colors.red,
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 2, horizontal: 8),
              child: Text(
                "${transaction.status.toUpperCase()}",
                style: TextStyle(
                  fontSize: 6,
                  color: Colors.white,
                ),
              ),
            ),
          ),
          SizedBox(width: 8),
        transaction.type2!=null? Material(
            shape: StadiumBorder(),
            color: Colors.blue,
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 2, horizontal: 8),
              child: Text(
                "${transaction.type2!.toUpperCase()}",
                style: TextStyle(
                  fontSize: 6,
                  color: Colors.white,
                ),
              ),
            ),
          ):SizedBox(),
        ],
      ),
      subtitle: Text(
        'Credit ${transaction.type}',
        style: style.titleMedium,
      ),
      trailing: Text(
        '${transaction.credits}',
        style: style.titleMedium,
      ),
    );
  }
}
