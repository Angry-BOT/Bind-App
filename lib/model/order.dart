
import 'package:cloud_firestore/cloud_firestore.dart';

class Order {
  final String id;
  final String name;
  final String orderId;
  final String uid;
  final int quantity;
  final double price;
  final String productName;
  final double amount;
  final String paymentStatus;
  final String paymentMethod;
  final DateTime createdAt;
  final String type;
  final int? extraQuantity;
  final double? discount;
  final String state;

  Order({
    required this.id,
    required this.orderId,
    required this.quantity,
    required this.price,
    required this.amount,
    required this.paymentStatus,
    required this.paymentMethod,
    required this.createdAt,
    required this.productName,
    required this.type,
    required this.uid,
    required this.extraQuantity,
    required this.discount,
    required this.name,
    required this.state,
  });

  Order copyWith({
    String? id,
    int? quantity,
    double? amount,
    String? paymentStatus,
    String? paymentMethod,
    DateTime? createdAt,
    String? orderId,
    String? productName,
    String? type,
    String? uid,
    double? price,
    double? discount,
    String? name,
    String? state
  }) {
    return Order(
      id: id ?? this.id,
      quantity: quantity ?? this.quantity,
      amount: amount ?? this.amount,
      paymentStatus: paymentStatus ?? this.paymentStatus,
      paymentMethod: paymentMethod ?? this.paymentMethod,
      createdAt: createdAt ?? this.createdAt,
      orderId: orderId??this.orderId,
      productName: productName??this.productName,
      type: type??this.type,
      uid: uid??this.uid,
      extraQuantity: extraQuantity??this.extraQuantity,
      price: price??this.price,
      discount: discount?? this.discount,
      name: name??this.name,
      state: state??this.state,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'orderId':orderId,
      'quantity': quantity,
      'amount': amount,
      'paymentStatus': paymentStatus,
      'paymentMethod': paymentMethod,
      'createdAt': Timestamp.fromDate(createdAt),
      'productName': productName,
      'type': type,
      'uid': uid,
      'extraQuantity': extraQuantity,
      'price': price,
      'discount': discount,
      'name': name,
      'state': state,
    };
  }

  factory Order.fromMap(DocumentSnapshot doc) {
    final Map<String, dynamic> map = doc.data() as Map<String, dynamic>;
    return Order(
      id: doc.id,
      quantity: map['quantity'],
      amount: map['amount'],
      paymentStatus: map['paymentStatus'],
      paymentMethod: map['paymentMethod'],
      createdAt: map['createdAt'].toDate(),
      orderId: map['orderId'],
      productName: map['productName'],
      type: map['type'],
      uid: map['uid'],
      extraQuantity: map['extraQuantity'],
      price: map['price'],
      discount: map['discount'],
      name: map['name'],
      state: map['state'],
    );
  }
}


class OrderType {
  static const String assistance = 'assistance';
  static const String credits = 'credits';
}