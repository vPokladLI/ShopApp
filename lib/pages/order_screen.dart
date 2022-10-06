import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/orders.dart' show Orders;
import '../widgets/order_item.dart';
import '../widgets/app_drawer.dart';

class OrderScreen extends StatelessWidget {
  static String routName = '/order';
  const OrderScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final orders = context.watch<Orders>();
    return Scaffold(
      appBar: AppBar(
        title: const Text('Order details'),
      ),
      drawer: const AppDrawer(),
      body: ListView.builder(
        itemCount: orders.items.length,
        itemBuilder: (context, index) => OrderItem(orders.items[index]),
      ),
    );
  }
}
