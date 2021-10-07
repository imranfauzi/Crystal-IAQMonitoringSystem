import 'package:crystal/controller/authController.dart';
import 'package:crystal/view/Homepage.dart';
import 'package:crystal/view/LoginPage.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';


class AuthWrapper extends GetWidget<AuthController> {

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      return (Get.find<AuthController>().user != null) ? Homepage() : LoginPage();
    });
  }
}



