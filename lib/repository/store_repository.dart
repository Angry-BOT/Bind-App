import 'dart:io';

import 'package:bind_app/model/wallet.dart';

import '../enums/survicableRadius.dart';
import '../firebase_utils/constants.dart';
import '../model/store.dart';
import '../ui/pages/auth/providers/auth_view_model_provider.dart';
import '../utils/constants.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:geoflutterfire/geoflutterfire.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

final storeRepositoryProvider = Provider((ref) => StoreRepository(ref));

class StoreRepository {
  final Ref ref;

  StoreRepository(this.ref);

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseStorage _storage = FirebaseStorage.instance;

  final _geo = Geoflutterfire();

  User get user => ref.watch(authViewModelProvider).user!;

  Future<void> writeStore({required Store store, required File? file}) async {
    String? url;
    if (file != null) {
      url = await _uploadImage('', file);
      if (url == null) {
        return Future.error("Upload error");
      }
    }
    final batch = _firestore.batch();
    if (store.logo.isNotEmpty) {
      batch.update(_firestore.collection(Constants.stores).doc(store.id),
          store.copyWith(logo: url).toMap());
    } else {
      batch.set(_firestore.collection(Constants.stores).doc(store.id),
          store.copyWith(logo: url).toMap());
      batch.update(_firestore.collection(Constants.users).doc(store.id), {
        Constants.username: store.username,
        Constants.usernameKey: store.username.toLowerCase()
      });
      batch.set(
        _firestore.collection(Constants.wallets).doc(store.id),
        Wallet(
          id: '',
          credits: 5,
          createdAt: DateTime.now(),
          freez: false,
        ).toMap(),
      );
    }
    await batch.commit();
  }

  Future<String?> _uploadImage(String key, File file) async {
    final task =
        await _storage.ref(FirebaseKeys.logos).child(user.uid).putFile(file);
    return await task.ref.getDownloadURL();
  }

  Stream<Store> storeStream(String id) =>
      _firestore.collection(Constants.stores).doc(id).snapshots().map(
            (event) => Store.fromFirestore(event),
          );

  void setActive(bool value) {
    _firestore.collection(Constants.stores).doc(user.uid).update(
      {
        Constants.active: value,
      },
    );
  }

  Future<String?> getAlreadyExistedUsername(String username) async {
    return _firestore
        .collection(Constants.stores)
        .where(Constants.usernameKey, isEqualTo: username)
        .get()
        .then(
          (value) => value.docs.isNotEmpty
              ? value.docs.first[Constants.usernameKey]
              : null,
        );
  }

  Future<List<Store>> storesFuture() async {
    return await _firestore
        .collection(Constants.stores)
        .where(Constants.enabled, isEqualTo: true)
        .get()
        .then(
          (value) => value.docs
              .map(
                (e) => Store.fromFirestore(e),
              )
              .toList(),
        );
  }

  Future<List<DocumentSnapshot>> storesLimitFuture(
      {required int limit, DocumentSnapshot? last}) async {
    var collectionRef = _firestore
        .collection(Constants.stores)
        .where(Constants.enabled, isEqualTo: true)
        .where(Constants.survicableRadius, isEqualTo: SurvicableRadius.panIndia)
        .where(Constants.canBeRec, isEqualTo: true)
        .where(Constants.rating, isGreaterThanOrEqualTo: 3.8)
        .orderBy(Constants.rating, descending: true)
        .limit(limit);
    if (last != null) {
      collectionRef = collectionRef.startAfterDocument(last);
    }
    return await collectionRef.get().then(
          (value) => value.docs,
        );
  }

