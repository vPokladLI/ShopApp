import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/cart.dart';
import '../providers/products_provider.dart';

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
  var _isFavoriteSelected = false;
  var _isLoading = true;

  @override
  void initState() {
    _isLoading = true;
    try {
      Provider.of<Products>(context, listen: false).fetchAndSetProducts();
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          padding: const EdgeInsets.symmetric(vertical: 50, horizontal: 10),
          backgroundColor: Theme.of(context).colorScheme.error,
          content: Text(
            e.toString(),
            textAlign: TextAlign.center,
            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          )));
    }
    setState(() {
      _isLoading = false;
    });
    super.initState();
  }

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
                  _isFavoriteSelected =
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
        drawer: AppDrawer(),
        body: _isLoading
            ? const Center(
                child: CircularProgressIndicator(),
              )
            : ProductsGrid(_isFavoriteSelected));
  }
}
