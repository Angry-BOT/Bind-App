import '../../components/loading.dart';
import 'providers/enquiry_provider.dart';
import '../store/enquiry_page.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class AdminEnquiryRoot extends ConsumerWidget {
  const AdminEnquiryRoot({Key? key, required this.id}) : super(key: key);
  final String id;
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return ref.watch(enquiryProvider(id)).when(
          data: (enquiry) => AdminEnquiryPage(enquiry: enquiry),
          loading: () => Scaffold(
            body: Loading(),
          ),
          error: (e, s) => Scaffold(
            body: Text(
              e.toString(),
            ),
          ),
        );
  }
}
