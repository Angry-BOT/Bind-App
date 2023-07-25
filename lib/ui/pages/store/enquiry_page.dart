import 'package:bind_app/ui/components/icons.dart';

import '../../../repository/profile_repository.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../model/enquiry.dart';
import '../../components/my_appbar.dart';
import '../help/enquiry_help_page.dart';
import '../../theme/app_colors.dart';
import '../../../utils/formats.dart';
import '../../../utils/labels.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class AdminEnquiryPage extends ConsumerWidget {
  final Enquiry enquiry;

  const AdminEnquiryPage({Key? key, required this.enquiry}) : super(key: key);
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final style = theme.textTheme;
    return Scaffold(
      appBar: MyAppBar(
        title: Text("${Labels.enquiry} #${enquiry.enquiryId}"),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) =>
                      EnquiryHelpPage(enquiry: enquiry, isAdmin: true),
                ),
              );
            },
            child: Text(
              Labels.needHelp,
              style: style.bodySmall!.copyWith(color: style.bodyLarge!.color),
            ),
          )
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
                      // textAlign: TextAlign.end,
                    ),
                    SizedBox(height: 16),
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            enquiry.customerName,
                            style: style.titleMedium,
                          ),
                        ),
                        SizedBox(width: 4),
                        ElevatedButton(
                          onPressed: () async {
                            try {
                              final profile = await ref
                                  .read(profileRepositoryProvider)
                                  .profileFuture(enquiry.customerId);
                              launch('tel:${profile.mobile}');
                            } catch (e) {
                              print(e.toString());
                            }
                          },
                          child: Text(Labels.contact),
                        ),
                        SizedBox(width: 4),
                        SizedBox(
                          height: 36,
                          width: 36,
                          child: RawMaterialButton(
                            fillColor: theme.primaryColor,
                            shape: CircleBorder(),
                            onPressed: () async {
                              try {
                                final profile = await ref
                                    .read(profileRepositoryProvider)
                                    .profileFuture(enquiry.customerId);
                                launch('https://wa.me/${profile.mobile}');
                              } catch (e) {
                                print(e.toString());
                              }
                            },
                            child: AppIcons.whatsapp,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 12),
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
                    )
                  ],
            ),
          ),
        ],
      ),
    );
  }
}
