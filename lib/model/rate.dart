
import 'package:cloud_firestore/cloud_firestore.dart';

class Rate {
  final String id;
  final String storeId;
  final String enquiryId;
  final String customerId;
  final String customerName;
  final bool fulFill;
  final bool quality;
  final double rating;
  final List<String> images;
  final String review;
  final DateTime createdAt;
  final String? reply;
  final bool publish;
  final String city;
  

  Rate({
    required this.id,
    required this.storeId,
    required this.customerId,
    required this.customerName,
    required this.fulFill,
    required this.quality,
    required this.rating,
    required this.images,
    required this.review,
    required this.createdAt,
    required this.enquiryId,
    required this.publish,
     this.reply,
    required this.city,
  });

  Rate copyWith({
    String? id,
    String? storeId,
    String? customerId,
    String? customerName,
    bool? fulFill,
    bool? quality,
    double? rating,
    List<String>? images,
    String? review,
    String? reply,
    bool? publish,
    String? city,
  }) {
    return Rate(
      id: id ?? this.id,
      storeId: storeId ?? this.storeId,
      customerId: customerId ?? this.customerId,
      customerName: customerName ?? this.customerName,
      fulFill: fulFill ?? this.fulFill,
      quality: quality ?? this.quality,
      rating: rating ?? this.rating,
      images: images ?? this.images,
      review: review ?? this.review,
      createdAt: createdAt,
      enquiryId: enquiryId,
      reply: reply,
      publish: publish??this.publish,
      city: city??this.city,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'storeId': storeId,
      'customerId': customerId,
      'enquiryId':enquiryId,
      'customerName': customerName,
      'fulFill': fulFill,
      'quality': quality,
      'rating': rating,
      'images': images,
      'review': review,
      'createdAt':Timestamp.fromDate(createdAt),
      'reply':reply,
      'publish':publish,
      'city': city,
    };
  }

  factory Rate.fromMap(DocumentSnapshot doc) {
    final Map<String, dynamic> map = doc.data() as Map<String, dynamic>;
    return Rate(
      id: doc.id,
      storeId: map['storeId'],
      customerId: map['customerId'],
      customerName: map['customerName'],
      fulFill: map['fulFill'],
      quality: map['quality'],
      rating: map['rating'],
      images: List<String>.from(map['images']),
      review: map['review'],
      createdAt: map['createdAt'].toDate(),
      enquiryId: map['enquiryId'],
      reply: map['reply'],
      publish: map['publish'],
      city: map['city']
    );
  }
}
