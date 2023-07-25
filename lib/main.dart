import 'package:bind_app/providers/keys_provider.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import 'ui/pages/splash/splash_page.dart';
import 'ui/theme/app_colors.dart';
import 'utils/labels.dart';

Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp();
  print("Handling a background message: ${message.messageId}");
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
  await Firebase.initializeApp();
  runApp(ProviderScope(child: MyApp()));
}

class MyApp extends ConsumerWidget {
  TextTheme _buildTextTheme(TextTheme base) {
    return base
        .copyWith(
          titleLarge: TextStyle(
            fontWeight: FontWeight.w700,
          ),
          titleSmall: TextStyle(fontWeight: FontWeight.w600, fontSize: 16),
        )
        .apply(
          fontFamily: 'EuclidSquare',
          bodyColor: AppColors.textColor,
        )
        .copyWith(
          labelSmall: TextStyle(color: Color(0xFF838B97), letterSpacing: 0.25),
        );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    ref.read(keysProvider).init();
    final base = ThemeData.light();
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: Labels.bindName,
      theme: ThemeData(
        primaryColor: AppColors.primary,
        iconTheme: IconThemeData(
          color: AppColors.iconColor,
        ),
        primaryIconTheme: IconThemeData(
          color: AppColors.iconColor,
        ),
        appBarTheme: AppBarTheme(
          systemOverlayStyle: SystemUiOverlayStyle.dark.copyWith(
            statusBarColor: Colors.transparent
          ),
          backgroundColor: Colors.transparent,
        ),
        bottomNavigationBarTheme:
            BottomNavigationBarThemeData(backgroundColor: Color(0xFFF6F6F6)),
        shadowColor: AppColors.shadowColor,
        scaffoldBackgroundColor: AppColors.scaffoldbackgroundColor,
        disabledColor: AppColors.disabledColor,
        textTheme: _buildTextTheme(base.textTheme),
        primaryTextTheme: _buildTextTheme(base.primaryTextTheme),
        buttonTheme: ButtonThemeData(
          shape: StadiumBorder(),
          padding: EdgeInsets.symmetric(
            horizontal: 32,
            vertical: 16,
          ),
          textTheme: ButtonTextTheme.primary,
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ButtonStyle(
            backgroundColor: MaterialStateProperty.all(AppColors.primary),
            shape: MaterialStateProperty.all(StadiumBorder()),
            padding: MaterialStateProperty.all(
              EdgeInsets.symmetric(horizontal: 16),
            ),
          ),
        ),
        dividerTheme: DividerThemeData(
          thickness: 1,
        ),
        outlinedButtonTheme: OutlinedButtonThemeData(
          style: ButtonStyle(
            shape: MaterialStateProperty.all(StadiumBorder()),
            side: MaterialStateProperty.all(
              BorderSide(
                color: AppColors.primary,
              ),
            ),
            foregroundColor: MaterialStateProperty.all(Colors.black),
          ),
        ),
        cardTheme: CardTheme(
          clipBehavior: Clip.antiAlias,
        ),
        inputDecorationTheme: InputDecorationTheme(
          contentPadding: EdgeInsets.all(16),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
          ),
        ), colorScheme: ColorScheme.fromSwatch(primarySwatch: Colors.amber).copyWith(background: AppColors.backgroundColor),
      ),
      home: SplashPage(),
    );
  }
}
