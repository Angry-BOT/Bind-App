import '../../utils/utils.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';

import 'post_image.dart';
import 'post_text.dart';
import 'post_type.dart';
import 'post_video.dart';

class Post {
  final String id;
  final String? category;
  final String title;
  final String image;
  final String content;
  int likes;
  final DateTime date;
  final int bookmarks;
  final List components;
  final bool fav;

  Post({
    required this.title,
    required this.image,
    required this.content,
    required this.likes,
    required this.date,
    required this.id,
    required this.category,
    required this.bookmarks,
    required this.components,
    required this.fav,
  });

  String get dateLabel =>
      "${Utils.ordinalSuffixOf(date.day)} ${DateFormat('MMM yyyy').format(date)}";

  factory Post.fromMap(DocumentSnapshot doc) {
    final Map<String, dynamic> map = doc.data() as Map<String, dynamic>;
    final Iterable list = map['components'];
    final List _components = [];
    for (var item in list) {
      switch (item['type']) {
        case PostType.text:
          _components.add(PostText.fromMap(item));
          break;
        case PostType.image:
          _components.add(PostImage.fromMap(item));
          break;
        case PostType.video:
          _components.add(PostVideo.fromMap(item));
          break;
      }
    }
    return Post(
      title: map['title'],
      content: map['content'],
      likes: map['likes'],
      date: map['date'].toDate(),
      category: map['category'],
      id: doc.id,
      image: map['image'],
      bookmarks: map['bookmarks'],
      components: _components,
      fav: map['fav'],
    );
  }
}
