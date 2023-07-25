
import '../../../../model/subcategory.dart';
import '../../../../repository/categories_repository.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

final subcategoriesProvider = FutureProvider.family<List<Subcategory>,String>(
  (ref,id) => ref.read(categoriesRepositoryProvider).subCategoriesStream(id),
);
