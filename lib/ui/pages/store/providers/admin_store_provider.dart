import 'package:bind_app/ui/pages/profile/providers/profile_provider.dart';

import '../../../../model/store.dart';
import '../../../../repository/store_repository.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

final adminStoreProvider = StreamProvider<Store>(
  (ref) => ref.read(storeRepositoryProvider).storeStream(
        ref.watch(
          profileProvider.select((value) => value.value!.id),
        ),
      ),
);
