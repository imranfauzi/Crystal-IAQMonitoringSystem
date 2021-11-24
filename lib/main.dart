import 'package:crystal/model/notificationAPI.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
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
  Widget build(BuildContext context) {
    return GetMaterialApp(
        debugShowCheckedModeBanner: false,
        home: AuthWrapper(),
        initialBinding: AuthBinding(),
        title: "Crystal",
    );
  }
}


