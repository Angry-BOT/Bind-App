import '../../../../model/category.dart';
import '../../../../repository/categories_repository.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

final categoriesProvider = FutureProvider<List<StoreCategory>>(
  (ref) => ref.read(categoriesRepositoryProvider).categoriesFuture,
);