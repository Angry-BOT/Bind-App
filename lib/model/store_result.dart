
class StoreResult {
  final String id;
  final String name;
  final String username;
  final List<String> products;
  final String type;
  final String survicableRadius;
  final bool active;

  StoreResult({
    required this.id,
    required this.name,
    required this.username,
    required this.products,
    required this.type,
    required this.survicableRadius,
    required this.active,
  });

  factory StoreResult.fromMap(Map<String, dynamic> map) {
    return StoreResult(
      id: map['id'] ?? '',
      name: map['name'] ?? '',
      username: map['username'] ?? '',
      products:  List<String>.from(map['products']??[]),
      type: map['type'] ?? '',
      survicableRadius: map['survicableRadius'] ?? '',
      active: map['active']??true,
    );
  }
}