  Stream<List<Store>> nearByStoresStream(
      {required GeoPoint point, required String survicableRadius}) {
    var collectionRef = _firestore
        .collection(Constants.stores)
        .where(Constants.enabled, isEqualTo: true)
        .where(Constants.survicableRadius, isEqualTo: survicableRadius);

    if (survicableRadius == SurvicableRadius.panIndia) {
      collectionRef = collectionRef.where(Constants.canBeRec, isEqualTo: false);
    }

    final Stream<List<DocumentSnapshot>> stream = _geo
        .collection(collectionRef: collectionRef)
        .within(
            center: GeoFirePoint(point.latitude, point.longitude),
            radius: survicableRadius == SurvicableRadius.r10 ? 10 : 35,
            field: Constants.point,
            strictMode: true);
    return stream.map(
      (event) => event.map((e) => Store.fromFirestore(e)).toList(),
    );
  }

  Future<List<Store>> nearByStoresStrea(
      {required GeoPoint point, required String survicableRadius}) async {
    var collectionRef = _firestore
        .collection(Constants.stores)
        .where(Constants.enabled, isEqualTo: true)
        .where(Constants.survicableRadius, isEqualTo: survicableRadius);

    if (survicableRadius == SurvicableRadius.panIndia) {
      collectionRef = collectionRef.where(Constants.canBeRec, isEqualTo: false);
    }

    final Stream<List<DocumentSnapshot>> stream = _geo
        .collection(collectionRef: collectionRef)
        .within(
            center: GeoFirePoint(point.latitude, point.longitude),
            radius: survicableRadius == SurvicableRadius.r10 ? 10 : 35,
            field: Constants.point,
            strictMode: true);
    return stream
        .map(
          (event) => event.map((e) => Store.fromFirestore(e)).toList(),
        )
        .firstWhere((element) => true);
  }

  Future<List<Store>> subCateogryStoresFuture(String value) async {
    return await _firestore
        .collection(Constants.stores)
        .where(Constants.enabled, isEqualTo: true)
        .where(Constants.survicableRadius, isEqualTo: SurvicableRadius.panIndia)
        .where(Constants.subCategories, arrayContains: value)
        .get()
        .then(
          (value) => value.docs
              .map(
                (e) => Store.fromFirestore(e),
              )
              .where((element) => element.products.isNotEmpty)
              .toList(),
        );
  }

  Future<List<Store>> storeSearchResultsFuture(String value) async {
    return await _firestore
        .collection(Constants.stores)
        .where(Constants.enabled, isEqualTo: true)
        .where(Constants.survicableRadius, isEqualTo: SurvicableRadius.panIndia)
        .where(Constants.name, isEqualTo: value)
        .get()
        .then(
          (value) => value.docs
              .map(
                (e) => Store.fromFirestore(e),
              )
              .toList(),
        );
  }

  Future<List<Store>> storeSearchResultsByProductNameFuture(
      String value) async {
    return await _firestore
        .collection(Constants.stores)
        .where(Constants.enabled, isEqualTo: true)
        .where(Constants.survicableRadius, isEqualTo: SurvicableRadius.panIndia)
        .where(Constants.products, arrayContains: value)
        .get()
        .then(
          (value) => value.docs
              .map(
                (e) => Store.fromFirestore(e),
              )
              .toList(),
        );
  }

  Future<Store> storeFuture(String id) async {
    return await _firestore.collection(Constants.stores).doc(id).get().then(
          (value) => Store.fromFirestore(value),
        );
  }

  void saveProducts({required List<String> names, required String id}) {
    _firestore
        .collection(Constants.stores)
        .doc(id)
        .update({Constants.products: names});
  }

  void addView({required String id}) {
    _firestore.collection(Constants.stores).doc(id).update({
      Constants.views: FieldValue.increment(1),
    });
  }

  Future<void> updateUserName(
      {required String id, required String name}) async {
    final _batch = _firestore.batch();
    _batch.update(_firestore.collection(Constants.stores).doc(id), {
      Constants.username: name,
      Constants.usernameKey: name.toLowerCase(),
    });
    _batch.update(_firestore.collection(Constants.users).doc(id),
        {Constants.username: name, Constants.usernameKey: name.toLowerCase()});
    await _batch.commit();
  }
}
