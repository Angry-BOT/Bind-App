import '../../components/loading.dart';
import 'assistance_page.dart';
import 'order_page.dart';
import 'providers/assistance_provider.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class AssistanceRoot extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final assistanceStream = ref.watch(assistanceProvider);
    return assistanceStream.when(
      data: (v) => v == null ? AssistancePage() : OrderPage(assistance: v),
      loading: () => Scaffold(
        body: Loading(),
      ),
      error: (e, s) => Scaffold(
        body: Center(
          child: Text(e.toString()),
        ),
      ),
    );
  }
}
