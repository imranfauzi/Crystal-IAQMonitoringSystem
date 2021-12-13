import 'package:crystal/model/sensor_data.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter_sparkline/flutter_sparkline.dart';


class RealtimeAQI extends StatefulWidget {
  const RealtimeAQI({
    Key key,
    @required this.dbRefAQI,
    @required this.w
  }) : super(key: key);


  final DatabaseReference dbRefAQI;
  final double w;

  @override
  State<RealtimeAQI> createState() => _RealtimeAQIState();
}

class _RealtimeAQIState extends State<RealtimeAQI> {

  List<double> data1 = [0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0 ];
  List<double> listsAQI2 = [];
  List<double> listsPPM2 = [];

  SensorData sensorData = new SensorData();
  Material AQI_Chart(String title, String val, String subtitle, List data) {
    return Material(
      color: Color(0xFF2E294E),
      elevation: 14.0,
      borderRadius: BorderRadius.circular(24.0),
      shadowColor: Color(0x802196F3),
      child: Center(
        child: Padding(
          padding: EdgeInsets.all(8.0),
          child: ListView(
            children: [
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
                    child: Text(val,
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

  @override
  Widget build(BuildContext context) {
    return Padding(
    padding: const EdgeInsets.all(8.0),
    child: Container(
      child: StreamBuilder(
          stream: widget.dbRefAQI.onValue,
          builder: (context, AsyncSnapshot<Event> snapshot) {
            if (snapshot.hasData) {
              listsAQI2.clear();
              DataSnapshot dataValues = snapshot.data.snapshot;
              Map<dynamic, dynamic> values = dataValues.value;

              values.forEach((key, values) {
                if(values["value"]!="nan"){
                  listsAQI2.add(double.tryParse(values["value"]));
                }});
              if (listsAQI2.length < 70) {
                listsPPM2 = data1;
              } else {
                listsPPM2 = listsAQI2.sublist(listsAQI2.length-70, listsAQI2.length-1);
                sensorData.ppm = double.parse((listsAQI2[listsAQI2.length-1]).toString().substring(0, 2));
              }
              return AQI_Chart("Indoor Air Quality",
                  double.tryParse(listsAQI2[listsAQI2.length-1].toString().substring(0, 5)).toString() + " ppm",
                  "updated every 3 seconds", listsPPM2);
            } return CircularProgressIndicator();
          }),
      decoration: BoxDecoration( borderRadius: BorderRadius.all(Radius.circular(20))), width: widget.w / 1.04,
    ),
  );
  }
}