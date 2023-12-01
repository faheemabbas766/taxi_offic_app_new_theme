import 'package:animator/animator.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:taxi_app/presentation/Language/appLocalizations.dart';
import 'package:taxi_app/presentation/constance/constance.dart';
import 'dart:convert';
import 'genericnotifications.dart';
import 'presentation/constance/constance.dart' as constance;
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_ringtone_player/flutter_ringtone_player.dart';
import 'package:provider/provider.dart';
import 'package:taxi_app/pages/home.dart';
import 'package:taxi_app/presentation/appTheme.dart';
import 'package:taxi_app/providers/bottomnavpro.dart';
import 'package:taxi_app/providers/homepro.dart';
import 'package:taxi_app/providers/pendingjobspro.dart';
import 'package:taxi_app/providers/startshiftpro.dart';
import 'package:taxi_app/providers/themepro.dart';
import 'Api & Routes/api.dart';
import 'Api & Routes/routes.dart';
import 'firebase_options.dart';
import 'providers/completedjobspro.dart';
import 'providers/currentjobspro.dart';
import 'providers/pobmappro.dart';
import 'providers/tripdetailspro.dart';

Widget _showMessage(BuildContext context, message) {
  return Material(
    type: MaterialType.transparency,
    child: Padding(
      padding: EdgeInsets.only(top:200,right: 10, left: 10, bottom: MediaQuery.of(context).padding.bottom),
      child: Stack(
        alignment: Alignment.bottomCenter,
        children: <Widget>[
          Positioned(
            top: 0,
            right: 0,
            left: 0,
            bottom: 16,
            child: Padding(
              padding: const EdgeInsets.only(right: 24, left: 24),
              child: Animator<Offset>(
                tween: Tween<Offset>(
                  begin: const Offset(0, 0.5),
                  end: const Offset(0, 0),
                ),
                duration: const Duration(seconds: 1),
                cycles: 1,
                builder: (context, animate, _) => SlideTransition(
                  position: animate.animation,
                  child: Container(
                    decoration: BoxDecoration(
                      color: Theme.of(context).scaffoldBackgroundColor,
                      borderRadius: BorderRadius.circular(12),
                      boxShadow: [
                        BoxShadow(
                          color: AppTheme.isLightTheme ? Colors.black.withOpacity(0.2) : Colors.white.withOpacity(0.2),
                          blurRadius: 12,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
          Positioned(
            top: 12,
            right: 0,
            left: 0,
            bottom: 16,
            child: Padding(
              padding: const EdgeInsets.only(right: 12, left: 12),
              child: Animator<Offset>(
                tween: Tween<Offset>(
                  begin: const Offset(0, 0.5),
                  end: const Offset(0, 0),
                ),
                duration: const Duration(milliseconds: 700),
                cycles: 1,
                builder: (context, animate, _) => SlideTransition(
                  position: animate.animation,
                  child: Container(
                    decoration: BoxDecoration(
                      color: Theme.of(context).scaffoldBackgroundColor,
                      borderRadius: BorderRadius.circular(12),
                      boxShadow: [
                        BoxShadow(
                          color: AppTheme.isLightTheme ? Colors.black.withOpacity(0.2) : Colors.white.withOpacity(0.2),
                          blurRadius: 6,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
          Animator<Offset>(
            tween: Tween<Offset>(
              begin: Offset(0, 0.4),
              end: Offset(0, 0),
            ),
            duration: const Duration(milliseconds: 700),
            cycles: 1,
            builder: (context, animate, _) => SlideTransition(
              position: animate.animation,
              child: Padding(
                padding: const EdgeInsets.only(top: 24),
                child: Container(
                  decoration: BoxDecoration(
                    color: Theme.of(context).scaffoldBackgroundColor,
                    borderRadius: BorderRadius.circular(12),
                    boxShadow: [
                      BoxShadow(
                        color: Theme.of(context).dividerColor,
                        blurRadius: 4,
                      ),
                    ],
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(12),
                    child: Column(
                      children: <Widget>[
                        Container(
                          padding: const EdgeInsets.all(14),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              const SizedBox(
                                width: 8,
                              ),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  Text(
                                    AppLocalizations.of("${jsonDecode(message.data['Customer_Detail'])["CUS_NAME"]}"),
                                    style: Theme.of(context).textTheme.titleLarge!.copyWith(
                                      fontWeight: FontWeight.bold,
                                      color: Theme.of(context).textTheme.titleLarge!.color,
                                    ),
                                  ),
                                  const SizedBox(
                                    height: 4,
                                  ),
                                  Row(
                                    children: <Widget>[
                                      Container(
                                        height: 24,
                                        width: 150,
                                        decoration: BoxDecoration(
                                          borderRadius: const BorderRadius.all(
                                            Radius.circular(15),
                                          ),
                                          color: Theme.of(context).primaryColor,
                                        ),
                                        child: Center(
                                          child: Text(
                                            AppLocalizations.of("Ph# ${jsonDecode(message.data['Customer_Detail'])["CUS_PHONE"]}"),
                                            style: Theme.of(context).textTheme.labelLarge!.copyWith(
                                              fontWeight: FontWeight.bold,
                                              color: ConstanceData.secoundryFontColor,
                                            ),
                                          ),
                                        ),
                                      ),
                                      const SizedBox(
                                        width: 4,
                                      ),
                                      Container(
                                        height: 24,
                                        width: 74,
                                        decoration: BoxDecoration(
                                          borderRadius: BorderRadius.all(
                                            Radius.circular(15),
                                          ),
                                          color: Theme.of(context).primaryColor,
                                        ),
                                        child: Center(
                                          child: Text(
                                            AppLocalizations.of(
                                                jsonDecode(message.data['booking_detail'])[
                                                "BM_PAY_METHOD"]
                                                    .toString() ==
                                                    "1"
                                                    ? "Cash"
                                                    : jsonDecode(message.data['booking_detail'])[
                                                "BM_PAY_METHOD"]
                                                    .toString() ==
                                                    "2"
                                                    ? "Card"
                                                    : "Account"),
                                            style: Theme.of(context).textTheme.labelLarge!.copyWith(
                                              fontWeight: FontWeight.bold,
                                              color: ConstanceData.secoundryFontColor,
                                            ),
                                          ),
                                        ),
                                      )
                                    ],
                                  )
                                ],
                              ),
                              const Expanded(
                                child: SizedBox(),
                              ),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.end,
                                children: <Widget>[
                                  Text('${jsonDecode(message.data['booking_detail'])["total_amount"].toString()} £',
                                    style: Theme.of(context).textTheme.titleLarge!.copyWith(
                                      fontWeight: FontWeight.bold,
                                      color: Theme.of(context).textTheme.titleLarge!.color,
                                    ),
                                  ),
                                  Text(
                                    '2.2 km',
                                    style: Theme.of(context).textTheme.bodySmall!.copyWith(
                                      color: Theme.of(context).disabledColor,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                        Divider(
                          height: 0.5,
                          color: Theme.of(context).disabledColor,
                        ),
                        SingleChildScrollView(
                          child: Column(
                            children: [
                              Container(
                                padding: EdgeInsets.symmetric(
                                    vertical: RouteManager.width / 70),
                                width: RouteManager.width / 1.5,
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    SizedBox(height: RouteManager.width / 20),
                                    Container(
                                      padding: EdgeInsets.symmetric(
                                          vertical: RouteManager.width / 70),
                                      width: RouteManager.width / 1.5,
                                      height: 280,
                                      child: ListView.builder(
                                        itemCount: bookingStops.length,
                                        itemBuilder: (context, index) {
                                          var bookingStop = bookingStops[index];
                                          bool isFirstStop = index == 0;
                                          bool isLastStop =
                                              index == bookingStops.length - 1;

                                          String title;
                                          Color
                                          stopColor; // Define a color for the stop based on your conditions
                                          Color
                                          navigationColor; // Define a color for the navigation button based on your conditions
                                          String address = bookingStop[
                                          'BD_LOCATION'] ??
                                              "abc"; // Use an empty string as default

                                          if (isFirstStop) {
                                            title = "Pick Up";

                                            stopColor = Colors.black;
                                            navigationColor = Colors.green;
                                            // Set the navigation button color for the first stop
                                          } else if (isLastStop) {
                                            title = "Destination";
                                            stopColor = Colors.black;
                                            navigationColor = Colors
                                                .red; // Set the navigation button color for the last stop
                                          } else {
                                            title = "Stop $index";
                                            stopColor = Colors.black;
                                            navigationColor = const Color(0xff0038FF);
                                            // Set the navigation button color for intermediate stops
                                          }
                                          return ListTile(
                                            title: Text(
                                              title,
                                              style: TextStyle(
                                                color: stopColor,
                                                fontWeight: FontWeight.bold,
                                                fontSize: RouteManager.width / 25,
                                              ),
                                            ),
                                            subtitle: Column(
                                              crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                              children: [
                                                Text(
                                                  address,
                                                  style: TextStyle(
                                                    fontSize: RouteManager.width / 30,
                                                  ),
                                                ),
                                              ],
                                            ),
                                            trailing: IconButton(
                                              icon: Icon(Icons.navigation_rounded,
                                                  color:
                                                  navigationColor), // Use the navigation button color
                                              onPressed: () {
                                                if (isLastStop) {
                                                  var destinationStop = bookingStop;
                                                  openGoogleMapsNavigationToDestination(
                                                    double.parse(
                                                        destinationStop['BD_LAT']),
                                                    double.parse(
                                                        destinationStop['BD_LANG']),
                                                  );
                                                } else {
                                                  var startStop = bookingStop;
                                                  openGoogleMapsNavigationToDestination(
                                                    double.parse(startStop['BD_LAT']),
                                                    double.parse(
                                                        startStop['BD_LANG']),
                                                  );
                                                }
                                              },
                                            ),
                                          );
                                        },
                                      ),
                                    )
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                        Divider(
                          height: 0.5,
                          color: Theme.of(context).disabledColor,
                        ),
                        Padding(
                          padding: const EdgeInsets.only(right: 14, left: 14, top: 10, bottom: 10),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: <Widget>[
                              InkWell(
                                onTap: () {
                                  API.showLoading("", context);
                                  API.respondToBooking(
                                      int.parse(jsonDecode(message.data['booking_detail'])["BM_SN"]), 7, context).then((value) async {
                                      Navigator.of(context, rootNavigator: true).pop();
                                      Navigator.of(context, rootNavigator: true).pop();
                                      await FlutterRingtonePlayer.play(fromAsset: 'assets/cancel_tone.wav');
                                    },
                                  );
                                },
                                child: Container(
                                  height: 32,
                                  width: 80,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(10),
                                    color: Theme.of(context).scaffoldBackgroundColor,
                                  ),
                                  child: Center(
                                    child: Text(
                                      AppLocalizations.of('Reject'),
                                      style: Theme.of(context).textTheme.labelLarge!.copyWith(
                                        fontWeight: FontWeight.bold,
                                        color: Theme.of(context).disabledColor,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                              const SizedBox(
                                width: 10,
                              ),
                              InkWell(
                                onTap: () async {
                                  API.showLoading("", context);
                                  API.respondToBooking(
                                      int.parse(jsonDecode(message.data['booking_detail'])["BM_SN"]),
                                      2, context).then((value) {
                                      Navigator.of(context, rootNavigator: true).pop();
                                      Navigator.of(context, rootNavigator: true).pop();
                                      Navigator.of(context)
                                          .pushNamed(Routes.JOBS);
                                    },
                                  );
                                  await FlutterRingtonePlayer.play(fromAsset: 'assets/accept_tone.mp3');
                                },
                                child: Container(
                                  height: 32,
                                  width: 80,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(10),
                                    color: Theme.of(context).primaryColor,
                                  ),
                                  child: Center(
                                    child: Text(
                                      AppLocalizations.of('ACCEPT'),
                                      style: Theme.of(context).textTheme.labelLarge!.copyWith(
                                        fontWeight: FontWeight.bold,
                                        color: ConstanceData.secoundryFontColor,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        )
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    ),
  );
}
String token = '';
@pragma('vm:entry-point')
Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  if (message.data.toString() == "{title: Admin Ended ur shift}") {
    GenericNotifications.showNotification(
      id: 1,
      title: "Shift Ended",
      body: "Your Shift has been Ended by the Admin",
      payload: "0",
    );
    return;
  }
  Map<String, dynamic> map = {};
  if (kDebugMode) {
    print("?????????????????????????????????????????????????${message.data}");
  }
  map["CUS_NAME"] =
      jsonDecode(message.data['Customer_Detail'])["CUS_NAME"].toString();
  map["CUS_PHONE"] =
      jsonDecode(message.data['Customer_Detail'])["CUS_PHONE"].toString();
  map["BM_DATE"] =
      jsonDecode(message.data['booking_detail'])["BM_DATE"].toString();
  map["BM_PASSENGER"] =
      jsonDecode(message.data['booking_detail'])["BM_PASSENGER"].toString();
  map["BM_LAGGAGE"] =
      jsonDecode(message.data['booking_detail'])["BM_M_LUGGAE"].toString();
  map["BM_PAY_METHOD"] =
      jsonDecode(message.data['booking_detail'])["BM_PAY_METHOD"].toString();
  map["total_amount"] =
      jsonDecode(message.data['booking_detail'])["total_amount"].toString();
  map["BM_SN"] =
  jsonDecode(message.data['booking_detail'])["BM_SN"];
  map["Booking_stops"] =
  jsonDecode(message.data['Booking_stops']);

  GenericNotifications.showNotification(
    id: 1,
    title: "New Booking",
    body: "Admin Assigned you a Booking",
    payload: jsonEncode(map),
  );
  if (kDebugMode) {
    print("HANDLING A BACKGROUND MESSAGE : ${message.messageId}");
  }
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp, DeviceOrientation.portraitDown,]);
  GenericNotifications.initNotifications();
  var abcd = await FlutterLocalNotificationsPlugin().getNotificationAppLaunchDetails();
  if (abcd!.didNotificationLaunchApp) {
    HomePro.notificationpayload = abcd.notificationResponse!.payload.toString();
  }
  SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual, overlays: [SystemUiOverlay.bottom]);
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
  FirebaseMessaging firebaseMessaging = FirebaseMessaging.instance;
  API.devid = await firebaseMessaging.getToken();
  if (kDebugMode) {
    print(
      "SENTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTT");
  }
  if (kDebugMode) {
    print("TOKEN IS :${API.devid}:");
  }
  NotificationSettings settings = await firebaseMessaging.requestPermission(
    alert: true,
    announcement: false,
    badge: true,
    carPlay: false,
    criticalAlert: false,
    provisional: false,
    sound: true,
  );
  if (kDebugMode) {
    print('Permission granted: ${settings.authorizationStatus}');
  }
  FirebaseMessaging.onMessage.listen((RemoteMessage message) {
    if (kDebugMode) {
      print("------------------------------------------------------------------------------------------------");
    }
    if (kDebugMode) {
      print("RECEIVED FOREGROUND MESSAGE.DATA :${message.data}:");
    }
    bookingStops = jsonDecode(message.data['Booking_stops']);
    if (message.data.toString() == "{title: Admin Ended ur shift}") {
      API.postlocation = false;
      Provider.of<HomePro>(RouteManager.context!, listen: false).shiftid = -1;
      Provider.of<HomePro>(RouteManager.context!, listen: false).vehicleid = -1;
      Provider.of<HomePro>(RouteManager.context!, listen: false)
          .notifyListenerz();
      showDialog(
          context: RouteManager.context!,
          builder: (cont) {
            return Dialog(
              backgroundColor: const Color.fromRGBO(101, 106, 121, 1),
              child: Container(
                  decoration: const BoxDecoration(
                    color: Color.fromRGBO(101, 106, 121, 1),
                    borderRadius: BorderRadius.all(
                      Radius.circular(20),
                    ),
                  ),
                  height: RouteManager.width / 3,
                  padding: const EdgeInsets.all(10),
                  child: Column(
                    children: [
                      Center(
                        child: Text(
                          "Shift Ended by Admin",
                          style: TextStyle(
                            color: Colors.red,
                            fontWeight: FontWeight.bold,
                            fontSize: RouteManager.width / 17,
                          ),
                        ),
                      ),
                      SizedBox(height: RouteManager.width / 30),
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.blue),
                        onPressed: () {
                          Navigator.of(cont, rootNavigator: true).pop();
                        },
                        child: SizedBox(
                          width: RouteManager.width / 5,
                          height: RouteManager.width / 8,
                          child: Center(
                            child: Text(
                              "OK",
                              style: TextStyle(
                                fontSize: RouteManager.width / 23,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  )),
            );
          }).then((value) {
        Provider.of<BottomNavigationPro>(RouteManager.context!, listen: false)
            .clearAll();
        Provider.of<StartShiftPro>(RouteManager.context!, listen: false)
            .clearAll();
        Provider.of<HomePro>(RouteManager.context!, listen: false)
            .timer!
            .cancel();
        Navigator.of(RouteManager.context!).pushNamedAndRemoveUntil(
          Routes.HOME,
          (route) => false,
        );
      });
      return;
    }
    FlutterRingtonePlayer.playNotification();
    API.respondToBooking(int.parse(jsonDecode(message.data['booking_detail'])["BM_SN"]), 99, RouteManager.context!).then((value){
        Navigator.of(RouteManager.context!).pushNamed(Routes.JOBS);
      },
    );
    if (kDebugMode) {
      print('Handling a foreground message: ${message.messageId}');
      print('Message data: ${message.data}');
      print("VEHICLE--------->>>>>>>>>>>>>>>>>>>>>>>${jsonDecode(message.data['vehicle'])["CAR_NAME"]}");
      if (message.notification != null) {
        print('Message notification: ${message.notification?.title}');
        print('Message notification: ${message.notification?.body}');
      }
    }
  });
  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider<StartShiftPro>(
            create: (_) => StartShiftPro()),
        ChangeNotifierProvider<HomePro>(
            create: (_) => HomePro()),
        ChangeNotifierProvider<BottomNavigationPro>(
            create: (_) => BottomNavigationPro()),
        ChangeNotifierProvider<CurrentJobsPro>(
            create: (_) => CurrentJobsPro()),
        ChangeNotifierProvider<PendingJobsPro>(lazy: false,
            create: (_) => PendingJobsPro()),
        ChangeNotifierProvider<CompletedJobsPro>(
            create: (_) => CompletedJobsPro()),
        ChangeNotifierProvider<TripDetailsPro>(
            create: (_) => TripDetailsPro()),
        ChangeNotifierProvider<PobMapPro>(
            create: (_) => PobMapPro()),
        ChangeNotifierProvider<ThemeModeProvider>(
          create: (_) => ThemeModeProvider(),),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  static setCustomTheme(BuildContext context, int index) {
    final _MyAppState? state = context.findAncestorStateOfType<_MyAppState>();
    state!.setCustomeTheme(index);
  }

  static setCustomLanguage(BuildContext context, String languageCode) {
    final _MyAppState? state = context.findAncestorStateOfType<_MyAppState>();
    state!.setLanguage(languageCode);
  }

  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  setCustomeTheme(int index) {
    if (index == 6) {
      setState(() {
        AppTheme.isLightTheme = true;
      });
    } else if (index == 7) {
      setState(() {
        AppTheme.isLightTheme = false;
      });
    } else {
      setState(() {
        constance.colorsIndex = index;
        constance.primaryColorString =
        ConstanceData().colors[constance.colorsIndex];
        constance.secondaryColorString = constance.primaryColorString;
      });
    }
  }

  String locale = "en";

  setLanguage(String languageCode) {
    setState(() {
      locale = languageCode;
      constance.locale = languageCode;
    });
  }

  @override
  Widget build(BuildContext context) {
    RouteManager.context=context;
    RouteManager.width = MediaQuery.of(context).size.width;
    RouteManager.height = MediaQuery.of(context).size.height;
    constance.locale = locale;
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: AppTheme.isLightTheme
          ? Brightness.dark
          : Brightness.light,
      statusBarBrightness: AppTheme.isLightTheme ? Brightness.light : Brightness
          .dark,
      systemNavigationBarColor: AppTheme.isLightTheme ? Colors.white : Colors
          .black,
      systemNavigationBarDividerColor: Colors.grey,
      systemNavigationBarIconBrightness: AppTheme.isLightTheme
          ? Brightness.dark
          : Brightness.light,
    ));
    return MaterialApp(
      title: 'MyCab Driver',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.getTheme(),
      routes: routes,
      initialRoute: Routes.SPLASH,
    );
  }
}
