import 'package:flutter/material.dart';
import '../Language/LanguageData.dart';

class ConstanceData {
  static const splashBackground = "assets/images/building_image.png";
  static const acceptjob = "assets/images/acceptjob.png";
  static const location = "assets/images/location.jpg";
  static const wallet = "assets/images/wallet.jpg";
  static const enableLocation = "assets/images/enableLocation.jpg";
  static const appicon = "assets/images/app_icon.png";
  static const userImage = "assets/images/user.jpg";
  static const mylocation = "assets/images/mylocation.jpg";
  static const mylocation1 = "assets/images/mylocation1.png";
  static const mylocation2 = "assets/images/mylocation2.png";
  static const mylocation3 = "assets/images/mylocation3.png";
  static const user1 = "assets/images/1.jpg";
  static const user2 = "assets/images/2.jpg";
  static const user3 = "assets/images/3.jpg";
  static const user4 = "assets/images/4.jpg";
  static const user5 = "assets/images/5.jpg";
  static const user6 = "assets/images/6.jpg";
  static const user7 = "assets/images/7.jpg";
  static const user8 = "assets/images/8.jpg";
  static const user9 = "assets/images/9.jpg";
  static const taxi = "assets/images/taxi.jpg";

  static const Color secoundryFontColor = Colors.white;

  List<String> colors = ['#e6230e', '#32a852', '#EB1165', '#760ee6', '#a6a6a6', '#ff5733'];
}

// Locale locale;
String locale = "en";

int colorsIndex = 0;
bool isLightTheme = true;

AllTextData allTextData = AllTextData(allText: []);
// var primaryColorString = '#EB1165';
// var secondaryColorString = '#EB1165';

var primaryColorString = ConstanceData().colors[colorsIndex];
var secondaryColorString = '#FF0000';
