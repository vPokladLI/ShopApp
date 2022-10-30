import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:firebase_auth/firebase_auth.dart';

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
                            color: Theme.of(context).colorScheme.onSecondary,
                            fontSize: 15,
                            fontWeight: FontWeight.bold),
                        backgroundColor:
                            Theme.of(context).colorScheme.secondary,
                      ),
                    ),
                    OrderButton(
                      cart: cart,
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

class OrderButton extends StatefulWidget {
  final Cart cart;
  const OrderButton({
    required this.cart,
    super.key,
  });

  @override
  State<OrderButton> createState() => _OrderButtonState();
}

class _OrderButtonState extends State<OrderButton> {
  Future<void> placeOrder() async {
    if (widget.cart.items.isEmpty) return;
    try {
      setState(() {
        _isLoading = true;
      });
      final user = Provider.of<User>(context, listen: false);

      await Provider.of<Orders>(context, listen: false).addOrder(
          widget.cart.total, widget.cart.items.values.toList(), user.uid);

      widget.cart.clear();
      // ignore: use_build_context_synchronously
      Navigator.of(context).pushReplacementNamed(OrderScreen.routName);
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
  }

  var _isLoading = false;

  @override
  Widget build(BuildContext context) {
    return TextButton.icon(
      onPressed: placeOrder,
      icon: _isLoading
          ? const CircularProgressIndicator()
          : const Icon(Icons.monetization_on_sharp),
      label: const Text(
        'ORDER NOW',
        style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
      ),
    );
  }
}
