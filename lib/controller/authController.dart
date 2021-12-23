import 'package:firebase_auth/firebase_auth.dart';
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
      if (e.code == 'weak-password') {
        if(password.length<8){
          Get.snackbar("The password provided is too weak.", "Password should be at least 8 characters", snackPosition: SnackPosition.BOTTOM);
        } else{
          Get.snackbar("The password provided is too weak.", "Password should be at least 8 characters", snackPosition: SnackPosition.BOTTOM);
        }
      } else if (e.code == 'email-already-in-use') {
        Get.snackbar("The account already exists for that email.", e.message, snackPosition: SnackPosition.BOTTOM);
      }
    }
  }

  Future<void> SignIn({String email, String password}) async {
    try {
      await _auth.signInWithEmailAndPassword(email: email, password: password);
    } catch (e) {
      if(e.code == "user-not-found") {
        Get.snackbar("No user found for that email.", e.message, snackPosition: SnackPosition.BOTTOM);
      } else if (e.code == 'wrong-password') {
        Get.snackbar("Wrong password provided for that user.", e.message, snackPosition: SnackPosition.BOTTOM);
      }
    }
  }

  Future<void> signOut() async {
    print("Logout");
    await _auth.signOut();
  }
}

