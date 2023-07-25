import '../../components/loading.dart';
import '../../components/my_appbar.dart';
import 'providers/faqs_provider.dart';
import '../../../utils/labels.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import 'faq_page.dart';

class FaqsPage extends ConsumerWidget {
  final String category;
  FaqsPage(this.category);
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final faqsAsync = ref.watch(faqsProvider(category));
    return Scaffold(
      appBar: MyAppBar(
        title: Text(Labels.fAQ),
      ),
      body: RefreshIndicator(
        onRefresh: () async {
          ref.refresh(faqsProvider(category));
        },
        child: faqsAsync.when(
          data: (faqs) => ListView(
            children: faqs
                .map(
                  (e) => ListTile(
                    title: Text(e.name),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => FaqPage(faq: e),
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
