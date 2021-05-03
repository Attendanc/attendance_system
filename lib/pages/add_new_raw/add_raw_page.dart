import 'package:flutter/material.dart';
import 'package:graduation_project/pages/add_lecture_screen/components/rounded_widget.dart';
import 'package:graduation_project/utilities/constants.dart';

class AddNewRawScreen extends StatefulWidget {
  @override
  _AddNewRawScreenState createState() => _AddNewRawScreenState();
}

class _AddNewRawScreenState extends State<AddNewRawScreen> {
  DateTime currentDate = DateTime.now();

  final timeController = TextEditingController();
  final dateController = TextEditingController();
  final nameController = TextEditingController();

  String nameValue;
  String timeValue;
  String dateValue;

  String initialDate = "ساعة";
  List<String> times = ["ساعة", "دقيقة"];

  bool isExpanded = false;

  @override
  Widget build(BuildContext context) {
    dateValue = "";
    timeValue = "";

    // function to select date
    Future<void> _selectTime(BuildContext context) async {
      var time = await showTimePicker(
        initialTime: TimeOfDay.now(),
        context: context,
      );
      setState(() {
        timeValue = time.format(context);
      });
    }

    //function to select date
    Future<void> _selectDate(BuildContext context) async {
      final DateTime date = await showDatePicker(
          context: context,
          initialDate: currentDate,
          firstDate: DateTime(2015),
          lastDate: DateTime(2050));
      if (date != null && date != currentDate) {
        setState(() {
          dateValue = "${date.day}/ ${date.month} / ${date.year}";
        });
      }
    }

    return Scaffold(
      backgroundColor: Colors.white,
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        elevation: 0.0,
        backgroundColor: Colors.white,
        iconTheme: IconThemeData(
          color: Colors.black, //change your color here
        ),
        title: Text(
          "Add Lecture",
          style: TextStyle(color: Colors.black),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Container(
          color: Colors.white,
          margin: EdgeInsets.all(16),
          child: Column(
            children: [
              TextField(
                decoration: new InputDecoration(
                    labelText: 'اسم المحاضرة',
                    border: OutlineInputBorder(),
                    prefixIcon: Icon(
                      Icons.book,
                      color: primaryLight,
                    ),
                    enabledBorder: const OutlineInputBorder(
                      borderSide:
                          const BorderSide(color: Colors.grey, width: 1.0),
                    )),
                onChanged: (value) {
                  nameValue = value;
                },
              ),
              SizedBox(
                height: 10,
              ),
              TextField(
                decoration: InputDecoration(
                  labelText: 'اسم القسم',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(
                    Icons.book,
                    color: primaryLight,
                  ),
                ),
                onChanged: (value) {
                  nameValue = value;
                },
              ),
              SizedBox(
                height: 10,
              ),
              TextField(
                decoration: InputDecoration(
                  labelText: 'اسم الصف',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(
                    Icons.book,
                    color: primaryLight,
                  ),
                ),
                onChanged: (value) {
                  nameValue = value;
                },
              ),
              SizedBox(
                height: 10,
              ),
              TextField(
                decoration: InputDecoration(
                  labelText: 'الموضوع',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(
                    Icons.book,
                    color: primaryLight,
                  ),
                ),
                onChanged: (value) {
                  nameValue = value;
                },
              ),
              SizedBox(
                height: 10,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Flexible(
                      child: FloatingActionButton.extended(
                          backgroundColor: primaryLight,
                          onPressed: () {
                            _selectDate(context);
                          },
                          icon: Icon(Icons.date_range),
                          label: Text(
                              dateValue != "" ? dateValue : "اضافة التاريخ"))),
                  SizedBox(
                    width: 20,
                  ),
                  Flexible(
                      child: FloatingActionButton.extended(
                          backgroundColor: primaryLight,
                          onPressed: () {
                            _selectTime(context);
                          },
                          icon: Icon(Icons.timelapse),
                          label: Text(timeValue != ""
                              ? timeValue.toString()
                              : "اضافة الوقت"))),
                ],
              ),
              SizedBox(
                height: 20,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Flexible(
                    child: TextField(
                      decoration: InputDecoration(
                        labelText: 'الوقت المسموح بعد دخول المحاضر',
                        border: OutlineInputBorder(),
                        prefixIcon: Icon(
                          Icons.timelapse,
                          color: primaryLight,
                        ),
                      ),
                      onChanged: (value) {},
                    ),
                  ),
                  SizedBox(
                    width: 10,
                  ),
                  Flexible(child: TimeDropDown())
                ],
              ),
              SizedBox(
                height: 20,
              ),
              Container(
                width: MediaQuery.of(context).size.width,
                margin: EdgeInsets.all(15.0),
                decoration: BoxDecoration(
                  color: primaryLight,
                  border: Border.all(
                    color: primaryLight,
                    width: 2,
                  ),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: FlatButton(
                    color: primaryLight,
                    textColor: Colors.white,
                    onPressed: () {
                      // add new raw---==---
                    },
                    child: Text(
                      'ADD Lecture',
                      style: TextStyle(fontSize: 17.0),
                    )),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget TimeDropDown() {
    return DropdownButton<String>(
      isExpanded: true,
      value: initialDate,
      icon: Icon(Icons.arrow_drop_down),
      iconSize: 24,
      elevation: 16,
      style: TextStyle(color: primaryLight, fontSize: 18),
      onChanged: (String data) {
        setState(() {
          initialDate = data;
        });
      },
      items: times.map<DropdownMenuItem<String>>((String value) {
        return DropdownMenuItem<String>(
          value: value,
          child: Text(value),
        );
      }).toList(),
    );
  }
}
