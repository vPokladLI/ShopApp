import 'package:flutter/material.dart';

import '../widgets/app_drawer.dart';

class UserProductsScreen extends StatelessWidget {
  const UserProductsScreen({super.key});
  static const routName = '/user/products';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Your products'),
        actions: [IconButton(onPressed: () {}, icon: Icon(Icons.add))],
      ),
      drawer: const AppDrawer(),
      floatingActionButton:
          // ignore: prefer_const_constructors
          FloatingActionButton(onPressed: () {}, child: Icon(Icons.add)),
    );
  }
}
