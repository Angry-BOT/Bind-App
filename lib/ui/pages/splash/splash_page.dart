import '../../../providers/pref_provider.dart';

import '../../../repository/local_repository.dart';
import '../onboarding/onboarding_page.dart';
import '../../root.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:flutter/material.dart';

import '../../../utils/assets.dart';

final seenProvider = FutureProvider<bool>((ref) async {
  await Future.delayed(Duration(seconds: 1));
  await ref.read(prefProvider.future);
  return ref.read(localRepositoryProvider).readSeen();
});

class SplashPage extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return ref.watch(seenProvider).when(
          data: (value) => value ? Root() : OnboardingPage(),
          loading: () => SplashView(),
          error: (e, s) => SplashView(),
        );
  }
}

class SplashView extends StatelessWidget {
  const SplashView({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Theme.of(context).primaryColor,
      child: SafeArea(
        child: Center(
          child: Image.asset(
            Assets.logo,
            height: 160,
          ),
        ),
      ),
    );
  }
}
