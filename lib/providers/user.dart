import 'package:firebase_auth/firebase_auth.dart';

class LocalUser {
  String? id;

  LocalUser.fromFirebase(User credential) {
    id = credential.uid;
  }
}
