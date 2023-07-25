import 'dart:convert';

import 'package:bind_app/providers/keys_provider.dart';

import '../model/id.dart';
import '../model/order.dart';
import '../ui/pages/auth/providers/auth_view_model_provider.dart';
import '../utils/constants.dart';
import '../utils/dates.dart';
import '../utils/formats.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:http/http.dart' as http;

final orderRepositoryProvider = Provider((ref) => OrderRepository(ref));

class OrderRepository {
  final Ref _ref;
  OrderRepository(this._ref);

  User get _user => _ref.read(authViewModelProvider).user!;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<String> order(Order order) async {
    final ID id =
        await _firestore.collection(Constants.iD).doc(order.type).get().then(
              (value) => ID.fromFirestore(value),
            );

    final String ex = order.type == OrderType.assistance ? 'BA' : 'B';

    final receiptId = id.date == Dates.today
        ? "$ex${Formats.id(Dates.today)}-${id.count + 1}"
        : "$ex${Formats.id(Dates.today)}-1";

    _firestore.collection(Constants.iD).doc(order.type).update(
          id.date == Dates.today
              ? {
                  Constants.count: FieldValue.increment(1),
                }
              : ID(date: Dates.today, count: 1).toMap(),
        );

    final keys = _ref.read(keysProvider);

    final String basicAuth = 'Basic ' +
        base64Encode(
            utf8.encode('${keys.razorpayKey}:${keys.razrorpaySecret}'));
    final response =
        await http.post(Uri.parse('https://api.razorpay.com/v1/orders'),
            headers: {
              'Content-Type': 'application/json',
              'authorization': basicAuth,
            },
            body: jsonEncode({
              "amount": (order.amount * 100).toInt(),
              "currency": "INR",
              "receipt": receiptId,
              "notes": {}
            }));
    if (response.statusCode == 200) {
      final id = jsonDecode(response.body)["id"];
      final doc = _firestore.collection(Constants.orders).doc(id);
      doc.set(
        order
            .copyWith(
              orderId: receiptId,
            )
            .toMap(),
      );
      return doc.id;
    } else {
      return Future.error(jsonDecode(response.body)["error"]["description"]);
    }
  }

  Future<void> update({
    required Map<String, dynamic> map,
    required String id,
  }) async {
    await _firestore.collection(Constants.orders).doc(id).update({
      ...map,
      Constants.updatedAt: Timestamp.now(),
    });

    // if (success != null) {
    //   if (success) {
    //     _batch.update(_firestore.collection(Constants.wallets).doc(_user.uid), {
    //       Constants.credits: FieldValue.increment(credits),
    //     });
    //   }
    // _batch.set(
    //   _firestore.collection(Constants.transactions).doc(),
    //   CreditTransaction(
    // id: '',
    // credits: credits,
    // status: success ? PaymentStatus.success : PaymentStatus.failed,
    // type: TransactionType.load,
    // createdAt: DateTime.now(),
    // refId: id,
    // uid: _user.uid,
    //   ).toMap(),
    // );
    // }
  }

  Stream<Order?> assistanceOrder(String id) {
    return _firestore
        .collection(Constants.orders)
        .where(Constants.uid, isEqualTo: id)
        .where(Constants.type, isEqualTo: OrderType.assistance)
        .orderBy(Constants.createdAt, descending: true)
        .limit(1)
        .snapshots()
        .map((event) {
      if (event.docs.isNotEmpty) {
        return Order.fromMap(event.docs.first);
      } else {
        return null;
      }
    });
  }
}
