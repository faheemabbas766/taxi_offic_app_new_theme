import 'dart:convert';
import 'package:animator/animator.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_ringtone_player/flutter_ringtone_player.dart';
import 'package:provider/provider.dart';
import 'package:taxi_app/presentation/Language/appLocalizations.dart';
import 'package:taxi_app/presentation/appTheme.dart';
import 'package:taxi_app/presentation/constance/constance.dart';
import 'package:taxi_app/providers/bottomnavpro.dart';
import 'Api & Routes/api.dart';
import 'Api & Routes/routes.dart';
import 'providers/homepro.dart';
import 'providers/startshiftpro.dart';

Widget onLineModeDetail(BuildContext context) {
  var bootmPadding = MediaQuery.of(context).padding.bottom;
  return Padding(
    padding: EdgeInsets.only(right: 10, left: 10, bottom: bootmPadding),
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
                begin: Offset(0, 0.5),
                end: Offset(0, 0),
              ),
              duration: Duration(seconds: 1),
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
                begin: Offset(0, 0.5),
                end: Offset(0, 0),
              ),
              duration: Duration(milliseconds: 700),
              cycles: 1,
              builder: (context, animate, _) => SlideTransition(
                position: animate.animation,
                child: Container(
                  decoration: BoxDecoration(
                    color: Theme.of(context).scaffoldBackgroundColor,
                    borderRadius: BorderRadius.circular(12),
                    boxShadow: [
                      new BoxShadow(
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
                            ClipRRect(
                              borderRadius: BorderRadius.circular(10),
                              child: Image.asset(
                                ConstanceData.userImage,
                                height: 40,
                                width: 40,
                              ),
                            ),
                            const SizedBox(
                              width: 8,
                            ),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                Text(
                                  AppLocalizations.of('Esther Berry'),
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
                                      width: 74,
                                      decoration: BoxDecoration(
                                        borderRadius: const BorderRadius.all(
                                          Radius.circular(15),
                                        ),
                                        color: Theme.of(context).primaryColor,
                                      ),
                                      child: Center(
                                        child: Text(
                                          AppLocalizations.of('ApplePay'),
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
                                          AppLocalizations.of('Discount'),
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
                                Text(
                                  '\$25.00',
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
                      Padding(
                        padding: const EdgeInsets.only(right: 14, left: 14, top: 10, bottom: 10),
                        child: Row(
                          children: <Widget>[
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                Text(
                                  AppLocalizations.of('PICKUP'),
                                  style: Theme.of(context).textTheme.bodySmall!.copyWith(
                                    color: Theme.of(context).disabledColor,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                Text(
                                  AppLocalizations.of('79 Swift Village'),
                                  style: Theme.of(context).textTheme.titleSmall!.copyWith(
                                    fontWeight: FontWeight.bold,
                                    color: Theme.of(context).textTheme.titleLarge!.color,
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
                      Padding(
                        padding: const EdgeInsets.only(right: 14, left: 14, top: 10, bottom: 10),
                        child: Row(
                          children: <Widget>[
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                Text(
                                  AppLocalizations.of('DROP OFF'),
                                  style: Theme.of(context).textTheme.bodySmall!.copyWith(
                                    color: Theme.of(context).disabledColor,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                Text(
                                  AppLocalizations.of('115 William St, Chicago, US'),
                                  style: Theme.of(context).textTheme.titleSmall!.copyWith(
                                    fontWeight: FontWeight.bold,
                                    color: Theme.of(context).textTheme.titleLarge!.color,
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
                      Padding(
                        padding: const EdgeInsets.only(right: 14, left: 14, top: 10, bottom: 10),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: <Widget>[
                            Container(
                              height: 32,
                              width: 80,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10),
                                color: Theme.of(context).scaffoldBackgroundColor,
                              ),
                              child: Center(
                                child: Text(
                                  AppLocalizations.of('Ignore'),
                                  style: Theme.of(context).textTheme.labelLarge!.copyWith(
                                    fontWeight: FontWeight.bold,
                                    color: Theme.of(context).disabledColor,
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(
                              width: 10,
                            ),
                            InkWell(
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
  );
}
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
              RouteManager.bottomPage,
              (route) => false,
            );
          });
          return;
        }
        showDialog(
          context: RouteManager.context!,
          builder: (cont) {
            return onLineModeDetail(cont);
          },
        );
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