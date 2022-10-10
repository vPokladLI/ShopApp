import 'package:flutter/material.dart';

import '../pages/products_overview_screen.dart';
import '../pages/order_screen.dart';
import '../pages/user_products_screen.dart';

class AppDrawer extends StatelessWidget {
  const AppDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Column(children: [
        AppBar(
          title: const Text('Hello'),
          automaticallyImplyLeading: false,
        ),
        const Divider(),
        ListTile(
          leading: const Icon(Icons.shop),
          title: const Text('Shop'),
          onTap: () {
            Navigator.of(context)
                .pushReplacementNamed(ProductsOverviewScreen.routName);
          },
        ),
        ListTile(
          leading: const Icon(Icons.payment),
          title: const Text('Orders'),
          onTap: () {
            Navigator.of(context).pushReplacementNamed(OrderScreen.routName);
          },
        ),
        ListTile(
          leading: const Icon(Icons.paste_sharp),
          title: const Text('User products'),
          onTap: () {
            Navigator.of(context)
                .pushReplacementNamed(UserProductsScreen.routName);
          },
        ),
      ]),
    );
  }
}
