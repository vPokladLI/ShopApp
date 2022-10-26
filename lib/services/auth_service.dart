import 'package:firebase_auth/firebase_auth.dart';
import '../models/http_exception.dart';

class Auth {
  final _auth = FirebaseAuth.instance;

  Future<void> registerWithEmailPassword(String email, String password) async {
    try {
      await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        throw HttpException('The password provided is too weak.');
      } else if (e.code == 'email-already-in-use') {
        throw HttpException('The account already exists for that email.');
      }
    } catch (e) {
      rethrow;
    }
  }

  Future<void> loginWithEmailPassword(
      String emailAddress, String password) async {
    try {
      await _auth.signInWithEmailAndPassword(
          email: emailAddress, password: password);
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        throw HttpException('No user found for that email.');
      } else if (e.code == 'wrong-password') {
        throw HttpException('Wrong password provided for that user.');
      }
    }
  }

  Future<void> signOut() async {
    await _auth.signOut();
  }

  Stream<User?> get currentUser {
    return _auth.authStateChanges();
  }
}
