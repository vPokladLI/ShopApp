import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/products_provider.dart';

class ProductDetailedScreen extends StatelessWidget {
  static const routName = '/product-details';
  const ProductDetailedScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final id = ModalRoute.of(context)?.settings.arguments as String;
    final selectedProduct =
        Provider.of<Products>(context, listen: false).findById(id);

    return Scaffold(
      appBar: AppBar(
        title: Text(selectedProduct.title),
      ),
    );
  }
}
