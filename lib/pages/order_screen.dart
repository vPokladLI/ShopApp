import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../providers/orders.dart' show Orders;
import '../widgets/order_item.dart';
import '../widgets/app_drawer.dart';

class OrderScreen extends StatefulWidget {
  static String routName = '/order';
  const OrderScreen({super.key});

  @override
  State<OrderScreen> createState() => _OrderScreenState();
}

class _OrderScreenState extends State<OrderScreen> {
  var _isLoading = true;
  @override
  void initState() {
    final user = Provider.of<User>(context, listen: false);
    Provider.of<Orders>(context, listen: false)
        .fetchAndSetOrders(user.uid)
        .then((_) {
      setState(() {
        _isLoading = false;
      });
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<User>(context, listen: false);

    final orders = context.watch<Orders>();
    Future<void> refreshOrders() async {
      orders.fetchAndSetOrders(user.uid);
    }

    return Scaffold(
        appBar: AppBar(
          title: const Text('Order details'),
        ),
        drawer: AppDrawer(),
        body: RefreshIndicator(
          onRefresh: refreshOrders,
          child: _isLoading
              ? const Center(
                  child: CircularProgressIndicator(),
                )
              : ListView.builder(
                  itemCount: orders.items.length,
                  itemBuilder: (context, index) =>
                      OrderItem(orders.items.reversed.toList()[index]),
                ),
        ));
  }
}
