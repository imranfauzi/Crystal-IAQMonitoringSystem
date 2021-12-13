import 'package:crystal/controller/firebaseReferences.dart';
import 'package:crystal/controller/pdf_api.dart';
import 'package:crystal/model/stat.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:open_file/open_file.dart';


class StatisticPage extends StatefulWidget {
  @override
  State<StatisticPage> createState() => _StatisticPageState();
}

class _StatisticPageState extends State<StatisticPage> {

  FirebaseReference ref = new FirebaseReference();

  List month = ["Jan", "Feb", "Mar", "Apr",
    "May", "Jun", "July", "Aug", "Sept", "Oct",
    "Nov", "Dec", "Average"];


  List<Map<dynamic, dynamic>> listsAQI = [];

  DateTime time = DateTime.now().toLocal();
  List<List<double>> listAverage;
  List<double> resultAverage;
  List<String> resultStatus;

  double totalYear = 0;
  int count; //count avgPPM that is not '0'

  Stat stat = Stat();

  //For dropdown button
  String dropDownValue = DateTime.now().year.toString();
  bool isTap=false;
  List<String> yearList = [DateTime.now().year.toString()];



  //status
  var iaqStatus = [
    "Good Air Quality",
    "Moderate Air Quality",
    "Unhealthy Air Quality",
    "Very Unhealthy Air Quality",
    "Hazardous Air Quality"
  ];

  //Status Icon
  Widget status(double data, IconData icon, Function pressed) {
    if(data==0)
      return Text("n/a");
    if(data<51)
      return IconButton(onPressed: pressed, icon: Icon(icon, color: Colors.blue,));
      // return Icon(icon,color: Colors.blue,);
    if(data>=51 && data<101)
      return IconButton(onPressed: pressed, icon: Icon(icon, color: Colors.green,));
    if(data>=101 && data<201)
      return IconButton(onPressed: pressed, icon: Icon(icon, color: Colors.yellow,));
    if(data>=201 && data<301)
      return IconButton(onPressed: pressed, icon: Icon(icon, color: Colors.orange));
    if(data>301)
      return IconButton(onPressed: pressed, icon: Icon(icon, color: Colors.red,));
  }

  //Status list
  statusList(List data, List result) {
    for (int i = 0; i < 13; i++) {
      if (data[i] == 0)
        result[i] = "n/a";
      if (data[i] >= 1 && data[i] < 51)
        result[i] = "Good Air Quality";
      if (data[i] >= 51 && data[i] < 101)
        result[i] = "Moderate Air Quality";
      if (data[i] >= 101 && data[i] < 201)
        result[i] = "Unhealthy Air Quality";
      if (data[i] >= 201 && data[i] < 301)
        result[i] = "Very Unhealthy Air Quality";
      if (data[i] > 301)
        result[i] = "Hazardous Air Quality";
    }
  }

