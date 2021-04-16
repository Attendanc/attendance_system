import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:graduation_project/utilities/constants.dart';

class CardSelectDepart extends StatefulWidget {
  CardSelectDepart({@required this.icon});

  IconData icon;

  @override
  _CardSelectDepartState createState() => _CardSelectDepartState();
}

class _CardSelectDepartState extends State<CardSelectDepart> {
  String dropdownValue = departments[0];

  @override
  Widget build(BuildContext context) {
    return Card(
        elevation: 5.0,
        child: ListTile(
          leading: Icon(
            widget.icon,
            color: primaryLight,
          ),
          title: DropdownButton<String>(
            isExpanded: true,
            value: dropdownValue,
            icon: Icon(Icons.arrow_drop_down),
            iconSize: 24,
            elevation: 16,
            style: TextStyle(color: primaryLight, fontSize: 18),
            onChanged: (String data) {
              setState(() {
                dropdownValue = data;
              });
            },
            items: departments.map<DropdownMenuItem<String>>((String value) {
              return DropdownMenuItem<String>(
                value: value,
                child: Text(value),
              );
            }).toList(),
          ),
        ));
  }
}
