
import 'package:cloud_firestore/cloud_firestore.dart';

class FailedDeal {
  final String id;
  final String storeId;
  final String eId;
  final String enquiryId;
  final String customerId;
  final String customerName;
  final DateTime createdAt;
  final String message;
  final String reason;

  FailedDeal({
    required this.id,
    required this.storeId,
    required this.enquiryId,
    required this.customerId,
    required this.customerName,
    required this.createdAt,
    required this.message,
    required this.reason,
    required this.eId,
  });

  FailedDeal copyWith({
    String? id,
    String? storeId,
    String? enquiryId,
    String? customerId,
    String? customerName,
    DateTime? createdAt,
    String? message,
    String? reason,
    String? eId,
  }) {
    return FailedDeal(
      id: id ?? this.id,
      storeId: storeId ?? this.storeId,
      enquiryId: enquiryId ?? this.enquiryId,
      customerId: customerId ?? this.customerId,
      customerName: customerName ?? this.customerName,
      createdAt: createdAt ?? this.createdAt,
      message: message ?? this.message,
      reason: reason ?? this.reason,
      eId: eId??this.eId,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'storeId': storeId,
      'enquiryId': enquiryId,
      'customerId': customerId,
      'customerName': customerName,
      'createdAt': Timestamp.fromDate(createdAt),
      'message': message,
      'reason': reason,
      'eId':eId,
    };
  }

  // factory FailedDeal.fromMap(DocumentSnapshot doc) {
  //   final Map<String, dynamic> map = doc.data() as Map<String, dynamic>; 
  //   return FailedDeal(
  //     id: doc.id,
  //     storeId: map['storeId'],
  //     enquiryId: map['enquiryId'],
  //     customerId: map['customerId'],
  //     customerName: map['customerName'],
  //     createdAt: DateTime.fromMillisecondsSinceEpoch(map['createdAt']),
  //     message: map['message'],
  //     reason: map['reason'],
  //     eId: map['eId'],
  //   );
  // }
}
