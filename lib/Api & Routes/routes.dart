import 'package:flutter/material.dart';
import 'package:taxi_app/bottom/bottomnavigation.dart';
import 'package:taxi_app/pages/add_booking.dart';
import 'package:taxi_app/pages/home.dart';
import 'package:taxi_app/pages/tripdetails.dart';
import '../pages/live_status.dart';
import '../pages/pobmap.dart';
import '../pages/startshift.dart';
import '../presentation/auth/loginScreen.dart';
import '../presentation/history/historyScreen.dart';
import '../presentation/home/homeScreen.dart';
import '../presentation/introduction/LocationScreen.dart';
import '../presentation/introduction/introductionScreen.dart';
import '../presentation/inviteFriend/inviteFriendScreen.dart';
import '../presentation/jobs/jobview.dart';
import '../presentation/notification/notificationScree.dart';
import '../presentation/setting/settingScreen.dart';
import '../presentation/splashScreen.dart';
import '../presentation/wallet/myWallet.dart';

class RouteManager {
  static Color appclr = const Color.fromARGB(255, 240, 240, 240);
  static BuildContext? context;
  static var width;
  static var height;
  static String? deviceid;
  static const String rootpage = "/";
  static const String signinpage = "/signin";
  static const String bottomPage = "/bottomPage";
  static const String homepage = "/homepage";
  static const String jobviewpage = "/jobviewpage";
  static const String startshiftpage = "/startshift";
  static const String tripdetailspage = "/tripdetails";
  static const String pobmappage = "/pobmappage";
  static const String addBooking = "/add_booking";
  static const String liveStatus = "/live_status";
  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case signinpage:
        return MaterialPageRoute(builder: (context) => LoginScreen());
      case rootpage:
        return MaterialPageRoute(builder: (context) => SplashScreen());
      case bottomPage:
        return MaterialPageRoute(builder: (context) => const BottomBar());
      case homepage:
        return MaterialPageRoute(builder: (context) => const Home());
      case jobviewpage:
        return MaterialPageRoute(builder: (context) => const JobView());
      case startshiftpage:
        return MaterialPageRoute(builder: (context) => const StartShift());
      case tripdetailspage:
        return MaterialPageRoute(builder: (context) => const TripDetails());
      case pobmappage:
        return MaterialPageRoute(builder: (context) => const PobMap());
      case addBooking:
        return MaterialPageRoute(builder: (context) => const AddBookingScreen());
      case liveStatus:
        return MaterialPageRoute(builder: (context) => const ShowDialogScreen());
      default:
        throw const FormatException("Route no Found!");
    }
  }
}





var routes = <String, WidgetBuilder>{
  Routes.SPLASH: (BuildContext context) => SplashScreen(),
  Routes.INTRODUCTION: (BuildContext context) => IntroductionScreen(),
  Routes.ENABLELOCATION: (BuildContext context) => EnableLocation(),
  Routes.HOME: (BuildContext context) => HomeScreen(),
  Routes.HISTORY: (BuildContext context) => HistoryScreen(),
  Routes.NOTIFICATION: (BuildContext context) => NotificationScreen(),
  Routes.INVITE: (BuildContext context) => InviteFriendScreen(),
  Routes.SETTING: (BuildContext context) => SettingScreen(),
  Routes.WALLET: (BuildContext context) => MyWallet(),
  Routes.LOGIN: (BuildContext context) => LoginScreen(),
  Routes.JOBS: (BuildContext context) => JobView(),
};
class Routes {
  static const String SPLASH = "/";
  static const String INTRODUCTION = "/introduction/introductionScreen";
  static const String ENABLELOCATION = "/introduction/LocationScreen";
  static const String LOGIN = "/auth/loginScreen";
  static const String HOME = "/home/homeScreen";
  static const String HISTORY = "/history/historyScreen";
  static const String NOTIFICATION = "/notification/notificationScree";
  static const String INVITE = "/inviteFriend/inviteFriendScreen";
  static const String SETTING = "/setting/settingScreen";
  static const String WALLET = "/wallet/myWallet";
  static const String JOBS = "/jobs/jobview.dart";
}
