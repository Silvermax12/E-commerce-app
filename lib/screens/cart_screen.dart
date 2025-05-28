import 'package:flutter/material.dart';
import '../components/product.dart';

class CartScreen extends StatelessWidget {
  final List<Product> cart;
  final Function(Product) onRemove;

  const CartScreen({Key? key, required this.cart, required this.onRemove})
    : super(key: key);

  double get totalPrice =>
      cart.fold(0, (total, current) => total + current.price);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Shopping Cart'),
        backgroundColor: Colors.blueAccent,
      ),
      body:
          cart.isEmpty
              ? Center(
                child: Text(
                  'Your cart is empty',
                  style: TextStyle(fontSize: 18),
                ),
              )
              : Column(
                children: [
                  Expanded(
                    child: ListView.separated(
                      padding: EdgeInsets.all(12),
                      itemCount: cart.length,
                      separatorBuilder:
                          (context, index) => Divider(thickness: 1),
                      itemBuilder: (context, index) {
                        final product = cart[index];
                        return ListTile(
                          leading: Image.network(
                            product.imageUrl,
                            width: 60,
                            height: 60,
                            fit: BoxFit.cover,
                            errorBuilder:
                                (context, error, stackTrace) =>
                                    Icon(Icons.broken_image, size: 40),
                          ),
                          title: Text(product.name),
                          subtitle: Text(
                            '\₦${product.price.toStringAsFixed(2)}',
                          ),
                          trailing: IconButton(
                            icon: Icon(Icons.delete, color: Colors.red),
                            onPressed: () => onRemove(product),
                          ),
                        );
                      },
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 12,
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Total:',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          '\₦${totalPrice.toStringAsFixed(2)}',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 8,
                    ),
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blueAccent,
                        minimumSize: Size(double.infinity, 50),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      child: Text('Checkout', style: TextStyle(fontSize: 20)),
                      onPressed: () {
                        showDialog(
                          context: context,
                          builder:
                              (context) => AlertDialog(
                                title: Text("Checkout"),
                                content: Text("This feature is coming soon."),
                                actions: [
                                  TextButton(
                                    child: Text("OK"),
                                    onPressed:
                                        () => Navigator.of(context).pop(),
                                  ),
                                ],
                              ),
                        );
                      },
                    ),
                  ),
                  SizedBox(height: 20),
                ],
              ),
    );
  }
}
