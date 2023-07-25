import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../../../model/store.dart';
import '../../../../repository/store_repository.dart';

final subCategoryStoresProvider = FutureProvider.family<List<Store>, String>(
  (ref, subCategory) =>
      ref.read(storeRepositoryProvider).subCateogryStoresFuture(subCategory),
);
