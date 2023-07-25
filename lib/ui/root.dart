import 'package:bind_app/ui/dash_board/widgets/my_navi_bar.dart';
import 'package:bind_app/ui/pages/auth/create_profile_page.dart';
import 'package:bind_app/ui/pages/splash/splash_page.dart';
import 'package:bind_app/ui/pages/store/message_page.dart';
import 'package:bind_app/utils/constants.dart';
import 'package:bind_app/utils/labels.dart';

import '../providers/init_share_provider.dart';
import '../providers/notify_init_provider.dart';
import 'components/loading.dart';
import 'pages/auth/email_verify_page.dart';
import 'pages/auth/verify_page.dart';

import '../enums/status.dart';
import 'dash_board/dash_board.dart';
import 'pages/address/select_address_page.dart';
import 'pages/banned_page.dart';
import 'pages/home/providers/home_view_model_provider.dart';
import 'pages/store/get_started_store.dart';
import 'pages/store/not_registered_page.dart';
import 'pages/store/providers/admin_store_provider.dart';
import 'pages/store/store_admin_page.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import 'pages/auth/login_page.dart';
import 'pages/auth/providers/auth_view_model_provider.dart';
import 'pages/auth/write_address_page.dart';
import 'pages/profile/providers/profile_provider.dart';

class Root extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final auth = ref.watch(authViewModelProvider);
    ref.read(initShareProvider);

    return auth.user == null
        ? Navigator(
            pages: [
              MaterialPage(child: LoginPage()),
              if (auth.verificationId != null)
                MaterialPage(
                  child: VerifyPage(),
                )
            ],
            onPopPage: (route, value) {
              return route.didPop(value);
            },
          )
        : Builder(
            builder: (context) {
              final profileStream = ref.watch(profileProvider);
              return profileStream.when(
                data: (profile) {
                  if (!profile.isEmailVerified) {
                    return EmailVerfiyPage();
                  } else {
                    if (profile.addresses.isNotEmpty) {
                      if (profile.status == Status.Banned) {
                        return BannedPage();
                      }
                      return DashboardRoot();
                    } else {
                      ref.read(dotProvider).dot = 1;
                      return WriteAddressPage();
                    }
                  }
                },
                loading: () => SplashView(),
                error: (e, s) {
                  print(e);

                  return CreateProfilePage();
                },
              );
            },
          );
  }
}

final messageProvider = ChangeNotifierProvider((ref) => StoreMessage());

class StoreMessage extends ChangeNotifier {
  bool value = false;

  void show() {
    value = true;
  }

  void remove() {
    value = false;
    type = '';
    message = '';
    notifyListeners();
  }

  void update(){
    notifyListeners();
  }

  String message = '';
  String type = '';
  String? get description =>
      type == Constants.failed ? Labels.pleaseCheckYourEmail : null;
}

class StoreRoot extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final profile = ref.watch(profileProvider).value!;
    final storeStream = ref.watch(adminStoreProvider);
    final message = ref.watch(messageProvider);
    if (!profile.isEntrepreneur) {
      return NotRegisteredPage();
    } else {
      return storeStream.when(
        data: (store) => message.value
            ? message.type.isEmpty
                ? GetStartedPage(
                    applied: true,
                    created: true,
                  )
                : MessagePage(
                    created: true,
                  )
            : StoreAdminPage(),
        loading: () => Scaffold(
          body: Loading(),
        ),
        error: (e, s) {
          return message.value && message.type.isNotEmpty
              ? MessagePage(
                  created: false,
                )
              : GetStartedPage(
                  applied: profile.aadharId != null,
                  created: false,
                );
        },
      );
    }
  }
}

class DashboardRoot extends ConsumerStatefulWidget {
  const DashboardRoot({Key? key}) : super(key: key);

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _DashboardRootState();
}

class _DashboardRootState extends ConsumerState<DashboardRoot>
    with WidgetsBindingObserver {
  @override
  void initState() {
    ref.read(notifiyInitProivder(context));
    WidgetsBinding.instance.addObserver(this);
    super.initState();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);
    if (state == AppLifecycleState.resumed) {
      MyMessageHandler.handle(context: context, reader: ref.read);
    }
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final model = ref.watch(homeViewModelProvider);
    return model.address != null ? Dashboard() : SelectAddressPage();
  }
}
