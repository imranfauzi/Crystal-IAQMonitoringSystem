import 'package:draw_graph/draw_graph.dart';
import 'package:draw_graph/models/feature.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'dart:core';

class HistoryAQI extends StatefulWidget {
  const HistoryAQI({
    Key key,
    @required this.dbRefAQI,
    @required this.w,
  }) : super(key: key);

  final DatabaseReference dbRefAQI;
  final double w;

  @override
  State<HistoryAQI> createState() => _HistoryAQIState();
}

class _HistoryAQIState extends State<HistoryAQI> {


  DateTime time = DateTime.now().toLocal();
  List<Map<dynamic, dynamic>> listsAQI1 = [];
  //to store aqi value for aqi history graph
  List<double> listsPPM1 = [0,0,0];
  List<dynamic> average_1 = [], average_2 = [], average_3 = [];
  double resultaverage_1, resultaverage_2, resultaverage_3;

  //get time beforeNow
  strDate(int d){
    return time.subtract(Duration(days: d)).toString().substring(0,10);
  }
  //sanitize by date
  void sortingByDay(Map<dynamic, dynamic> item, int day, List<dynamic> list){
    if(DateTime.tryParse(item["date"]).year == time.subtract(Duration(days: day)).year &&
        DateTime.tryParse(item["date"]).month == time.subtract(Duration(days: day)).month &&
        DateTime.tryParse(item["date"]).day == time.subtract(Duration(days: day)).day)
    {
      try{
        var convert = double.tryParse(item["value"]);
        list.add(convert);
      } catch(e){
        print("average $day is empty");
      }
    }
  }
  //calculate the average
  calculateAverage(List<dynamic> list, var result) {
    if(list.length!=0){
      result = double.tryParse((list.reduce((a,b) => a+b)/list.length/300).toStringAsFixed(2));
      if(result<=1.0) {
        return result;
      }else {
        return result = 1.0;
      }
    } else {
      return result = 0.0;
    }
  }


  @override
  Widget build(BuildContext context) {
    
    
    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: Container(
        padding: EdgeInsets.all(20),
        child: StreamBuilder(
            stream: widget.dbRefAQI.onValue,
            builder: (context, AsyncSnapshot<Event> snapshot) {
              if (snapshot.hasData) {
                listsAQI1.clear();
                DataSnapshot dataValues = snapshot.data.snapshot;
                Map<dynamic, dynamic> values = dataValues.value;
                values.forEach((key, values) {
                  if(values["value"]!="nan") {
                    listsAQI1.add(values);
                  }});
                if(listsAQI1.length>0){
                    /*For sorting all values based on date*/
                    for(final item in listsAQI1){
                      if(DateTime.tryParse(item["date"])!=null && double.tryParse(item["value"])<300){
                       sortingByDay(item, 1, average_1);
                       sortingByDay(item, 2, average_2);
                       sortingByDay(item, 3, average_3);
                      }
                    }
                  listsPPM1.replaceRange(0, 3, [
                    calculateAverage(average_3, resultaverage_3),
                    calculateAverage(average_2, resultaverage_2),
                    calculateAverage(average_1, resultaverage_1)]);
                    print("ini listsPPM1: $listsPPM1");
                }
                List<Feature> features = [
                  Feature(title: "Flutter", color: Colors.yellow, data: listsPPM1)];
                return Stack(
                  children: [
                    Container(
                      child: Text("PPM", style: TextStyle(color: Colors.yellow, fontSize: 15)),
                      alignment: Alignment.topLeft,
                    ),
                    Container(
                      child: Text("IAQ History Data", style: TextStyle(color: Colors.yellow, fontSize: 20)),
                      alignment: Alignment.topRight,
                    ),
                    LineGraph(
                      features: features, size: Size(350, 350),
                      labelX: [strDate(3), strDate(2), strDate(1)],
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
        width: widget.w / 1.1,
      ),
    );
  }
}

//
