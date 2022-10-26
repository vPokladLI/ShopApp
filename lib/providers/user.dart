import 'package:flutter/foundation.dart';

class LocalUser with ChangeNotifier {
  String? _id;
  LocalUser();

  setId(String? id) {
    _id = id;
    notifyListeners();
  }

  get userId {
    return _id;
  }
}
