import 'package:flutter/material.dart';

class AboutTabBar extends StatelessWidget {
  const AboutTabBar({
    Key? key,
    required this.tabLabels,
    required this.controller,
  }) : super(key: key);

  final List<String> tabLabels;
  final TabController controller;
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Material(
      color: theme.scaffoldBackgroundColor,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          TabBar(
            indicatorPadding: EdgeInsets.only(top: 45),
            indicatorWeight: 3,
            controller: controller,
            indicatorSize: TabBarIndicatorSize.label,
            indicator: BoxDecoration(
              color: theme.primaryColor,
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(16),
                topRight: Radius.circular(16),
              ),
            ),
            isScrollable: true,
            tabs: tabLabels
                .map(
                  (e) => Tab(
                    text: e,
                  ),
                )
                .toList(),
          ),
          Divider(
            height: 1,
            thickness: 1,
          ),
        ],
      ),
    );
  }
}
