import 'package:bind_app/providers/notify_init_provider.dart';
import 'package:pinput/pinput.dart';

import '../../dash_board/dash_board.dart';
import '../../theme/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../../utils/labels.dart';
import '../../components/big_button.dart';
import '../../components/progess_loader.dart';
import 'providers/auth_view_model_provider.dart';
import 'utils/auth_message.dart';

class VerifyPage extends HookConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final style = theme.textTheme;

    final defaultPinTheme = PinTheme(
      width: 40,
      height: 40,
      constraints: BoxConstraints.expand(
        height: 40,
      ),
      decoration: BoxDecoration(
        border: Border.all(color: theme.primaryColor),
        borderRadius: BorderRadius.circular(8),
      ),
    );

    final controller = useTextEditingController();
    final model = ref.watch(authViewModelProvider);
    controller.addListener(() {
      model.code = controller.text;
    });
    return ProgressLoader(
      isLoading: model.loading,
      child: Scaffold(
        backgroundColor: theme.colorScheme.background,
        body: Padding(
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
                        Labels.verifyOTP,
                        style: style.titleLarge,
                      ),
                      SizedBox(height: 48),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            Labels.otpSentTo(model.phone),
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
                      SizedBox(height: 8),
                      Row(
                        children: [
                          Expanded(
                            child: Pinput(
                              separator: SizedBox(
                                width: MediaQuery.of(context).size.width/40,
                              ),
                              onTap: () =>
                                  model.authMessage = AuthMessage.empty(),
                              controller: controller,
                              length: 6,
                              defaultPinTheme: defaultPinTheme,
                              submittedPinTheme: defaultPinTheme.copyWith(
                                decoration:
                                    defaultPinTheme.decoration!.copyWith(
                                  border: Border.all(
                                    color: AppColors.green,
                                  ),
                                ),
                              ),
                              errorPinTheme: defaultPinTheme.copyWith(
                                decoration:
                                    defaultPinTheme.decoration!.copyWith(
                                  border: Border.all(
                                    color: AppColors.red,
                                  ),
                                ),
                              ),
                              followingPinTheme: defaultPinTheme.copyWith(
                                  decoration: defaultPinTheme.decoration!
                                      .copyWith(
                                          border: model.authMessage.color ==
                                                  AppColors.red
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
                                            onSend: () {},
                                            onComplete: () {
                                              ref
                                                  .read(indexProvider.state)
                                                  .state = 0;
                                            })
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
                      )
                    ],
                  ),
                ),
              ),
              BigButton(
                child: Text(Labels.verify),
                onPressed: model.code.length == 6
                    ? () {
                        model.verifyOTP(
                            clear: controller.clear,
                            onVerify: () {
                              ref.read(indexProvider.state).state = 0;
                              //TODO
                              ref.refresh(notifiyInitProivder(context));
                            });
                      }
                    : null,
              ),
              SizedBox(height: 24)
            ],
          ),
        ),
      ),
    );
  }
}
