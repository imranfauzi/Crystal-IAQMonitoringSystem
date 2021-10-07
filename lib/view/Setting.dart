import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'Homepage.dart';

class Setting extends StatefulWidget {
  @override
  _SettingState createState() => _SettingState();
}

class _SettingState extends State<Setting> {


  @override
  Widget build(BuildContext context) {

    Size sizes = MediaQuery.of(context).size;


    return Scaffold(


      body: SafeArea(
        child: Column(
          children: [
            SizedBox(height: 7,),
            Row(
              children: [
                IconButton(icon: Icon(Icons.arrow_back), onPressed: (){
                  Get.to(() =>Homepage());
                }),
                Text("Settings", style: TextStyle(fontSize: 20, fontWeight: FontWeight.w500),),

              ],
            ),
            SizedBox(height: 20,),
            ListTile(
              leading: Icon(Icons.info),
              title: Text("Version 1.0.0", style: TextStyle(fontSize: 16)),
            ),
            Divider(),
            ListTile(
              leading: Icon(Icons.email),
              title: Text("m.imran.fauzi@gmail.com", style: TextStyle(fontSize: 16)),
            ),
            Divider(),
            ListTile(
              leading: Icon(Icons.insert_drive_file),
              title: Text("About Developer", style: TextStyle(fontSize: 16)),
              subtitle: Text("Follow our Instagram 'blackcoffee' for more information"),
            ),
            Divider(),
            SizedBox(height: 10,),
            Center(child: Text("Export 3 Days Report", style: TextStyle(fontSize: 16),),),
            SizedBox(height: 10,),
            IconButton(
                iconSize: 40,
                icon: Icon(Icons.arrow_circle_down),
                onPressed: (){})
          ],
        ),
      ),
    );
  }
}
// if(controller.isDark){
// Get.changeTheme(ThemeData.dark());
// _riveArtboard.removeController(_controller);
// _riveArtboard.addController(_controller = SimpleAnimation('toDark'));
// }else {
// Get.changeTheme(ThemeData.light());
// _riveArtboard.removeController(_controller);
// _riveArtboard.addController(_controller = SimpleAnimation('toLight'));
// }