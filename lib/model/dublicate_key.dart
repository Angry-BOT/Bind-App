
class DublicateKey {
  final String name;
  int count;

  DublicateKey({
    required this.name,
    required this.count,
  });

  DublicateKey copyWith({
    String? name,
    int? count,
  }) {
    return DublicateKey(
      name: name ?? this.name,
      count: count ?? this.count,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'count': count,
    };
  }

  factory DublicateKey.fromMap(Map<String, dynamic> map) {
    return DublicateKey(
      name: map['name'],
      count: map['count'],
    );
  }
}
