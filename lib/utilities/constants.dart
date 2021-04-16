import 'dart:ui';

const primary = Color(0xFF1a237e);
const primaryDark = Color(0xFF000051);
const primaryLight = Color(0xFF534bae);

const secondary = Color(0xFF5c6bc0);
const secondaryDark = Color(0xFF26418f);
const secondaryLight = Color(0xFF8e99f3);

const textOnPrimary = Color(0xFFffffff);
const textOnSecondary = Color(0xFFffffff);

// Form Error
final RegExp emailValidatorRegExp = RegExp(
    r"[a-z0-9!#$%&'*+/=?^_`{|}~-]+(?:\.[a-z0-9!#$%&'*+/=?^_`{|}~-]+)*@(?:[a-z0-9](?:[a-z0-9-]*[a-z0-9])?\.)+[a-z0-9](?:[a-z0-9-]*[a-z0-9])?");
final RegExp phoneValidatorRegExp = RegExp(r"^01[0,1,2,5]{1}[0-9]{8}");

const String kEmailNullError = "Please Enter your email";
const String kInvalidEmailError = "Please Enter Valid Email";
const String kPassNullError = "Please Enter your password";
const String kShortPassError = "Password is too short";
const String kMatchPassError = "Passwords don't match";
const String kNamelNullError = "Please Enter your name";
const String kPhoneNumberNullError = "Please Enter your phone number";
const String kInvalidPhoneNumberError = "Please Enter Valid Phone Number";
const String kAddressNullError = "Please Enter your address";
const String kItemNullError = "Please Enter An Item";

// Firebase Errors
//Conditions
const String kNetworkFieldCond = "ERROR_NETWORK_REQUEST_FAILED";
const String kUserNotFoundCond = "ERROR_USER_NOT_FOUND";
//Messages
const String kNetworkFieldMessage = "Check your network connection.";
const String kEmailInUseMessage =
    "The email address is already in use by another account.";
const String kUserNotFoundMessage = "User not found. Please sign up";
const String kUserPasswordInvaild = "The password is invalid.";

List<String> departments = [
  "عمارة",
  "كهرباء",
  "نظم وحاسبات",
  "تخطيط عمراني",
  "اعدادي هندسة"
];

List<String> departmentsShow = [
  "عمارة",
  "كهرباء",
  "نظم وحاسبات",
  "تخطيط عمراني"
];

List<String> computer_classes = [
  "أولي نظم",
  "ثانيه نظم",
  "ثالثة نظم",
  "رابعة نظم"
];
List<String> arch_classes = [
  "أولي عمارة ",
  "ثانية عمارة",
  "ثالثة عمارة ",
  "رابعة عمارة "
];
List<String> electric_classes = [
  "أولي كهرباء",
  "ثانية كهرباء",
  "ثالثة كهرباء ",
  "رابعة كهرباء "
];
List<String> takteet_classes = [
  "أولي تخطيط ",
  "ثانية تخطيط",
  "ثالثة تخطيط ",
  "رابعة تخطيط"
];
