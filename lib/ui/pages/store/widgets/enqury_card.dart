import '../../../../model/enquiry.dart';
import '../../../components/gray_label.dart';
import '../../credits/widgets/credit.dart';
import '../enquiry_page.dart';
import 'enquiry_buy_dialog.dart';
import '../../../theme/app_colors.dart';
import '../../../../utils/formats.dart';
import '../../../../utils/labels.dart';
import 'package:flutter/material.dart';

class EnquiryCard extends StatelessWidget {
  final Enquiry enquiry;

  const EnquiryCard({Key? key, required this.enquiry}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final style = theme.textTheme;
    return AspectRatio(
      aspectRatio: 2.5,
      child: Container(
        decoration: BoxDecoration(
          color: theme.cardColor,
          boxShadow: [
            BoxShadow(
              color: AppColors.shadowColor,
              blurRadius: 12,
            )
          ],
          borderRadius: BorderRadius.circular(20),
        ),
        margin: EdgeInsets.all(8),
        padding: EdgeInsets.all(16),
        child: Stack(
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      Formats.date(enquiry.createdAt),
                      style: style.labelSmall,
                    ),
                    enquiry.pending
                        ? StreamBuilder<int>(
                            initialData: 0,
                            stream: Stream.periodic(
                                Duration(seconds: 1), (v) =>  v),
                            builder: (context, snap) {
                              final duration = enquiry.expiryDate.difference(DateTime.now());
                              return RichText(
                                text: TextSpan(
                                  text: Labels.expiresIn,
                                  style: style.labelSmall!
                                      .copyWith(color: Colors.black),
                                  children: [
                                    TextSpan(
                                      text:
                                          ' ${Formats.duration(duration.inMinutes)}',
                                      style: style.labelSmall!.copyWith(
                                        color: theme.colorScheme.error,
                                        fontSize: 8,
                                      ),
                                    ),
                                  ],
                                ),
                              );
                            },
                          )
                        : !enquiry.bought
                            ? RichText(
                                text: TextSpan(
                                  text: Labels.expiredOn,
                                  style: style.labelSmall!
                                      .copyWith(color: Colors.black),
                                  children: [
                                    TextSpan(
                                      text:
                                          ' ${Formats.date(enquiry.expiryDate)}',
                                      style: style.labelSmall!.copyWith(
                                        color: theme.colorScheme.error,
                                        fontSize: 8,
                                      ),
                                    ),
                                  ],
                                ),
                              )
                            : SizedBox()
                  ],
                ),
                Spacer(),
                Text(
                 enquiry.bought? enquiry.customerName:enquiry.customerName.split(' ').first,
                  style: style.titleMedium,
                ),
                Spacer(),
                Text(
                  Labels.interestedIn,
                  style: TextStyle(fontSize: 8),
                ),
                Row(
                  children: [
                    Flexible(
                      child: Text(
                        enquiry.products.first,
                        style: style.bodySmall,
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
            Positioned(
              right: 0,
              top: 0,
              bottom: 0,
              child: Center(
                child: enquiry.bought
                    ? ElevatedButton(
                        style: ButtonStyle(
                          padding: MaterialStateProperty.all(
                            EdgeInsets.symmetric(horizontal: 24),
                          ),
                        ),
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) =>
                                  AdminEnquiryPage(enquiry: enquiry),
                            ),
                          );
                        },
                        child: Text(Labels.view),
                      )
                    : enquiry.pending
                        ? OutlinedButton.icon(
                            style: ButtonStyle(
                                padding: MaterialStateProperty.all(
                                    EdgeInsets.fromLTRB(8, 8, 12, 8))),
                            onPressed: () {
                              showDialog(
                                context: context,
                                builder: (context) => EnquiryBuyDialog(id: enquiry.id),
                              );
                            },
                            icon: Credit(size: 24),
                            label: Text('1 Credit'),
                          )
                        : OutlinedButton(
                            style: ButtonStyle(
                              side: MaterialStateProperty.all(
                                BorderSide(
                                  color: AppColors.red,
                                ),
                              ),
                            ),
                            onPressed: null,
                            child: Text(
                              Labels.expired,
                              style: TextStyle(
                                color: AppColors.red,
                              ),
                            ),
                          ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
