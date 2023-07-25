import '../../../../model/store.dart';
import '../../../../repository/store_repository.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';


final storeProvider = FutureProvider.family<Store, String>(
  (ref, id) => ref.read(storeRepositoryProvider).storeFuture(id),
);
