import 'package:bind_app/providers/notify_init_provider.dart';

import '../../dash_board/dash_board.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../../../utils/labels.dart';
import '../../components/big_button.dart';
import '../../components/progess_loader.dart';
import 'providers/auth_view_model_provider.dart';

class LoginPage extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final style = theme.textTheme;
    final GoogleSignIn googleSignIn = GoogleSignIn();
    final FirebaseAuth firebaseAuth = FirebaseAuth.instance;
    final model = ref.watch(authViewModelProvider);
    return Scaffold(
      backgroundColor: theme.colorScheme.background,
      body: ProgressLoader(
        isLoading: model.loading,
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            children: [
              Expanded(
                child: SizedBox(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        Labels.signupOrLogin,
                        style: style.titleLarge,
                      ),
                      SizedBox(height: 48),
                      Text(
                        Labels.enterYourMobileNumber,
                        style: style.titleMedium,
                      ),
                      SizedBox(height: 12),
                      TextFormField(
                        initialValue: model.phone,
                        maxLength: 10,
                        keyboardType: TextInputType.number,
                        onChanged: (v) => model.phone = v,
                        textAlign: TextAlign.center,
                        decoration: InputDecoration(
                          enabledBorder:
                              theme.inputDecorationTheme.border!.copyWith(
                            borderSide: BorderSide(
                              color: theme.primaryColor,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              BigButton(
                child: Text(Labels.continueButton),
                onPressed: model.phone.length == 10
                    ? () => model.sendOTP(
                          onComplete: () {
                            ref.read(indexProvider.state).state = 0;
                            ref.refresh(notifiyInitProivder(context));
                          },
                          onSend: () {},
                        )
                    : null,
              ),
              SizedBox(height: 24),
              BigButton(
                child: Text('Sign in with Google'),
                onPressed: () async {
                  final GoogleSignInAccount? googleUser =
                      await googleSignIn.signIn();
                  final GoogleSignInAuthentication googleAuth =
                      await googleUser!.authentication;

                  // Use these details to create a new auth credential
                  final credential = GoogleAuthProvider.credential(
                    accessToken: googleAuth.accessToken,
                    idToken: googleAuth.idToken,
                  );

                  // Sign in to Firebase with the Google [UserCredential]
                  await firebaseAuth.signInWithCredential(credential);

                  // Optional: once signed in, navigate to the next screen
                  Navigator.of(context).pushReplacementNamed('/nextScreen');
                },
              ),
              SizedBox(height: 24)
            ],
          ),
        ),
      ),
    );
  }
}
