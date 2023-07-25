import '../../../../model/enquiry.dart';
import '../../../components/gray_label.dart';
import '../../../theme/app_colors.dart';
import '../../../../utils/formats.dart';
import '../../../../utils/labels.dart';
import 'package:flutter/material.dart';

import '../my_enquiry_page.dart';

class MyEnquiryCard extends StatelessWidget {
  final Enquiry enquiry;
  const MyEnquiryCard({Key? key, required this.enquiry}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final style = theme.textTheme;
    return Container(
      clipBehavior: Clip.antiAlias,
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
      margin: EdgeInsets.all(8),
      child: Stack(
        children: [
          Padding(
            padding: EdgeInsets.all(24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  Formats.date(enquiry.createdAt),
                  style: style.labelSmall,
                ),
                SizedBox(height: 8),
                Text(
                  enquiry.storeName,
                  style: style.titleMedium,
                ),
                SizedBox(height: 8),
                Text(
                  enquiry.storeType,
                  style: style.bodySmall,
                ),
                SizedBox(height: 4),
                Row(
                  children: [
                    Flexible(
                      child: Text(
                        enquiry.products.first,
                        // style: style.caption!.copyWith(
                        //   color: style.
                        // ),
                      ),
                    ),
                    SizedBox(width: 8),
                    enquiry.products.length > 1
                        ? GrayLabel(
                            label: "+ ${enquiry.products.length - 1} others")
                        : SizedBox()
                  ],
                ),
              ],
            ),
          ),
          Positioned(
            right: 0,
            child: Material(
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(8)
              ),
              color: enquiry.bought
                  ? AppColors.lightGreen
                  : enquiry.expired
                      ? AppColors.lightRed
                      : AppColors.loghtOrange,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                child: Text(
                  enquiry.bought
                      ? Labels.enquiryViewed
                      : enquiry.expired
                          ? Labels.enquiryNotAccepted
                          : Labels.enquiryYetToBeAccepted,
                  style: TextStyle(
                      fontSize: 8,
                      fontWeight: FontWeight.bold,
                      color: enquiry.bought
                          ? AppColors.greenAccent
                          : enquiry.expired
                              ? AppColors.redDark
                              : AppColors.orange),
                ),
              ),
            ),
          ),
          Positioned(
            right: 16,
            top: 0,
            bottom: 0,
            child: Center(
              child: ElevatedButton(
                style: ButtonStyle(
                  padding: MaterialStateProperty.all(
                    EdgeInsets.symmetric(horizontal: 24),
                  ),
                ),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => MyEnquiryPage(enquiry: enquiry),
                    ),
                  );
                },
                child: Text(Labels.view),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
