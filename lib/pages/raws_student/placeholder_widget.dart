import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:graduation_project/utilities/constants.dart';
import 'package:keyboard_visibility/keyboard_visibility.dart';

class HomeWidget extends StatefulWidget {
  @override
  _HomeWidgetState createState() => _HomeWidgetState();
}

class _HomeWidgetState extends State<HomeWidget> {
  TextEditingController _textEditingController = new TextEditingController();

  List<String> _values = new List();
  List<bool> _selected = new List();

  bool keyboardOpen = false;

  @override
  void initState() {
    super.initState();
    KeyboardVisibilityNotification().addNewListener(
      onChange: (bool visible) {
        setState(() => keyboardOpen = visible);
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(50.0),
        child: AppBar(
          backgroundColor: Colors.white,
          elevation: 0.0,
          title: Text(
            'Search Lectures',
            style: TextStyle(color: Colors.black),
          ),
          centerTitle: true,
          iconTheme: IconThemeData(
            color: Colors.black, //change your color here
          ),
        ),
      ),
      backgroundColor: Colors.white,
      body: Padding(
        padding: EdgeInsets.all(10),
        child: Column(
          children: [
            Expanded(
              child: Column(
                children: [
                  Visibility(
                    visible: _values.length > 0 ? true : false,
                    replacement: Container(
                      width: 0,
                      height: 0,
                    ),
                    child: Container(height: 50, child: buildChips()),
                  ),
                  SizedBox(
                    height: 5,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Expanded(
                        flex: 5,
                        child: Container(
                          width: 100,
                          height: 30,
                          child: TextField(
                            textDirection: TextDirection.rtl,
                            decoration: InputDecoration(
                                hintText: 'انقر كلمات مفتاحية ثم ابحث'),
                            controller: _textEditingController,
                          ),
                        ),
                      ),
                      SizedBox(
                        width: 10,
                      ),
                      Expanded(
                        flex: 1,
                        child: Container(
                          width: 30,
                          height: 30,
                          child: IconButton(
                              icon: Icon(Icons.add),
                              onPressed: () {
                                _values.add(_textEditingController.text);
                                _selected.add(true);
                                _textEditingController.clear();

                                setState(() {
                                  _values = _values;
                                  _selected = _selected;
                                });
                              }),
                        ),
                      ),
                      SizedBox(
                        width: 10,
                      ),
                      Expanded(
                        flex: 1,
                        child: Container(
                          width: 30,
                          height: 30,
                          child: IconButton(
                              icon: Icon(Icons.search), onPressed: () {}),
                        ),
                      )
                    ],
                  )
                ],
              ),
            ),
            SizedBox(
              height: 10,
            ),
          ],
        ),
      ),
      floatingActionButton: Visibility(
        visible: MediaQuery.of(context).viewInsets.bottom == 0.0,
        child: FloatingActionButton.extended(
          onPressed: () {
            _displayTextInputDialog(context);
          },
          heroTag: 'join',
          label: const Text('Join'),
          icon: const Icon(
            Icons.person_add,
            color: Colors.white,
          ),
          backgroundColor: primaryLight,
        ),
      ),
    );
  }

  Widget buildChips() {
    List<Widget> chips = new List();

    for (int i = 0; i < _values.length; i++) {
      InputChip actionChip = InputChip(
        //selected: _selected[i],
        label: Text(_values[i]),
        elevation: 10,
        pressElevation: 5,
        onPressed: () {
          setState(() {
            _selected[i] = !_selected[i];
          });
        },
        onDeleted: () {
          _values.removeAt(i);
          _selected.removeAt(i);

          setState(() {
            _values = _values;
            _selected = _selected;
          });
        },
      );

      chips.add(actionChip);
    }

    return ListView.separated(
      separatorBuilder: (BuildContext context, int index) {
        return SizedBox(height: 3);
      },
      shrinkWrap: true,
      // This next line does the trick.
      scrollDirection: Axis.horizontal,
      itemCount: chips.length,

      itemBuilder: (BuildContext context, int index) {
        return chips[index];
      },
    );
  }

  Future<void> _displayTextInputDialog(BuildContext context) async {
    return showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text('الانضمام الي صف'),
            content: TextField(
              onChanged: (value) {
                setState(() {});
              },
              decoration: InputDecoration(
                  hintText: "قم بطلب رمز الصف من المعلم ثم اكتبه"),
            ),
            actions: <Widget>[
              FlatButton(
                color: primaryLight,
                textColor: Colors.white,
                child: Text('انضمام'),
                onPressed: () {
                  setState(() {
                    Navigator.pop(context);
                  });
                },
              ),
            ],
          );
        });
  }
}
