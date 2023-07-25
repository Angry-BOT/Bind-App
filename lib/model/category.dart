
import 'package:cloud_firestore/cloud_firestore.dart';


class StoreCategory {
  final String id;
  final String name;
  final String image;
  final int index;
  
  StoreCategory({
    required this.id,
    required this.name,
    required this.image,
    required this.index,
  });

  StoreCategory copyWith({
    String? name,
    String? image,
    int? index    
  }) {
    return StoreCategory(
      name: name ?? this.name,
      image: image ?? this.image,
      id: id,
      index: index??this.index,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'image': image,
      'index':index,
    };
  }

  factory StoreCategory.fromMap(DocumentSnapshot doc) {
    final map = doc.data() as Map<String,dynamic>;
    return StoreCategory(
      name: map['name'],
      image: map['image'],
      id: doc.id,
      index: map['index']
    );
  }

  factory StoreCategory.empty() => StoreCategory(
    id: '',
    image: '',
    name: '',
    index: 0,
  );
}
