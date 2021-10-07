import 'package:crystal/authentication_service.dart';
import 'package:crystal/view/Graph.dart';
import 'package:crystal/view/Setting.dart';
import 'package:flutter/material.dart';
import 'package:flutter_sparkline/flutter_sparkline.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';

class Homepage extends StatefulWidget {



  @override
  _HomepageState createState() => _HomepageState();
}

class _HomepageState extends State<Homepage> {
  // final FirebaseAuth _auth = FirebaseAuth.instance;
  // User user;
  //
  // @override
  // void initState() {
  //   // TODO: implement initState
  //   super.initState();
  //   initUser();
  // }
  //
  // initUser() async {
  //   user = await _auth.currentUser;
  //   setState(() {});
  // }



  var data = [0.0, 1.0, 1.5, 2.0, 0.0, 0.0, -0.5, -1.0, -0.5, 0.0, 0.0];
  var data1 = [0.0, -2.0, 3.5, -2.0, 0.5, 0.7, 0.8, 1.0, 2.0, 3.0, 3.2];
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

  Material info(String username) {
    return Material(
      color: Color(0xFF2E294E),
      elevation: 14.0,
      borderRadius: BorderRadius.circular(10.0),
      shadowColor: Color(0xFF820263),
      child: Padding(
        padding: EdgeInsets.all(8.0),
        child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Text(
                    "SignOut",
                    style: TextStyle(color: Color(0xFF70D6FF), fontSize: 15),
                  ),
                  IconButton(
                      color: Colors.white,
                      iconSize: 30,
                      icon: Icon(Icons.logout),
                      onPressed: () {

                      }),
                ],
              ),
              Padding(
                padding: EdgeInsets.all(1.0),
                child: Text(
                  "User: " + username,
                  style: TextStyle(
                    fontSize: 20.0,
                    color: Colors.white,
                  ),
                ),
              ),
              IconButton(
                  color: Colors.white,
                  iconSize: 30,
                  icon: Icon(Icons.settings),
                  onPressed: (){
                    Get.to(() => Setting());
                  })
            ]),
      ),
    );
  }
  
  Material chart1(String title, String priceVal, String subtitle) {
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
                    padding: EdgeInsets.all(1.0),
                    child: Text(
                      title,
                      style: TextStyle(
                        fontSize: 20.0,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFFEE964B),
                      ),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.all(1.0),
                    child: Text(
                      priceVal,
                      style: TextStyle(fontSize: 30.0, color: Colors.white),
                    ),
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
                    height: 15,
                  ),
                  Padding(
                    padding: EdgeInsets.all(5.0),
                    child: new Sparkline(
                      data: data,
                      lineColor: Color(0xffff6101),
                      pointsMode: PointsMode.all,
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

  Material ppmText(String title, String subtitle) {
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
                          fontSize: 20.0,
                          color: Color(0xFFF95738),
                          fontWeight: FontWeight.bold),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.all(8.0),
                    child: Text(
                      subtitle,
                      maxLines: 5,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(fontSize: 15.0, color: Colors.white),
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

  Material ppmText1(String title, String subtitle) {
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
                          fontSize: 20.0,
                          color: Color(0xFFEE964B),
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
                          fontSize: 20.0,
                          color: Color(0xFFEE964B),
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

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      backgroundColor: Colors.white,
      body: Container(
        child: StaggeredGridView.count(
          crossAxisCount: 4,
          mainAxisSpacing: 1,
          crossAxisSpacing: 5,
          children: [
            Padding(
                padding: const EdgeInsets.only(top: 8),
               // child: info("${user?.email}")),
                child: info("username")),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: chart1("LIVE Indoor Air Quality Level", "120ppm",
                  "+12.54 than normal"),
            ),
            // Padding(
            //   padding: const EdgeInsets.all(8.0),
            //   child: Graph(),
            // ),
            // Padding(
            //   padding: const EdgeInsets.all(8.0),
            //   child: Graph2(),
            // ),
            Padding(
              padding: EdgeInsets.all(8),
              child: ppmText("ALERT", notice[3]),
            ),
            Padding(
              padding: EdgeInsets.only(right: 8),
              child: ppmText1("Temperature", "27 ℃"),
            ),
            Padding(
              padding: EdgeInsets.only(right: 8),
              child: ppmText2("Humidity", "27%"),
            ),
          ],
          staggeredTiles: [
            StaggeredTile.extent(4, 250.0),
            StaggeredTile.extent(4, 250.0),

            //    StaggeredTile.extent(4, 250.0),
            StaggeredTile.extent(2, 250.0),
            StaggeredTile.extent(2, 120.0),
            StaggeredTile.extent(2, 120.0),
          ],
        ),
      ),
    );
  }
}
