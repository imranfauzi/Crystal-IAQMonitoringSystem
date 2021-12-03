import 'package:flutter/material.dart';


class BuildDropDownButton extends StatefulWidget {
  BuildDropDownButton({
    this.dropDownValue,
    this.yearList
  });

   String dropDownValue;
   List<String> yearList;

  @override
  _BuildDropDownButtonState createState() => _BuildDropDownButtonState();
}

class _BuildDropDownButtonState extends State<BuildDropDownButton> {
  @override
  Widget build(BuildContext context) {

    widget.dropDownValue = DateTime.now().year.toString();

    return DropdownButton<String>(
      icon: const Icon(Icons.arrow_downward),
      iconSize: 17,
      elevation: 16,
      value: widget.dropDownValue,
      onChanged: (String newValue) {
        setState(() {
          widget.dropDownValue = newValue;
        });
      },
      items: widget.yearList.toSet().toList()
          .map<DropdownMenuItem<String>>((String value) {
        return DropdownMenuItem<String> (
          value: value,
          child: Text(value),
        );
      }).toList(),


    );
  }
}


