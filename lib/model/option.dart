class Option {
  final DateTime startTime;
  final DateTime? endTime;
  final String name;
  final int quantity;
  final double? discount;
  final int? extra;

  Option({
    required this.startTime,
    this.endTime,
    required this.name,
    required this.quantity,
    this.discount,
    this.extra,
  });

  int get finalCredits => quantity + (extra ?? 0);

  String get formatedName =>'$name on $quantity+ credits buy';

  Option copyWith({
    DateTime? startTime,
    DateTime? endTime,
    String? name,
    int? quantity,
    double? amount,
    double? discount,
    int? extra,
  }) {
    return Option(
      startTime: startTime ?? this.startTime,
      endTime: endTime ?? this.endTime,
      name: name ?? this.name,
      quantity: quantity ?? this.quantity,
      discount: discount ?? this.discount,
      extra: extra ?? this.extra,
    );
  }

  // Map<String, dynamic> toMap() {
  //   return {
  //     'startTime': startTime.millisecondsSinceEpoch,
  //     'endTime': endTime?.millisecondsSinceEpoch,
  //     'name': name,
  //     'quantity': quantity,
  //     'amount': amount,
  //     'discount': discount,
  //     'extra': extra,
  //   };
  // }

  factory Option.fromMap(Map<String, dynamic> map) {
    return Option(
      startTime: map['startTime'].toDate(),
      endTime: map['endTime']?.toDate(),
      name: map['name'],
      quantity: map['quantity'],
      discount: map['discount'] != null ? map['discount'] : null,
      extra: map['extra'] != null ? map['extra'] : null,
    );
  }

  double amount(double price, int q) {
    final total = ((price / 1.18) * q);
    final totalexpectDiscount = total - (total * (discount ?? 0) / 100);
    return double.parse(
        (totalexpectDiscount + 0.18 * totalexpectDiscount).toStringAsFixed(0));
  }
}
