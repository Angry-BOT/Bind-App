import '../../../../model/enquiry.dart';
import '../../../../repository/enquiry_repository.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

final enquiryProvider = FutureProvider.family<Enquiry,String>((ref,id)=>ref.read(enquiryRepositoryProvider).enquiryFuture(id),);