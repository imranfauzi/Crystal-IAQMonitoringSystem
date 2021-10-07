// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:flutter/cupertino.dart';
// import 'package:flutter/material.dart';
//
// class AuthenticationService {
//   final FirebaseAuth _firebaseAuth;
//
//   AuthenticationService(this._firebaseAuth);
//
//   Stream<User> get authStateChanges => _firebaseAuth.idTokenChanges();
//
//
//   Future<void> signOut() async {
//     await _firebaseAuth.signOut();
//   }
//
//   Future<Object> signIn({String email, String password, BuildContext context}) async {
//     try {
//       await _firebaseAuth.signInWithEmailAndPassword(email: email, password: password);
//       return "Signed in";
//     } on FirebaseAuthException catch (e) {
//       if (e.code == 'user-not-found') {
//         print('No user found for that email.');
//       } else if (e.code == 'wrong-password') {
//         print('Wrong password provided for that user.');
//       }
//       print("login failed");
//       return ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(content: Text(e.message)),
//       );
//     }
//   }
//
//   Future<Object> signUp({String email, String password, BuildContext context}) async {
//     try {
//       await _firebaseAuth.createUserWithEmailAndPassword(email: email, password: password);
//       return "Signed up";
//     } on FirebaseAuthException catch (e) {
//       if (e.code == 'user-not-found') {
//         print('No user found for that email.');
//       } else if (e.code == 'wrong-password') {
//         print('Wrong password provided for that user.');
//       }
//       print("inilah emessage ${e.message}");
//       return ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(content: Text(e.message)),
//       );
//     }
//   }
// }
//
// class EmailValidator {
//   static String validate(String value) {
//     if (value.isEmpty){
//       return "Email can't be empty";
//     }
//     return null;
//   }
// }