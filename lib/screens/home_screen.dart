import 'package:flutter/material.dart';
import '../components/product.dart';
import 'items.dart';
import '../components/product_details.dart';
import '../components/product_card.dart';

class HomeScreen extends StatelessWidget {
  final List<Product> cart;
  final void Function(Product) onAddToCart;
  final VoidCallback onCartTap;
  final int selectedCategory;
  final void Function(int) onCategoryTap;

  const HomeScreen({
    super.key,
    required this.cart,
    required this.onAddToCart,
    required this.onCartTap,
    required this.selectedCategory,
    required this.onCategoryTap,
  });

  @override
  Widget build(BuildContext context) {
    final categories = [
      'Electronics',
      'Fashion',
      'Housing',
      'Phones',
      'Computers',
      'Beauty',
    ];
    final data = getCategoryProducts();
    final products = data[categories[selectedCategory]]!;

    return Scaffold(
      appBar: AppBar(
        title: const Text('SILVERMAX STORE'),
        actions: [
          IconButton(
            onPressed: onCartTap,
            icon: Stack(
              children: [
                const Icon(Icons.shopping_cart),
                if (cart.isNotEmpty)
                  Positioned(
                    right: 0,
                    child: Container(
                      padding: const EdgeInsets.all(2),
                      decoration: BoxDecoration(
                        color: Colors.blueAccent,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      constraints: const BoxConstraints(
                        minWidth: 16,
                        minHeight: 16,
                      ),
                      child: Text(
                        '${cart.length}',
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 10,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),
              ],
            ),
          ),
        ],
      ),
      body: Column(
        children: [
          // Category selector
          SizedBox(
            height: 60,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: categories.length,
              itemBuilder: (_, i) {
                final isSelected = i == selectedCategory;
                return GestureDetector(
                  onTap: () => onCategoryTap(i),
                  child: Container(
                    margin: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 8,
                    ),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 10,
                    ),
                    decoration: BoxDecoration(
                      color: isSelected ? Colors.blueAccent : Colors.grey[200],
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      categories[i],
                      style: TextStyle(
                        color: isSelected ? Colors.white : Colors.black87,
                        fontWeight:
                            isSelected ? FontWeight.bold : FontWeight.normal,
                      ),
                    ),
                  ),
                );
              },
            ),
          ),

          // Product grid
          Expanded(
            child:
                products.isEmpty
                    ? const Center(child: Text('No products found'))
                    : GridView.builder(
                      padding: const EdgeInsets.all(12),
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 2,
                            mainAxisSpacing: 12,
                            crossAxisSpacing: 12,
                            childAspectRatio: 0.7,
                          ),
                      itemCount: products.length,
                      itemBuilder: (_, idx) {
                        final p = products[idx];
                        return ProductCard(
                          product: p,
                          onTap:
                              () => Navigator.of(context).push(
                                MaterialPageRoute(
                                  builder:
                                      (_) => ProductDetailsScreen(
                                        product: p,
                                        onAddToCart: onAddToCart,
                                      ),
                                ),
                              ),
                        );
                      },
                    ),
          ),
        ],
      ),
    );
  }
}
