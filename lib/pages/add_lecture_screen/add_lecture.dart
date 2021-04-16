import 'package:flutter/material.dart';
import 'package:graduation_project/pages/add_lecture_screen/components/rounded_widget.dart';
import 'package:graduation_project/pages/departments_screen/depatment.dart';
import 'package:graduation_project/provider/lecture_provider.dart';
import 'package:graduation_project/utilities/constants.dart';
import 'package:provider/provider.dart';

/**
 * creted by shaimaa salama
 */
class AddLectureScreen extends StatefulWidget {
  static String routeName = "/all_lecture";

  @override
  _AddLectureScreenState createState() => _AddLectureScreenState();
}

class _AddLectureScreenState extends State<AddLectureScreen> {
  String initialDepartment = departments[0];
  String initialSection = arch_classes[0];
  List<String> sections = arch_classes;

  DateTime currentDate = DateTime.now();

  final timeController = TextEditingController();
  final dateController = TextEditingController();
  final nameController = TextEditingController();
  String nameValue;

  Future<void> onSubmit() async {
    print("submit store lecture at lecturers============");

    if (dateController == null || timeController == null || nameValue.isEmpty) {
      print("fields are empty");

      _showMyDialog('Empty Fields');
    } else if (dateController != null &&
        timeController != null &&
        nameValue.isNotEmpty) {
      print("fields not empty");

      var result = await Provider.of<LectureProvider>(context, listen: false)
          .storeLectures(initialDepartment, initialSection, nameValue,
              dateController.text, timeController.text);

      if (result['success'] == true) {
        print("store lecture success");

        Navigator.pushNamed(context, DepartmentScreen.routeName);
      } else {
        print("store lecture failed");

        _showMyDialog(result['error'].toString() + " ");
      }
    }
  }

  Future<void> _showMyDialog(String error) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Notice'),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Text(error),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: Text('Cancel'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    bool visible = true;

    // function to select date
    Future<void> _selectTime(BuildContext context) async {
      var time = await showTimePicker(
        initialTime: TimeOfDay.now(),
        context: context,
      );
      timeController.text = time.format(context);
    }

    //function to select date
    Future<void> _selectDate(BuildContext context) async {
      final DateTime date = await showDatePicker(
          context: context,
          initialDate: currentDate,
          firstDate: DateTime(2015),
          lastDate: DateTime(2050));
      if (date != null && date != currentDate)
        dateController.text = "${date.day}/ ${date.month} / ${date.year}";
    }

    @override
    void dispose() {
      // Clean up the controller when the widget is removed
      timeController.dispose();
      dateController.dispose();
      nameController.dispose();

      super.dispose();
    }

    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: SingleChildScrollView(
        child: Container(
          margin: EdgeInsets.all(16),
          child: Column(
            children: [
              SizedBox(
                height: 50,
              ),
              Text(
                'Add Lecture',
                style: TextStyle(fontSize: 20, color: primaryDark),
              ),
              SizedBox(
                height: 50,
              ),
              TextField(
                decoration: InputDecoration(
                  labelText: 'Lecture Name',
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
              RoundedWidget(
                icon: Icons.circle,
                child: DropdownButton<String>(
                  isExpanded: true,
                  value: initialDepartment,
                  icon: Icon(Icons.arrow_drop_down),
                  iconSize: 24,
                  elevation: 16,
                  style: TextStyle(color: Colors.black, fontSize: 18),
                  onChanged: (String data) {
                    setState(() {
                      initialDepartment = data;
                      if (initialDepartment == departments[0]) {
                        sections = arch_classes;
                        initialSection = arch_classes[0];
                      } else if (initialDepartment == departments[1]) {
                        sections = electric_classes;
                        initialSection = electric_classes[0];
                      } else if (initialDepartment == departments[2]) {
                        sections = computer_classes;
                        initialSection = computer_classes[0];
                      } else if (initialDepartment == departments[3]) {
                        sections = takteet_classes;
                        initialSection = takteet_classes[0];
                      } else {
                        visible = false;
                        initialSection = "";
                        sections = [];
                      }
                    });
                  },
                  items:
                      departments.map<DropdownMenuItem<String>>((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(value),
                    );
                  }).toList(),
                ),
              ),
              SizedBox(
                height: 10,
              ),
              Visibility(
                visible: visible,
                child: RoundedWidget(
                  icon: Icons.perm_contact_cal_outlined,
                  child: DropdownButton<String>(
                    isExpanded: true,
                    value: initialSection,
                    icon: Icon(Icons.arrow_drop_down),
                    iconSize: 24,
                    elevation: 16,
                    style: TextStyle(color: Colors.black, fontSize: 18),
                    onChanged: (String data) {
                      setState(() {
                        initialSection = data;
                      });
                    },
                    items:
                        sections.map<DropdownMenuItem<String>>((String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Text(value),
                      );
                    }).toList(),
                  ),
                ),
              ),
              SizedBox(
                height: 10,
              ),
              RoundedWidget(
                  icon: Icons.timelapse,
                  child: TextField(
                    readOnly: true,
                    controller: timeController,
                    decoration: InputDecoration(
                        hintText: 'Pick your Time', labelText: 'select time'),
                    onTap: () async {
                      _selectTime(context);
                    },
                  )),
              SizedBox(
                height: 20,
              ),
              RoundedWidget(
                  icon: Icons.date_range_outlined,
                  child: TextField(
                    readOnly: true,
                    controller: dateController,
                    decoration: InputDecoration(
                        hintText: 'Pick your Date', labelText: 'select date'),
                    onTap: () async {
                      _selectDate(context);
                    },
                  )),
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
                  borderRadius: BorderRadius.circular(12),
                ),
                child: FlatButton(
                    color: primaryLight,
                    textColor: Colors.white,
                    onPressed: () {
                      onSubmit();
                    },
                    child: Text(
                      'ADD Lecture',
                      style: TextStyle(fontSize: 25.0),
                    )),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
