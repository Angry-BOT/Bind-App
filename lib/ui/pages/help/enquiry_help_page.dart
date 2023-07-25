import '../../../model/enquiry.dart';
import '../../components/icons.dart';
import '../../components/my_appbar.dart';
import '../../theme/app_colors.dart';
import '../../../utils/constants.dart';
import '../../../utils/formats.dart';
import '../../../utils/labels.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class EnquiryHelpPage extends StatelessWidget {
  const EnquiryHelpPage({Key? key, required this.enquiry, this.isAdmin = false})
      : super(key: key);
  final Enquiry enquiry;
  final bool isAdmin;
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final style = theme.textTheme;
    final message =
        "Hi, I need help with ${enquiry.enquiryId} for ${isAdmin ? "my " : ""}BIND Store ${enquiry.username}";
    return Scaffold(
      appBar: MyAppBar(
        title: Text(Labels.help),
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
                  Formats.dateTime(enquiry.createdAt),
                  style: style.bodySmall,
                  textAlign: TextAlign.end,
                ),
                SizedBox(height: 12),
                isAdmin
                    ? Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                              Text(
                                enquiry.customerName,
                                style: style.titleMedium,
                              ),
                              SizedBox(height: 16),
                              Text(
                                Labels.interestedIn,
                                style: style.bodyLarge,
                              ),
                              SizedBox(height: 8),
                            ] +
                            enquiry.products
                                .map((e) => Row(
                                      children: [
                                        CircleAvatar(
                                          radius: 2,
                                          backgroundColor: theme.primaryColor,
                                        ),
                                        SizedBox(width: 4),
                                        Text(
                                          e,
                                          style: style.bodySmall,
                                        )
                                      ],
                                    ))
                                .toList() +
                            [
                              SizedBox(height: 32),
                              Text(
                                Labels.deliveryAddress.toUpperCase(),
                                style: style.bodyLarge,
                              ),
                              SizedBox(height: 12),
                              Text(
                                enquiry.address.customFormat,
                                style: style.bodySmall,
                              ),
                              SizedBox(height: 32),
                              TextFormField(
                                minLines: 1,
                                maxLines: 5,
                                readOnly: true,
                                initialValue: enquiry.message,
                                textInputAction: TextInputAction.done,
                              )
                            ],
                      )
                    : Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
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
                            textInputAction: TextInputAction.done,
                          ),
                        ],
                      ),
                SizedBox(height: 24),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    MaterialButton(
                      color: theme.primaryColor,
                      onPressed: () {
                        launch(
                            'mailto:${Constants.supportEmail}?&body=$message');
                      },
                      child: Row(
                        children: [
                          Icon(
                            Icons.email_outlined,
                            size: 18,
                          ),
                          SizedBox(width: 4),
                          Text(Labels.emailUs),
                        ],
                      ),
                    ),
                    MaterialButton(
                      color: theme.primaryColor,
                      onPressed: () {
                        launch(
                            'https://wa.me/${Constants.supportContact}?text=$message');
                      },
                      child: Row(
                        children: [
                          AppIcons.whatsapp,
                          SizedBox(width: 4),
                          Text(Labels.whatsapp),
                        ],
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 12),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
