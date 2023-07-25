import '../../components/loading.dart';
import '../../components/my_appbar.dart';
import 'faqs_page.dart';
import 'providers/faq_categories_provider.dart';
import '../../../utils/labels.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class FaqCategoriesPage extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final categoriesAsync = ref.watch(faqCategoriesProvider);
    return Scaffold(
      appBar: MyAppBar(
        title: Text(Labels.fAQ),
      ),
      body: RefreshIndicator(
        onRefresh: () async {
          ref.refresh(faqCategoriesProvider);
        },
        child: categoriesAsync.when(
          data: (categories) => ListView(
            children: categories
                .map(
                  (e) => ListTile(
                    title: Text(e),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => FaqsPage(e),
                        ),
                      );
                    },
                  ),
                )
                .toList(),
          ),
          loading: () => Loading(),
          error: (e, s) => Text(
            e.toString(),
          ),
        ),
      ),
    );
  }
}
