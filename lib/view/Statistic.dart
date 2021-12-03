import 'package:crystal/controller/firebaseReferences.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_navigation/src/extension_navigation.dart';



class StatisticPage extends StatefulWidget {
  @override
  State<StatisticPage> createState() => _StatisticPageState();
}

class _StatisticPageState extends State<StatisticPage> {

  FirebaseReference ref = new FirebaseReference();

  List month = ["January", "February", "March", "April",
    "May", "June", "July", "August", "September", "October",
    "November", "December"];


  List<Map<dynamic, dynamic>> listsAQI = [];

  DateTime time = DateTime.now().toLocal();
  List<List<double>> listAverage;
  List<double> resultAverage;


  //For dropdown button
  String dropDownValue = DateTime.now().year.toString();
  bool isTap=false;
  List<String> yearList = [DateTime.now().year.toString()];
  //

  //get time beforeNow
  strDate(int d){
    return time.subtract(Duration(days: d)).toString().substring(0,10);
  }


  @override
  Widget build(BuildContext context) {

    listAverage = [[],[],[],[],[],[],[],[],[],[],[],[]];
    resultAverage = [0,0,0,0,0,0,0,0,0,0,0,0];
    yearList.sort((a,b) => int.tryParse(b).compareTo(int.tryParse(a)));

    return Scaffold(
      appBar: AppBar(title: Text("Statistics of Indoor Air Quality"), backgroundColor: Colors.orangeAccent,),
      body: Container(
        child: Column(
          children: [
            Center(
              child: StreamBuilder(
                  stream: ref.dbRefAQI.onValue,
                  builder: (context, AsyncSnapshot<Event> snapshot) {
                    if(snapshot.hasData){
                      listsAQI.clear();

                      for(int i = 0; i<12; i++){
                        listAverage[i].clear();
                      }
                      DataSnapshot dataValues = snapshot.data.snapshot;
                      Map<dynamic, dynamic> values = dataValues.value;
                      values.forEach((key, values) {
                        if(values["value"]!="nan"){
                          listsAQI.add(values);
                        }});
                      if(listsAQI.length>0){
                        print("length: ${listsAQI.length}");
                        for(final item in listsAQI){
                            if(DateTime.tryParse(item["date"])!=null && double.tryParse(item["value"])<300 &&
                                DateTime.tryParse(item["date"]).year!=1970){
                                yearList.add(DateTime.tryParse(item["date"]).year.toString());
                              for(int i=1; i<=12; i++){
                                if(DateTime.tryParse(item["date"]).year.toString() == dropDownValue &&
                                    DateTime.tryParse(item["date"]).month.toInt() == i) {
                                  try{
                                    var convert = double.tryParse(item["value"]);
                                     listAverage[i-1].add(convert);
                                  } catch(e){
                                    print("average is empty");
                                  }
                                }
                              }
                            }
                        }
                        for(int i=0; i<12; i++){
                          if(listAverage[i].length!=0){
                            double result = double.tryParse((listAverage[i].
                            reduce((a, b) => a+b)/listAverage[i].length).toStringAsFixed(2));
                            resultAverage[i] = result;
                          }
                        }
                      }
                      return Column(
                        children: [
                          DataTable(
                              columns: <DataColumn> [
                                DataColumn(
                                  label: Text(
                                    '$dropDownValue',
                                    style: TextStyle(fontStyle: FontStyle.italic),
                                  ),
                                ),
                                DataColumn(
                                  label: Text(
                                    'PPM value',
                                    style: TextStyle(fontStyle: FontStyle.italic),
                                  ),
                                ),
                              ],
                              rows: <DataRow> [
                                for(int i=0; i<12; i++)
                                  DataRow(
                                    cells: <DataCell>[
                                      DataCell(Text(month[i])),
                                      DataCell(Text(
                                          (resultAverage[i]!=0)?resultAverage[i].toString():"n/a"
                                      )),
                                    ],
                                  ),
                              ]),
                        ],
                      );
                    }return CircularProgressIndicator();
                  }
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                IconButton(
                  hoverColor: Colors.white,
                  splashColor: Colors.orangeAccent,
                  splashRadius: 19,
                    onPressed: (){
                      setState(() {});},
                    icon: Icon(Icons.refresh,size: 20,)),
                SizedBox(width: 20,),
                DropdownButton<String>(
                  icon: const Icon(Icons.arrow_downward),
                  iconSize: 17,
                  elevation: 16,
                  hint: Text("d"),
                  value: dropDownValue,
                  onChanged: (String newValue) {
                    setState(() {
                      dropDownValue = newValue;
                    });

                  },
                  items: yearList.toSet().toList()
                      .map<DropdownMenuItem<String>>((String value) {
                    return  DropdownMenuItem<String> (
                      value: value,
                      child: Text(value),
                    );
                  }).toList(),
                )
              ],
            )
          ],
        ),
      ),
    );
  }

  // DropdownButton<String> buildDropdownButton() {
  //   return
  // }
}





