import 'package:bind_app/utils/constants.dart';
import 'package:bind_app/utils/labels.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';

import '../enums/bussiness_type.dart';
import '../enums/status.dart';
import 'address.dart';

class Profile {
  final String id;
  bool isEntrepreneur;
  final String firstName;
  final String lastName;
  final String emailAddress;
  final String mobile;
  final List<Address> addresses;
  final Status status;
  final List<String> favorites;
  final List<String> likes;
  final List<String> bookmarks;
  final bool isEmailVerified;

  final List<String>? storeIds;
  final String? image;
  final String? about;
  final String? token;
  final bool? aadharVerified;

  final String? username;
  final String? aadharId;
  final String? aadharImage;
  final String? aadharImage2;
  final String? verificationImage;
  final String? udyogAadharNumber;
  final String? udyogAadhar;
  final String? category;
  final String? survicableRadius;
  final List<String>? subCategories;
  final List<BussinessType>? type;
  final bool? isUdyogVerified;
  final List<String>? reviewedFaqs;

  Profile({
    this.id = '',
    required this.isEntrepreneur,
    required this.firstName,
    required this.lastName,
    required this.emailAddress,
    required this.mobile,
    required this.status,
    required this.favorites,
    required this.likes,
    required this.bookmarks,
    this.aadharVerified,
    this.storeIds,
    this.addresses = const [],
    this.aadharId,
    this.aadharImage,
    this.aadharImage2,
    this.verificationImage,
    this.udyogAadharNumber,
    this.category,
    this.subCategories,
    this.type,
    this.survicableRadius,
    this.udyogAadhar,
    this.isUdyogVerified,
    this.image,
    this.about,
    this.reviewedFaqs,
    this.username,
    this.token,
    required this.isEmailVerified,
  });

  Profile copyWith(
      {String? id,
      bool? isEntrepreneur,
      String? firstName,
      String? lastName,
      String? emailAddress,
      String? mobile,
      List<Address>? addresses,
      String? aadharId,
      String? aadharImage,
      String? aadharImage2,
      String? verificationImage,
      Status? status,
      String? udyogAadharNumber,
      String? udyogAadhar,
      String? category,
      String? survicableRadius,
      List<String>? subCategories,
      List<BussinessType>? type,
      bool? isUdyogVerified,
      String? image,
      String? about,
      List<String>? storeIds,
      bool? aadharVerified}) {
    return Profile(
      id: id ?? this.id,
      isEntrepreneur: isEntrepreneur ?? this.isEntrepreneur,
      firstName: firstName ?? this.firstName,
      lastName: lastName ?? this.lastName,
      mobile: mobile ?? this.mobile,
      emailAddress: emailAddress ?? this.emailAddress,
      addresses: addresses ?? this.addresses,
      aadharId: aadharId ?? this.aadharId,
      aadharImage: aadharImage ?? this.aadharImage,
      aadharImage2: aadharImage2 ?? this.aadharImage2,
      verificationImage: verificationImage ?? this.verificationImage,
      status: status ?? this.status,
      udyogAadharNumber: udyogAadharNumber ?? this.udyogAadharNumber,
      udyogAadhar: udyogAadhar ?? this.udyogAadhar,
      category: category ?? this.category,
      survicableRadius: survicableRadius ?? this.survicableRadius,
      subCategories: subCategories ?? this.subCategories,
      type: type ?? this.type,
      isUdyogVerified: isUdyogVerified ?? this.isUdyogVerified,
      favorites: favorites,
      likes: likes,
      bookmarks: bookmarks,
      image: image ?? this.image,
      about: about ?? this.about,
      reviewedFaqs: reviewedFaqs,
      username: username,
      storeIds: storeIds ?? this.storeIds,
      isEmailVerified: isEmailVerified,
      aadharVerified: aadharVerified ?? this.aadharVerified,
    );
  }

  bool get isReady =>
      isEntrepreneur &&
      category != null &&
      subCategories != null &&
      subCategories!.isNotEmpty &&
      type != null &&
      type!.isNotEmpty &&
      survicableRadius != null;

  bool get storeAddressExist =>
      addresses.where((element) => element.name == Constants.store).isNotEmpty;

  Map<String, dynamic> toCreateMap() {
    return {
      'firstName': firstName,
      'lastName': lastName,
      'mobile': mobile,
      'emailAddress': emailAddress,
      'isEntrepreneur': false,
      'isEmailVerified': false,
      'status': describeEnum(status),
      'favorites': favorites,
      'likes': likes,
      'bookmarks': bookmarks,
      'addresses': addresses,
      'createdAt': Timestamp.now(),
      'nameKey': firstName[0].toLowerCase(),
    };
  }

  Map<String, dynamic> toDetailsMap() {
    return {
      'category': category,
      'subCategories': subCategories,
      'type': type?.map((x) => describeEnum(x)).toList(),
      'survicableRadius': survicableRadius,
      'isEntrepreneur': isEntrepreneur,
      'aadharId': aadharId,
      'aadharImage': aadharImage,
      'aadharImage2': aadharImage2,
      'verificationImage': verificationImage,
      'addresses': addresses.map((x) => x.toMap()).toList(),
      'aadharVerified': false,
    };
  }

  factory Profile.fromFirestore(DocumentSnapshot doc) {
    final map = doc.data() as Map;
    final Iterable list = map['addresses'];
    return Profile(
      id: doc.id,
      isEntrepreneur: map['isEntrepreneur'],
      firstName: map['firstName'],
      lastName: map['lastName'],
      mobile: map['mobile'],
      emailAddress: map['emailAddress'],
      addresses: List<Address>.from(
        list
            .map(
              (x) => Address.fromMap(x),
            )
            .toList(),
      ),
      aadharId: map['aadharId'],
      aadharImage: map['aadharImage'],
      verificationImage: map['verificationImage'],
      status: getStatus(map['status']),
      udyogAadharNumber: map['udyogAadharNumber'],
      category: map['category'],
      subCategories: map['subCategories'] != null
          ? List<String>.from(map['subCategories'])
          : null,
      type: map['type'] != null
          ? List<BussinessType>.from(
              map['type']?.map(
                (x) => getBussinessType(x),
              ),
            )
          : null,
      udyogAadhar: map['udyogAadhar'],
      survicableRadius: map['survicableRadius'],
      isUdyogVerified: map['isUdyogVerified'],
      favorites: List<String>.from(map['favorites']),
      likes: List<String>.from(map['likes']),
      bookmarks: List<String>.from(map['bookmarks']),
      image: map['image'],
      about: map['about'],
      reviewedFaqs: map['reviewedFaqs'] != null
          ? List<String>.from(map['reviewedFaqs'])
          : null,
      username: map['username'],
      storeIds:
          map['storeIds'] != null ? List<String>.from(map['storeIds']) : null,
      token: map['token'],
      isEmailVerified: map['isEmailVerified'],
      aadharImage2: map['aadharImage2'],
      aadharVerified:
          map['aadharVerified'] ?? (getStatus(map['status']) == Status.Active),
    );
  }

  Map<String, dynamic> editMap() {
    return {
      'firstName': firstName,
      'lastName': lastName,
      'emailAddress': emailAddress,
      'image': image,
      'about': about,
      'mobile': mobile,
      'nameKey': firstName[0].toLowerCase(),
    };
  }

  bool get homeAddressExist =>
      addresses.where((element) => element.name == Labels.home).isNotEmpty;
}
