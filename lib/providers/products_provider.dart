import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
// import '../services/database.dart';
import 'product_provider.dart';

FirebaseDatabase database = FirebaseDatabase.instance;
final ref = database.ref();

class Products with ChangeNotifier {
  List<Product> _items = [];
  String? userId;

  List<Product> get allItems {
    return [..._items];
  }

  List<Product> get favoriteItems {
    return _items.where((prodItem) => prodItem.isFavorite).toList();
  }

  Product findById(String id) {
    return _items.firstWhere((e) => e.id == id);
  }

  Future fetchAndSetProducts(userId) async {
    final DataSnapshot products = await ref.child('/products').get();
    final DataSnapshot userFavorites =
        await ref.child('/UserFavorites/$userId').get();
    if (products.value == null) {
      return;
    }

    final extractedData = products.value as Map<String, dynamic>;

    final List<Product> loadedProducts = [];
    extractedData.forEach((prodId, prodData) {
      bool isUserFavorite(String prodId) {
        // ignore: unnecessary_null_comparison
        if (userFavorites == null) {
          return false;
        }
        final userFavData = userFavorites.value as Map<String, bool>;
        if (userFavData[prodId] == null) return false;
        return userFavData[prodId]!;
      }

      loadedProducts.add(Product(
        id: prodId,
        title: prodData['title'],
        description: prodData['description'],
        price: prodData['price'],
        isFavorite: isUserFavorite(prodId),
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
