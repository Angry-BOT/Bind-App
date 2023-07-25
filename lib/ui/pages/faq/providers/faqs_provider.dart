import '../../../../model/faq.dart';
import '../../../../repository/faq_repository.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

final faqsProvider = FutureProvider.family<List<Faq>,String>(
  (ref,category) => ref.read(faqRepositoryProvider).faqsFuture(category),
);
