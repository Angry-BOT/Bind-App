import '../../auth/providers/auth_view_model_provider.dart';

import '../../../../model/enquiry.dart';
import '../../../../repository/enquiry_repository.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

final myEnquiresProvider = FutureProvider<List<Enquiry>>(
  (ref) => ref.read(enquiryRepositoryProvider).myEnquiriesFuture(
        ref.watch(authViewModelProvider.select((value) => value.user!.uid)),
      ),
);
