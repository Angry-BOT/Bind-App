import '../model/category.dart';
import '../model/subcategory.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

final categoriesRepositoryProvider = Provider((ref) => CategoriesRepository());

class CategoriesRepository {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  Future<List<StoreCategory>> get categoriesFuture =>
      _firestore.collection('categories').get().then(
            (event) => event.docs
                .map(
                  (e) => StoreCategory.fromMap(e),
                )
                .toList(),
          );

  Future<List<Subcategory>> subCategoriesStream(String id) => _firestore
      .collection('subcategories')
      .where('categoryId', isEqualTo: id)
      .get()
      .then(
        (event) => event.docs
            .map(
              (e) => Subcategory.fromMap(e),
            )
            .toList(),
      );
}
