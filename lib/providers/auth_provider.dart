import 'package:flutter/widgets.dart';

class Auth with ChangeNotifier {
  late String _token;
  late DateTime _expireTime;
  late String _userId;
  late bool _isAuth;

  Future<void> register(String email, String password) async {}
}
