import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
// import '../services/database.dart';
import 'product_provider.dart';

FirebaseDatabase database = FirebaseDatabase.instance;
final ref = database.ref();

class Products with ChangeNotifier {
  List<Product> _items = [];

  List<Product> get allItems {
    return [..._items];
  }

  List<Product> get favoriteItems {
    return _items.where((prodItem) => prodItem.isFavorite).toList();
  }

  Product findById(String id) {
    return _items.firstWhere((e) => e.id == id);
  }

  Future fetchAndSetProducts() async {
    final snapshot = await ref.child('/products').get();
    if (snapshot.value == null) {
      return;
    }

    final extractedData = snapshot.value as Map<dynamic, dynamic>;

    final List<Product> loadedProducts = [];
    extractedData.forEach((prodId, prodData) {
      loadedProducts.add(Product(
        id: prodId,
        title: prodData['title'],
        description: prodData['description'],
        price: prodData['price'],
        isFavorite: prodData['isFavorite'],
        imageUrl: prodData['imageUrl'],
      ));
    });
    _items = loadedProducts;
    notifyListeners();
  }

  Future addProduct(Product product) async {
    DatabaseReference productsRef = database.ref('/products');
    DatabaseReference newProductRef = productsRef.push();
    String? prodIdRef = productsRef.push().key;
    try {
      await newProductRef.set({
        'title': product.title,
        'description': product.description,
        'imageUrl': product.imageUrl,
        'price': product.price,
        'isFavorite': product.isFavorite,
      });
      final newProduct = Product(
        title: product.title,
        description: product.description,
        price: product.price,
        imageUrl: product.imageUrl,
        id: prodIdRef,
      );
      _items.add(newProduct);
      notifyListeners();
    } catch (e) {
      rethrow;
    }
  }

  Future deleteProduct(String productId) async {
    DatabaseReference ref = database.ref("/products/$productId");

    try {
      await ref.remove();
      _items.removeWhere((e) => e.id == productId);
      notifyListeners();
    } catch (e) {
      rethrow;
    }
  }

  Future updateProduct(Product newProduct) async {
    DatabaseReference ref = database.ref("/products/${newProduct.id}");
    final index = _items.indexWhere((element) => element.id == newProduct.id);
    if (index >= 0) {
      try {
        await ref.update({
          'description': newProduct.description,
          'imageUrl': newProduct.imageUrl,
          'price': newProduct.price,
          'title': newProduct.title
        });
        _items[index] = newProduct;
        notifyListeners();
      } catch (e) {
        rethrow;
      }
    }
  }
}
