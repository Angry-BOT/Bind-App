import '../../../../model/store.dart';
import '../../../../repository/store_repository.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

final storeSearchResultsProvider = FutureProvider.family<List<Store>, String>(
  (ref, key) => ref.read(storeRepositoryProvider).storeSearchResultsFuture(key),
);


final storeSearchResultsByProductNameProvider = FutureProvider.family<List<Store>, String>(
  (ref, key) => ref.read(storeRepositoryProvider).storeSearchResultsByProductNameFuture(key),
);
