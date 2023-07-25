
import 'package:cloud_firestore/cloud_firestore.dart';

class CategoryEvent {
 final String id;
  final String city;
 final Timestamp createdAt;
 final List<String> subcategoryIds;
 
  CategoryEvent({
    required this.id,
    required this.city,
    required this.createdAt,
    required this.subcategoryIds,
  });

  // CategoryEvent copyWith({
  //   String? categoryId,
  //   Timestamp? createdAt,
  // }) {
  //   return CategoryEvent(
  //     categoryId: categoryId ?? this.categoryId,
  //     createdAt: createdAt ?? this.createdAt,
  //   );
  // }

  Map<String, dynamic> toMap() {
    return {
      'categoryId': id,
      'createdAt': createdAt,
      'city': city,
      'subcategoryIds': subcategoryIds,
    };
  }

  // factory CategoryEvent.fromMap(Map<String, dynamic> map) {
  //   return CategoryEvent(
  //     categoryId: map['categoryId'],
  //     createdAt: map['createdAt'],
  //   );
  // }
}
