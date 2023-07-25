import 'dart:io';

import '../enums/survicableRadius.dart';
import '../firebase_utils/constants.dart';
import '../model/product.dart';
import '../model/store.dart';
import '../ui/pages/auth/providers/auth_view_model_provider.dart';
import '../ui/pages/store/providers/admin_store_provider.dart';
import '../utils/constants.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

final productsRepositoryProvider = Provider((ref) => ProductsRepository(ref));

class ProductsRepository {
  final Ref ref;

  ProductsRepository(this.ref);

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseStorage _storage = FirebaseStorage.instance;

  User get user => ref.watch(authViewModelProvider).user!;
  Store get _store => ref.read(adminStoreProvider).value!;
  bool get isPanIndia => _store.survicableRadius == SurvicableRadius.panIndia;

  Future<void> writeProduct(
      {required Product product,
      required File? file,
      required List<File> files,
      String? oldName}) async {
    final productRef = _firestore
        .collection(Constants.products)
        .doc(product.id.isEmpty ? null : product.id);

    String? url = file != null ? await _uploadImage(productRef.id, file) : null;

    for (var item in files) {
      product.images.add(await _uploadImage(
          DateTime.now().millisecondsSinceEpoch.toString(), item));
    }

    final batch = _firestore.batch();
    if (product.id.isNotEmpty) {
      batch.update(productRef, product.copyWith(image: url).toMap());
      if (oldName != null) {
        _store.products[_store.products.indexOf(oldName)] = product.name;
        batch.update(
            _firestore.collection(Constants.stores).doc(product.storeId),
            {Constants.products: _store.products});
      }
    } else {
      batch.set(
        productRef,
        product.copyWith(image: url).toMap(),
      );
      batch.update(
          _firestore.collection(Constants.stores).doc(product.storeId), {
        Constants.products: FieldValue.arrayUnion([product.name])
      });
    }
    await batch.commit();
  }

  Future<String> _uploadImage(String key, File file) async {
    final task =
        await _storage.ref(FirebaseKeys.products).child(key).putFile(file);
    return await task.ref.getDownloadURL();
  }

  Stream<List<Product>> productsStream(String storeId) {
    return _firestore
        .collection(Constants.products)
        .where(Constants.storeId, isEqualTo: storeId)
        .snapshots()
        .map(
          (event) => event.docs
              .map(
                (e) => Product.fromMap(e),
              )
              .toList(),
        );
  }

  void deleteProduct(
      {required String id,
      required String name,
      required String storeId,
      required bool isPanIndia}) {
    final batch = _firestore.batch();
    batch.update(_firestore.collection(Constants.stores).doc(storeId), {
      Constants.products: FieldValue.arrayRemove([name]),
    });
    batch.delete(_firestore.collection(Constants.products).doc(id));
    batch.commit();
  }
}
