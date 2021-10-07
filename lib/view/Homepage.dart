import 'dart:ffi';

import 'package:crystal/authentication_service.dart';
import 'package:crystal/controller/authController.dart';
import 'package:crystal/model/notificationAPI.dart';
import 'package:crystal/model/sensor_data.dart';

import 'package:crystal/view/Setting.dart';
import 'package:draw_graph/draw_graph.dart';
import 'package:draw_graph/models/feature.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_sparkline/flutter_sparkline.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:workmanager/workmanager.dart';
class Homepage extends StatefulWidget {

  String payload;

  Homepage({this.payload});

  @override
  _HomepageState createState() => _HomepageState();
}

class _HomepageState extends State<Homepage> {


  List<double> data1 = [0.0, -2.0, 3.5, -2.0, 0.5, 0.7, 0.8, 1.0, 2.0, 3.0, 3.2];
  var notice = [
    "Great air quality",
    "Good air quality",
    "Medium air quality",
    "Poor air quality"
  ];

  List<Color> gradientColors = [
    const Color(0xff23b6e6),
    const Color(0xff02d39a),
  ];

  // Material info(String username) {
  //   return Material(
  //     color: Color(0xFF2E294E),
  //     elevation: 14.0,
  //     borderRadius: BorderRadius.circular(10.0),
  //     shadowColor: Color(0xFF820263),
  //     child: Padding(
  //       padding: EdgeInsets.all(8.0),
  //       child: Column(
  //           mainAxisAlignment: MainAxisAlignment.start,
  //           children: <Widget>[
  //             Row(
  //               mainAxisAlignment: MainAxisAlignment.end,
  //               children: [
  //                 Text(
  //                   "SignOut",
  //                   style: TextStyle(color: Color(0xFF70D6FF), fontSize: 15),
  //                 ),
  //                 IconButton(
  //                     color: Colors.white,
  //                     iconSize: 30,
  //                     icon: Icon(Icons.logout),
  //                     onPressed: () {
  //                       context.read<AuthenticationService>().signOut();
  //                     }),
  //               ],
  //             ),
  //             Padding(
  //               padding: EdgeInsets.all(1.0),
  //               child: Text(
  //                 "User: " + username,
  //                 style: TextStyle(
  //                   fontSize: 20.0,
  //                   color: Colors.white,
  //                 ),
  //               ),
  //             ),
  //             IconButton(
  //                 color: Colors.white,
  //                 iconSize: 30,
  //                 icon: Icon(Icons.settings),
  //                 onPressed: () {
  //                   Get.to(() => Setting());
  //                 })
  //           ]),
  //     ),
  //   );
  // }

