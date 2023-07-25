import '../../../../model/post/post.dart';
import '../../../../repository/posts_repository.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

final postProvider = FutureProvider.autoDispose.family<Post, String>(
  (ref, id) => ref.read(postsRepositoryProvider).postFuture(id),
);
