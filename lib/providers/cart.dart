import 'package:flutter/material.dart';

class CartItem {
  String id;
  String title;
  double price;
  int quantity;
  CartItem(
      {required this.id,
      required this.quantity,
      required this.title,
      required this.price});
}

class Cart with ChangeNotifier {
  final Map<String, CartItem> _items = {};

  Map<String, CartItem> get items {
    return {..._items};
  }

  int get count {
    return _items.length;
  }

  bool isInCart(String productId) {
    return _items.containsKey(productId);
  }

  void addItem(
      {required String productId,
      required String title,
      required double price}) {
    if (_items.containsKey(productId)) {
      _items.update(
          productId,
          (prev) => CartItem(
              quantity: prev.quantity + 1,
              id: prev.id,
              title: prev.title,
              price: prev.price));
    } else {
      _items.putIfAbsent(
          productId,
          () => CartItem(
              id: UniqueKey().toString(),
              price: price,
              title: title,
              quantity: 1));
    }
    notifyListeners();
  }
}
