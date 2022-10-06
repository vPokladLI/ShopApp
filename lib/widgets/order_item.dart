import 'package:flutter/material.dart';
import 'dart:math';
import 'package:intl/intl.dart';

import '../providers/orders.dart' as model;
import '../providers/cart.dart';

class OrderItem extends StatefulWidget {
  final model.OrderItem order;

  const OrderItem(this.order, {super.key});

  @override
  State<OrderItem> createState() => _OrderItemState();
}

class _OrderItemState extends State<OrderItem> {
  var _expanded = false;
  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.all(10),
      child: Column(
        children: [
          ListTile(
            onTap: () {
              setState(() {
                _expanded = !_expanded;
              });
            },
            title: Text('\$${widget.order.amount}'),
            subtitle: Text(DateFormat('dd/ MMMM/ yyyy,  HH:mm')
                .format(widget.order.dateTime)),
            trailing: IconButton(
                onPressed: () {
                  setState(() {
                    _expanded = !_expanded;
                  });
                },
                icon: Icon(!_expanded ? Icons.expand_more : Icons.expand_less)),
          ),
          if (_expanded)
            Container(
              padding: const EdgeInsets.only(top: 3),
              color: Theme.of(context).colorScheme.secondary,
              height: max(widget.order.products.length * 75.0, 75),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: widget.order.products
                    .map(
                      (e) => ExpandedContent(e),
                    )
                    .toList(),
              ),
            )
        ],
      ),
    );
  }
}

class ExpandedContent extends StatelessWidget {
  final CartItem product;
  const ExpandedContent(this.product, {super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      child: ListTile(
        title: Text(
          '\$${product.price}',
          overflow: TextOverflow.fade,
        ),
        subtitle: Text('x ${product.quantity}'),
        leading: Container(
          width: 150,
          alignment: Alignment.centerLeft,
          child: Text(
            product.title,
            softWrap: true,
            overflow: TextOverflow.fade,
            style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
        ),
        trailing: Text(
          (product.price * product.quantity).toStringAsFixed(2),
          style: const TextStyle(fontSize: 18),
        ),
      ),
    );
  }
}
