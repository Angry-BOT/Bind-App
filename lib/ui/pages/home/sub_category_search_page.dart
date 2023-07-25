import '../../../model/store.dart';
import 'widgets/store_card.dart';
import 'package:flutter/material.dart';

class SearchStorePage extends SearchDelegate {
  final List<Store> products;

  SearchStorePage(this.products);
  @override
  List<Widget> buildActions(BuildContext context) {
    return [
      IconButton(
        icon: Icon(Icons.clear),
        onPressed: () {
          showSuggestions(context);
          query = "";
        },
      ),
    ];
  }

  @override
  Widget buildLeading(BuildContext context) {
    return IconButton(
      icon: AnimatedIcon(
        icon: AnimatedIcons.menu_arrow,
        progress: transitionAnimation,
      ),
      onPressed: () => close(context, null),
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    return ListView(
      padding: EdgeInsets.symmetric(vertical: 8),
      children: products
          .where((element) =>
              element.name.toLowerCase().contains(query.toLowerCase()))
          .map(
            (e) => StoreCard(store: e),
          )
          .toList(),
    );
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    return ListView(
      padding: EdgeInsets.symmetric(vertical: 8),
      children: products
          .where((element) =>
              element.name.toLowerCase().contains(query.toLowerCase()))
          .map(
            (e) => StoreCard(store: e),
          )
          .toList(),
    );
  }
}
