import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../pages/products_overview_screen.dart';
import '../pages/order_screen.dart';
import '../pages/user_products_screen.dart';

import '../services/auth_service.dart';

class AppDrawer extends StatelessWidget {
  final _auth = Auth();
  AppDrawer({super.key});
  @override
  Widget build(BuildContext context) {
    final userEmail =
        Provider.of<User?>(context, listen: false)?.email as String;
    return Drawer(
      child: Column(children: [
        AppBar(
          title: Text('Hello, $userEmail'),
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
        ListTile(
          leading: const Icon(Icons.logout_outlined),
          title: const Text(' Logout'),
          onTap: () {
            _auth.signOut();
            Navigator.of(context).pushReplacementNamed('/');
          },
        ),
      ]),
    );
  }
}
