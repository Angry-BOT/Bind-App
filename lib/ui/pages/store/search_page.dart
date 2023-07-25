import '../../../model/product.dart';
import 'widgets/product_card.dart';
import 'package:flutter/material.dart';

class SearchProductPage extends SearchDelegate {
  final List<Product> products;
  SearchProductPage(this.products);
  
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
      children: products
          .where((element) =>
              element.name.toLowerCase().contains(query.toLowerCase()))
          .map(
            (e) => ProductCard(product: e),
          )
          .toList(),
    );
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    return ListView(
      children: products
          .where((element) =>
              element.name.toLowerCase().contains(query.toLowerCase()))
          .map(
            (e) => ProductCard(product: e),
          )
          .toList(),
    );
  }
}
