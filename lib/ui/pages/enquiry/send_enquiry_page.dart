import 'package:bind_app/ui/components/progess_loader.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../../model/store.dart' as models;
import '../../components/big_button.dart';
import '../../components/my_appbar.dart';
import 'enquiry_page.dart';
import 'product_selection_page.dart';
import 'providers/enquire_view_model_provider.dart';
import '../store/widgets/store_banner.dart';
import '../../../utils/labels.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

class SendEnquiryPage extends HookConsumerWidget {
  final models.Store store;

  const SendEnquiryPage({Key? key, required this.store}) : super(key: key);
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final model = ref.watch(enquireViewModelProvider(store.id));
    final controller =
        useTextEditingController(text: model.products.join(', '));

    return ProgressLoader(
      isLoading: model.loading,
      child: Scaffold(
        appBar: MyAppBar(
          title: Text("${Labels.sendEnquiry}${model.enquiry.id}"),
        ),
        bottomNavigationBar: Padding(
          padding: const EdgeInsets.only(left: 24, bottom: 24, right: 24),
          child: BigButton(
            child: Text(Labels.send),
            arrow: true,
            onPressed: model.ready
                ? () {
                    model.enquire(onDone: (enquiry) {
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                          builder: (context) => EnquiryPage(enquiry: enquiry),
                        ),
                      );
                    });
                  }
                : null,
          ),
        ),
        body: ListView(
          padding: EdgeInsets.all(8),
          children: [
            StoreBanner(store: store),
            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(Labels.whatAreYouInterested),
                  SizedBox(height: 8),
                  TextFormField(
                    controller: controller,
                    onTap: () async {
                      await Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) =>
                              ProductSelectionPage(store: store),
                        ),
                      );
                      controller.text = model.products.join(', ');
                    },
                    readOnly: true,
                    decoration: InputDecoration(
                        suffixIcon: Icon(Icons.keyboard_arrow_down)),
                  ),
                  SizedBox(height: 32),
                  Text(Labels.message),
                  SizedBox(height: 8),
                  TextFormField(
                    initialValue: model.message,
                    textCapitalization: TextCapitalization.sentences,
                    maxLines: 5,
                    onChanged: (v) => model.message = v,
                    textInputAction: TextInputAction.done,
                  )
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
