import 'package:cloud_firestore/cloud_firestore.dart';

class Product {
  final String id;
  final String storeId;
  final String image;
  final String name;
  final String description;
  double? price;
  final bool? priceOnEnquire;
  final String unit;
  final List<String> images;

  Product({
    required this.id,
    required this.name,
    required this.image,
    required this.description,
    required this.price,
    this.priceOnEnquire,
    required this.unit,
    required this.storeId,
    required this.images,
  });

  Product copyWith({
    String? id,
    String? name,
    String? image,
    String? description,
    double? price,
    bool? priceOnEnquire,
    String? unit,
    String? storeId,
    List<String>? images,
  }) {
    return Product(
      id: id ?? this.id,
      name: name ?? this.name,
      description: description ?? this.description,
      price: price ?? this.price,
      priceOnEnquire: priceOnEnquire ?? this.priceOnEnquire,
      unit: unit ?? this.unit,
      image: image ?? this.image,
      storeId: storeId ?? this.storeId,
      images: images ?? this.images,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'image': image,
      'description': description,
      'price': price,
      'priceOnEnquire': priceOnEnquire,
      'unit': unit,
      'storeId': storeId,
      'images': images,
    };
  }

  factory Product.fromMap(DocumentSnapshot doc) {
    final Map<String, dynamic> map = doc.data() as Map<String, dynamic>;
    return Product(
      id: doc.id,
      name: map['name'],
      description: map['description'],
      price: map['price'],
      priceOnEnquire: map['priceOnEnquire'],
      unit: map['unit'],
      image: map['image'],
      storeId: map['storeId'],
      images: List<String>.from(map['images']??[]),
    );
  }

  factory Product.empty() => Product(
        id: '',
        name: '',
        description: '',
        price: null,
        unit: '',
        image: '',
        storeId: '',
        images: [],
      );
}
