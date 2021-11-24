import 'package:crystal/controller/authController.dart';
import 'package:crystal/model/notificationAPI.dart';
import 'package:crystal/model/sensor_data.dart';
import 'package:draw_graph/draw_graph.dart';
import 'package:draw_graph/models/feature.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_sparkline/flutter_sparkline.dart';
import 'package:workmanager/workmanager.dart';

class Homepage extends StatefulWidget {
  String payload;

  Homepage({this.payload});

  @override
  _HomepageState createState() => _HomepageState();
}

class _HomepageState extends State<Homepage> {
  List<double> data1 = [
    0.0,
    0.0,
    0.0,
    0.0,
    0.0,
    0.0,
    0.0,
    0.0,
    0.0,
    0.0,
    0.0
  ];

  var iaqStatus = [
    "Good Air Quality",
    "Moderate Air Quality",
    "Unhealthy Air Quality",
    "Very Unhealthy Air Quality",
    "Hazardous Air Quality"
  ];

  List<Color> gradientColors = [
    const Color(0xff23b6e6),
    const Color(0xff02d39a),
  ];

  Material AQI_Chart(String title, String priceVal, String subtitle, List data) {
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
                      style: TextStyle(fontSize: 25.0, color: Colors.yellow,
                      ),
                    ),
                  ),
                  SizedBox(height: 20,),
                  Padding(padding: EdgeInsets.all(1.0),
                    child: Text(priceVal,
                      style: TextStyle(fontSize: 30.0, color: Colors.white),
                    ),
                  ),
                  SizedBox(height: 20,),
                  Padding(padding: EdgeInsets.all(1.0),
                    child: Text(subtitle,
                      style: TextStyle(fontSize: 20.0, color: Colors.white54,
                      ),
                    ),
                  ),
                  SizedBox(height: 30,),
                  Padding(
                    padding: EdgeInsets.all(5.0),
                    child: new Sparkline(data: data,lineColor: Color(0xffff6101),
                      pointsMode: PointsMode.last,
                      pointColor: Colors.yellow,
                      pointSize: 10.0,
                    ),),],),
            ],
          ),
        ),
      ),
    );
  }

  final dbRefHumidity =
      FirebaseDatabase.instance.reference().child("DHT11").child("Humidity");
  final dbRefTemperature =
      FirebaseDatabase.instance.reference().child("DHT11").child("Temperature");
  final dbRefAQI =
      FirebaseDatabase.instance.reference().child("MQ135").child("PPM").child("value");
  final dbRefDate =
      FirebaseDatabase.instance.reference().child("MQ135").child("PPM").child("date");


  List<String> listsHumidity = [];
  List<String> listsTemperature = [];

  //to add aqi value
  List<String> listsAQI = [];
  //to store cleaned aqi value
  List<double> listsPPM = [];
  //to store aqi value for aqi history graph
  List<double> listPPM1 = [0, 0, 0];
  var average3;
  var average2;
  var average1;

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

  Widget iaqStatusText(double value, double size){
    if(value<51){
      return Text(iaqStatus[0], style: TextStyle(fontSize: size, color: Colors.blueAccent),);
    }
    if(value>=51 && value<101){
      return Text(iaqStatus[1], style: TextStyle(fontSize: size, color: Colors.green),);
    }
    if(value>=101 && value<201){
      return Text(iaqStatus[2], style: TextStyle(fontSize: size, color: Colors.yellow),);
    }
    if(value>=201 && value<301){
        return Text(iaqStatus[2], style: TextStyle(fontSize: size, color: Colors.orange),);
    }
    else{
      if(value==1000){
        return Text("Loading...", style: TextStyle(fontSize: size, color: Colors.blue),);
      } else {
        return Text(iaqStatus[3], style: TextStyle(fontSize: size, color: Colors.red),);
      }

    }
}

  Widget temperatureStatusText(double value, double size){

    if(value>=23 && value<=26){
      return Text("Normal", style: TextStyle(fontSize: size, color: Colors.green),);
    }
    if(value>26){
      if(value==100){
        return Text("Loading...", style: TextStyle(fontSize: size, color: Colors.blueAccent),);
      }else {
        return Text("Above Normal", style: TextStyle(fontSize: size, color: Colors.orange),);
      }

    }
    if(value<23){
      return Text("Below Normal", style: TextStyle(fontSize: size, color: Colors.blueAccent),);
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
    iaqStatusText;
  }

  void listenNotification() =>
      NotificationAPI.onNotifications.stream.listen(onClickNotification);

  void onClickNotification(String payload) => Navigator.of(context).push(
      MaterialPageRoute(builder: (context) => Homepage(payload: payload)));

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
                //Title
                Padding(
                  padding: const EdgeInsets.only(top: 60, left: 20),
                  child: Text('CRYSTAL: Indoor Air Quality (IAQ)\nMonitoring System',
                    textAlign: TextAlign.center,style: TextStyle(fontSize: 25,
                        color: Colors.blueGrey),),
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
                          stream: dbRefAQI.onValue,
                          builder: (context, AsyncSnapshot<Event> snapshot) {
                            if (snapshot.hasData) {
                              listsAQI.clear();
                              DataSnapshot dataValues = snapshot.data.snapshot;
                              Map<dynamic, dynamic> values = dataValues.value;
                              values.forEach((key, values) {
                                if(values!="nan"){
                                  listsAQI.add(values);
                                }});
                              if (listsAQI.length < 70) {
                                listsPPM = data1;
                              } else {
                                listsPPM = listsAQI
                                    .map(double.parse)
                                    .toList()
                                    .sublist(listsAQI.length - 70,
                                    listsAQI.length - 1);
                                //insert data to SensorData Model
                                sensorData.ppm = double.parse(
                                    (listsAQI[listsAQI.length - 1])
                                        .substring(0, 3));
                                iaq = sensorData.ppm;
                                if (double.parse((listsAQI[listsAQI.length - 1])
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
                                  trailing: Text("IAQ"),
                                  leading: Icon(Icons.nature_rounded),
                                  title: Text( (double.tryParse(listsAQI[listsAQI.length - 1].substring(0, 3)) == null)?
                                      "loading..." : listsAQI[listsAQI.length - 1].substring(0, 3)+ "ppm"),
                                ),
                              );
                            }
                            return CircularProgressIndicator();
                          }),
                      //Temperature of air
                      StreamBuilder(
                          stream: dbRefTemperature.onValue,
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
                          stream: dbRefHumidity.onValue,
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
                                     Column(
                                       children: [
                                         Text("IAQ Status\n", style: TextStyle(fontSize: 20),),
                                         Container(
                                           padding: EdgeInsets.all(10),
                                            decoration: BoxDecoration(
                                              border: Border.all(
                                                color: Colors.green,
                                                 ),
                                               borderRadius: BorderRadius.all(Radius.circular(20)),
                                                    ),
                                             child: iaqStatusText((sensorData.ppm!=null) ? sensorData.ppm: 1000, 20,)),
                                       ],
                                     ),
                                     Column(
                                       children: [
                                         Text("Temperature Status\n", style: TextStyle(fontSize: 20),),
                                         Container(
                                           padding: EdgeInsets.all(10),
                                           child:temperatureStatusText((temp!=null) ? temp: 100, 20),
                                           decoration: BoxDecoration(
                                             border: Border.all(
                                               color: Colors.blue,
                                             ),
                                             borderRadius: BorderRadius.all(Radius.circular(20)),
                                           ),
                                         ),
                                       ],
                                     )
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
                          //******Air Quality Graph
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
                                        if(values!="nan"){
                                          listsAQI.add(values);
                                        }});
                                      if(listsAQI.length<70){
                                        listsPPM = data1;
                                      } else{
                                        listsPPM = listsAQI.map(double.parse).toList().sublist(listsAQI.length-70, listsAQI.length-1);
                                        //masukkan data di model sensor_data
                                        sensorData.ppm = double.parse((listsAQI[listsAQI.length-1]).substring(0, 2));
                                      } return AQI_Chart("Indoor Air Quality",
                                          listsAQI[listsAQI.length-1].substring(0, 3) + "ppm",
                                          "updated every 3 seconds", listsPPM);
                                    } return CircularProgressIndicator();
                                  }),
                              decoration: BoxDecoration( borderRadius: BorderRadius.all(Radius.circular(20))), width: w / 1.04,
                            ),
                          ),
                          //******History Air Quality Graph
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
                                        if(values!="nan") {
                                          listsAQI.add(values);
                                        }});
                                      if(listsAQI.length<70){
                                        listPPM1 = [0.1, 0.1, 0.1];
                                      } else{
                                        average3 = (listsAQI.map(double.parse).toList().sublist(listsAQI.length-60, listsAQI.length-40)
                                            .map((m) => m).reduce((value, element) => value + element))/(20)/300;
                                        average2 = (listsAQI.map(double.parse).toList().sublist(listsAQI.length-40, listsAQI.length-20)
                                            .map((m) => m).reduce((value, element) => value + element))/(20)/300;
                                        average1 = (listsAQI.map(double.parse).toList().sublist(listsAQI.length-20, listsAQI.length-1)
                                            .map((m) => m).reduce((value, element) => value + element))/(20)/300;
                                        print("ini average $average3");
                                        print("average2: $average2");
                                        print("average1: $average1");
                                        listPPM1.replaceRange(0, 3, [average3,average2,average1]);
                                        print("listPPM1 $listPPM1");
                                      }
                                      List<Feature> features = [
                                        Feature(title: "Flutter", color: Colors.yellow, data: listPPM1,
                                        )];
                                      return Stack(
                                        children: [
                                          Container(
                                            child: Text("IAQ History Data", style: TextStyle(color: Colors.yellow, fontSize: 20)),
                                            // child: Column(
                                            //   children: [
                                            //     Text("3DA: ${(average3*300)} ppm", style: TextStyle(color: Colors.yellow, fontSize: 25),),
                                            //     SizedBox(height: 10),
                                            //     Text("2DA: ${average2*300} ppm", style: TextStyle(color: Colors.yellow, fontSize: 25),),
                                            //     SizedBox(height: 10),
                                            //     Text("1DA: ${average1*300} ppm", style: TextStyle(color: Colors.yellow, fontSize: 25),),
                                            //   ],
                                            // ),
                                            alignment: Alignment.topRight,
                                          ),
                                          LineGraph(
                                            features: features, size: Size(350, 350),
                                            labelX: ['3 Days ago', '2 Days ago', '1 Days ago'],
                                            labelY: ['50','100','150','200','250','300'],
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
                          //
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Container(
                              child:   StreamBuilder(
                                  stream: dbRefAQI.onValue,
                                  builder: (context, AsyncSnapshot<Event> snapshot) {
                                    if (snapshot.hasData) {
                                      listsAQI.clear();
                                      DataSnapshot dataValues = snapshot.data.snapshot;
                                      Map<dynamic, dynamic> values = dataValues.value;
                                      values.forEach((key, values) {
                                        if(values!="nan"){
                                          listsAQI.add(values);
                                        }});
                                      if (listsAQI.length < 70) {
                                        listsPPM = data1;
                                      } else {
                                        listsPPM = listsAQI
                                            .map(double.parse)
                                            .toList()
                                            .sublist(listsAQI.length - 70,
                                            listsAQI.length - 1);
                                        //insert data to SensorData Model
                                        sensorData.ppm = double.parse(
                                            (listsAQI[listsAQI.length - 1])
                                                .substring(0, 3));
                                        iaq = sensorData.ppm;
                                        if (double.parse((listsAQI[listsAQI.length - 1])
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
                                          trailing: Text("IAQ"),
                                          leading: Icon(Icons.nature_rounded),
                                          title: Text( (double.tryParse(listsAQI[listsAQI.length - 1].substring(0, 3)) == null)?
                                          "loading..." : listsAQI[listsAQI.length - 1].substring(0, 3)+ "ppm"),
                                        ),
                                      );
                                    }
                                    return CircularProgressIndicator();
                                  }),
                              decoration: BoxDecoration( borderRadius: BorderRadius.all(Radius.circular(20))), width: w / 1.04,
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

// 0.0,
// -2.0,
// 3.5,
// -2.0,
// 0.5,
// 0.7,
// 0.8,
// 1.0,
// 2.0,
// 3.0,
// 3.2
// ];
//
// Material ppmText1(String title, String subtitle) {
//   return Material(
//     color: Color(0xFF2E294E),
//     elevation: 14.0,
//     borderRadius: BorderRadius.circular(24.0),
//     shadowColor: Color(0x802196F3),
//     child: Center(
//       child: Padding(
//         padding: EdgeInsets.all(8.0),
//         child: Container(
//           height: 150,
//           child: Column(
//             mainAxisAlignment: MainAxisAlignment.center,
//             children: <Widget>[
//               Padding(
//                 padding: EdgeInsets.all(8.0),
//                 child: Text(
//                   title,
//                   style: TextStyle(
//                     fontSize: 25.0,
//                     color: Colors.yellow,
//                     //color: Color(0xFFEE964B),
//                   ),
//                 ),
//               ),
//               Padding(
//                 padding: EdgeInsets.all(8.0),
//                 child: Text(
//                   subtitle,
//                   style: TextStyle(fontSize: 30.0, color: Colors.white),
//                 ),
//               ),
//             ],
//           ),
//         ),
//       ),
//     ),
//   );
// }
//
// Material ppmText2(String title, String subtitle) {
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
//                         fontSize: 30.0,
//                         color: Colors.yellow,
//                         // color: Color(0xFFEE964B),
//                         fontWeight: FontWeight.bold),
//                   ),
//                 ),
//                 Padding(
//                   padding: EdgeInsets.all(8.0),
//                   child: Text(
//                     subtitle,
//                     style: TextStyle(fontSize: 30.0, color: Colors.white),
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