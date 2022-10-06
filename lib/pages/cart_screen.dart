import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/orders.dart';
import '../providers/cart.dart' show Cart;

import '../pages/order_screen.dart';

import '../widgets/cart_item.dart';

class CartScreen extends StatelessWidget {
  static String routName = '/cart';
  const CartScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final cart = Provider.of<Cart>(context);

    void placeOrder() {
      if (cart.items.isEmpty) return;
      Provider.of<Orders>(context, listen: false)
          .addOrder(cart.total, cart.items.values.toList());
      cart.clear();
      Navigator.of(context).pushReplacementNamed(OrderScreen.routName);
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Your`s shopping cart '),
      ),
      body: Column(children: [
        if (cart.items.isNotEmpty)
          Card(
            margin: const EdgeInsets.all(15),
            child: Padding(
              padding: const EdgeInsets.all(10),
              child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'Total:',
                      style: TextStyle(fontSize: 20),
                    ),
                    const Spacer(),
                    Container(
                      margin: const EdgeInsets.only(right: 10),
                      child: Chip(
                        label: Text('\$${cart.total.toStringAsFixed(2)}'),
                        labelPadding: const EdgeInsets.all(3),
                        labelStyle: TextStyle(
                            color: Theme.of(context).colorScheme.onPrimary,
                            fontSize: 15,
                            fontWeight: FontWeight.bold),
                        backgroundColor:
                            Theme.of(context).colorScheme.secondary,
                      ),
                    ),
                    TextButton.icon(
                      onPressed: placeOrder,
                      icon: const Icon(Icons.monetization_on_sharp),
                      label: const Text(
                        'ORDER NOW',
                        style: TextStyle(
                            fontSize: 16, fontWeight: FontWeight.bold),
                      ),
                    )
                  ]),
            ),
          ),
        const SizedBox(
          height: 10,
        ),
        cart.items.isEmpty
            ? Center(
                heightFactor: 20,
                child: Text(
                  'Your`s cart is empty...',
                  style: Theme.of(context).textTheme.titleLarge,
                ),
              )
            : Expanded(
                child: ListView.builder(
                  itemCount: cart.items.length,
                  itemBuilder: (context, index) => CartItem(
                    id: cart.items.values.toList()[index].id,
                    productId: cart.items.keys.toList()[index],
                    price: cart.items.values.toList()[index].price,
                    quantity: cart.items.values.toList()[index].quantity,
                    title: cart.items.values.toList()[index].title,
                  ),
                ),
              )
      ]),
    );
  }
}
