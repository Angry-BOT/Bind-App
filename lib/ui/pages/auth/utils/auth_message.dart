import 'dart:ui';

import '../../../theme/app_colors.dart';

class AuthMessage {
  String text;
  Color color;
  AuthMessage({
    required this.text,
    required this.color,
  });

 factory AuthMessage.error(String message) => AuthMessage(
        text: message,
        color: AppColors.red,
      );

  factory AuthMessage.empty() => AuthMessage(
        text: '',
        color: AppColors.primary,
      );
  factory AuthMessage.otpResent() => AuthMessage(
        text: 'OTP Resent',
        color: AppColors.green,
      );
  factory AuthMessage.incorrectOtp() => AuthMessage(
        text: 'Incorrect OTP',
        color: AppColors.red,
      );
}
