import 'package:cloud_firestore/cloud_firestore.dart';

class Subcategory {
  final String id;
  final String name;
  final String image;
  final String categoryId;
    final int index;


  Subcategory({
    required this.id,
    required this.name,
    required this.image,
    required this.categoryId,
        required this.index,

  });

  // Subcategory copyWith({
  //   String? name,
  //   String? image,
  //   String? categoryId,
  // }) {
  //   return Subcategory(
  //     id: id,
  //     name: name ?? this.name,
  //     image: image ?? this.image,
  //     categoryId: categoryId ?? this.categoryId,
  //           index: index,

  //   );
  // }

  // Map<String, dynamic> toMap() {
  //   return {'name': name, 'image': image, 'categoryId': categoryId,};
  // }

  factory Subcategory.fromMap(DocumentSnapshot doc) {
    final map = doc.data() as Map<String, dynamic>;
    return Subcategory(
      name: map['name'],
      image: map['image'],
      categoryId: map['categoryId'],
      id: doc.id,
      index: map['index'],
    );
  }

  // factory Subcategory.empty() {
  //   return Subcategory(
  //     name: '',
  //     image: '',
  //     categoryId: '',
  //     id: '',
  //     index: 0
  //   );
  // }
}
