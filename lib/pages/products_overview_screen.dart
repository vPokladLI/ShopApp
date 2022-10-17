import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/cart.dart';

import '../pages/cart_screen.dart';
import '../widgets/app_drawer.dart';
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
                        onPressed: () {
                          (cart.count > 0)
                              ? Navigator.of(context)
                                  .pushNamed(CartScreen.routName)
                              : null;
                        },
                        icon: Icon((cart.count > 0)
                            ? Icons.shopping_cart_checkout
                            : Icons.shopping_cart_outlined)))),
            PopupMenuButton(
              onSelected: (FilterOptions value) {
                setState(() {
                  isFavoriteSelected =
                      (value == FilterOptions.favorites) ? true : false;
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
        drawer: const AppDrawer(),
        body: ProductsGrid(isFavoriteSelected));
  }
}
