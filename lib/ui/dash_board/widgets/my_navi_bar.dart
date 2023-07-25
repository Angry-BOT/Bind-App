import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class MyNaviItem {
  Icon icon;
  String label;
  MyNaviItem({
    required this.icon,
    required this.label,
  });
}

final dotProvider = Provider<Dot>((ref) => Dot());

class Dot {
  int? dot;
}

class MyNavibar extends ConsumerWidget {
  final List<MyNaviItem> items;
  final int index;
  final Function(int) onSelect;
  const MyNavibar(
      {Key? key,
      required this.items,
      required this.index,
      required this.onSelect})
      : super(key: key);
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final dot = ref.read(dotProvider);
    return Container(
      decoration: BoxDecoration(
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(24),
            topRight: Radius.circular(24),
          ),
          color: theme.bottomNavigationBarTheme.backgroundColor,
          boxShadow: [
            BoxShadow(
              blurRadius: 10,
              color: theme.shadowColor,
              offset: Offset(0, -2),
            )
          ]),
      child: Padding(
        padding: const EdgeInsets.all(8),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: items
              .map(
                (e) => MyAnimatedItem1(
                  item: e,
                  selected: items.indexOf(e) == index,
                  onTap: () {
                    if (dot.dot != null && dot.dot == items.indexOf(e)) {
                      dot.dot = null;
                    }
                    onSelect(items.indexOf(e));
                  },
                  dot: dot.dot == items.indexOf(e),
                ),
              )
              .toList(),
        ),
      ),
    );
  }
}

class MyAnimatedItem1 extends StatelessWidget {
  const MyAnimatedItem1({
    Key? key,
    required this.item,
    required this.selected,
    required this.dot,
    required this.onTap,
  }) : super(key: key);
  final MyNaviItem item;
  final bool selected;
  final Function() onTap;
  final bool dot;
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: AnimatedSize(
          alignment: Alignment.center,
          curve: Curves.easeIn,
          duration: Duration(milliseconds: 500),
          child: Container(
            decoration: BoxDecoration(
              border: Border.all(
                color: selected
                    ? theme.primaryColor
                    : theme.bottomNavigationBarTheme.backgroundColor!,
                width: selected ? 1 : 0,
              ),
              borderRadius: BorderRadius.circular(14),
            ),
            child: MyAnimatedItem(
              item: item,
              selected: selected,
              dot: dot,
            ),
          ),
        ),
      ),
    );
  }
}

class MyAnimatedItem extends StatelessWidget {
  const MyAnimatedItem({
    Key? key,
    required this.dot,
    required this.item,
    required this.selected,
  }) : super(key: key);
  final MyNaviItem item;
  final bool selected;
  final bool dot;
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return AnimatedSize(
      alignment: Alignment.centerLeft,
      curve: Curves.easeIn,
      duration: Duration(milliseconds: 300),
      child: Padding(
        padding: const EdgeInsets.all(4),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Stack(
              children: [
                Padding(
                  padding: const EdgeInsets.all(4),
                  child: Icon(
                    item.icon.icon,
                    color: selected ? theme.primaryColor : null,
                  ),
                ),
                if (dot)
                  Positioned(
                    right: 0,
                    child: CircleAvatar(
                      radius: 4,
                      backgroundColor: theme.primaryColor,
                    ),
                  ),
              ],
            ),
            selected
                ? Padding(
                    padding: const EdgeInsets.all(4),
                    child: Text(item.label),
                  )
                : SizedBox()
          ],
        ),
      ),
    );
  }
}

class MyAnimatedItem3 extends StatelessWidget {
  const MyAnimatedItem3({
    Key? key,
    required this.item,
    required this.selected,
    required this.onTap,
  }) : super(key: key);
  final MyNaviItem item;
  final bool selected;
  final Function() onTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: AnimatedSize(
          alignment: Alignment.centerLeft,
          curve: Curves.easeIn,
          duration: Duration(milliseconds: 300),
          child: Container(
            decoration: BoxDecoration(
              border: Border.all(
                color: selected
                    ? theme.primaryColor
                    : theme.bottomNavigationBarTheme.backgroundColor!,
                width: selected ? 1 : 0,
              ),
              borderRadius: BorderRadius.circular(14),
            ),
            child: Padding(
              padding: const EdgeInsets.all(4),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(4),
                    child: Icon(
                      item.icon.icon,
                      color: selected ? theme.primaryColor : null,
                    ),
                  ),
                  selected
                      ? Padding(
                          padding: const EdgeInsets.all(4),
                          child: Text(item.label),
                        )
                      : SizedBox()
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
