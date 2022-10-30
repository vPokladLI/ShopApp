import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';

FirebaseDatabase database = FirebaseDatabase.instance;

class Product with ChangeNotifier {
  final String? id;
  final String title;
  final String description;
  final String imageUrl;
  final double price;
  bool isFavorite;

  Product(
      {required this.id,
      required this.title,
      required this.description,
      required this.imageUrl,
      required this.price,
      this.isFavorite = false});

  Future<void> toggleFavorite(String userId) async {
    try {
      isFavorite = !isFavorite;
      final userRef = database.ref('/UserFavorites/$userId');
      await userRef.update({id as String: isFavorite});
    } catch (e) {
      isFavorite = !isFavorite;
    }
    notifyListeners();
  }
}
