import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
// import 'package:http/http.dart' as http;
import 'package:shop_app/models/http_exception.dart';

import './cart.dart';

FirebaseDatabase database = FirebaseDatabase.instance;

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
  final ref = database.ref();
  List<OrderItem> _orders = [];

  List<OrderItem> get items {
    return [..._orders];
  }

  Future fetchAndSetOrders() async {
    // final url = Uri.https(_endpoint, '/orders.json');
    try {
      final snapshot = await ref.child('/orders').get();
      if (snapshot.value == null) {
        return;
      }
      final extractedData = snapshot.value as Map<dynamic, dynamic>;
      // print(extractedData);

      List<OrderItem> loadedOrders = [];

      extractedData.forEach((orderId, order) {
        loadedOrders.add(OrderItem(
            id: orderId,
            amount: order['amount'].toDouble(),
            dateTime: DateTime.parse(order['dateTime']),
            products: (order['products'] as List<dynamic>)
                .map((e) => CartItem(
                    id: e['id'],
                    price: e['price'].toDouble(),
                    quantity: e['quantity'],
                    title: e['title']))
                .toList()));
      });
      _orders = loadedOrders.reversed.toList();
    } catch (e) {
      rethrow;
    }
  }

  Future addOrder(double amount, List<CartItem> products) async {
    final timeStamp = DateTime.now();
    DatabaseReference ordersRef = database.ref('/orders');
    DatabaseReference newOrder = ordersRef.push();
    String? orderId = ordersRef.push().key;

    try {
      await newOrder.set({
        'amount': amount,
        'products': products
            .map((el) => {
                  'id': el.id,
                  'title': el.title,
                  'quantity': el.quantity,
                  'price': el.price,
                })
            .toList(),
        'dateTime': timeStamp.toIso8601String()
      });
      _orders.add(OrderItem(
          amount: amount,
          products: products,
          dateTime: timeStamp,
          id: orderId!));
      notifyListeners();
    } catch (e) {
      throw HttpException('Failed to make order... Try again later');
    }
  }

  void removeOrder(String orderId) {
    _orders.removeWhere((order) => order.id == orderId);
    notifyListeners();
  }
}
