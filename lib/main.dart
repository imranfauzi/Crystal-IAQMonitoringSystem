import 'package:crystal/authentication_service.dart';
import 'package:crystal/model/notificationAPI.dart';
import 'package:crystal/model/sensor_data.dart';
import 'package:crystal/view/Homepage.dart';
import 'package:crystal/view/LoginPage.dart';
import 'package:crystal/view/RegisterPage.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';
import 'package:workmanager/workmanager.dart';

import 'controller/authBinding.dart';
import 'controller/authWrappper.dart';




Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  await Workmanager().initialize(NotificationAPI.callbackDispatcher, isInDebugMode: true);
  

  return runApp(Crystal());
}


class Crystal extends StatelessWidget {
  @override

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
        debugShowCheckedModeBanner: false,
        home: AuthWrapper(),
        initialBinding: AuthBinding(),
        title: "Crystal",
    );
  }
}


