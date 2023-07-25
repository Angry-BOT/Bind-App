import 'package:bind_app/ui/pages/auth/providers/auth_view_model_provider.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../../../model/profile.dart';
import '../../../../repository/profile_repository.dart';

final profileProvider = StreamProvider<Profile>((ref) {
  return ref.read(profileRepositoryProvider).profileStream(
      ref.watch(authViewModelProvider.select((value) => value.user!.uid)));
});
