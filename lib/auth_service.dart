import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AuthService {
  final FirebaseAuth _firebaseAuth;

  AuthService(this._firebaseAuth);

  Stream<User> get authStateChanges => _firebaseAuth.authStateChanges();

  Future<void> signOut() async {
    await _firebaseAuth.signOut();
  }

  Future<void> signIn({String email, String password}) async {
    try {
      UserCredential result = await _firebaseAuth.signInWithEmailAndPassword(
          email: email, password: password);
      return;
    } on FirebaseAuthException catch (e) {
      return;
    }
  }

  Future<String> signUp(
      {String firstName,
      String lastName,
      String email,
      String password}) async {
    try {
      UserCredential userCred = await _firebaseAuth
          .createUserWithEmailAndPassword(email: email, password: password);
      await FirebaseFirestore.instance
          .collection('users')
          .doc(userCred.user.uid)
          .set({'firstName': firstName, 'lastName': lastName, 'email': email});

      return "User signed in";
    } on FirebaseAuthException catch (e) {
      return e.message;
    }
  }
}
