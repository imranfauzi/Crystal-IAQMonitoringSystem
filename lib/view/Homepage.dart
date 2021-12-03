import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:crystal/components/historyAQI.dart';
import 'package:crystal/components/iaqStatusText.dart';
import 'package:crystal/components/realtimeAQI.dart';
import 'package:crystal/components/tempStatusText.dart';
import 'package:crystal/controller/authController.dart';
import 'package:crystal/controller/firebaseReferences.dart';
import 'package:crystal/model/notificationAPI.dart';
import 'package:crystal/model/sensor_data.dart';
import 'package:crystal/view/Statistic.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_navigation/src/extension_navigation.dart';
import 'package:workmanager/workmanager.dart';

class Homepage extends StatefulWidget {
  String payload;

  Homepage({this.payload});

  @override
  _HomepageState createState() => _HomepageState();
}

class _HomepageState extends State<Homepage> {

  List<double> data1 = [4.0, 0.0, 3.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0 ];


  List<Color> gradientColors = [
    const Color(0xff23b6e6),
    const Color(0xff02d39a),
  ];


  FirebaseReference ref = new FirebaseReference();

  List<String> listsHumidity = [];
  List<String> listsTemperature = [];

  //to add aqi value
  List<Map<dynamic, dynamic>> listsAQI = [];
  List<Map<dynamic, dynamic>> listsAQI1 = [];
  //to store cleaned aqi value
  List<double> listsPPM = [];
  List<String> yearList = ["2021"];

  bool noti = true;
  bool notiButt = false;
  String textValue = "Notification ON";

  double temp = 100;
  double iaq = 1000;

  NotificationAPI notificationAPI = new NotificationAPI();
  SensorData sensorData = new SensorData();
  final FirebaseAuth _auth = FirebaseAuth.instance;


