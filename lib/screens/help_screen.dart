import 'package:flutter/material.dart';

class HelpScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(automaticallyImplyLeading: false, title: Text('Help')),
      body: ListView.separated(
        padding: EdgeInsets.all(16),
        itemCount: menuItems.length,
        separatorBuilder: (context, index) {
          if (index == 6) return Divider(thickness: 2);
          if (index == 12) return Divider(thickness: 2);
          return Divider();
        },
        itemBuilder: (context, index) {
          final item = menuItems[index];

          return ListTile(
            title: Text(item.title),
            trailing: item.showTrailing ? Icon(Icons.chevron_right) : null,
            onTap: () => _handleMenuItemTap(context, item),
          );
        },
      ),
    );
  }

  void _handleMenuItemTap(BuildContext context, MenuItem item) {
    if (item.title == '') {
    } else {
      // Handle other menu items
      showDialog(
        context: context,
        builder:
            (context) => AlertDialog(
              content: Text("This feature is coming soon."),
              actions: [
                TextButton(
                  child: Text("OK"),
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
  final bool showTrailing;

  MenuItem({required this.title, this.showTrailing = true});
}

final List<MenuItem> menuItems = [
  MenuItem(title: 'Help Center'),
  MenuItem(title: 'Place an Order'),
  MenuItem(title: 'Payment Options'),
  MenuItem(title: 'Track an Order'),
  MenuItem(title: 'Cancel an Order'),
  MenuItem(title: 'Returns and Refunds'),
  MenuItem(title: 'Live Chat'),
];
