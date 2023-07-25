import 'package:cloud_firestore/cloud_firestore.dart';

class Address {
  final String name;
  final String location;
  final String formated;
  final String number;
  final String landmark;
  final GeoPoint point;
  final String city;
  String? state;

  Address({
    required this.name,
    required this.location,
    required this.formated,
    required this.number,
    required this.landmark,
    required this.point,
    required this.city,
    required this.state,
  });

  factory Address.empty() => Address(
      formated: '',
      landmark: '',
      location: '',
      name: '',
      number: '',
      point: GeoPoint(0, 0),
      city: '',
      state: '');

  Address copyWith({
    String? name,
    String? location,
    String? formated,
    String? number,
    String? landmark,
    GeoPoint? point,
    String? city,
    String? state,
  }) {
    return Address(
      name: name ?? this.name,
      location: location ?? this.location,
      formated: formated ?? this.formated,
      number: number ?? this.number,
      landmark: landmark ?? this.landmark,
      point: point ?? this.point,
      city: city ?? this.city,
      state: state ?? this.state,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'location': location,
      'formated': formated,
      'number': number,
      'landmark': landmark,
      'point': point,
      'city': city,
      'state': state,
    };
  }

  String get customFormat => "$number, $landmark, $formated";

  factory Address.fromMap(Map<String, dynamic> map) {
    return Address(
      name: map['name'],
      location: map['location'],
      formated: map['formated'],
      number: map['number'],
      landmark: map['landmark'],
      point: map['point'],
      city: map['city'],
      state: map['state'],
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is Address &&
        other.location == location &&
        other.number == number &&
        other.landmark == landmark &&
        other.point == point &&
        other.city == city &&
        other.state == state;
  }

  @override
  int get hashCode {
    return location.hashCode ^
        number.hashCode ^
        landmark.hashCode ^
        point.hashCode ^
        city.hashCode ^
        state.hashCode;
  }
}
