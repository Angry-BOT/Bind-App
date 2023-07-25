import '../recommended_stores_page.dart';
import '../../../../utils/labels.dart';
import 'package:flutter/material.dart';

class ViewAllButton extends StatelessWidget {
  const ViewAllButton({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Center(
        child: InkWell(
          onTap: () => Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => RecommendedStoresPage(),
            ),
          ),
          borderRadius: BorderRadius.circular(32),
          child: Material(
            shape: StadiumBorder(),
            color: theme.dividerColor,
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Padding(
                  padding: const EdgeInsets.only(left: 16, right: 8),
                  child: Text(Labels.viewAll),
                ),
                Material(
                  shape: CircleBorder(),
                  color: Colors.grey.shade300,
                  elevation: 8,
                  child: Padding(
                    padding: const EdgeInsets.all(4.0),
                    child: Icon(Icons.add),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
