import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

class AccountScreen extends StatelessWidget {
  const AccountScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: const Text('Account'),
      ),
      body: ListView.separated(
        padding: const EdgeInsets.all(16),
        itemCount: menuItems.length,
        separatorBuilder: (context, index) {
          if (index == 6 || index == 12) return const Divider(thickness: 2);
          return const Divider();
        },
        itemBuilder: (context, index) {
          final item = menuItems[index];
          return ListTile(
            leading: Icon(item.icon, color: Colors.grey[600]),
            title: Text(item.title),
            trailing:
                item.showTrailing ? const Icon(Icons.chevron_right) : null,
            onTap: () => _handleMenuItemTap(context, item),
          );
        },
      ),
    );
  }

  void _handleMenuItemTap(BuildContext context, MenuItem item) {
    if (item.title == 'Logout') {
      showDialog(
        context: context,
        builder:
            (context) => AlertDialog(
              title: const Text('Logout'),
              content: const Text('Are you sure you want to logout?'),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text('Cancel'),
                ),
                TextButton(
                  onPressed: () async {
                    Navigator.pop(context); // close dialog

                    // 1. Sign out of Firebase
                    await FirebaseAuth.instance.signOut();

                    // 2. Sign out of Google (if used)
                    final googleSignIn = GoogleSignIn();
                    if (await googleSignIn.isSignedIn()) {
                      await googleSignIn.signOut();
                    }

                    // 3. Navigate back to login (replacing history)
                    Navigator.pushNamedAndRemoveUntil(
                      context,
                      '/', // your login route
                      (route) => false,
                    );
                  },
                  child: const Text(
                    'Logout',
                    style: TextStyle(color: Colors.red),
                  ),
                ),
              ],
            ),
      );
    } else {
      // Placeholder for other items
      showDialog(
        context: context,
        builder:
            (context) => AlertDialog(
              content: const Text("This feature is coming soon."),
              actions: [
                TextButton(
                  child: const Text("OK"),
                  onPressed: () => Navigator.of(context).pop(),
                ),
              ],
            ),
      );
    }
  }
}

class MenuItem {
  final String title;
  final IconData icon;
  final bool showTrailing;

  const MenuItem({
    required this.title,
    this.icon = Icons.list,
    this.showTrailing = true,
  });
}

const List<MenuItem> menuItems = [
  MenuItem(title: 'My Account', icon: Icons.person),
  MenuItem(title: 'Orders', icon: Icons.shopping_bag),
  MenuItem(title: 'Inbox', icon: Icons.mail),
  MenuItem(title: 'Pending Reviews', icon: Icons.rate_review),
  MenuItem(title: 'Voucher', icon: Icons.confirmation_number),
  MenuItem(title: 'Wishlist', icon: Icons.favorite),
  MenuItem(title: 'Followed Sellers', icon: Icons.store),
  MenuItem(title: 'Recently Viewed', icon: Icons.history),
  MenuItem(title: 'Account Management', icon: Icons.settings),
  MenuItem(title: 'Payment Settings', icon: Icons.payment),
  MenuItem(title: 'Address Book', icon: Icons.location_on),
  MenuItem(title: 'Newsletter Preferences', icon: Icons.email),
  MenuItem(title: 'Close Account', icon: Icons.warning, showTrailing: false),
  MenuItem(title: 'Logout', icon: Icons.exit_to_app, showTrailing: false),
];
