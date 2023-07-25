import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../../../model/profile.dart';
import '../../../../repository/profile_repository.dart';

final sellerProfileProvider = StreamProvider.family<Profile,String>((ref,id) {
  return ref.read(profileRepositoryProvider).sellerProfileStream(id);
});
