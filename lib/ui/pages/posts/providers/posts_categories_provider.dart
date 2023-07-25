import '../../../../repository/posts_repository.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

final postCategoriesProvider = FutureProvider<List<String>>(
  (ref) => ref.read(postsRepositoryProvider).postsCategories,
);
