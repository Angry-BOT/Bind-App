import 'package:bind_app/ui/components/stars_background.dart';
import 'package:bind_app/utils/assets.dart';
import 'package:bind_app/utils/formats.dart';

import '../../../model/enquiry.dart';
import '../../components/my_appbar.dart';
import '../../theme/app_colors.dart';
import '../../../utils/labels.dart';
import 'package:flutter/material.dart';

class EnquiryPage extends StatelessWidget {
  final Enquiry enquiry;

  const EnquiryPage({Key? key, required this.enquiry}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final style = theme.textTheme;
    return Scaffold(
      appBar: MyAppBar(
        title: Text("${Labels.enquiry} ${enquiry.enquiryId}"),
      ),
      body: ListView(
        padding: EdgeInsets.all(16),
        children: [
          AspectRatio(
            aspectRatio: 1,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Spacer(),
                Expanded(
                  flex: 8,
                  child: Stack(
                    fit: StackFit.expand,
                    alignment: Alignment.center,
                    children: [
                      StarsBackground(),
                      Image.asset(Assets.enquirySent),
                    ],
                  ),
                ),
                Spacer(),
                Text(
                  Labels.thankYouYourEnquiry,
                  style: style.titleLarge,
                  textAlign: TextAlign.center,
                ),
                Spacer(),
                MaterialButton(
                  color: theme.primaryColor,
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: Text(Labels.backToStore),
                ),
                Spacer(),
              ],
            ),
          ),
          Divider(height: 0.5),
          SizedBox(height: 16),
          Container(
            decoration: BoxDecoration(
              color: theme.cardColor,
              borderRadius: BorderRadius.circular(8),
              boxShadow: [
                BoxShadow(color: theme.shadowColor, blurRadius: 8),
              ],
            ),
            padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 8),
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        Formats.dateTime(enquiry.createdAt),
                        style: style.bodySmall,
                      ),
                      Material(
                        borderRadius: BorderRadius.circular(4),
                        color: AppColors.green,
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 8, vertical: 4),
                          child: Text(
                            "SUCCESS",
                            style: style.bodySmall!.copyWith(
                              color: theme.cardColor,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    children: [
                      Expanded(
                        child: Text(
                          Labels.store,
                          style: style.bodyLarge,
                        ),
                      ),
                      Expanded(
                        flex: 3,
                        child: Text(enquiry.storeName),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    children: [
                      Expanded(
                        child: Text(
                          Labels.items,
                          style: style.bodyLarge,
                        ),
                      ),
                      Expanded(
                        flex: 3,
                        child: Text(
                            '${enquiry.products.first} ${enquiry.products.length > 1 ? "+ ${enquiry.products.length - 1} others" : ''}'),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}
