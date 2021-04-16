import 'package:flutter/material.dart';
import 'package:graduation_project/model/Doctor.dart';
import 'package:graduation_project/provider/doctor_provider.dart';
import 'package:provider/provider.dart';

class Body extends StatefulWidget {
  @override
  _BodyState createState() => _BodyState();
}

class _BodyState extends State<Body> {
  List<Doctor> doctors;

  @override
  void initState() {
    Provider.of<DoctorProvider>(context, listen: false).getAllDoctors();
    doctors = Provider.of<DoctorProvider>(context, listen: false).allDoctor;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.all(10),
      child: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            SizedBox(
              height: 10,
            ),
            Consumer<DoctorProvider>(
              builder: (context, docData, child) {
                Widget content = Center(child: Text('No Doctors'));
                if (doctors.length > 0) {
                  content = Center(
                    child: Container(
                      color: Colors.white,
                      margin: EdgeInsets.all(5),
                      alignment: Alignment.center,
                      child: ListView.builder(
                          itemCount: doctors.length,
                          scrollDirection: Axis.vertical,
                          shrinkWrap: true,
                          itemBuilder: (BuildContext context, index) {
                            return ListTile(
                              title: Text(doctors[index].name.toString()),
                              subtitle: Text(
                                  doctors[index].email.substring(0, 7) +
                                      "@gmail.com"),
                              leading: Image.asset('assets/images/user.png'),
                            );
                          }),
                    ),
                  );
                } else if (docData.isLoading) {
                  content = Center(
                    child: Container(
                        color: Colors.white,
                        child: CircularProgressIndicator()),
                  );
                }
                return RefreshIndicator(
                    onRefresh: docData.getAllDoctors, child: content);
              },
            )
          ],
        ),
      ),
    );
  }
}
