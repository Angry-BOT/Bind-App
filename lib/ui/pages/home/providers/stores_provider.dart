import '../../../../model/store.dart';
import '../../../../repository/store_repository.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

final storesProvider = FutureProvider<List<Store>>(
  (ref) => ref.read(storeRepositoryProvider).storesFuture(),
);