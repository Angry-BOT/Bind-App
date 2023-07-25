import 'package:bind_app/repository/store_repository.dart';
import 'package:bind_app/ui/pages/profile/providers/profile_provider.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

final manageViewedStoresProvider = Provider.family<void, String>((ref, id) {
  // final stores = ref.read(viewdStoresProvider);
  // if (!stores.contains(id)) {
  // stores.add(id);
  // ref.read(viewdStoresProvider).add(id);
  // ref.read(prefProvider).value!.setStringList(Constants.stores, stores.toSet().toList());
  if (ref.read(profileProvider).value!.id != id) {
    ref.read(storeRepositoryProvider).addView(id: id);
  }
  // }
});
