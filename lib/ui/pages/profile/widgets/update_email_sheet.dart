import 'package:pinput/pinput.dart';

import '../../../components/loading.dart';
import '../../../theme/app_colors.dart';
import '../../auth/utils/auth_message.dart';
import '../providers/edit_profile_view_model_provider.dart';
import '../../../../utils/labels.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

final keyProvider = Provider.autoDispose((ref) => GlobalKey<FormState>());

class UpdateEmailSheet extends HookConsumerWidget {
  const UpdateEmailSheet({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final style = theme.textTheme;
    final bottom = MediaQuery.of(context).viewInsets.bottom;
    final model = ref.watch(editProfileViewModelProvider);
    final _formkey = ref.watch(keyProvider);
    final controller = useTextEditingController();
    controller.addListener(() {
      model.code = controller.text;
    });
    final defaultPinTheme = PinTheme(
      width: 40,
      height: 40,
      decoration: BoxDecoration(
        border: Border.all(color: theme.primaryColor),
        borderRadius: BorderRadius.circular(8),
      ),
    );

    return SingleChildScrollView(
      child: Padding(
        padding: EdgeInsets.fromLTRB(24, 24, 24, 24 + bottom),
        child: model.verificationId != null
            ? Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Text(
                          Labels.otpSentTo(model.newEmail),
                          style: style.titleMedium,
                        ),
                      ),
                      GestureDetector(
                        onTap: () {
                          model.verificationId = null;
                        },
                        child: Text(Labels.changeEmail),
                      )
                    ],
                  ),
                  SizedBox(height: 12),
                  Pinput(
                    onTap: () => model.authMessage = AuthMessage.empty(),
                    controller: controller,
                    length: 6,
                    defaultPinTheme: defaultPinTheme,
                    submittedPinTheme: defaultPinTheme.copyWith(
                      decoration: defaultPinTheme.decoration!.copyWith(
                        border: Border.all(
                          color: AppColors.green,
                        ),
                      ),
                    ),
                    errorPinTheme: defaultPinTheme.copyWith(
                      decoration: defaultPinTheme.decoration!.copyWith(
                        border: Border.all(
                          color: AppColors.red,
                        ),
                      ),
                    ),
                    followingPinTheme: defaultPinTheme.copyWith(
                        decoration: defaultPinTheme.decoration!.copyWith(
                            border: model.authMessage.color == AppColors.red
                                ? Border.all(
                                    color: Colors.red,
                                  )
                                : null)),
                  ),
                  SizedBox(height: 12),
                  Text(
                    model.authMessage.text,
                    style: TextStyle(
                      color: model.authMessage.color,
                    ),
                  ),
                  SizedBox(height: 16),
                  Center(
                    child: model.loading2
                        ? Loading()
                        : MaterialButton(
                            color: theme.primaryColor,
                            onPressed: model.code.length == 6
                                ? () {
                                    model.verifyEmailOtp(
                                        clear: controller.clear,
                                        onVerify: () {
                                          Navigator.pop(
                                            context,
                                            model.newEmail,
                                          );
                                        });
                                  }
                                : null,
                            child: Text(Labels.save),
                          ),
                  ),
                ],
              )
            : Form(
                key: _formkey,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(Labels.enterNewEmailAddress),
                    SizedBox(height: 12),
                    TextFormField(
                      validator: (v) => model.validateEmail(v!),
                      keyboardType: TextInputType.emailAddress,
                      autofocus: true,
                      initialValue: model.newEmail,
                      onChanged: (v) => model.newEmail = v,
                    ),
                    SizedBox(height: 16),
                    Center(
                      child: model.loading2
                          ? Loading()
                          : MaterialButton(
                              color: theme.primaryColor,
                              onPressed: model.emailAddress.isNotEmpty
                                  ? () {
                                      if (_formkey.currentState!.validate()) {
                                        model.sendOtpToEmail();
                                      }
                                    }
                                  : null,
                              child: Text(Labels.next),
                            ),
                    ),
                  ],
                ),
              ),
      ),
    );
  }
}
