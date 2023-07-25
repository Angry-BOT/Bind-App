import '../utils/dates.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ID {
  final DateTime date;
   int count;

  ID({required this.date, required this.count});

  factory ID.fromFirestore(DocumentSnapshot doc) {
    final map = doc.data() as Map<String, dynamic>;
    return ID(
      date: map['date'].toDate(),
      count: map['count'],
    );
  }

  Map<String,dynamic> toMap() => {
    "date": Timestamp.fromDate(date),
    "count": count,
  };

  factory ID.empty() => ID(date: Dates.today, count: 0);
}
