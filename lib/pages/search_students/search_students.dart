import 'package:flutter/material.dart';
import 'package:graduation_project/model/Student.dart';
import 'package:graduation_project/provider/student_provider.dart';
import 'package:graduation_project/utilities/constants.dart';
import 'package:provider/provider.dart';

class SearchStudents extends StatefulWidget {
  static String routeName = "/search";

  @override
  _SearchStudentsState createState() => _SearchStudentsState();
}

class _SearchStudentsState extends State<SearchStudents> {
  Widget _appBarTitle = new Text('Search Example');
  Icon _searchIcon = new Icon(Icons.search);

  final TextEditingController _filter = new TextEditingController();

  String _searchText = "";
  List<Student> names = new List();
  List<Student> filteredNames = new List();
  List<Student> students;

  /// listeners to textEditing-----
  _SearchStudentsState() {
    _filter.addListener(() {
      if (_filter.text.isEmpty) {
        setState(() {
          _searchText = "";
          filteredNames = names;
        });
      } else {
        setState(() {
          _searchText = _filter.text;
        });
      }
    });
  }
  @override
  void initState() {
    this._getNames();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _buildBar(context),
      body: Container(
        child: _buildList(),
      ),
      resizeToAvoidBottomPadding: false,
    );
  }

  Widget _buildList() {
    if (!(_searchText.isEmpty)) {
      List<Student> tempList = new List();
      for (int i = 0; i < filteredNames.length; i++) {
        if (filteredNames[i]
            .name
            .toLowerCase()
            .contains(_searchText.toLowerCase())) {
          tempList.add(filteredNames[i]);
        }
      }
      filteredNames = tempList;
    }
    return ListView.builder(
      itemCount: names == null ? 0 : filteredNames.length,
      itemBuilder: (BuildContext context, int index) {
        return ListTile(
          title: Text(filteredNames[index].name.toString()),
          subtitle: Text(filteredNames[index].section),
          leading: Image.asset('assets/images/user.png'),
        );
      },
    );
  }

  void _getNames() async {
    Provider.of<StudentProvider>(context, listen: false).getAllStudents();
    students = Provider.of<StudentProvider>(context, listen: false).allStudents;

    List<Student> tempList = new List();

    students.forEach((element) {
      tempList.add(element);
    });
    setState(() {
      names = tempList;
      names.shuffle();
      filteredNames = names;
    });
  }

  Widget _buildBar(BuildContext context) {
    return new AppBar(
      centerTitle: true,
      backgroundColor: primaryLight,
      title: _appBarTitle,
      leading: new IconButton(
        icon: _searchIcon,
        onPressed: _searchPressed,
      ),
    );
  }

  void _searchPressed() {
    setState(() {
      if (this._searchIcon.icon == Icons.search) {
        this._searchIcon = new Icon(Icons.close);
        this._appBarTitle = new TextField(
          controller: _filter,
          decoration: new InputDecoration(
              prefixIcon: new Icon(Icons.search), hintText: 'Search...'),
        );
      } else {
        this._searchIcon = new Icon(Icons.search);
        this._appBarTitle = new Text('Search Example');
        filteredNames = names;
        _filter.clear();
      }
    });
  }
}