  //show indoor air quality status list
  Future<void> _showMyDialog() async {
    return showDialog<void>(
      context: context,
      barrierDismissible: true, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(32.0))),
          title: const Text('Indoor Air Quality Status'),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Row(
                  children: [
                    Icon(Icons.album_rounded, color: Colors.blue,),
                    SizedBox(width: 10,),
                    Text("Good")
                  ],
                ),
                SizedBox(height: 10,),
                Row(
                  children: [
                    Icon(Icons.album_rounded, color: Colors.green,),
                    SizedBox(width: 10,),
                    Text("Moderate")
                  ],
                ),
                SizedBox(height: 10,),
                Row(
                  children: [
                    Icon(Icons.album_rounded, color: Colors.yellow,),
                    SizedBox(width: 10,),
                    Text("Unhealthy")
                  ],
                ),
                SizedBox(height: 10,),
                Row(
                  children: [
                    Icon(Icons.album_rounded, color: Colors.orange,),
                    SizedBox(width: 10,),
                    Text("Very Unhealthy")
                  ],
                ),
                SizedBox(height: 10,),
                Row(
                  children: [
                    Icon(Icons.album_rounded, color: Colors.red,),
                    SizedBox(width: 10,),
                    Text("Hazardous")
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  //open generated pdf
  Future onSubmit() async {
    showDialog(
        barrierDismissible: false,
        context: context,
        builder: (context) => Center(child: CircularProgressIndicator())
    );

  final file = await PdfApi().generatePDF(stat: stat);
  print(file.path);

  Navigator.of(context).pop();
  await OpenFile.open(file.path);

}

@override
  void initState() {
    // TODO: implement initState
    super.initState();
    count = 0;
  }


  @override
  Widget build(BuildContext context) {

    listAverage = [[],[],[],[],[],[],[],[],[],[],[],[], []];
    resultAverage = [0,0,0,0,0,0,0,0,0,0,0,0,0];

    resultStatus = ["","","","","","","","","","","","",""];
    yearList.sort((a,b) => int.tryParse(b).compareTo(int.tryParse(a)));

    stat.avgPPM = resultAverage;
    stat.avgStatus = resultStatus;
    stat.currentYear = dropDownValue;
    stat.avgYear = totalYear;



    var h = MediaQuery.of(context).size.height;

    return Scaffold(
      appBar: AppBar(
        title: Text("Statistics of IAQ"),
        backgroundColor: Colors.orangeAccent,
        actions: [
          IconButton(
              // onPressed: () {Get.to(InformationPage(), transition: Transition.rightToLeftWithFade);},
              // icon: Icon(Icons.info_outlined)
            onPressed: () async {onSubmit();},
            icon: Icon(Icons.save),
          )
        ], ),
      body: Container(
        height: h,
        child: ListView(
          children: [
            Center(
              child: StreamBuilder(
                  stream: ref.dbRefAQI.onValue,
                  builder: (context, AsyncSnapshot<Event> snapshot) {
                    if(snapshot.hasData){
                      listsAQI.clear();
                      count=0;
                      totalYear=0;
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
                            if(DateTime.tryParse(item["date"])!=null && double.tryParse(item["value"])<1000 &&
                                DateTime.tryParse(item["date"]).year!=1970){
                                yearList.add(DateTime.tryParse(item["date"]).year.toString());
                              for(int i=1; i<=12; i++){
                                if(DateTime.tryParse(item["date"]).year.toString() == dropDownValue &&
                                    DateTime.tryParse(item["date"]).month.toInt() == i) {
                                  try{
                                    var convert = double.tryParse(item["value"]);
                                     listAverage[i-1].add(convert);
                                  } catch(e){
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
                            if(result!=0){
                              count++;
                              totalYear = totalYear+ result;
                            }

                          }
                        }
                        resultAverage[12] = double.tryParse((totalYear/count).toStringAsFixed(2));
                        statusList(resultAverage, resultStatus);
                        print("count: $count");

                      }
                      return Expanded(
                        child: Column(
                          children: [
                            Column(
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
                                          'PPM Average',
                                          style: TextStyle(fontStyle: FontStyle.italic),
                                        ),
                                      ),
                                      DataColumn(
                                        label: Text(
                                          'Status',
                                          style: TextStyle(fontStyle: FontStyle.italic),
                                        ),
                                      ),
                                    ],
                                    rows: <DataRow> [
                                      for(int i=0; i<13; i++)
                                        DataRow(
                                          cells: <DataCell>[
                                            DataCell(Text(month[i])),
                                            DataCell(Text(
                                                (resultAverage[i]!=0)?resultAverage[i].toString():"n/a"
                                            )),
                                            DataCell(status(resultAverage[i], Icons.album_rounded, (){
                                              _showMyDialog();
                                            })),
                                          ],
                                        ),
                                    ]
                                ),
                              ],
                            ),
                          ],
                        ),
                      );
                    }return CircularProgressIndicator();
                  }
              ),
            ),
            Expanded(
              child: Row(
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
                      return DropdownMenuItem<String> (
                        value: value,
                        child: Text(value),
                      );
                    }).toList(),
                  )
                ],
              ),
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





