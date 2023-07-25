import 'package:cloud_firestore/cloud_firestore.dart';

class Wallet {
  final String id;
  final int credits;
  final DateTime createdAt;
  final DateTime? updatedAt;
  final bool freez;

  Wallet({
    required this.id,
    required this.credits,
    required this.createdAt,
    this.updatedAt,
    required this.freez,
  });

  Wallet copyWith({
    String? id,
    int? credits,
    DateTime? createdAt,
    DateTime? updatedAt,
    bool? freez,
  }) {
    return Wallet(
      id: id ?? this.id,
      credits: credits ?? this.credits,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      freez: freez ?? this.freez,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'credits': credits,
      'createdAt': Timestamp.fromDate(createdAt),
      'updatedAt': updatedAt!=null? Timestamp.fromDate(updatedAt!):null,
      'freez': freez,
    };
  }

  factory Wallet.fromMap(DocumentSnapshot doc) {
    final Map<String, dynamic> map = doc.data() as Map<String, dynamic>;
    return Wallet(
      id: doc.id,
      credits: map['credits'],
      createdAt: map['createdAt'].toDate(),
      updatedAt: map['updatedAt']?.toDate(),
      freez: map['freez'],
    );
  }
}
