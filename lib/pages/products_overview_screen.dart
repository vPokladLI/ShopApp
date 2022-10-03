import 'package:flutter/material.dart';

import '../widgets/products_grid.dart';

class ProductsOverviewScreen extends StatelessWidget {
  static String routName = '/products-overview';
  const ProductsOverviewScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Products overview'),
        ),
        body: const ProductsGrid());
  }
}
