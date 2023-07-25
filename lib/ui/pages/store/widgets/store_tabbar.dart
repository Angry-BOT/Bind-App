
import '../providers/admin_enquires_provider.dart';
import '../../../../utils/labels.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class StoreTabBar extends ConsumerWidget {
  StoreTabBar({
    Key? key,
    required this.tabController,
  }) : super(key: key);

  final List<String> tabLabels = [
    Labels.store,
    Labels.products,
    Labels.enquiries,
    Labels.settings
  ];
  final TabController tabController;
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final enquriesStream = ref.watch(activeEnquiresProvider);
    final pendingCount = enquriesStream.asData?.value
            .where((element) => !element.bought)
            .length ??
        0;
    return Column(
      children: [
        Stack(
          children: [
            TabBar(
              controller: tabController,
              indicatorSize: TabBarIndicatorSize.label,
              indicator: BoxDecoration(
                  color: theme.primaryColor,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(16),
                    topRight: Radius.circular(16),
                  )),
              indicatorPadding: EdgeInsets.only(top: 46),
              indicatorWeight: 4,
              isScrollable: true,
              tabs: tabLabels
                  .map(
                    (e) => Tab(
                      text: e == Labels.enquiries ? null : e,
                      child: e == Labels.enquiries
                          ? Row(
                              children: [
                                Text(e),
                                SizedBox(width: pendingCount != 0 ? 4 : 0),
                                pendingCount != 0
                                    ? Transform.translate(
                                        offset: Offset(0, -8),
                                        child: CircleAvatar(
                                          radius: 8,
                                          backgroundColor: theme.primaryColor,
                                          child: Text(
                                            '$pendingCount',
                                            style: TextStyle(
                                                color: Colors.black,
                                                fontSize: 10),
                                          ),
                                        ),
                                      )
                                    : SizedBox(),
                              ],
                            )
                          : null,
                    ),
                  )
                  .toList(),
            ),
          ],
        ),
        Divider(
          height: 1,
          thickness: 1,
        ),
      ],
    );
  }
}
