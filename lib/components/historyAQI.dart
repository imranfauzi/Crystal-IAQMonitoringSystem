import 'package:crystal/model/historygraphdata.dart';
import 'package:draw_graph/draw_graph.dart';
import 'package:draw_graph/models/feature.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'dart:core';

import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:syncfusion_flutter_core/theme.dart';

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
  TooltipBehavior _tooltipBehavior;
  DateTime time = DateTime.now().toLocal();
  List<Map<dynamic, dynamic>> listsAQI1 = [];

  //to store aqi value for aqi history graph
  List<double> listsPPM1 = [0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0];
  List<dynamic> average_1 = [], average_2 = [], average_3 = [],
      average_4 = [],average_5 = [],average_6 = [],average_7 = [];
  double resultaverage_1, resultaverage_2, resultaverage_3,
      resultaverage_4, resultaverage_5, resultaverage_6, resultaverage_7;

  //get time beforeNow
  strDate(int d) {
    return time.subtract(Duration(days: d)).toString().substring(5, 10);
  }

  //sanitize by date
  void sortingByDay(Map<dynamic, dynamic> item, int day, List<dynamic> list) {
    if (DateTime.tryParse(item["date"]).year ==
            time.subtract(Duration(days: day)).year &&
        DateTime.tryParse(item["date"]).month ==
            time.subtract(Duration(days: day)).month &&
        DateTime.tryParse(item["date"]).day ==
            time.subtract(Duration(days: day)).day) {
      try {
        double convert = double.tryParse(item["value"]);
        list.add(convert);
      } catch (e) {
        print("average $day is empty");
      }
    }
  }

  calculateAverage(List<dynamic> list, double result) {
    if (list.length != 0) {
        result = double.tryParse(
            (list.reduce((a, b) => a + b) / list.length)
                .toStringAsFixed(2));
        if(result>1000){
          result = 1000.00;
          return result.toInt().toDouble();
        } else {
          return result.toInt().toDouble();
        }
    } else {
      result = 0;
      return result;
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    listsPPM1 = [0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0];
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(1.0),
      child: Container(
        padding: EdgeInsets.all(15),
        child: StreamBuilder(
            stream: widget.dbRefAQI.onValue,
            builder: (context, AsyncSnapshot<Event> snapshot) {
              if (snapshot.hasData) {
                 listsAQI1.clear();
                DataSnapshot dataValues = snapshot.data.snapshot;
                Map<dynamic, dynamic> values = dataValues.value;
                values.forEach((key, values) {
                  if (values["value"] != "nan") {
                    listsAQI1.add(values);
                  }
                });
                if (listsAQI1.length > 0) {
                  /*For sorting all values based on date*/
                  for (final item in listsAQI1) {
                    if (DateTime.tryParse(item["date"]) != null && double.tryParse(item["value"])<1001) {
                      sortingByDay(item, 1, average_1);
                      sortingByDay(item, 2, average_2);
                      sortingByDay(item, 3, average_3);
                      sortingByDay(item, 4, average_4);
                      sortingByDay(item, 5, average_5);
                      sortingByDay(item, 6, average_6);
                      sortingByDay(item, 7, average_7);
                    }
                  }
                  listsPPM1.replaceRange(0, 7, [
                    calculateAverage(average_7, resultaverage_7),
                    calculateAverage(average_6, resultaverage_6),
                    calculateAverage(average_5, resultaverage_5),
                    calculateAverage(average_4, resultaverage_4),
                    calculateAverage(average_3, resultaverage_3),
                    calculateAverage(average_2, resultaverage_2),
                    calculateAverage(average_1, resultaverage_1)
                  ]);
                }
                return Stack(children: [
                  Container(
                    child: Text("PPM",
                        style: TextStyle(color: Colors.yellow, fontSize: 15)),
                    alignment: Alignment.topLeft,
                  ),
                  SfChartTheme(
                    data: SfChartThemeData(
                        brightness: Brightness.dark,
                        axisLineColor: Colors.white,
                        majorGridLineColor: Colors.white30,
                        backgroundColor: Color(0xFF2E294E)),
                    child: SfCartesianChart(
                      primaryXAxis: CategoryAxis(isVisible: true),
                      title: ChartTitle(
                          text: "Week IAQ History",
                          textStyle: TextStyle(color: Colors.yellow,)),
                      legend: Legend(
                          isVisible: true,),
                      //plotAreaBackgroundColor: Colors.white,
                      backgroundColor: Color(0xFF2E294E),
                      tooltipBehavior: _tooltipBehavior,
                      series: <LineSeries<SalesData, String>>[
                        LineSeries<SalesData, String>(
                            color: Colors.amber,
                            name: "PPM average",
                            xAxisName: "day",
                            yAxisName: "value",
                            dataSource: <SalesData>[
                                SalesData(strDate(7), listsPPM1[0]),
                                SalesData(strDate(6), listsPPM1[1]),
                                SalesData(strDate(5), listsPPM1[2]),
                                SalesData(strDate(4), listsPPM1[3]),
                                SalesData(strDate(3), listsPPM1[4]),
                                SalesData(strDate(2), listsPPM1[5]),
                                SalesData(strDate(1), listsPPM1[6])
                            ],
                            xValueMapper: (SalesData sales, _) => sales.year,
                            yValueMapper: (SalesData sales, _) => sales.sales,
                            // Enable data label
                            dataLabelSettings:
                                DataLabelSettings(isVisible: true))
                      ],
                    ),
                  )
                ]);
              }
              return CircularProgressIndicator();
            }),
        decoration: BoxDecoration(
            color: Color(0xFF2E294E),
            borderRadius: BorderRadius.all(Radius.circular(20))),
        width: widget.w / 1.1,
      ),
    );
  }
}

//
