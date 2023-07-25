import 'package:cloud_firestore/cloud_firestore.dart';

import 'option.dart';

class MasterData {
  final double price;
  final List<Option> options;
  final double assistancePrice;
  final int versionCode;
  final int versionCodeIos;
  final bool forceUpdate;
  final bool forceUpdateIos;

  MasterData({
    required this.price,
    required this.options,
    required this.assistancePrice,
    required this.forceUpdate,
    required this.versionCode,
    required this.forceUpdateIos,
    required this.versionCodeIos,
  });

  // MasterData copyWith({
  //   double? price,
  //   List<Option>? options,
  // }) {
  //   return MasterData(
  //     price: price ?? this.price,
  //     options: options ?? this.options,
  //   );
  // }

  // Map<String, dynamic> toMap() {
  //   return {
  //     'price': price,
  //     'options': options.map((x) => x.toMap()).toList(),
  //   };
  // }

  factory MasterData.fromMap(DocumentSnapshot doc) {
    final Map<String, dynamic> map = doc.data() as Map<String, dynamic>;
    return MasterData(
      price: map['price'].toDouble(),
      options: List<Option>.from(map['options']?.map((x) => Option.fromMap(x))),
      assistancePrice: map['assistancePrice'].toDouble(),
      forceUpdate: map['forceUpdate'],
      versionCode: map['versionCode'],
      versionCodeIos: map['versionCodeIos'],
      forceUpdateIos: map['forceUpdateIos'],
    );
  }
}
