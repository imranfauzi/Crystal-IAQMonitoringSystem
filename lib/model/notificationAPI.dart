import 'package:crystal/model/sensor_data.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:rxdart/rxdart.dart';
import 'package:workmanager/workmanager.dart';

class NotificationAPI {

  static final _notification = FlutterLocalNotificationsPlugin();
  static final onNotifications = BehaviorSubject<String>(); //kena rxdart pckg untuk dgr pada notification
  SensorData sensorData = new SensorData();

  static callbackDispatcher() {
    Workmanager().executeTask((task, inputData) {

      if(SensorData().ppm > 315){
        var android = new AndroidInitializationSettings('app_icon');

        // initialise settings for both Android and iOS device.
        var settings = new InitializationSettings(android: android);
        _notification.initialize(settings);
        showNotification();
        return NotificationAPI.showNotification(
            title: "BAD Air Quality!!",
            body: "Low air quality index detected,\nplease improve the space airflow.",
            payload: "payload"
        );
      }
      return Future.value(true);
    });
  }


  static Future _notificationDetails() async {
    return NotificationDetails(
      android: AndroidNotificationDetails(
        'channel id',
        'channel name',
        'channel description',
        importance: Importance.max,
        playSound: true,
        icon: "app_icon",


      ),
      iOS: IOSNotificationDetails()
    );
  }

// Bila tekan noti ni, dia akan pergi ikut payload
  static Future init({bool initScheduled = false}) async {
    final android = AndroidInitializationSettings("app_icon");
    final settings = InitializationSettings(android: android);

    //when app closed
    final details = await _notification.getNotificationAppLaunchDetails();
    if(details != null && details.didNotificationLaunchApp){
      onNotifications.add(details.payload);
    }
    await _notification.initialize(
      settings,
      onSelectNotification: (payload) async {
        onNotifications.add(payload);
      },
    );
  }

  static Future showNotification({

    int id = 0,
    String title,
    String body,
    String payload,
    DateTime scheduleDate,

  }) async =>
      _notification.show(id, title, body, await _notificationDetails(),
      payload: payload, );


}

