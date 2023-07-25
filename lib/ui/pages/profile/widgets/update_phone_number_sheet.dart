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

class UpdatePhoneNumberSheet extends HookConsumerWidget {
  const UpdatePhoneNumberSheet({Key? key}) : super(key: key);

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
                      Text(
                        Labels.otpSentTo(model.newMobile),
                        style: style.titleMedium,
                      ),
                      GestureDetector(
                        onTap: () {
                          model.verificationId = null;
                        },
                        child: Text(Labels.changeNumber),
                      )
                    ],
                  ),
                  SizedBox(height: 12),
                  Row(
                    children: [
                      Expanded(
                        child: Pinput(
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
                                  border:
                                      model.authMessage.color == AppColors.red
                                          ? Border.all(
                                              color: Colors.red,
                                            )
                                          : null)),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(bottom: 8),
                        child: StreamBuilder<int>(
                            initialData: 30,
                            stream: model.stream,
                            builder: (context, snapshot) {
                              return IconButton(
                                disabledColor: style.labelSmall!.color,
                                color: theme.primaryColor,
                                onPressed: snapshot.data! <= 00
                                    ? () => model.sendOTP(
                                          onComplete: () {
                                            Navigator.pop(context);
                                          },
                                        )
                                    : null,
                                icon: Column(
                                  children: [
                                    Icon(Icons.restart_alt),
                                    Text(
                                      snapshot.data! <= 0
                                          ? "0:00"
                                          : "0:${snapshot.data}",
                                      style: style.labelSmall!.copyWith(
                                        fontSize: 6,
                                      ),
                                    )
                                  ],
                                ),
                              );
                            }),
                      )
                    ],
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
                                    model.verifyOTP(
                                        clear: controller.clear,
                                        onVerify: () {
                                          Navigator.pop(
                                              context, model.user.phoneNumber);
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
                    Text(Labels.enterNewMobileNo),
                    SizedBox(height: 12),
                    TextFormField(
                      validator: (v) => model.validateMobile(v!),
                      autofocus: true,
                      initialValue: model.newMobile,
                      onChanged: (v) => model.newMobile = v,
                      maxLength: 10,
                      keyboardType: TextInputType.number,
                    ),
                    SizedBox(height: 16),
                    Center(
                      child: model.loading2
                          ? Loading()
                          : MaterialButton(
                              color: theme.primaryColor,
                              onPressed: model.newMobile.length == 10
                                  ? () {
                                      if (_formkey.currentState!.validate()) {
                                        model.sendOTP(onComplete: () {
                                          Navigator.pop(
                                              context, model.user.phoneNumber);
                                        });
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
