import 'package:flutter/material.dart';

import './cart.dart';

class OrderItem {
  final String id;
  final double amount;
  final List<CartItem> products;
  final DateTime dateTime;
  OrderItem(
      {required this.id,
      required this.amount,
      required this.dateTime,
      required this.products});
}

class Orders with ChangeNotifier {
  final List<OrderItem> _orders = [];

  List<OrderItem> get items {
    return [..._orders];
  }

  void addOrder(double amount, List<CartItem> products) {
    _orders.insert(
        0,
        OrderItem(
            amount: amount,
            products: products,
            dateTime: DateTime.now().toLocal(),
            id: UniqueKey().toString()));
    notifyListeners();
  }

  void removeOrder(String orderId) {
    _orders.removeWhere((order) => order.id == orderId);
    notifyListeners();
  }
}
