import 'package:crystal/components/iaqStatus.dart';
import 'package:crystal/model/sensor_data.dart';
import 'package:flutter/material.dart';

class IAQStatusText extends StatefulWidget {
  const IAQStatusText({
    Key key,
    @required this.sensorData,
  }) : super(key: key);
  final SensorData sensorData;
  @override
  State<IAQStatusText> createState() => _IAQStatusTextState();
}
class _IAQStatusTextState extends State<IAQStatusText> {
  var iaqStatus = [ "Good Air Quality", "Moderate Air Quality",
    "Unhealthy Air Quality",
    "Very Unhealthy Air Quality",
    "Hazardous Air Quality"
  ];
  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Text("IAQ Status\n", style: TextStyle(fontSize: 18),),
        Container(
            padding: EdgeInsets.all(10),
            decoration: BoxDecoration(
              border: Border.all(
                color: Colors.green,
              ),
              borderRadius: BorderRadius.all(Radius.circular(20)),
            ),
            child: IAQStatus(iaqStatus: iaqStatus, value: (widget.sensorData.ppm!=null) ?
            widget.sensorData.ppm: 1000, size: 17)),
      ],
    );
  }
}


