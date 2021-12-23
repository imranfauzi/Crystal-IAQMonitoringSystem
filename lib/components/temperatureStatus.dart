import 'package:flutter/material.dart';

class TemperatureStatus extends StatefulWidget {

  const TemperatureStatus({
    Key key,
    @required this.value,
    @required this.size,
  }) : super(key: key);

  final double value;
  final double size;
  @override
  _TemperatureStatusState createState() => _TemperatureStatusState();
}

class _TemperatureStatusState extends State<TemperatureStatus> {
  @override
  Widget build(BuildContext context) {
    {
      if (widget.value >= 23 && widget.value <= 26) {
        return Text("Normal",
          style: TextStyle(fontSize: widget.size, color: Colors.green),);
      }
      if (widget.value > 26) {
        if (widget.value == 100) {
          return Text("Loading...",
            style: TextStyle(fontSize: widget.size, color: Colors.blueAccent),);
        } else {
          return Text("Above Normal",
            style: TextStyle(fontSize: widget.size, color: Colors.orange),);
        }
      }
      if (widget.value < 23) {
        return Text("Below Normal",
          style: TextStyle(fontSize: widget.size, color: Colors.blueAccent),);
      }
    }
  }
}
