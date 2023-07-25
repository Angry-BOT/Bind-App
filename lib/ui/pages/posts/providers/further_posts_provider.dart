import '../../../../model/post/post.dart';
import '../../../../repository/posts_repository.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

final furtherPostsProvider = FutureProvider<List<Post>>(
  (ref) => ref.read(postsRepositoryProvider).furtherPostsFuture.then((value) {
             final list1 = value.where((element) => element.fav).toList();
          list1.sort((a, b) => b.date.compareTo(a.date));
          final list2 = value.where((element) => !element.fav).toList();
          list2.sort((a, b) => b.date.compareTo(a.date));
    return list1+list2;
  }),
);
