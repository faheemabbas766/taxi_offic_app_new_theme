import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:provider/provider.dart';
import 'package:taxi_app/providers/bottomnavpro.dart';
import 'Api & Routes/api.dart';
import 'Api & Routes/routes.dart';
import 'providers/homepro.dart';
import 'providers/startshiftpro.dart';
class GenericNotifications {
  static final _notifications = FlutterLocalNotificationsPlugin();
  static List<dynamic> bookingStopsAll = [];
  static initNotifications() {
    _notifications.initialize(
      const InitializationSettings(
        android: AndroidInitializationSettings(
          '@mipmap/ic_launcher',
        ),
        iOS: DarwinInitializationSettings(),
        // iOS: IOSInitializationSettings(),
      ),
      onDidReceiveNotificationResponse: (n) async {
        if (kDebugMode) {
          print(
            "RECEIVED FOREGROUND RESPONSE :::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::${n.payload}");
        }
        if (n.payload.toString() == "0") {
          Provider.of<HomePro>(RouteManager.context!, listen: false).shiftid =
              -1;
          Provider.of<HomePro>(RouteManager.context!, listen: false).vehicleid =
              -1;
          API.postlocation = false;
          // Provider.of<StartShiftPro>(context,listen:false).vehicle_in_shift=Vehicle(vehicleid, make, model);
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
            Provider.of<BottomNavigationPro>(RouteManager.context!,
                    listen: false)
                .clearAll();
            Provider.of<StartShiftPro>(RouteManager.context!, listen: false)
                .clearAll();
            Navigator.of(RouteManager.context!).pushNamedAndRemoveUntil(
              Routes.HOME,
              (route) => false,
            );
          });
          return;
        }
        cancelAllNotifications();
        Navigator.of(RouteManager.context!).pushNamed(Routes.JOBS);
      },
      // onDidReceiveBackgroundNotificationResponse: notificationTapBackground,
    );
  }

  static Future showNotification(
      {int id = 0, String? title, String? body, String? payload}) async {
    // _notifications.toString();
    print("ID:::::::::::::::::::::::::::::::::::::::::::::::::::::::$id:");
    // _notifications.initialize()
    _notifications.show(id, title, body, await _notificationDetails(),
        payload: payload);
  }

  static void cancelAllNotifications() {
    _notifications.cancelAll();
  }

  static Future _notificationDetails() async {
    return const NotificationDetails(
      android: AndroidNotificationDetails(
        'channel id',
        'channel name',
        importance: Importance.max,
        enableVibration: true,
        playSound: true,
        visibility: NotificationVisibility.public,
        priority: Priority.high,
        fullScreenIntent: true,
        actions: <AndroidNotificationAction>[
          AndroidNotificationAction(
            'accept_action',
            'Close',
            titleColor: Colors.red,
            cancelNotification:true,
          ),
          AndroidNotificationAction(
            'reject_action',
            'Open',
            titleColor: Colors.green,
            showsUserInterface:true,
          ),
        ],
      ),
      iOS: DarwinNotificationDetails(),
    );
  }
}