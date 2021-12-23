import 'package:flutter/material.dart';

class IAQStatus extends StatefulWidget {
  const IAQStatus({
    Key key,
    @required this.iaqStatus,
    @required this.value,
    @required this.size,
  }) : super(key: key);

  final List<String> iaqStatus;
  final double value;
  final double size;
  @override
  State<IAQStatus> createState() => _IAQStatusState();
}

class _IAQStatusState extends State<IAQStatus> {
  @override
  Widget build(BuildContext context) {
    if(widget.value<51){
      return Text(widget.iaqStatus[0], style: TextStyle(fontSize: widget.size, color: Colors.blueAccent, ),textAlign: TextAlign.center);
    }
    if(widget.value>=51 && widget.value<101){
      return Text(widget.iaqStatus[1], style: TextStyle(fontSize: widget.size, color: Colors.green),textAlign: TextAlign.center,);
    }
    if(widget.value>=101 && widget.value<201){
      return Text(widget.iaqStatus[2], style: TextStyle(fontSize: widget.size, color: Colors.amber),textAlign: TextAlign.center);
    }
    if(widget.value>=201 && widget.value<301){
      return Text(widget.iaqStatus[2], style: TextStyle(fontSize: widget.size, color: Colors.orange),textAlign: TextAlign.center);
    } else{
      if(widget.value==1000){
        return Text("Loading...", style: TextStyle(fontSize: widget.size, color: Colors.blue),textAlign: TextAlign.center);
      } else {
        return Text(widget.iaqStatus[3], style: TextStyle(fontSize: widget.size, color: Colors.red),textAlign: TextAlign.center);
      }
    }
  }
}


