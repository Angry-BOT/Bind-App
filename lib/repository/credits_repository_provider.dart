import '../enums/payment_status.dart';

import '../model/id.dart';
import '../model/order.dart';
import '../model/transaction.dart';
import '../model/wallet.dart';
import '../ui/pages/auth/providers/auth_view_model_provider.dart';
import '../utils/constants.dart';
import '../utils/dates.dart';
import '../utils/formats.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

final creditsRepositoryProvider = Provider((ref) => CreditsRepository(ref));

class CreditsRepository {
  final Ref _ref;
  CreditsRepository(this._ref);

  User get _user => _ref.read(authViewModelProvider).user!;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Stream<Wallet> streamWallet(String id) => _firestore
      .collection(Constants.wallets)
      .doc(id)
      .snapshots()
      .map((event) => Wallet.fromMap(event));

  Future<String> order(Order order) async {
    final ID id = await _firestore
        .collection(Constants.iD)
        .doc(Constants.credits)
        .get()
        .then(
          (value) => ID.fromFirestore(value),
        );

    final receiptId = id.date == Dates.today
        ? "B${Formats.id(Dates.today)}-${id.count + 1}"
        : "B${Formats.id(Dates.today)}-1";

    _firestore.collection(Constants.iD).doc(Constants.credits).update(
          id.date == Dates.today
              ? {
                  Constants.count: FieldValue.increment(1),
                }
              : ID(date: Dates.today, count: 1).toMap(),
        );

    final String username = 'rzp_test_4oXNQf3X0f5a5B';
    final String password = '15cAuO72CIFtcTGNJVpomoxN';
    final String basicAuth =
        'Basic ' + base64Encode(utf8.encode('$username:$password'));
    final response = await http.post(
        Uri.parse('https://api.razorpay.com/v1/orders'),
        headers: {
          'Content-Type': 'application/json',
          'authorization': basicAuth
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
    required bool? success,
    required int credits,
  }) async {
    final _batch = _firestore.batch();
    _batch.update(_firestore.collection(Constants.orders).doc(id), map);
    if (success != null) {
      if (success) {
        _batch.update(_firestore.collection(Constants.wallets).doc(_user.uid), {
          Constants.credits: FieldValue.increment(credits),
        });
      }
      _batch.set(
        _firestore.collection(Constants.transactions).doc(),
        CreditTransaction(
          id: '',
          credits: credits,
          status: success ? PaymentStatus.success : PaymentStatus.failed,
          type: TransactionType.load,
          createdAt: DateTime.now(),
          refId: id,
          uid: _user.uid,
        ).toMap(),
      );
    }
    await _batch.commit();
  }

  Stream<Order> streamOrder(String id) => _firestore
      .collection(Constants.orders)
      .doc(id)
      .snapshots()
      .map((event) => Order.fromMap(event));

  Future<List<DocumentSnapshot>> transactionsLimitFuture(
      {required int limit,
      DocumentSnapshot? last,
      bool? debit,
      required String id}) async {
    var collectionRef = _firestore
        .collection(Constants.transactions)
        .where(Constants.uid, isEqualTo: id);

    if (debit != null) {
      collectionRef = collectionRef.where(Constants.debit, isEqualTo: debit);
    }
    collectionRef =
        collectionRef.orderBy(Constants.createdAt, descending: true);
    if (last != null) {
      collectionRef = collectionRef.startAfterDocument(last);
    }

    collectionRef = collectionRef.limit(limit);
    return await collectionRef.get().then(
          (value) => value.docs,
        );
  }

  Future<void> buyEnquiry({required String enquiryId}) async {
    final _batch = _firestore.batch();
    _batch.update(_firestore.collection(Constants.enquires).doc(enquiryId), {
      Constants.bought: true,
      Constants.updatedAt: Timestamp.now(),
    });
    _batch.update(_firestore.collection(Constants.wallets).doc(_user.uid), {
      Constants.credits: FieldValue.increment(-1),
    });
    _batch.set(
        _firestore.collection(Constants.transactions).doc(),
        CreditTransaction(
          uid: _user.uid,
          id: '',
          createdAt: DateTime.now(),
          credits: 1,
          refId: enquiryId,
          status: PaymentStatus.success,
          type: TransactionType.deducted,
        ).toMap());
    _batch.commit();
  }

  void addCreditsFromShare(
      {required String storeId, required String uid, bool firstTime = false}) {
    final _batch = _firestore.batch();
    _batch.update(_firestore.collection(Constants.users).doc(uid), {
      'storeIds': firstTime ? [storeId] : FieldValue.arrayUnion([storeId])
    });
    _batch.update(_firestore.collection(Constants.wallets).doc(storeId),
        {Constants.credits: FieldValue.increment(3)});
    _batch.set(
      _firestore.collection(Constants.transactions).doc(),
      CreditTransaction(
        uid: storeId,
        id: '',
        createdAt: DateTime.now(),
        credits: 3,
        refId: uid,
        status: PaymentStatus.success,
        type: TransactionType.added,
        type2: TransactionType2.successfulReferral,
      ).toMap(),
    );
    _batch.commit();
  }
}
