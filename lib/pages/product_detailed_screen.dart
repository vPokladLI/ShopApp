import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../pages/cart_screen.dart';
import '../providers/products_provider.dart';
import '../providers/cart.dart';

import '../widgets/badge.dart';

class ProductDetailedScreen extends StatelessWidget {
  static const routName = '/product-details';
  const ProductDetailedScreen({super.key});
  PreferredSizeWidget _buildAppbar(product, cart) {
    return AppBar(title: Text(product.title), actions: [
      Consumer<Cart>(
          builder: (context, cart, child) => Badge(
              value: cart.count,
              child: IconButton(
                  onPressed: () {
                    Navigator.of(context).pushNamed(CartScreen.routName);
                  },
                  icon: Icon((cart.count > 0)
                      ? Icons.shopping_cart_checkout
                      : Icons.shopping_cart_outlined)))),
    ]);
  }

  Widget _buildAddToCardButton(context, product, cart) {
    return ElevatedButton.icon(
        onPressed: () {
          cart.addItem(
              productId: product.id,
              title: product.title,
              price: product.price);
          ScaffoldMessenger.of(context).hideCurrentSnackBar();
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              elevation: 10,
              action: SnackBarAction(
                  textColor: Theme.of(context).colorScheme.secondary,
                  label: 'UNDO',
                  onPressed: () {
                    cart.undoAddItem(product.id);
                  }),
              backgroundColor: Theme.of(context).colorScheme.primary,
              content: const Text('Item added to a cart'),
              duration: const Duration(seconds: 2),
            ),
          );
        },
        icon: const Icon(Icons.shopping_cart_outlined),
        label: const Text('Add to cart'));
  }

  @override
  Widget build(BuildContext context) {
    final id = ModalRoute.of(context)?.settings.arguments as String;
    final product = Provider.of<Products>(context, listen: false).findById(id);
    final cart = Provider.of<Cart>(context, listen: false);
    final mediaQ = MediaQuery.of(context);
    final isLandscape = mediaQ.orientation == Orientation.landscape;
    MediaQuery.of(context).orientation == Orientation.landscape;
    final appBar = _buildAppbar(product, cart);

    return Scaffold(
      appBar: appBar,
      body: SingleChildScrollView(
        child: isLandscape
            ? Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                SizedBox(
                  width: mediaQ.size.width / 2,
                  height: mediaQ.size.height -
                      mediaQ.padding.top -
                      appBar.preferredSize.height,
                  child: Hero(
                    tag: product.id as Object,
                    child: Image.network(
                      product.imageUrl,
                      fit: BoxFit.scaleDown,
                    ),
                  ),
                ),
                SizedBox(
                  width: mediaQ.size.width / 2 - 10,
                  child: Column(
                    children: [
                      Text(
                        '\$${product.price}',
                        style:
                            const TextStyle(fontSize: 20, color: Colors.grey),
                      ),
                      const SizedBox(
                        height: 30,
                      ),
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.symmetric(horizontal: 10),
                        child: Text(
                          product.description,
                          softWrap: true,
                          textAlign: TextAlign.center,
                        ),
                      ),
                      const SizedBox(
                        height: 30,
                      ),
                      _buildAddToCardButton(context, product, cart)
                    ],
                  ),
                )
              ])
            : Column(
                children: [
                  SizedBox(
                    width: double.infinity,
                    height: mediaQ.size.height / 2,
                    child: Hero(
                      tag: product.id as Object,
                      child: Image.network(
                        product.imageUrl,
                        fit: BoxFit.contain,
                        alignment: Alignment.topCenter,
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  Text(
                    '\$${product.price}',
                    style: const TextStyle(fontSize: 20, color: Colors.grey),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.symmetric(horizontal: 10),
                    child: Text(
                      product.description,
                      softWrap: true,
                      textAlign: TextAlign.center,
                    ),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  _buildAddToCardButton(context, product, cart)
                ],
              ),
      ),
    );
  }
}
