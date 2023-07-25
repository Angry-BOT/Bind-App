
import 'package:cloud_firestore/cloud_firestore.dart';

class CreditTransaction {
  final String id;
  final String refId;
  final String uid;
  final int credits;
  final String status;
  final String type;
  final String? type2;
  final DateTime createdAt;

  CreditTransaction({
    required this.id,
    required this.credits,
    required this.status,
    required this.type,
    required this.createdAt,
    required this.refId,
    required this.uid,
    this.type2,
  });

  CreditTransaction copyWith({
    String? id,
    int? credits,
    String? status,
    String? type,
    DateTime? createdAt,
    String? refId,
    String? uid,
    String? type2
  }) {
    return CreditTransaction(
      id: id ?? this.id,
      credits: credits ?? this.credits,
      status: status ?? this.status,
      type: type ?? this.type,
      createdAt: createdAt ?? this.createdAt,
      refId: refId??this.refId,
      uid: uid??this.uid,
      type2: type2??this.type2,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'credits': credits,
      'status': status,
      'type': type,
      'createdAt': Timestamp.fromDate(createdAt),
      'refId':refId,
      'uid': uid,
      'debit': type==TransactionType.deducted,
      'type2':type2
    };
  }

  factory CreditTransaction.fromMap(DocumentSnapshot doc) {
    final Map<String, dynamic> map = doc.data() as  Map<String, dynamic>;
    return CreditTransaction(
      id: doc.id,
      credits: map['credits'],
      status: map['status'],
      type: map['type'],
      createdAt: map['createdAt'].toDate(),
      uid: map['uid'],
      refId: map['refId'],
      type2: map['type2'],
    );
  }
}


class TransactionType {
  static const String added = "Added";
  static const String deducted = "Deducted";
  static const String load = "Load";
}

class TransactionType2 {
  static const String freeCredit = "free credit";
  static const String successfulReferral = "successful referral";
  static const String admin = "admin";
}