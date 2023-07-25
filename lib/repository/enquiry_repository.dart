import '../model/report/category_event.dart';

import '../model/enquiry.dart';
import '../model/id.dart';
import '../utils/constants.dart';
import '../utils/dates.dart';
import '../utils/formats.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

final enquiryRepositoryProvider = Provider(
  (ref) => EnquiryRepository(),
);

class EnquiryRepository {


  final FirebaseFirestore _firestore = FirebaseFirestore.instance;


  Future<Enquiry> sendEnquiry(
      {required Enquiry enquiry,
      required String categoryId,
      required List<String> subcategories}) async {
    final ID id = await _firestore
        .collection(Constants.iD)
        .doc(Constants.enquiry)
        .get()
        .then(
          (value) => ID.fromFirestore(value),
        );
    final _batch = _firestore.batch();
    _batch.update(
      _firestore.collection(Constants.iD).doc(Constants.enquiry),
      id.date == Dates.today
          ? {
              Constants.count: FieldValue.increment(1),
            }
          : ID(date: Dates.today, count: 1).toMap(),
    );
    _batch.set(
      _firestore.collection(Constants.enquires).doc(),
      enquiry
          .copyWith(
            enquiryId: id.date == Dates.today
                ? "E${Formats.id(Dates.today)}-${id.count + 1}"
                : "E${Formats.id(Dates.today)}-1",
          )
          .toMap(),
    );

    ///Added for analytics
    _batch.update(_firestore.collection(Constants.stores).doc(enquiry.storeId),
        {Constants.enquiries: FieldValue.increment(1)});
    _batch.set(
      _firestore.collection(Constants.categoriesEvents).doc(),
      CategoryEvent(
        id: categoryId,
        createdAt: Timestamp.now(),
        city: enquiry.address.city,
        subcategoryIds: subcategories,
      ).toMap(),
    );

    ///
    await _batch.commit();
    return enquiry.copyWith(
        enquiryId: id.date == Dates.today
            ? "E${Formats.id(Dates.today)}-${id.count + 1}"
            : "E${Formats.id(Dates.today)}-1");
  }

  Future<List<Enquiry>> myEnquiriesFuture(String id) async {
    return _firestore
        .collection(Constants.enquires)
        .where(Constants.customerId, isEqualTo: id)
        .orderBy(Constants.createdAt, descending: true)
        .get()
        .then(
          (value) => value.docs
              .map(
                (e) => Enquiry.fromMap(e),
              )
              .toList(),
        );
  }

  Stream<List<Enquiry>> pendingEnquiriesFuture(String id) {
    return _firestore
        .collection(Constants.enquires)
        .where(Constants.storeId, isEqualTo: id)
        .where(Constants.createdAt,
            isGreaterThanOrEqualTo: DateTime.now().subtract(Duration(days: 1)))
        .orderBy(Constants.createdAt, descending: true)
        .snapshots()
        .map(
          (value) => value.docs
              .map(
                (e) => Enquiry.fromMap(e),
              )
              .toList(),
        );
  }

  Stream<List<Enquiry>> updatedEnquiriesFuture(String id) {
    return _firestore
        .collection(Constants.enquires)
        .where(Constants.storeId, isEqualTo: id)
        .where(Constants.updatedAt, isGreaterThanOrEqualTo: DateTime.now())
        .snapshots()
        .map(
          (value) => value.docs
              .map(
                (e) => Enquiry.fromMap(e),
              )
              .toList(),
        );
  }

  Future<List<DocumentSnapshot>> otherEnquriesFuture(
      {required int limit,
      DocumentSnapshot? last,
      required String storeId,
      bool? bought}) async {
    var collectionRef = _firestore
        .collection(Constants.enquires)
        .where(Constants.storeId, isEqualTo: storeId);
    if (bought ?? false) {
      collectionRef = collectionRef.where(Constants.bought, isEqualTo: true);
    }
    collectionRef = collectionRef
        .where(Constants.createdAt,
            isLessThan: DateTime.now().subtract(Duration(days: 1)))
        .orderBy(Constants.createdAt, descending: true)
        .limit(limit);
    if (last != null) {
      collectionRef = collectionRef.startAfterDocument(last);
    }
    return await collectionRef.get().then(
          (value) => value.docs,
        );
  }

  Future<Enquiry> enquiryFuture(String id) async {
    return _firestore
        .collection(Constants.enquires)
        .doc(id)
        .get()
        .then((value) => Enquiry.fromMap(value));
  }
}