  void toggleSwitch(bool value) {
    if (notiButt == false) {
      setState(() {
        notiButt = true;
        textValue = 'Notification OFF';
      });
      print('Notification OFF');
    } else {
      setState(() {
        notiButt = false;
      textValue = 'Notification ON';
      });
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    NotificationAPI.init();
    listenNotification();
    Workmanager()
        .initialize(NotificationAPI.callbackDispatcher, isInDebugMode: true);
  }

  void listenNotification() =>
      NotificationAPI.onNotifications.stream.listen(onClickNotification);

  void onClickNotification(String payload) => Navigator.of(context).push(
      MaterialPageRoute(builder: (context) => Homepage(payload: payload)));

  @override
  Widget build(BuildContext context) {
    final w = MediaQuery.of(context).size.width;
    final h = MediaQuery.of(context).size.height;
    // Text('CRYSTAL: Indoor Air Quality (IAQ)\nMonitoring System',
    //   textAlign: TextAlign.center,style: TextStyle(fontSize: 25,
    //       color: Colors.blueGrey),),
    return Scaffold(
      body: SafeArea(
        child: Container(
          child: Center(
            child: Stack(
              children: [
                //Title
                Padding(
                  padding: EdgeInsets.only(top: 60,left: 20, right: 20),
                  child: AnimatedTextKit(

                    isRepeatingAnimation: true,
                      repeatForever: true,
                      animatedTexts:[
                        FadeAnimatedText("C R Y S T A L\nIndoor Air Quality (IAQ) Monitoring System",
                            textAlign: TextAlign.center,
                            duration: Duration(seconds: 6),
                            textStyle: TextStyle(fontSize: 25, color: Colors.purple, fontWeight: FontWeight.bold)),

                      ])
                ),
                // *********Top element**********
                //Sign out Button
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    TextButton(
                      onPressed: () => AuthController().signOut(),
                      style: ButtonStyle(
                          overlayColor: MaterialStateColor.resolveWith(
                              (states) => Colors.red)),
                      child: Icon(Icons.logout, color: Colors.red,),
                    ),
                    //Notification Switch
                    Row(
                      children: [
                        Text(textValue),
                        Switch(
                          onChanged: toggleSwitch,
                          value: notiButt,
                          inactiveThumbColor: Colors.green,
                          inactiveTrackColor: Colors.greenAccent,
                          activeColor: Colors.redAccent,
                          activeTrackColor: Colors.red,
                        ),],)],),
                // *********Bottom element****************
                Padding(
                  padding: const EdgeInsets.only(left: 5, right: 5, top: 550),
                  child: ListView(
                    children: [
                      //Air Quality Index
                      StreamBuilder(
                          stream: ref.dbRefAQI.onValue,
                          builder: (context, AsyncSnapshot<Event> snapshot) {
                            if (snapshot.hasData) {
                              listsAQI.clear();
                              DataSnapshot dataValues = snapshot.data.snapshot;
                              Map<dynamic, dynamic> values = dataValues.value;
                              values.forEach((key, values) {
                                if(values["value"]!="nan"){
                                  listsAQI.add(values);
                                }});

                              if (listsAQI.length>0) {
                                for(int a = 0; listsAQI.length<70; a++) {
                                  listsPPM.add(double.tryParse(listsAQI[a]["value"]));
                                }
                                sensorData.ppm = double.parse(
                                    (listsAQI[listsAQI.length - 1]["value"])
                                        .substring(0, 3));
                                  iaq = sensorData.ppm;
                                if (double.parse((listsAQI[listsAQI.length - 1]["value"])
                                        .substring(0, 3)) > 100 && noti == true &&
                                    notiButt == false) {
                                  NotificationAPI.showNotification(
                                      title: "BAD Air Quality!!",
                                      body:
                                      "High air quality index detected,\nplease improve the space airflow.",
                                      payload: "payload");
                                  noti = false;
                                  //limit a notification per minute
                                  Future.delayed(const Duration(minutes: 1), () {
                                        setState(() {noti = true;});
                                      });}}
                              return  Card(
                                color: Colors.greenAccent,
                                elevation: 6,
                                child: ListTile(
                                  onTap: () {Get.to(StatisticPage());},
                                  trailing: Text("IAQ ( Date: "+listsAQI[listsAQI.length-1]["date"]+ " )"),
                                  leading: Icon(Icons.nature_rounded),
                                  title: Text( (double.tryParse(listsAQI[listsAQI.length - 1]["value"].substring(0, 3)) == null)?
                                      "loading..." : double.tryParse(listsAQI[listsAQI.length - 1]["value"].substring(0, 5)).toString()+ " ppm"),
                                ),
                              );
                            }
                            return CircularProgressIndicator();
                          }),
                      //Temperature of air
                      StreamBuilder(
                          stream: ref.dbRefTemperature.onValue,
                          builder: (context, AsyncSnapshot<Event> snapshot) {
                            if (snapshot.hasData) {
                              listsTemperature.clear();
                              DataSnapshot dataValues = snapshot.data.snapshot;
                              Map<dynamic, dynamic> values = dataValues.value;
                              values.forEach((key, values) {
                                if(values!="nan"){
                                  listsTemperature.add(values);
                                }});
                              sensorData.temperature = double.parse(listsTemperature
                              [listsTemperature.length-1].substring(0,2));
                              temp = sensorData.temperature;
                              print("Temperature: $temp");
                              return new ListView.builder(
                                  shrinkWrap: true,
                                  itemCount: 1,
                                  itemBuilder:
                                      (BuildContext context, int index) {
                                    return Card(
                                      color: Colors.cyanAccent,
                                      elevation: 6,
                                      child: ListTile(
                                        trailing: Text("Temperature"),
                                        leading:
                                        Icon(Icons.thermostat_outlined),
                                        title: Text((double.tryParse(listsTemperature[listsTemperature.length-1]
                                            .substring(0, 2))==null) ? "Loading..." :listsTemperature
                                        [listsTemperature.length-1]
                                            .substring(0, 2) +
                                            "°C"),
                                      ),
                                    );
                                  });
                            }
                            return CircularProgressIndicator();
                          }),
                      //Humidity of air
                      StreamBuilder(
                          stream: ref.dbRefHumidity.onValue,
                          builder: (context, AsyncSnapshot<Event> snapshot) {
                            if (snapshot.hasData) {
                              listsHumidity.clear();
                              DataSnapshot dataValues = snapshot.data.snapshot;
                              Map<dynamic, dynamic> values = dataValues.value;
                              values.forEach((key, values) {
                                if(values!="nan"){
                                  listsHumidity.add(values);
                                }});
                              return new ListView.builder(
                                  shrinkWrap: true,
                                  itemCount: 1,
                                  itemBuilder:
                                      (BuildContext context, int index) {
                                    print("This is the index $index");
                                    return Card(
                                      color: Colors.lightBlueAccent,
                                      elevation: 6,
                                      child: ListTile(
                                        trailing: Text("Humidity"),
                                        leading: Icon(Icons.water),
                                        title: Text((double.tryParse(listsHumidity
                                        [listsHumidity.length-1]
                                            .substring(0, 2)) == null )?"Loading...":listsHumidity
                                        [listsHumidity.length-1]
                                                .substring(0, 2) +
                                            "%"),
                                      ),
                                    );
                                  });
                            }
                            return CircularProgressIndicator();
                          }),
                    ],
                  ),
                ),
                // *********Graph****************
                Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    SizedBox(height: 150,),
                    Container(
                      height: h / 2,
                      child: ListView(
                        scrollDirection: Axis.horizontal,
                        children: [
                          //******Sun Picture and Status of sensors************
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Container(
                              width: w,
                              child: Column(
                                children: [
                                  Image(
                                      image: AssetImage('assets/images/sun.png'),
                                      height: h / 3,
                                      width: w / 3,
                                      colorBlendMode: BlendMode.lighten),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                   children: [
                                     //IAQ status
                                     StreamBuilder(
                                      stream: ref.dbRefAQI.onValue,
                                      builder: (context, AsyncSnapshot<Event> snapshot) {
                                        if (snapshot.hasData) {
                                          listsAQI.clear();
                                          DataSnapshot dataValues = snapshot.data.snapshot;
                                          Map<dynamic, dynamic> values = dataValues.value;
                                          values.forEach((key, values) {
                                            if(values["value"]!="nan"){
                                              listsAQI.add(values);
                                            }});

                                          if (listsAQI.length>0) {
                                            for(int a = 0; listsAQI.length<70; a++) {
                                              listsPPM.add(double.tryParse(listsAQI[a]["value"]));
                                            }
                                            sensorData.ppm = double.parse(
                                                (listsAQI[listsAQI.length - 1]["value"])
                                                    .substring(0, 3));
                                            iaq = sensorData.ppm;
                                          }
                                          return Expanded(child: IAQStatusText(sensorData: sensorData),);
                                        }
                                        return CircularProgressIndicator();
                                      }),
                                     //Temp status
                                     StreamBuilder(
                                         stream: ref.dbRefTemperature.onValue,
                                         builder: (context, AsyncSnapshot<Event> snapshot) {
                                           if (snapshot.hasData) {
                                             listsTemperature.clear();
                                             DataSnapshot dataValues = snapshot.data.snapshot;
                                             Map<dynamic, dynamic> values = dataValues.value;
                                             values.forEach((key, values) {
                                               if(values!="nan"){
                                                 listsTemperature.add(values);
                                               }});
                                             sensorData.temperature = double.parse(listsTemperature
                                             [listsTemperature.length-1].substring(0,2));
                                             temp = sensorData.temperature;
                                             print("Temperature: $temp");
                                             return Expanded(child: new TempStatusText(temp: temp));
                                           }
                                           return CircularProgressIndicator();
                                         }),
                                   ],
                                  ),
                                ],
                              ),
                              decoration: BoxDecoration(
                                //  color: Colors.orange,
                                  borderRadius: BorderRadius.all(Radius.circular(20))),
                              height: h / 2.5,
                            ),
                          ),
                          RealtimeAQI(dbRefAQI: ref.dbRefAQI,w: w),
                          HistoryAQI(dbRefAQI: ref.dbRefAQI, w: w, ),
                        ],
                      ),
                    ),
                  ],
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}




