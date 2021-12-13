import 'package:flutter/material.dart';


class InformationPage extends StatelessWidget {
  const InformationPage({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var h = MediaQuery.of(context).size.height;
    var w = MediaQuery.of(context).size.width;

    return Scaffold(
      appBar: AppBar(title: Text("Air Quality Information"), backgroundColor: Colors.orangeAccent,),
      body: Container(
        child: Image(
          image: AssetImage('assets/images/stat1.png'),
          height: h,
          width: w,

        ),
      ),
    );
  }
}
