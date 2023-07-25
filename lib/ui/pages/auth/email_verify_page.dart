import '../../components/my_appbar.dart';
import 'providers/create_profile_view_model_provider.dart';
import '../profile/providers/profile_provider.dart';
import '../../../utils/labels.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import 'create_profile_page.dart';

class EmailVerfiyPage extends ConsumerWidget {
  const EmailVerfiyPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context,WidgetRef ref) {
    final profile = ref.read(profileProvider).value!;
    return Scaffold(
      appBar: MyAppBar(
        title: Text(Labels.emailVerification),
      ),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Spacer(),
            Text(
              Labels.chechEmail,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontWeight: FontWeight.w600,
                fontSize: 15,
              ),
            ),
            SizedBox(height: 16),
            Text(
              '${Labels.aVerificationLinkHasBeen} ${profile.emailAddress}',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontWeight: FontWeight.w600,
              ),
            ),
            SizedBox(height: 16),
            Text(
              Labels.pleaseDoVerifyYourEmail,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontWeight: FontWeight.w600,
              ),
            ),
            Spacer(flex: 6),
            Text(
              Labels.inCaseYouHaveEntered,
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 16),
            Center(
              child: OutlinedButton(
                onPressed: () {
                  ref.read(createProfileViewModelProvider).profile = profile;
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => CreateProfilePage(),
                    ),
                  );
                },
                child: Text(Labels.changeEmail),
              ),
            ),
            Spacer(flex: 3),
          ],
        ),
      ),
    );
  }
}
