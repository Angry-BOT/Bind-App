import '../../../../repository/faq_repository.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

final faqCategoriesProvider = FutureProvider<List<String>>(
  (ref) => ref.read(faqRepositoryProvider).categoriesFuture,
);
