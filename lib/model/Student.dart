class Student {
  String uid;
  String name;
  String email;
  String password;
  String number;
  String department;
  String section;
  String imagePath;
  bool abscence = false;

  Student(
      {this.name,
      this.email,
      this.password,
      this.number,
      this.department,
      this.section,
      this.abscence,
      this.uid,
      this.imagePath});
}
