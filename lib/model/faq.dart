import 'package:cloud_firestore/cloud_firestore.dart';

import 'post/post_image.dart';
import 'post/post_text.dart';
import 'post/post_type.dart';
import 'post/post_video.dart';

class Faq {
  final String id;
  final String name;
  final String? category;
  final List components;
  final int helpful;
  final int notHelpful;
  
  Faq({
    required this.id,
    required this.name,
    required this.components,
    required this.category,
    required this.helpful,
    required this.notHelpful,
  });

  Faq copyWith({
    String? name,
    List? components,
    String? category,
  }) {
    return Faq(
      id: this.id,
      name: name ?? this.name,
      components: components ?? this.components,
      category: category??this.category,
      helpful: this.helpful,
      notHelpful: this.notHelpful,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'components': components.map((e) => e.toMap()).toList(),
      'category':category,
      'helpful':helpful,
      'notHelpful':notHelpful,
    };
  }

  factory Faq.fromMap(DocumentSnapshot doc) {
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
    return Faq(
      id: doc.id,
      name: map['name'],
      components: _components,
      category: map['category'],
      helpful: map['helpful'],
      notHelpful: map['notHelpful']
    );
  }

  factory Faq.empty() => Faq(
        id: '',
        name: '',
        components: [],
        category: null,
        helpful: 0,
        notHelpful: 0,
      );
}
