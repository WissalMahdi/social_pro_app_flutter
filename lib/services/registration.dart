// ignore_for_file: avoid_print

import 'package:firebase_auth/firebase_auth.dart';

class RegistrationServices {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  Future createNewUser(String email, String password) async {
    try {
      UserCredential result = await _auth.createUserWithEmailAndPassword(
          email: email.trim(), password: password.trim());
      User? user = result.user;
      return user;
    } catch (e) {
      print(e.toString());
    }
  }
}
