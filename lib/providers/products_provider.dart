import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shop_app/models/http_exception.dart';
// import '../services/database.dart';
import 'product_provider.dart';

class Products with ChangeNotifier {
  static const _endpoint =
      'flutter-shop-app-365508-default-rtdb.europe-west1.firebasedatabase.app';
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
    final url = Uri.https(_endpoint, '/products.json');

    final response = await http.get(url);
    print(response.statusCode);
    final extractedData = json.decode(response.body);

    if (extractedData == null) {
      return;
    }
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
    final url = Uri.https(_endpoint, '/products.json');
    return http
        .post(
      url,
      body: json.encode({
        'title': product.title,
        'description': product.description,
        'imageUrl': product.imageUrl,
        'price': product.price,
        'isFavorite': product.isFavorite,
      }),
    )
        .then((response) {
      if (response.statusCode == 200) {
        final newProduct = Product(
          title: product.title,
          description: product.description,
          price: product.price,
          imageUrl: product.imageUrl,
          id: jsonDecode(response.body)['name'],
        );
        _items.add(newProduct);
        notifyListeners();
      }
    });

    // _items.insert(0, newProduct); // at the start of the list
  }

  Future deleteProduct(String productId) async {
    final url = Uri.https(_endpoint, '/products/$productId.json');
    try {
      final response = await http.delete(url);
      if (response.statusCode == 200) {
        _items.removeWhere((e) => e.id == productId);
        notifyListeners();
      }
    } catch (e) {
      rethrow;
    }
  }

  Future updateProduct(Product newProduct) async {
    final url = Uri.https(_endpoint, '/products/${newProduct.id}.json');
    final index = _items.indexWhere((element) => element.id == newProduct.id);
    if (index >= 0) {
      try {
        final response = await http.patch(url,
            body: json.encode({
              'description': newProduct.description,
              'imageUrl': newProduct.imageUrl,
              'price': newProduct.price,
              'title': newProduct.title
            }));
        if (response.statusCode == 200) {
          _items[index] = newProduct;
          notifyListeners();
        }
        throw response.body;
      } catch (e) {
        rethrow;
      }
    }
  }
}
