import '../../components/loading.dart';
import '../credits/providers/enquiry_provider.dart';

import '../../../model/enquiry.dart';
import '../../components/my_appbar.dart';
import '../help/enquiry_help_page.dart';
import 'providers/rate_view_model_provider.dart';
import 'rate_page.dart';
import 'rate_page2.dart';
import '../../theme/app_colors.dart';
import '../../../utils/formats.dart';
import '../../../utils/labels.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class MyEnquiryPage extends ConsumerWidget {
  final Enquiry enquiry;

  const MyEnquiryPage({Key? key, required this.enquiry}) : super(key: key);
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final style = theme.textTheme;
    final reviewed = ref.watch(reviewedProvider.state).state;
    return Scaffold(
      appBar: MyAppBar(
        titleSpacing: 0,
        title: Row(
          children: [
            Flexible(child: Text("${Labels.enquiry} ")),
            Text("#${enquiry.enquiryId}"),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => EnquiryHelpPage(enquiry: enquiry),
                ),
              );
            },
            child: Text(
              Labels.needHelp,
              style: style.bodySmall!.copyWith(color: style.bodyLarge!.color),
            ),
          ),
        ],
      ),
      body: ListView(
        padding: EdgeInsets.all(16),
        children: [
          Container(
            decoration: BoxDecoration(
              color: theme.cardColor,
              boxShadow: [
                BoxShadow(
                  color: AppColors.shadowColor,
                  blurRadius: 12,
                )
              ],
              borderRadius: BorderRadius.circular(8),
            ),
            padding: EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text(
                  Formats.date(enquiry.createdAt),
                  style: style.bodySmall,
                  textAlign: TextAlign.end,
                ),
                SizedBox(height: 12),
                Text(
                  enquiry.storeName,
                  style: style.titleMedium,
                ),
                Text(
                  "${Labels.by} ${enquiry.username}",
                  style: style.bodySmall!.copyWith(fontSize: 11),
                ),
                SizedBox(height: 12),
                Text(
                  Labels.enquiredFor,
                  style: style.bodySmall,
                ),
                Text(enquiry.products.join(', ')),
                SizedBox(height: 12),
                Text(
                  Labels.deliveryAddress,
                  style: style.bodySmall,
                ),
                Text(enquiry.address.customFormat),
                SizedBox(height: 12),
                TextFormField(
                  minLines: 1,
                  maxLines: 5,
                  readOnly: true,
                  initialValue: enquiry.message,
                ),
              ],
            ),
          ),
          SizedBox(height: 32),
          enquiry.reviewed || reviewed.contains(enquiry.id)
              ? SizedBox()
              : enquiry.readyForReview
                  ? Text(
                      Labels.didYouSuccessfully,
                      textAlign: TextAlign.center,
                      style: style.titleMedium,
                    )
                  : SizedBox(),
          SizedBox(height: 16),
          (enquiry.reviewed || reviewed.contains(enquiry.id))
              ? SizedBox()
              : enquiry.readyForReview
                  ? Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        OutlinedButton(
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => RatePage(
                                  storeId: enquiry.storeId,
                                  enquiryId: enquiry.id,
                                ),
                              ),
                            );
                          },
                          style: ButtonStyle(
                            side: MaterialStateProperty.all(
                              BorderSide(color: AppColors.green),
                            ),
                          ),
                          child: Text(Labels.yes),
                        ),
                        SizedBox(width: 16),
                        OutlinedButton(
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => RatePage2(enquiry),
                              ),
                            );
                          },
                          child: Text(Labels.no),
                          style: ButtonStyle(
                            side: MaterialStateProperty.all(
                              BorderSide(color: theme.colorScheme.error),
                            ),
                          ),
                        ),
                      ],
                    )
                  : SizedBox()
        ],
      ),
    );
  }
}

class MyEnquiryRoot extends ConsumerWidget {
  const MyEnquiryRoot({Key? key, required this.id}) : super(key: key);
  final String id;
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return ref.watch(enquiryProvider(id)).when(
          data: (enquiry) => MyEnquiryPage(enquiry: enquiry),
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
