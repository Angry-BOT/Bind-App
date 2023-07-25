import 'dart:io';

import '../model/failed_deal.dart';
import '../model/rate.dart';
import '../model/store.dart';
import 'store_repository.dart';
import '../utils/constants.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

final ratingRepositoryProvider = Provider((ref) => RatingRepository(ref));

class RatingRepository {
  final Ref _ref;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseStorage _storage = FirebaseStorage.instance;

  RatingRepository(this._ref);

  Future<void> rate(Rate rate, List<File> files) async {
    Store? store;
    try {
      store = await StoreRepository(_ref).storeFuture(rate.storeId);
    } catch (e) {
      print('Store not exists');
    }
    if (store == null) {
      return;
    }
    final List<String> urls = [];
    for (var item in files) {
      final String? url = await _uploadImage(item);
      if (url != null) {
        urls.add(url);
      }
    }
    final _batch = _firestore.batch();
    _batch.update(_firestore.collection(Constants.stores).doc(store.id), {
      Constants.rating: (store.rating * store.ratingCount + rate.rating) /
          (store.ratingCount + 1),
      Constants.ratingCount: store.ratingCount + 1,
      Constants.canBeRec: (store.ratingCount + 1) >= 5 ? true : false,
    });
    _batch
        .update(_firestore.collection(Constants.enquires).doc(rate.enquiryId), {
      'reviewed': true,
    });
    _batch.set(
      _firestore.collection(Constants.reviews).doc(),
      rate.copyWith(images: urls).toMap(),
    );
    _batch.commit();
  }

  void submitFailedDeal(FailedDeal deal) {
    final _batch = _firestore.batch();
    _batch.update(_firestore.collection(Constants.enquires).doc(deal.eId), {
      'reviewed': true,
    });
    _batch.set(
        _firestore.collection(Constants.failedDeals).doc(), deal.toMap());
    _batch.commit();
  }

  Future<String?> _uploadImage(File file) async {
    final task = await _storage
        .ref("review")
        .child(DateTime.now().toString())
        .putFile(file);
    return await task.ref.getDownloadURL();
  }

  Future<List<DocumentSnapshot>> reviewsLimitFuture(
      {required int limit,
      DocumentSnapshot? last,
      required String storeId}) async {
    var collectionRef = _firestore
        .collection(Constants.reviews)
        .where(Constants.storeId, isEqualTo: storeId)
        .where(Constants.publish, isEqualTo: true)
        .limit(limit);
    if (last != null) {
      collectionRef = collectionRef.startAfterDocument(last);
    }
    return await collectionRef.get().then(
          (value) => value.docs,
        );
  }

  void reply({required String id, required String message}) {
    _firestore.collection(Constants.reviews).doc(id).update(
      {
        Constants.reply: message,
        Constants.updatedAt: Timestamp.now(),
      },
    );
  }

  Stream<List<Rate>> updatedReviewsStream() {
    return _firestore
        .collection(Constants.reviews)
        .where(Constants.updatedAt, isGreaterThanOrEqualTo: DateTime.now())
        .snapshots()
        .map(
          (event) => event.docs.map((e) => Rate.fromMap(e)).toList(),
        );
  }
}
