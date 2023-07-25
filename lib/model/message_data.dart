
class MessageData {
  final String type;
  final String? refId;

  MessageData({
    required this.type,
    required this.refId,
  });

  MessageData copyWith({
    String? type,
    String? refId,
  }) {
    return MessageData(
      type: type ?? this.type,
      refId: refId ?? this.refId,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'type': type,
      'refId': refId,
    };
  }

  factory MessageData.fromMap(Map<String, dynamic> map) {
    return MessageData(
      type: map['type'],
      refId: map['refId'],
    );
  }
}


class MessageType {
  static const String enquiryStore = 'enquiry_store';
  static const String enquiryCustomer = 'enquiry_customer';

  static const String credits = 'credits';
  static const String offers = "offers";
  static const String posts = "posts";
  static const String reviews = "reviews";
    static const String aadhaar = 'aadhaar';

}