import 'package:crystal/components/temperatureStatus.dart';
import 'package:flutter/material.dart';

class TempStatusText extends StatefulWidget {
  const TempStatusText({
    Key key,
    @required this.temp,
  }) : super(key: key);

  final double temp;

  @override
  State<TempStatusText> createState() => _TempStatusTextState();
}

class _TempStatusTextState extends State<TempStatusText> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text("Temperature Status\n", style: TextStyle(fontSize: 18),),
        Container(
          padding: EdgeInsets.all(10),
          child:TemperatureStatus(value: (widget.temp!=null) ? widget.temp: 100, size: 17),
          decoration: BoxDecoration(
            border: Border.all(
              color: Colors.blue,
            ),
            borderRadius: BorderRadius.all(Radius.circular(20)),
          ),
        ),
      ],
    );
  }
}