import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/cart.dart';

import '../widgets/products_grid.dart';
import '../widgets/badge.dart';

enum FilterOptions { favorites, all }

class ProductsOverviewScreen extends StatefulWidget {
  static String routName = '/products-overview';
  const ProductsOverviewScreen({super.key});

  @override
  State<ProductsOverviewScreen> createState() => _ProductsOverviewScreenState();
}

class _ProductsOverviewScreenState extends State<ProductsOverviewScreen> {
  var isFavoriteSelected = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Products overview'),
          actions: [
            Consumer<Cart>(
                builder: (context, cart, child) => Badge(
                    value: cart.count,
                    child: IconButton(
                        onPressed: () {},
                        icon: Icon((cart.count > 0)
                            ? Icons.shopping_cart_checkout
                            : Icons.shopping_cart_outlined)))),
            PopupMenuButton(
              onSelected: (FilterOptions value) {
                setState(() {
                  if (value == FilterOptions.favorites) {
                    isFavoriteSelected = true;
                  } else {
                    isFavoriteSelected = false;
                  }
                });
              },
              icon: const Icon(Icons.more_vert),
              itemBuilder: (context) => [
                const PopupMenuItem(
                  value: FilterOptions.favorites,
                  child: Text('Show favorites'),
                ),
                const PopupMenuItem(
                  value: FilterOptions.all,
                  child: Text('Show all'),
                ),
              ],
            ),
          ],
        ),
        body: ProductsGrid(isFavoriteSelected));
  }
}
