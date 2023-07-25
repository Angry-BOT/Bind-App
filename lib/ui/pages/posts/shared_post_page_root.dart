import '../../components/loading.dart';
import 'post_page.dart';
import 'providers/post_provider.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class SharedPostPageRoot extends ConsumerWidget {
  const SharedPostPageRoot({Key? key, required this.id}) : super(key: key);
  final String id;
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final postAsync = ref.watch(postProvider(id));
    return Scaffold(
      body: postAsync.when(
        data: (post) => PostPage(
          post: post,
        ),
        loading: () => Scaffold(
          body: Loading(),
        ),
        error: (e, s) => Scaffold(
          body: Text(
            e.toString(),
          ),
        ),
      ),
    );
  }
}
