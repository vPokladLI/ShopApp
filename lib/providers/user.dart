import 'package:flutter/foundation.dart';
import 'package:firebase_auth/firebase_auth.dart';

class LocalUser with ChangeNotifier {
  final User? _user;
  LocalUser(this._user);

  get id {
    return _user?.uid;
  }
}
