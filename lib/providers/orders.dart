import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shop_app/models/http_exception.dart';

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
  static const _endpoint =
      'flutter-shop-app-365508-default-rtdb.europe-west1.firebasedatabase.app';
  List<OrderItem> _orders = [];

  List<OrderItem> get items {
    return [..._orders];
  }

  Future fetchAndSetOrders() async {
    final url = Uri.https(_endpoint, '/orders.json');
    try {
      final response = await http.get(url);
      if (response.statusCode == 200) {
        final Map<String, dynamic> decodedResponse = jsonDecode(response.body);
        if (decodedResponse.isNotEmpty) {
          List<OrderItem> loadedOrders = [];
          decodedResponse.forEach((orderId, order) {
            loadedOrders.add(OrderItem(
                id: orderId,
                amount: order['amount'],
                dateTime: DateTime.parse(order['dateTime']),
                products: (order['products'] as List<dynamic>)
                    .map((e) => CartItem(
                        id: e['id'],
                        price: e['price'],
                        quantity: e['quantity'],
                        title: e['title']))
                    .toList()));
          });
          _orders = loadedOrders.reversed.toList();
        }
      }
    } catch (e) {
      rethrow;
    }
  }

  Future addOrder(double amount, List<CartItem> products) async {
    final url = Uri.https(_endpoint, '/orders.json');
    final timeStamp = DateTime.now();

    final response = await http.post(url,
        body: json.encode({
          'amount': amount,
          'products': products
              .map((el) => {
                    'id': el.id,
                    'title': el.title,
                    'quantity': el.quantity,
                    'price': el.price,
                  })
              .toList(),
          'dateTime': timeStamp.toIso8601String(),
        }));

    if (response.statusCode == 200) {
      final Map<String, dynamic> decodedResponse = jsonDecode(response.body);
      _orders.insert(
          0,
          OrderItem(
              amount: amount,
              products: products,
              dateTime: timeStamp,
              id: decodedResponse['name']));
      notifyListeners();
    } else {
      throw HttpException('Failed to make order... Try again later');
    }
  }

  void removeOrder(String orderId) {
    _orders.removeWhere((order) => order.id == orderId);
    notifyListeners();
  }
}
