import '../model/post/post.dart';
import '../utils/constants.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

final postsRepositoryProvider = Provider((ref) => PostsRepository());

class PostsRepository {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  DocumentSnapshot? doc;

  Future<List<Post>> get initialPostsFuture => _firestore
          .collection(Constants.posts)
          .where(Constants.active, isEqualTo: true)
          .orderBy('fav', descending: true)
          .limit(5)
          .get()
          .then(
        (value) {
          if (value.docs.length == 5) {
            doc = value.docs.last;
          }
          final list = value.docs.map((e) => Post.fromMap(e)).toList();
          final list1 = list.where((element) => element.fav).toList();
          list1.sort((a, b) => b.date.compareTo(a.date));
          final list2 = list.where((element) => !element.fav).toList();
          list2.sort((a, b) => b.date.compareTo(a.date));
          return list1+list2;
        },
      );

  Future<Post> postFuture(String id) async {
    return _firestore.collection(Constants.posts).doc(id).get().then(
          (value) => Post.fromMap(value),
        );
  }

  Future<List<Post>> get furtherPostsFuture => doc != null
      ? _firestore
          .collection(Constants.posts)
          .where(Constants.active, isEqualTo: true)
          .orderBy('fav', descending: true)
          .startAfterDocument(doc!)
          .get()
          .then((value) => value.docs.map((e) => Post.fromMap(e)).toList())
      : Future.value([]);

  Future<List<String>> get postsCategories async => await _firestore
      .collection('postCategories')
      .doc('postCategories')
      .get()
      .then((event) => event.data()!['values'].cast<String>());
}
