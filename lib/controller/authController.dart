import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';


class AuthController extends GetxController {

  FirebaseAuth _auth = FirebaseAuth.instance;
  Rxn<User> _firebaseUser = Rxn<User>();

  User get user => _firebaseUser.value;

  @override
  void onInit() {
    _firebaseUser.bindStream(_auth.authStateChanges());
    super.onInit();
  }

  Future<void> SignUp({String email, String password}) async {

    try{
      await _auth.createUserWithEmailAndPassword(email: email, password: password);
      Get.back();
    } catch (e) {
      Get.snackbar("Error in creating account", e.message, snackPosition: SnackPosition.BOTTOM);
    }
  }

  Future<void> SignIn({String email, String password}) async {

    try {
      await _auth.signInWithEmailAndPassword(email: email, password: password);
    } catch (e) {
      Get.snackbar("Error in login to account", e.message, snackPosition: SnackPosition.BOTTOM);
    }
  }

  Future<void> signOut() async {
    print("Logout");
    await _auth.signOut();
  }

  }

