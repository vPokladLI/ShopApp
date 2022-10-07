import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/cart.dart';

class CartItem extends StatelessWidget {
  final double price;
  final int quantity;
  final String id;
  final String productId;
  final String title;

  const CartItem(
      {required this.id,
      required this.productId,
      required this.price,
      required this.quantity,
      required this.title,
      super.key});

  @override
  Widget build(BuildContext context) {
    final cart = Provider.of<Cart>(context);
    return Dismissible(
      key: ValueKey(id),
      direction: DismissDirection.endToStart,
      background: Container(
          margin: const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
          padding: const EdgeInsets.only(right: 20),
          alignment: Alignment.centerRight,
          decoration: const BoxDecoration(
              gradient: LinearGradient(
            colors: [Colors.white, Colors.red],
          )),
          child: Icon(
            Icons.delete,
            color: Theme.of(context).colorScheme.onError,
          )),
      onDismissed: (direction) {
        cart.removeItem(productId);
      },
      child: Card(
        elevation: 5,
        margin: const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
        child: Padding(
          padding: const EdgeInsets.all(5),
          child: ListTile(
            leading: CircleAvatar(
                radius: 30,
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: FittedBox(child: Text('\$ ${price.toString()}')),
                )),
            title: Text(title.toString()),
            subtitle: Text('total \$${(price * quantity).toStringAsFixed(2)}'),
            trailing: SizedBox(
              width: 150,
              child: Row(
                children: [
                  IconButton(
                      onPressed: () {
                        if (quantity == 1) {
                          cart.removeItem(productId);
                        }
                        cart.changeQuantity(productId, Change.decrement);
                      },
                      icon: const Icon(Icons.arrow_left)),
                  Text(
                    'x ${quantity.toString()}',
                    style: const TextStyle(fontSize: 20),
                  ),
                  IconButton(
                      onPressed: () {
                        cart.changeQuantity(productId, Change.increment);
                      },
                      icon: const Icon(Icons.arrow_right))
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
