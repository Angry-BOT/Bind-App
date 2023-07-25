import '../../../repository/local_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../../utils/assets.dart';
import '../../../utils/labels.dart';
import '../../components/big_button.dart';
import '../../components/my_appbar.dart';
import '../../root.dart';

class OnboardingPage extends HookConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final style = theme.textTheme;

    final _controller = useTabController(initialLength: 3);
    _controller.addListener(
      () {
        ref.read(onBoardingIndexProvider.state).state = _controller.index;
      },
    );
    return Scaffold(
      appBar: MyAppBar(
        underline: false,
        actions: [
          TextButton(
            onPressed: () {
              ref.read(localRepositoryProvider).saveSeen();
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                  builder: (context) => Root(),
                ),
              );
            },
            child: Text(
              Labels.skip,
              style: TextStyle(color: style.bodySmall!.color),
            ),
          ),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: TabBarView(
              controller: _controller,
              children: [
                Padding(
                  padding: const EdgeInsets.all(24),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Image.asset(Assets.onboarding1),
                      Text(
                        Labels.onboarding1,
                        style: style.titleLarge,
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(24),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Image.asset(Assets.onboarding2),
                      Text(
                        Labels.onboarding2,
                        style: style.titleLarge,
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(24),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Image.asset(Assets.onboarding3),
                      Text(
                        Labels.onboarding3,
                        style: style.titleLarge,
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
            child: BigButton(
              arrow: true,
              child: Text(Labels.next),
              onPressed: () {
                if (_controller.index == 2) {
                  ref.read(localRepositoryProvider).saveSeen();
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                      builder: (context) => Root(),
                    ),
                  );
                } else {
                  _controller.animateTo(_controller.index + 1);
                }
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 6),
            child: Consumer(
              builder: (context, ref, child) {
                final index = ref.watch(onBoardingIndexProvider.state);
                return Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [0, 1, 2]
                      .map(
                        (e) => Padding(
                          padding: const EdgeInsets.all(6.0),
                          child: CircleAvatar(
                            radius: 4,
                            backgroundColor: index.state == e
                                ? theme.primaryColor
                                : theme.dividerColor,
                          ),
                        ),
                      )
                      .toList(),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

final onBoardingIndexProvider = StateProvider<int>((ref) => 0);
