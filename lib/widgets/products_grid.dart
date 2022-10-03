import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/product_provider.dart';

import '../providers/products_provider.dart';

import './product_item.dart';

class ProductsGrid extends StatelessWidget {
  final bool isFav;
  const ProductsGrid(this.isFav, {super.key});

  @override
  Widget build(BuildContext context) {
    final productsData = Provider.of<Products>(context);
    final products = isFav ? productsData.favoriteItems : productsData.allItems;

    return (isFav && productsData.favoriteItems.isEmpty)
        ? Center(
            child: Text('No items added to favorites yet...',
                style: Theme.of(context).textTheme.titleLarge),
          )
        : GridView.builder(
            padding: const EdgeInsets.all(10),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 10,
                mainAxisSpacing: 10,
                childAspectRatio: 3 / 2.5),
            itemBuilder: (context, index) {
              return ChangeNotifierProvider.value(
                value: products[index],
                child: ProductItem(),
              );
            },
            itemCount: products.length,
          );
  }
}
