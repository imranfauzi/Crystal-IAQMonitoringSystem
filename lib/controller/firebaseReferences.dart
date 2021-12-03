

import 'package:firebase_database/firebase_database.dart';

class FirebaseReference {
  final dbRefHumidity =
  FirebaseDatabase.instance.reference().child("DHT11").child("Humidity");
  final dbRefTemperature =
  FirebaseDatabase.instance.reference().child("DHT11").child("Temperature");
  final dbRefAQI =
  FirebaseDatabase.instance.reference().child("MQ135").child("PPM");
}