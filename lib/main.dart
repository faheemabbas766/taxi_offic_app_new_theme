import 'dart:async';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
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
String token = '';
void showFutureJobDialog(BuildContext context, int bid) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return StatefulBuilder(
        builder: (context, setState) {
          int seconds = 30;
          late Timer timer;
          void startTimer() {
            timer = Timer.periodic(const Duration(seconds: 1), (timer) {
              if (seconds > 0) {
                seconds--;
                setState;
              } else {
                timer.cancel();
                Navigator.of(context).pop();
              }
            });
          }
          startTimer();
          return AlertDialog(
            title: const Text('Admin has assigned you a future job. Do you accept?'),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                Text('Time remaining: $seconds seconds'),
                const SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: <Widget>[
                    ElevatedButton(
                      onPressed: () async {
                        FlutterRingtonePlayer().stop();
                        await FlutterRingtonePlayer().play(fromAsset: 'assets/accept_tone.mp3');
                        timer.cancel();
                        Navigator.of(context).pop();
                        API.respondToBooking(bid, 2, context);
                      },
                      child: const Text('Accept'),
                    ),
                    ElevatedButton(
                      onPressed: () async {
                        FlutterRingtonePlayer().stop();
                        await FlutterRingtonePlayer().play(fromAsset: 'assets/cancel_tone.wav');
                        timer.cancel();
                        Navigator.of(context).pop();
                        API.respondToBooking(bid, 3, context);
                      },
                      child: const Text('Reject'),
                    ),
                  ],
                ),
              ],
            ),
          );
        },
      );
    },
  );
}
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
  print("HANDLING A BACKGROUND MESSAGE : ${message.messageId}");
  FlutterRingtonePlayer().play(fromAsset: 'assets/job_tone.mp3');
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
  FirebaseMessaging.onMessage.listen((RemoteMessage message) async {
    if (kDebugMode) {
      print("------------------------------------------------------------------------------------------------");
    }
    if (kDebugMode) {
      print("RECEIVED FOREGROUND MESSAGE.DATA :${message.data}:");
    }
    if(message.data['title'].contains('Admin assign you future job')) {
      FlutterRingtonePlayer().play(fromAsset:'assets/job_tone.mp3');
      print('booking ID::::::::::::::::::::::::::::'+jsonDecode(message.data['booking_detail'])["BM_SN"]);
      showFutureJobDialog(RouteManager.context!,int.parse(jsonDecode(message.data['booking_detail'])["BM_SN"]));
    }
    else if(message.data.toString().contains('Admin cancelled this booking')) {
      FlutterRingtonePlayer().playNotification();
      Navigator.of(RouteManager.context!).pushNamedAndRemoveUntil(Routes.HOME, (route) => false,);
      showDialog(
        context: RouteManager.context!,
        builder: (context) => Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10.0),
          ),
          elevation: 0,
          backgroundColor: Colors.transparent,
          child: Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(10.0),
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.5),
                  spreadRadius: 3,
                  blurRadius: 7,
                  offset: Offset(0, 3),
                ),
              ],
            ),
            child: const Padding(
              padding: EdgeInsets.all(20.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    Icons.info,
                    size: 40,
                    color: Colors.red,
                  ),
                  SizedBox(height: 20),
                  Text(
                    'Admin cancelled Booking',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      );
      const snackBar = SnackBar(
        content: Text('Admin cancelled your Booking'),
        duration: Duration(seconds: 10), // Duration for how long the SnackBar should be visible
      );
      ScaffoldMessenger.of(RouteManager.context!).showSnackBar(snackBar);

    }
    else if (message.data.toString() == "{title: Admin Ended ur shift}") {
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
    else{
      bookingStops = jsonDecode(message.data['Booking_stops']);
      FlutterRingtonePlayer().playNotification();
      Navigator.of(RouteManager.context!).pushNamed(Routes.JOBS);
      if (kDebugMode) {
        print('Handling a foreground message: ${message.messageId}');
        print('Message data: ${message.data}');
        print("VEHICLE--------->>>>>>>>>>>>>>>>>>>>>>>${jsonDecode(message.data['vehicle'])["CAR_NAME"]}");
        if (message.notification != null) {
          print('Message notification: ${message.notification?.title}');
          print('Message notification: ${message.notification?.body}');
        }
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
      // home: MapRouteScreen()
    );
  }
}