  Material chart1(String title, String priceVal, String subtitle, List data) {
    return Material(
      color: Color(0xFF2E294E),
      elevation: 14.0,
      borderRadius: BorderRadius.circular(24.0),
      shadowColor: Color(0x802196F3),
      child: Center(
        child: Padding(
          padding: EdgeInsets.all(8.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  Padding(
                    padding: EdgeInsets.all(1.0),
                    child: Text(
                      title,
                      style: TextStyle(
                        fontSize: 25.0,
                        color: Colors.yellow,
                       // color: Color(0xFFEE964B),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  Padding(
                    padding: EdgeInsets.all(1.0),
                    child: Text(
                      priceVal,
                      style: TextStyle(fontSize: 30.0, color: Colors.white),
                    ),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  Padding(
                    padding: EdgeInsets.all(1.0),
                    child: Text(
                      subtitle,
                      style: TextStyle(
                        fontSize: 20.0,
                        color: Colors.white54,
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 30,
                  ),
                  Padding(
                    padding: EdgeInsets.all(5.0),
                    child: new Sparkline(
                      data: data,
                      lineColor: Color(0xffff6101),
                      pointsMode: PointsMode.last,
                      pointColor: Colors.yellow,
                      pointSize: 10.0,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Material ppmText(String title, String subtitle) {
  //   return Material(
  //     color: Color(0xFF2E294E),
  //     elevation: 14.0,
  //     borderRadius: BorderRadius.circular(24.0),
  //     shadowColor: Color(0x802196F3),
  //     child: Center(
  //       child: Padding(
  //         padding: EdgeInsets.all(8.0),
  //         child: Row(
  //           mainAxisAlignment: MainAxisAlignment.center,
  //           children: <Widget>[
  //             Column(
  //               mainAxisAlignment: MainAxisAlignment.center,
  //               children: <Widget>[
  //                 Padding(
  //                   padding: EdgeInsets.all(8.0),
  //                   child: Text(
  //                     title,
  //                     style: TextStyle(
  //                         fontSize: 25.0,
  //                        color: Colors.yellow,
  //                        // color: Color(0xFFF95738),
  //                     ),
  //                   ),
  //                 ),
  //                 Padding(
  //                   padding: EdgeInsets.all(8.0),
  //                   child: Text(
  //                     subtitle,
  //                     maxLines: 5,
  //                     overflow: TextOverflow.ellipsis,
  //                     style: TextStyle(fontSize: 15.0, color: Colors.white),
  //                   ),
  //                 ),
  //               ],
  //             ),
  //           ],
  //         ),
  //       ),
  //     ),
  //   );
  // }

  Material ppmText1(String title, String subtitle) {
    return Material(
      color: Color(0xFF2E294E),
      elevation: 14.0,
      borderRadius: BorderRadius.circular(24.0),
      shadowColor: Color(0x802196F3),
      child: Center(
        child: Padding(
          padding: EdgeInsets.all(8.0),
          child: Container(
            height: 150,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Padding(
                  padding: EdgeInsets.all(8.0),
                  child: Text(
                    title,
                    style: TextStyle(
                        fontSize: 25.0,
                        color: Colors.yellow,
                        //color: Color(0xFFEE964B),
                        ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.all(8.0),
                  child: Text(
                    subtitle,
                    style: TextStyle(fontSize: 30.0, color: Colors.white),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Material ppmText2(String title, String subtitle) {
    return Material(
      color: Color(0xFF2E294E),
      elevation: 14.0,
      borderRadius: BorderRadius.circular(24.0),
      shadowColor: Color(0x802196F3),
      child: Center(
        child: Padding(
          padding: EdgeInsets.all(8.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Padding(
                    padding: EdgeInsets.all(8.0),
                    child: Text(
                      title,
                      style: TextStyle(
                          fontSize: 30.0,
                          color: Colors.yellow,
                         // color: Color(0xFFEE964B),
                          fontWeight: FontWeight.bold),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.all(8.0),
                    child: Text(
                      subtitle,
                      style: TextStyle(fontSize: 30.0, color: Colors.white),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  final dbRefHumidity = FirebaseDatabase.instance.reference().child("DHT11").child("Humidity");
  final dbRefTemperature = FirebaseDatabase.instance.reference().child("DHT11").child("Temperature");
  final dbRefAQI = FirebaseDatabase.instance.reference().child("MQ135").child("PPM");

  List<String> listsHumidity = [];
  List<String> listsTemperature = [];
  List<String> listsAQI = [];
  List<String> listsAQI1 = [""];
  List<double> listsPPM = [];
  List<double> listPPM1 = [0,0,0];
  bool noti = true;
  bool notiButt = false;
  String textValue ="Notification ON";
  var average3;
  var average2;
  var average1;

NotificationAPI notificationAPI = new NotificationAPI();
 SensorData sensorData = new SensorData();
  final FirebaseAuth _auth = FirebaseAuth.instance;

  Future<void> _signOut() async {
    print("logout");
    await _auth.signOut();
  }

  Future<void> _offNotify() async {
    noti = false;
    notiButt = false; //kalau true meaning no notification
  }

  void toggleSwitch(bool value){

      if(notiButt == false)
      {
        setState(() {
          notiButt = true;
          textValue = 'Notification OFF';
        });
        print('Notification OFF');
      }
      else
      {
        setState(() {
          notiButt = false;
          textValue = 'Notification ON';
        });
        print('Notification ON');
      }
      print(" notiButt $notiButt");

  }

@override
  void initState() {
    // TODO: implement initState
    super.initState();

    NotificationAPI.init();
    listenNotification();
    Workmanager().initialize(NotificationAPI.callbackDispatcher, isInDebugMode: true);
  }

  void listenNotification() => NotificationAPI.onNotifications.stream.listen(onClickNotification);
  
  void onClickNotification(String payload) => Navigator.of(context).push(MaterialPageRoute(builder: (context) => Homepage(payload: payload)));


  @override
  Widget build(BuildContext context) {
    final w = MediaQuery.of(context).size.width;
    final h = MediaQuery.of(context).size.height;

    return Scaffold(
      body: SafeArea(
        child: Container(

          child: Center(
            child: Stack(
              children: [

                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Container(
                    alignment: Alignment.center,
                    width: w,
                    child: Expanded(
                        child: Image(
                      image: AssetImage('assets/images/sun.png'),
                      height: h / 2,
                      width: w / 2,
                      colorBlendMode: BlendMode.lighten
                    )),
                    decoration: BoxDecoration(
                        //  color: Colors.orange,
                        borderRadius: BorderRadius.all(Radius.circular(20))),
                    height: h / 2.5,

                  ),
                ),
                // *********Gambar Sun**************
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    TextButton(
                      onPressed: () => AuthController().signOut(),
                      style: ButtonStyle(
                          overlayColor: MaterialStateColor.resolveWith((states) => Colors.red)
                      ),
                      child: Icon(Icons.logout, color: Colors.red, ), ),

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
                        ),
                      ],
                    )
                  ],
                ),
                // *********Column bawah****************
                Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Container(
                      height: h / 2,
                      child: ListView(
                        scrollDirection: Axis.horizontal,
                        children: [
                          //******Air Quality
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Container(
                              child: StreamBuilder(
                                  stream: dbRefAQI.onValue,
                                  builder: (context, AsyncSnapshot<Event> snapshot) {
                                    if (snapshot.hasData) {
                                      listsAQI.clear();
                                      DataSnapshot dataValues = snapshot.data.snapshot;
                                      Map<dynamic, dynamic> values = dataValues.value;

                                      values.forEach((key, values) {
                                        listsAQI.add(values);
                                        listsAQI1.clear();
                                        listsAQI1.add(values);

                                      });

                                      if(listsAQI.length<70){
                                        listsPPM = data1;
                                      }
                                      else{
                                        listsPPM = listsAQI.map(double.parse).toList().sublist(listsAQI.length-70, listsAQI.length-1);
                                        //masukkan data di model sensor_data
                                        sensorData.ppm = double.parse((listsAQI1[listsAQI1.length-1]).substring(0, 3));
                                        print("Nilai ${sensorData.ppm}");

                                        if (double.parse((listsAQI1[listsAQI1.length-1]).substring(0, 3)) > 315 && noti == true && notiButt == false ){

                                          print("Notification pernah $noti");

                                          NotificationAPI.showNotification(
                                            title: "BAD Air Quality!!",
                                            body: "Low air quality index detected,\nplease improve the space airflow.",
                                            payload: "payload"
                                          );
                                            noti = false;
                                            // setiap satu minit dia akan bunyi lagi kalau aqi masih tinggi, untuk limit berapa
                                          // banyak noti yang boleh bunyi dlam satu minit.
                                            Future.delayed(const Duration(minutes: 1), () {
                                              setState(() {
                                                noti = true;
                                              });
                                            });

                                          print("Notification $noti");

                                        }

                                      }

                                      listsAQI1.clear();



                                      return chart1("Indoor Air Quality",
                                          listsAQI[listsAQI.length-1].substring(0, 3) + "ppm",
                                          (int.parse((listsAQI[listsAQI.length-1]).substring(0, 2)) - 100 ).toString()+ " more than normal", listsPPM);
                                    }
                                    return CircularProgressIndicator();
                                  }),
                              decoration: BoxDecoration(
                                  borderRadius:
                                  BorderRadius.all(Radius.circular(20))),
                              width: w / 1.04,
                            ),
                          ),
                          // *****Humidity and Temperature
                          Padding(
                            padding: const EdgeInsets.all(20.0),
                            child: Container(
                              child: Column(
                                children: [
                                  StreamBuilder(
                                      stream: dbRefTemperature.onValue,
                                      builder: (context, AsyncSnapshot<Event> snapshot) {
                                        if (snapshot.hasData) {
                                          listsTemperature.clear();
                                          DataSnapshot dataValues = snapshot.data.snapshot;
                                          Map<dynamic, dynamic> values = dataValues.value;
                                          values.forEach((key, values) {
                                            listsTemperature.add(values);
                                          });
                                          return ppmText1("Temperature", listsTemperature[listsTemperature.length-1].substring(0, 2) + "°C");
                                        }
                                        return CircularProgressIndicator();
                                      }),
                                  SizedBox(
                                    height: 10,
                                  ),
                                  StreamBuilder(
                                      stream: dbRefHumidity.onValue,
                                      builder: (context, AsyncSnapshot<Event> snapshot) {
                                        if (snapshot.hasData) {
                                          listsHumidity.clear();
                                          DataSnapshot dataValues = snapshot.data.snapshot;
                                          Map<dynamic, dynamic> values = dataValues.value;
                                          values.forEach((key, values) {
                                            listsHumidity.add(values);
                                          });
                                          return ppmText1("Humidity", listsHumidity[listsHumidity.length-1].substring(0, 2)+ "%");
                                        }
                                        return CircularProgressIndicator();
                                      }),
                                ],
                              ),
                              decoration: BoxDecoration(
                                  borderRadius:
                                  BorderRadius.all(Radius.circular(20))),
                              width: w / 1.1,
                            ),
                          ),
                          // History graph
                          Padding(
                            padding: const EdgeInsets.all(20.0),
                            child: Container(
                              padding: EdgeInsets.all(20),
                              child: StreamBuilder(
                                  stream: dbRefAQI.onValue,
                                  builder: (context, AsyncSnapshot<Event> snapshot) {
                                    if (snapshot.hasData) {
                                      listsAQI.clear();
                                      DataSnapshot dataValues = snapshot.data.snapshot;
                                      Map<dynamic, dynamic> values = dataValues.value;




                                      values.forEach((key, values) {
                                        listsAQI.add(values);
                                      });


                                      if(listsAQI.length<70){
                                        listPPM1 = [0.1, 0.1, 0.1];
                                      }else{
                                        average3 = (listsAQI.map(double.parse).toList().sublist(listsAQI.length-60, listsAQI.length-40)
                                            .map((m) => m).reduce((value, element) => value + element))/(20)/1000;
                                        average2 = (listsAQI.map(double.parse).toList().sublist(listsAQI.length-40, listsAQI.length-20)
                                            .map((m) => m).reduce((value, element) => value + element))/(20)/1000;
                                        average1 = (listsAQI.map(double.parse).toList().sublist(listsAQI.length-20, listsAQI.length-1)
                                            .map((m) => m).reduce((value, element) => value + element))/(20)/1000;
                                        print("ini average $average3");
                                        print("average2: $average2");
                                        print("average1: $average1");
                                     //   listPPM1 = listsAQI.map(double.parse).toList().sublist(listsAQI.length-4, listsAQI.length-1);
                                     //    listPPM1.insert(0, average3);
                                     //    listPPM1.insert(1, average2);
                                     //    listPPM1.insert(2, average1);
                                        listPPM1.replaceRange(0, 3, [average3,average2,average1]);
                                        print("listPPM1 $listPPM1");
                                      }

                                      List<Feature> features = [
                                        Feature(
                                          title: "Flutter",
                                          color: Colors.yellow,
                                          data: listPPM1,
                                        )];

                                      return Stack(
                                        children: [
                                          Container(
                                            child: Column(
                                              children: [
                                                Text("3DA: ${(average3*1000)} ppm", style: TextStyle(color: Colors.yellow, fontSize: 25),),
                                                SizedBox(height: 10),
                                                Text("2DA: ${average2*1000} ppm", style: TextStyle(color: Colors.yellow, fontSize: 25),),
                                                SizedBox(height: 10),
                                                Text("1DA: ${average1*1000} ppm", style: TextStyle(color: Colors.yellow, fontSize: 25),),
                                              ],
                                            ),
                                            alignment: Alignment.center,
                                          ),
                                          LineGraph(
                                            features: features,
                                            size: Size(350, 350),
                                            labelX: ['3 Days ago', '2 Days ago', '1 Days ago'],
                                            labelY: ['100', '.', '300', '.', '500', '.', '700', '.', '900', '.'],
                                            //    showDescription: true,
                                            graphColor: Colors.white,
                                          ),
                                        ],

                                      );
                                    }
                                    return CircularProgressIndicator();
                                  }),
                              decoration: BoxDecoration(
                                  color: Color(0xFF2E294E),
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(20))),
                              width: w / 1.1,
                            ),
                          ),
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



    // return Scaffold(
    //     body: Column(
    //       children: [
    //         StreamBuilder(
    //             stream: dbRefHumidity.onValue,
    //             builder: (context, AsyncSnapshot<Event> snapshot) {
    //               if (snapshot.hasData) {
    //                 listsHumidity.clear();
    //                 DataSnapshot dataValues = snapshot.data.snapshot;
    //                 Map<dynamic, dynamic> values = dataValues.value;
    //                 values.forEach((key, values) {
    //                   listsHumidity.add(values);
    //                 });
    //                 return new ListView.builder(
    //                     shrinkWrap: true,
    //                     itemCount: listsHumidity.length,
    //                     itemBuilder: (BuildContext context, int index) {
    //                       return Card(
    //                         child: Column(
    //                           crossAxisAlignment: CrossAxisAlignment.start,
    //                           children: <Widget>[
    //                             Text("Humidity: " + listsHumidity[index]),
    //                           ],
    //                         ),
    //                       );
    //                     });
    //               }
    //               return CircularProgressIndicator();
    //             }),
    //         StreamBuilder(
    //             stream: dbRefTemperature.onValue,
    //             builder: (context, AsyncSnapshot<Event> snapshot) {
    //               if (snapshot.hasData) {
    //                 listsTemperature.clear();
    //                 DataSnapshot dataValues = snapshot.data.snapshot;
    //                 Map<dynamic, dynamic> values = dataValues.value;
    //                 values.forEach((key, values) {
    //                   listsTemperature.add(values);
    //                 });
    //                 return new ListView.builder(
    //                     shrinkWrap: true,
    //                     itemCount: listsTemperature.length,
    //                     itemBuilder: (BuildContext context, int index) {
    //                       return Card(
    //                         child: Column(
    //                           crossAxisAlignment: CrossAxisAlignment.start,
    //                           children: <Widget>[
    //                             Text("Temperature: " + listsTemperature[index]),
    //                           ],
    //                         ),
    //                       );
    //                     });
    //               }
    //               return CircularProgressIndicator();
    //             }),
    //       ],
    //     ));
//   }
// }

//   Widget build(BuildContext context) {
//
//     return Scaffold(
//       backgroundColor: Colors.white,
//       body: Container(
//         child: StaggeredGridView.count(
//           crossAxisCount: 4,
//           mainAxisSpacing: 1,
//           crossAxisSpacing: 5,
//           children: [
//             Padding(
//                 padding: const EdgeInsets.only(top: 8),
//                // child: info("${user?.email}")),
//                 child: info("username")),
//             Padding(
//               padding: const EdgeInsets.all(8.0),
//               child: chart1("LIVE Indoor Air Quality Level", "120ppm",
//                   "+12.54 than normal"),
//             ),
//             // Padding(
//             //   padding: const EdgeInsets.all(8.0),
//             //   child: Graph(),
//             // ),
//             // Padding(
//             //   padding: const EdgeInsets.all(8.0),
//             //   child: Graph2(),
//             // ),
//             Padding(
//               padding: EdgeInsets.all(8),
//               child: ppmText("ALERT", notice[3]),
//             ),
//             Padding(
//               padding: EdgeInsets.only(right: 8),
//               child: ppmText1("Temperature", "27 ℃"),
//             ),
//             Padding(
//               padding: EdgeInsets.only(right: 8),
//               child: ppmText2("Humidity", "27%"),
//             ),
//           ],
//           staggeredTiles: [
//             StaggeredTile.extent(4, 250.0),
//             StaggeredTile.extent(4, 250.0),
//
//             //    StaggeredTile.extent(4, 250.0),
//             StaggeredTile.extent(2, 250.0),
//             StaggeredTile.extent(2, 120.0),
//             StaggeredTile.extent(2, 120.0),
//           ],
//         ),
//       ),
//     );
//   }
// }
