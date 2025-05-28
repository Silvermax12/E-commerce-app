import 'package:flutter/material.dart';
import '../components/product.dart';
import 'items.dart';
import '../components/product_details.dart';

class ProductSearchDelegate extends SearchDelegate<Product?> {
  final void Function(Product) onAddToCart; // ← new field

  ProductSearchDelegate({required this.onAddToCart}); // ← new constructor

  final List<Product> allProducts =
      getCategoryProducts().values.expand((list) => list).toList();

  @override
  String get searchFieldLabel => 'What are you looking for?';

  @override
  List<Widget>? buildActions(BuildContext context) => [
    if (query.isNotEmpty)
      IconButton(
        icon: const Icon(Icons.clear),
        onPressed: () {
          query = '';
          showSuggestions(context);
        },
      ),
  ];

  @override
  Widget? buildLeading(BuildContext context) =>
      BackButton(onPressed: () => close(context, null));

  @override
  Widget buildResults(BuildContext context) {
    final results =
        allProducts
            .where((p) => p.name.toLowerCase().contains(query.toLowerCase()))
            .toList();

    if (results.isEmpty) {
      return Center(child: Text('No results for "$query"'));
    }

    return ListView.builder(
      itemCount: results.length,
      itemBuilder: (_, i) {
        final product = results[i];
        return ListTile(
          leading: Image.network(
            product.imageUrl,
            width: 50,
            fit: BoxFit.cover,
          ),
          title: Text(product.name),
          subtitle: Text('₦${product.price}'),
          trailing: IconButton(
            icon: const Icon(Icons.add_shopping_cart),
            onPressed: () {
              onAddToCart(product); // ← call the callback
              close(context, product); // close search
            },
          ),
          onTap: () {
            Navigator.of(context).push(
              MaterialPageRoute(
                builder:
                    (_) => ProductDetailsScreen(
                      product: product,
                      onAddToCart: onAddToCart,
                    ),
              ),
            );
          },
        );
      },
    );
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    if (query.isEmpty) {
      return Center(child: Text('This Is SILVERMAX STORE Search Page'));
    }
    final suggestions =
        allProducts
            .where((p) => p.name.toLowerCase().contains(query.toLowerCase()))
            .toList();
    return ListView.builder(
      itemCount: suggestions.length,
      itemBuilder: (_, i) {
        final product = suggestions[i];
        return ListTile(
          title: Text(product.name),
          onTap: () {
            query = product.name;
            showResults(context);
          },
        );
      },
    );
  }
}
