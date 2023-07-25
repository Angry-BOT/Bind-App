import '../../../../model/post/post.dart';
import '../../../../repository/posts_repository.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

final initialPostsProvider = FutureProvider<List<Post>>(
  (ref) => ref.read(postsRepositoryProvider).initialPostsFuture,
);
