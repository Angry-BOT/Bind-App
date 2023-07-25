import '../enums/survicableRadius.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:geoflutterfire/geoflutterfire.dart';
import 'package:geolocator/geolocator.dart';

class Store {
  final String id;
  final String username;
  final String name;
  final String description;
  final bool isVerified;
  final bool aadharVerified;
  final String logo;
  final bool active;
  final bool enabled;
  final String type;
  final String category;
  final List<String> subCategories;
  final List<String> products;
  final double rating;
  final bool canBeRec;
  final int ratingCount;
  final GeoFirePoint point;
  final String survicableRadius;
  final int views;
  final int enquiries;

  Store({
    required this.id,
    required this.username,
    required this.name,
    required this.description,
    required this.isVerified,
    required this.logo,
    required this.active,
    required this.enabled,
    required this.products,
    required this.category,
    required this.subCategories,
    required this.type,
    required this.canBeRec,
    required this.rating,
    required this.ratingCount,
    required this.point,
    required this.survicableRadius,
    required this.enquiries,
    required this.views,
    required this.aadharVerified,
  });

  Store copyWith(
      {String? id,
      String? username,
      String? name,
      String? description,
      bool? isVerified,
      String? logo,
      bool? active,
      bool? enabled,
      String? type,
      String? category,
      List<String>? subCategories,
      List<String>? products,
      double? rating,
      bool? canBeRec,
      int? ratingCount,
      GeoFirePoint? point,
      String? survicableRadius,
      bool? aadharVerified}) {
    return Store(
      id: id ?? this.id,
      username: username ?? this.username,
      name: name ?? this.name,
      description: description ?? this.description,
      isVerified: isVerified ?? this.isVerified,
      logo: logo ?? this.logo,
      active: active ?? this.active,
      enabled: enabled ?? this.enabled,
      category: category ?? this.category,
      products: products ?? this.products,
      subCategories: subCategories ?? this.subCategories,
      type: type ?? this.type,
      canBeRec: canBeRec ?? this.canBeRec,
      rating: rating ?? this.rating,
      ratingCount: ratingCount ?? this.ratingCount,
      point: point ?? this.point,
      survicableRadius: survicableRadius ?? this.survicableRadius,
      enquiries: enquiries,
      views: views,
      aadharVerified: aadharVerified ?? this.aadharVerified,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'username': username,
      'name': name,
      'description': description,
      'isVerified': isVerified,
      'logo': logo,
      'active': active,
      'enabled': enabled,
      'category': category,
      'products': products,
      'subCategories': subCategories,
      'type': type,
      'rating': rating,
      'ratingCount': ratingCount,
      'point': point.data,
      'survicableRadius': survicableRadius,
      'canBeRec': canBeRec,
      'usernameKey': username.toLowerCase(),
      'enquiries': enquiries,
      'views': views,
      'aadharVerified': aadharVerified,
    };
  }

  factory Store.fromFirestore(DocumentSnapshot doc) {
    final Map<String, dynamic> map = doc.data() as Map<String, dynamic>;
    final GeoPoint geopoint = map['point']['geopoint'];
    return Store(
      id: doc.id,
      username: map['username'],
      name: map['name'],
      description: map['description'],
      isVerified: map['isVerified'],
      logo: map['logo'],
      active: map['active'],
      enabled: map['enabled'],
      category: map['category'],
      products: List<String>.from(map['products']),
      subCategories: List<String>.from(map['subCategories']),
      type: map['type'],
      canBeRec: map['canBeRec'],
      rating: map['rating'],
      ratingCount: map['ratingCount'],
      point: Geoflutterfire()
          .point(latitude: geopoint.latitude, longitude: geopoint.longitude),
      survicableRadius: map['survicableRadius'],
      enquiries: map['enquiries'] ?? 0,
      views: map['views'] ?? 0,
      aadharVerified: map['aadharVerified'] ?? true,
    );
  }

  bool isRelevant(GeoPoint location) {
    if (survicableRadius == SurvicableRadius.panIndia) {
      return true;
    } else {
      return Geolocator.distanceBetween(location.latitude, location.longitude,
              point.latitude, point.longitude) <=
          (survicableRadius == SurvicableRadius.r10 ? 10 : 35) * 1000;
    }
  }

  factory Store.empty() => Store(
        id: '',
        username: '',
        name: '',
        description: '',
        isVerified: false,
        logo: '',
        active: true,
        enabled: true,
        category: '',
        products: [],
        subCategories: [],
        type: '',
        canBeRec: false,
        rating: 0,
        ratingCount: 0,
        point: GeoFirePoint(0, 0),
        survicableRadius: '',
        enquiries: 0,
        views: 0,
        aadharVerified: false,
      );
}
