import 'package:http/http.dart' as http;
import '../providers/product_provider.dart';

class Database {
  final _endpoint = Uri.https(
      'https://flutter-shop-app-365508-default-rtdb.europe-west1.firebasedatabase.app/products');

  addNewProduct(Product newProduct) async {}
}
