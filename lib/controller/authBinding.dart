

import 'package:crystal/controller/authController.dart';
import 'package:get/get.dart';

class AuthBinding extends Bindings {

  @override
  void dependencies() {
    Get.lazyPut<AuthController>(() => AuthController());
  }

}