// import 'dart:convert';

// import 'package:cloud_firestore/cloud_firestore.dart';

// class SubcategoryEvent {
//   final String categoryId;
//   final String   id;
//   final String city;
//   final Timestamp createdAt;

//   SubcategoryEvent({
//     required this.categoryId,
//     required this.id,
//     required this.createdAt,
//     required this.city,
//   });

//   // SubcategoryEvent copyWith({
//   //   String? categoryId,
//   //   String? id,
//   //   Timestamp? createdAt,
//   // }) {
//   //   return SubcategoryEvent(
//   //     categoryId: categoryId ?? this.categoryId,
//   //     id: id ?? this.id,
//   //     createdAt: createdAt ?? this.createdAt,
//   //   );
//   // }

//   Map<String, dynamic> toMap() {
//     return {
//       'categoryId': categoryId,
//       'id': id,
//       'createdAt': createdAt,
//       'city': city,
//     };
//   }

//   // factory SubcategoryEvent.fromMap(Map<String, dynamic> map) {
//   //   return SubcategoryEvent(
//   //     categoryId: map['categoryId'] ?? '',
//   //     id: map['id'] ?? '',
//   //     createdAt: Timestamp.fromMap(map['createdAt']),
//   //   );
//   // }
// }
