import 'package:cloud_firestore/cloud_firestore.dart';

import 'address.dart';

class Enquiry {
  final String id;
  final String enquiryId;
  final String storeId;
  final String storeType;
  final String username;
  final String customerId;
  final String storeName;
  final String customerName;
  final Address address;
  final String message;
  final List<String> products;
  final DateTime createdAt;
  final DateTime? updatedAt;
  final bool reviewed;
  final bool bought;

  Enquiry({
    required this.id,
    required this.storeId,
    required this.storeType,
    required this.customerId,
    required this.storeName,
    required this.customerName,
    required this.address,
    required this.message,
    required this.products,
    required this.createdAt,
    required this.reviewed,
    required this.username,
    required this.enquiryId,
    required this.bought,
     this.updatedAt,
  });

  DateTime get expiryDate => createdAt.add(Duration(days: 1));

  bool get expired =>
      expiryDate.isBefore(DateTime.now()) && !bought;
  bool get readyForReview => (expired&&!bought)  ||
       (bought &&  (updatedAt??createdAt).add(Duration(days: 2)).subtract(Duration(minutes: 5)).isBefore(DateTime.now())) ;

  bool get pending =>
      expiryDate.isAfter(DateTime.now()) && !bought;

  Enquiry copyWith({
    String? id,
    String? storeId,
    String? storeType,
    String? customerId,
    String? storeName,
    String? customerName,
    Address? address,
    String? message,
    List<String>? products,
    String? status,
    String? enquiryId,
    bool? bought,
  }) {
    return Enquiry(
      id: id ?? this.id,
      storeId: storeId ?? this.storeId,
      storeType: storeType ?? this.storeType,
      customerId: customerId ?? this.customerId,
      storeName: storeName ?? this.storeName,
      customerName: customerName ?? this.customerName,
      address: address ?? this.address,
      message: message ?? this.message,
      products: products ?? this.products,
      // status: status ?? this.status,
      createdAt: this.createdAt,
      reviewed: reviewed,
      username: username,
      enquiryId: enquiryId ?? this.enquiryId,
      bought: bought ?? this.bought,
      updatedAt: this.updatedAt
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'storeId': storeId,
      'storeType': storeType,
      'customerId': customerId,
      'storeName': storeName,
      'customerName': customerName,
      'address': address.toMap(),
      'message': message,
      'products': products,
      'createdAt': Timestamp.fromDate(createdAt),
      'reviewed': reviewed,
      'username': username,
      'enquiryId': enquiryId,
      'bought': bought,
    };
  }

  factory Enquiry.fromMap(DocumentSnapshot doc) {
    final Map<String, dynamic> map = doc.data() as Map<String, dynamic>;
    return Enquiry(
      id: doc.id,
      storeId: map['storeId'],
      storeType: map['storeType'],
      customerId: map['customerId'],
      storeName: map['storeName'],
      customerName: map['customerName'],
      address: Address.fromMap(map['address']),
      message: map['message'],
      products: List<String>.from(map['products']),
      createdAt: map['createdAt'].toDate(),
      updatedAt: map['updatedAt']?.toDate(),
      reviewed: map['reviewed'],
      username: map['username'],
      enquiryId: map['enquiryId'],
      bought: map['bought'],
    );
  }
}