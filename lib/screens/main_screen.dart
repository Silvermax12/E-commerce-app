import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../components/product.dart';
import 'search_product.dart';
import 'home_screen.dart';
import 'cart_screen.dart';
import 'account_screen.dart';
import 'help_screen.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});
  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  final List<Product> _cart = [];
  late final FirebaseFirestore _db;
  late final FirebaseAuth _auth;

  int _currentIndex = 0;
  int _selectedCategory = 0;

  @override
  void initState() {
    super.initState();
    _db = FirebaseFirestore.instance;
    _auth = FirebaseAuth.instance;
    _loadCartFromFirestore();
  }

  Future<void> _loadCartFromFirestore() async {
    final user = _auth.currentUser;
    if (user == null) return;
    final doc = await _db.collection('carts').doc(user.uid).get();
    if (doc.exists) {
      final data = doc.data()!;
      final items =
          (data['items'] as List)
              .map(
                (m) => Product(
                  id: m['id'],
                  name: m['name'],
                  price: m['price'],
                  imageUrl: m['imageUrl'],
                  description: m['description'],
                ),
              )
              .toList();
      setState(() {
        _cart
          ..clear()
          ..addAll(items);
      });
    }
  }

  Future<void> _saveCartToFirestore() async {
    final user = _auth.currentUser;
    if (user == null) return;
    final itemsMap =
        _cart
            .map(
              (p) => {
                'id': p.id,
                'name': p.name,
                'price': p.price,
                'imageUrl': p.imageUrl,
                'description': p.description,
              },
            )
            .toList();
    await _db.collection('carts').doc(user.uid).set({'items': itemsMap});
  }

  void _addToCart(Product p) {
    setState(() => _cart.add(p));
    _saveCartToFirestore();
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text('${p.name} added to cart')));
  }

  void _removeFromCart(Product p) {
    setState(() => _cart.remove(p));
    _saveCartToFirestore();
  }

  void _goToCartTab() {
    setState(() => _currentIndex = 2);
  }

  @override
  Widget build(BuildContext context) {
    // Build HomeScreen with shared cart state and category callbacks
    final home = HomeScreen(
      cart: _cart,
      onAddToCart: _addToCart,
      onCartTap: _goToCartTab,
      selectedCategory: _selectedCategory,
      onCategoryTap:
          (i) => setState(() {
            _selectedCategory = i;
          }),
    );

    // Choose body based on selected tab
    Widget body;
    switch (_currentIndex) {
      case 0:
        body = home;
        break;
      case 2:
        body = CartScreen(cart: _cart, onRemove: _removeFromCart);
        break;
      case 3:
        body = AccountScreen();
        break;
      case 4:
        body = HelpScreen();
        break;
      default:
        body = home;
    }

    return WillPopScope(
      onWillPop: () async {
        if (_currentIndex != 0) {
          setState(() => _currentIndex = 0);
          return false;
        }
        return true;
      },
      child: Scaffold(
        body: body,
        bottomNavigationBar: BottomNavigationBar(
          currentIndex: _currentIndex,
          selectedItemColor: Colors.blueAccent,
          unselectedItemColor: Colors.grey,
          type: BottomNavigationBarType.fixed,
          onTap: (idx) {
            if (idx == 1) {
              // Search tapped: invoke SearchDelegate
              showSearch<Product?>(
                context: context,
                delegate: ProductSearchDelegate(onAddToCart: _addToCart),
              );
            } else {
              setState(() => _currentIndex = idx);
            }
          },
          items: const [
            BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
            BottomNavigationBarItem(icon: Icon(Icons.search), label: 'Search'),
            BottomNavigationBarItem(
              icon: Icon(Icons.shopping_cart),
              label: 'Cart',
            ),
            BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Account'),
            BottomNavigationBarItem(
              icon: Icon(Icons.help_outline),
              label: 'Help',
            ),
          ],
        ),
      ),
    );
  }
}
