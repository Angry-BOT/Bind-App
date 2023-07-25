import 'package:bind_app/providers/keys_provider.dart';

import '../../../../enums/payment_status.dart';
import '../../../../repository/order_repository.dart';
import '../../../../utils/labels.dart';

import '../../../../model/order.dart';
import '../../../../model/profile.dart';
import '../../profile/providers/profile_provider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:razorpay_flutter/razorpay_flutter.dart';

final orderCheckoutViewModelProvider =
    ChangeNotifierProvider((ref) => OrderCheckoutViewModel(ref));

class OrderCheckoutViewModel extends ChangeNotifier {
  final Ref _ref;
  OrderCheckoutViewModel(this._ref);

  Profile get _profile => _ref.read(profileProvider).value!;

  OrderRepository get _repository => _ref.read(orderRepositoryProvider);

  final _razorpay = Razorpay();

  bool _loading = false;
  bool get loading => _loading;
  set loading(bool loading) {
    _loading = loading;
    notifyListeners();
  }

  void pay(
      {required Function(String) onDone,
      required int quantity,
      required String productName,
      required double amount,
      required String type,
      required double price,
      required String name,
      double? discount,
      int? extra,
      String? idd}) async {
    loading = true;
    print("loading started");

    ////key secret = 15cAuO72CIFtcTGNJVpomoxN
    /// id = rzp_test_4oXNQf3X0f5a5B

    try {
      final l =
          _profile.addresses.where((element) => element.name == Labels.store);
      final order = Order(
        amount: amount,
        id: '',
        quantity: quantity,
        createdAt: DateTime.now(),
        paymentMethod: 'Razorpay',
        paymentStatus: PaymentStatus.notPaid,
        orderId: '',
        productName: productName,
        type: type,
        uid: _profile.id,
        extraQuantity: extra,
        price: price,
        discount: discount,
        name: name,
        state: l.isNotEmpty ? (l.first.state ?? '') : '',
      );
      late String id;
      if (idd != null) {
        id = idd;
      } else {
        try {
          id = await _repository.order(order);
          print("order created");
        } catch (e) {
          loading = false;
          print(e);
          return;
        }
      }
      final options = {
        'key': _ref.read(keysProvider).razorpayKey,
        'amount': (amount * 100).toInt(),
        'name': '$quantity $productName',
        'description': 'Pay For Checkout',
        'order_id': id,
        'prefill': {
          'contact': _profile.mobile,
          'email': _profile.emailAddress,
        }
      };
      print("option created");
      _razorpay.open(options);
      _razorpay.on(Razorpay.EVENT_PAYMENT_SUCCESS,
          (PaymentSuccessResponse res) async {
        _razorpay.clear();
        print("listened success");
        try {
          await _repository.update(
            map: {
              'paymentId': res.paymentId,
              'signature': res.signature,
              'paymentStatus': PaymentStatus.success,
              'createdAt': Timestamp.now(),
            },
            id: id,
          );
        } catch (e) {
          print(e);
        }
        print("order updated");
        onDone(id);
        loading = false;
      });
      _razorpay.on(Razorpay.EVENT_PAYMENT_ERROR,
          (PaymentFailureResponse res) async {
        print("listened updated");
        _razorpay.clear();
        try {
          await _repository.update(
            id: id,
            map: {
              'paymentStatus': PaymentStatus.failed,
            },
          );
        } catch (e) {
          print(e);
        }
        onDone(id);
        loading = false;
      });
      _razorpay.on(Razorpay.EVENT_EXTERNAL_WALLET,
          (ExternalWalletResponse res) {
        _repository.update(
          map: {
            'paymentMethod': res.walletName,
          },
          id: id,
        );
      });
    } catch (e) {
      print(e);
    }
  }
}
