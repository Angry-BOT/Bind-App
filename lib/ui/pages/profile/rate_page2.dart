import '../../../model/enquiry.dart';
import '../../components/big_button.dart';
import '../../components/my_appbar.dart';
import 'providers/rate_view_model_provider.dart';
import '../../../utils/labels.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class RatePage2 extends ConsumerWidget {
  final Enquiry enquiry;

  RatePage2(this.enquiry);
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final style = theme.textTheme;
    final model = ref.watch(rateViewModelProvider(enquiry.storeId));
    return Scaffold(
      appBar: MyAppBar(
        title: Text(Labels.rate),
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.fromLTRB(24, 0, 24, 24),
        child: BigButton(
          child: Text(Labels.submit),
          onPressed: model.wrongMessage != null &&
                  model.wrongMessage!.isNotEmpty &&
                  model.reason != null
              ? () {
                  model.submitFailedDeal(enquiry.enquiryId, enquiry.id);
                  Navigator.pop(context);
                }
              : null,
        ),
      ),
      body: ListView(
        padding: EdgeInsets.all(24),
        children: <Widget>[
              Text(
                Labels.helpUsWithTheReason,
                style: style.titleMedium,
              ),
            ] +
            [
              Labels.theSellerDidNotSeemToBeTrusted,
              Labels.thePaymentTermsDidNotWorkOut,
              Labels.theProductServiceWasNotAvailable,
              Labels.sellerDidNotHaveTime,
            ]
                .map(
                  (e) => Row(
                    children: [
                      Radio(
                          value: model.reason == e,
                          groupValue: true,
                          onChanged: (v) {
                            model.reason = e;
                          }),
                      Expanded(
                        child: Text(e),
                      ),
                    ],
                  ),
                )
                .toList() +
            [
              SizedBox(height: 16),
              Text(
                Labels.letUsKnowWhatWentWrong,
                style: style.titleMedium,
              ),
              SizedBox(height: 8),
              TextField(
                textCapitalization: TextCapitalization.sentences,
                onChanged: (v) => model.wrongMessage = v,
                minLines: 5,
                maxLines: 10,
                textInputAction: TextInputAction.done,
              )
            ],
      ),
    );
  }
}
