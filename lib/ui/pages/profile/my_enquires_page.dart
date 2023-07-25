import '../../components/loading.dart';
import '../../components/my_appbar.dart';
import 'providers/my_enquires_provider.dart';
import 'widgets/my_enquiry_card.dart';
import '../../../utils/labels.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class MyEnquiresPage extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final enquiresAsync = ref.watch(myEnquiresProvider);
    return Scaffold(
      appBar: MyAppBar(
        title: Text(Labels.myEnquiries),
      ),
      body: RefreshIndicator(
        onRefresh: () async {
          ref.refresh(myEnquiresProvider);
        },
        child: enquiresAsync.when(
          data: (enquires) => ListView(
            padding: EdgeInsets.all(8),
            children: enquires
                .map(
                  (e) => MyEnquiryCard(enquiry: e),
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
