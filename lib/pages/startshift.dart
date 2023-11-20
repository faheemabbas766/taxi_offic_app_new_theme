import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:provider/provider.dart';
import 'package:taxi_app/providers/homepro.dart';
import 'package:fluttertoast/fluttertoast.dart' as ft;
import '../Api & Routes/api.dart';
import '../Api & Routes/routes.dart';
import '../providers/startshiftpro.dart';
import '../providers/themepro.dart';

class StartShift extends StatefulWidget {
  const StartShift({super.key});

  @override
  State<StartShift> createState() => _StartShiftState();
}

class _StartShiftState extends State<StartShift> {
  @override
  void initState() {
    super.initState();
    API.getVehicles(
        Provider.of<HomePro>(context, listen: false).userid, context);
  }
  Future<bool> _handleLocationPermission(BuildContext context) async {
    bool serviceEnabled;
    LocationPermission permission;
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text(
          'Location services are disabled. Please enable the services')));
      return false;
    }
    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Location permissions are denied')));
        return false;
      }
    }
    if (permission == LocationPermission.deniedForever) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text(
          'Location permissions are permanently denied, we cannot request permissions.')));
      return false;
    }
    return true;
  }


  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        Provider.of<StartShiftPro>(context, listen: false).isloaded = false;
        Provider.of<StartShiftPro>(context, listen: false).vehicles = [];
        Provider.of<StartShiftPro>(context, listen: false).selectedvehicleid =
            -1;

        return true;
      },
      child: Scaffold(
        backgroundColor: AppColors.of(context).primaryDimColor,
        appBar: AppBar(
          backgroundColor: AppColors.of(context).primaryColor,
          title: Row(
            children: [
              SizedBox(width: RouteManager.width / 5.6),
              Text(
                "Shifts",
                style: TextStyle(fontSize: RouteManager.width / 10,color: AppColors.of(context).secondaryColor),
              ),
            ],
          ),
        ),
        body: !Provider.of<StartShiftPro>(context).isloaded
            ? const Center(
                child: CircularProgressIndicator(),
              )
            : Provider.of<HomePro>(context).shiftid != -1 &&
                    Provider.of<HomePro>(context).vehicleid != -1
                ? Column(
                    children: [
                      SizedBox(
                        height: RouteManager.width / 15,
                      ),
                      Container(
                        width: RouteManager.width / 1.11,
                        decoration: BoxDecoration(
                          borderRadius:
                              BorderRadius.circular(RouteManager.width / 10),
                          //color: const Color.fromARGB(255, 75, 189, 79),
                        ),
                        child: Builder(
                          builder: (context) {
                            for (int i = 0;
                                i <
                                    Provider.of<StartShiftPro>(context,
                                            listen: false)
                                        .vehicles
                                        .length;
                                i++) {
                              if (Provider.of<StartShiftPro>(context,
                                          listen: false)
                                      .vehicles[i]
                                      .id ==
                                  Provider.of<HomePro>(context, listen: false)
                                      .vehicleid) {
                                return Card(
                                  color: AppColors.of(context).primaryColor,
                                  shape: RoundedRectangleBorder(
                                    side: const BorderSide(
                                        color: Color(0xffFEC400)),
                                    borderRadius: BorderRadius.circular(5),
                                  ),
                                  child: Stack(
                                    children: [
                                      Column(
                                        children: [
                                          SizedBox(
                                            height: RouteManager.width / 30,
                                          ),
                                          Row(
                                            children: [
                                              SizedBox(
                                                width: RouteManager.width / 12,
                                              ),
                                              Text(
                                                "Start Time  :  ",
                                                style: TextStyle(
                                                  fontSize:
                                                      RouteManager.width / 20,
                                                  color: AppColors.of(context).secondaryColor,
                                                  fontWeight: FontWeight.w400,
                                                ),
                                              ),
                                              Text(
                                                "${Provider.of<HomePro>(context).shiftfrom!.year}-${Provider.of<HomePro>(context).shiftfrom!.month}-${Provider.of<HomePro>(context).shiftfrom!.day}  ",
                                                style: TextStyle(
                                                    fontSize:
                                                        RouteManager.width / 20,
                                                    color: AppColors.of(context).secondaryColor),
                                              ),
                                              Provider.of<HomePro>(context)
                                                          .shiftfrom!
                                                          .hour
                                                          .toString()
                                                          .length ==
                                                      1
                                                  ? Text(
                                                      "0${Provider.of<HomePro>(context).shiftfrom!.hour}:",
                                                      style: TextStyle(
                                                          fontSize: RouteManager
                                                                  .width /
                                                              20,
                                                          color: AppColors.of(context).secondaryColor),
                                                    )
                                                  : Text(
                                                      "${Provider.of<HomePro>(context).shiftfrom!.hour}:",
                                                      style: TextStyle(
                                                        fontSize:
                                                            RouteManager.width /
                                                                20,
                                                        color: AppColors.of(context).secondaryColor,
                                                      ),
                                                    ),
                                              Provider.of<HomePro>(context)
                                                          .shiftfrom!
                                                          .minute
                                                          .toString()
                                                          .length ==
                                                      1
                                                  ? Text(
                                                      "0${Provider.of<HomePro>(context).shiftfrom!.minute}",
                                                      style: TextStyle(
                                                          fontSize: RouteManager
                                                                  .width /
                                                              20,
                                                          color: AppColors.of(context).secondaryColor),
                                                    )
                                                  : Text(
                                                      Provider.of<HomePro>(
                                                              context)
                                                          .shiftfrom!
                                                          .minute
                                                          .toString(),
                                                      style: TextStyle(
                                                          fontSize: RouteManager
                                                                  .width /
                                                              20,
                                                          color: AppColors.of(context).secondaryColor),
                                                    ),
                                            ],
                                          ),
                                          Row(
                                            children: [
                                              SizedBox(
                                                width: RouteManager.width / 12,
                                              ),
                                              Text(
                                                "End   Time  :  ",
                                                style: TextStyle(
                                                  fontSize:
                                                      RouteManager.width / 20,
                                                  color: AppColors.of(context).secondaryColor,
                                                  fontWeight: FontWeight.w400,
                                                ),
                                              ),
                                              Text(
                                                "${Provider.of<HomePro>(context).shiftto!.year}-${Provider.of<HomePro>(context).shiftto!.month}-${Provider.of<HomePro>(context).shiftto!.day}  ",
                                                style: TextStyle(
                                                    fontSize:
                                                        RouteManager.width / 20,
                                                    color: AppColors.of(context).secondaryColor),
                                              ),
                                              Provider.of<HomePro>(context)
                                                          .shiftto!
                                                          .hour
                                                          .toString()
                                                          .length ==
                                                      1
                                                  ? Text(
                                                      "0${Provider.of<HomePro>(context).shiftto!.hour}:",
                                                      style: TextStyle(
                                                          fontSize: RouteManager
                                                                  .width /
                                                              20,
                                                          color: AppColors.of(context).secondaryColor),
                                                    )
                                                  : Text(
                                                      "${Provider.of<HomePro>(context).shiftto!.hour}:",
                                                      style: TextStyle(
                                                          fontSize: RouteManager
                                                                  .width /
                                                              20,
                                                          color: AppColors.of(context).secondaryColor),
                                                    ),
                                              Provider.of<HomePro>(context)
                                                          .shiftto!
                                                          .minute
                                                          .toString()
                                                          .length ==
                                                      1
                                                  ? Text(
                                                      "0${Provider.of<HomePro>(context).shiftto!.minute}",
                                                      style: TextStyle(
                                                          fontSize: RouteManager
                                                                  .width /
                                                              20,
                                                          color: AppColors.of(context).secondaryColor),
                                                    )
                                                  : Text(
                                                      Provider.of<HomePro>(
                                                              context)
                                                          .shiftto!
                                                          .minute
                                                          .toString(),
                                                      style: TextStyle(
                                                          fontSize: RouteManager
                                                                  .width /
                                                              20,
                                                          color: AppColors.of(context).secondaryColor),
                                                    ),
                                            ],
                                          ),
                                          Row(
                                            children: [
                                              SizedBox(
                                                  width:
                                                      RouteManager.width / 12),
                                              Text(
                                                "Car               :  ",
                                                style: TextStyle(
                                                  fontSize:
                                                      RouteManager.width / 20,
                                                  color:
                                                  AppColors.of(context).secondaryColor,
                                                  fontWeight: FontWeight.w400,
                                                ),
                                              ),
                                              Text(
                                                "${Provider.of<StartShiftPro>(context, listen: false).vehicles[i].make} ${Provider.of<StartShiftPro>(context, listen: false).vehicles[i].model}",
                                                style: TextStyle(
                                                  fontWeight: FontWeight.w400,
                                                  fontSize:
                                                      RouteManager.width / 20,
                                                  color:
                                                  AppColors.of(context).secondaryColor,
                                                ),
                                              ),
                                            ],
                                          ),
                                          SizedBox(
                                            height: RouteManager.width / 40,
                                          ),
                                        ],
                                      ),
                                      Center(
                                        child: Column(
                                          children: [
                                            SizedBox(
                                                height:
                                                    RouteManager.width / 60),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                );
                              }
                            }
                            return const SizedBox();
                          },
                        ),
                      ),
                      SizedBox(height: RouteManager.width / 28),
                      Opacity(
                        opacity: 0.5,
                        child: Container(
                          width: RouteManager.width / 1.3,
                          color: AppColors.of(context).primaryColor,
                          height: RouteManager.width / 100,
                        ),
                      ),
                      SizedBox(height: RouteManager.width / 28),
                      SizedBox(
                        height: RouteManager.height / 1.9,
                        child: ListView.builder(
                          itemCount: Provider.of<StartShiftPro>(context)
                              .vehicles
                              .length,
                          itemBuilder: (cont, ind) {
                            return const SizedBox();
                          },
                        ),
                      ),
                      InkWell(
                        onTap: () {
                          API.showLoading("", context);
                          API
                              .stopShift(
                            Provider.of<HomePro>(context, listen: false).userid,
                            Provider.of<HomePro>(context, listen: false)
                                .shiftid,
                            context,
                          )
                              .then((value) {
                            API.postlocation = false;
                            Navigator.of(context, rootNavigator: true).pop();
                          });
                        },
                        child: Container(
                          height: 50,
                          width: 320,
                          decoration: BoxDecoration(
                            border: Border.all(
                              color: const Color(0xfffebd23),
                            ),
                            color: const Color(0xfffebd23),
                            borderRadius: BorderRadius.circular(5),
                          ),
                          child: Center(
                            child: Text("Stop Shift",
                                style: TextStyle(
                                  color: AppColors.of(context).secondaryColor,
                                  fontSize: RouteManager.width / 12,
                                  fontWeight: FontWeight.bold,
                                )),
                          ),
                        ),
                      ),
                    ],
                  )
                : Column(
                    children: [
                      SizedBox(
                        height: RouteManager.width / 15,
                      ),
                      SizedBox(
                        height: RouteManager.height / 1.3,
                        child: ListView.builder(
                          itemCount: Provider.of<StartShiftPro>(context)
                              .vehicles
                              .length,
                          itemBuilder: (cont, ind) {
                            return Column(
                              children: [
                                InkWell(
                                  onTap: () {
                                    if (Provider.of<StartShiftPro>(cont,
                                                listen: false)
                                            .selectedvehicleid ==
                                        Provider.of<StartShiftPro>(cont,
                                                listen: false)
                                            .vehicles[ind]
                                            .id) {
                                      Provider.of<StartShiftPro>(cont,
                                              listen: false)
                                          .selectedvehicleid = -1;
                                      Provider.of<StartShiftPro>(cont,
                                              listen: false)
                                          .notifyListenerz();
                                      return;
                                    }
                                    Provider.of<StartShiftPro>(cont,
                                                listen: false)
                                            .selectedvehicleid =
                                        Provider.of<StartShiftPro>(cont,
                                                listen: false)
                                            .vehicles[ind]
                                            .id;
                                    Provider.of<StartShiftPro>(cont,
                                            listen: false)
                                        .notifyListenerz();
                                  },
                                  child: SizedBox(
                                    width: RouteManager.width,
                                    // alignment: Alignment.center,
                                    // color: Colors.red,
                                    child: Card(
                                      color: Provider.of<StartShiftPro>(cont)
                                                  .selectedvehicleid ==
                                              Provider.of<StartShiftPro>(cont)
                                                  .vehicles[ind]
                                                  .id
                                          ? const Color(0xfffebd23)
                                          : AppColors.of(context).primaryColor,
                                      elevation: 3,
                                      child: Stack(
                                        children: [
                                          Column(
                                            children: [
                                              SizedBox(
                                                height: RouteManager.width / 23,
                                              ),
                                              SizedBox(
                                                height: RouteManager.width / 40,
                                              ),
                                              Row(
                                                children: [
                                                  SizedBox(
                                                      width:
                                                          RouteManager.width /
                                                              23),
                                                  Text(
                                                    Provider.of<StartShiftPro>(
                                                            cont)
                                                        .vehicles[ind]
                                                        .make
                                                        .toString(),
                                                    style: TextStyle(
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      fontSize:
                                                          RouteManager.width /
                                                              20,
                                                      color: Theme.of(context).secondaryHeaderColor,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                              SizedBox(
                                                height: RouteManager.width / 40,
                                              ),
                                              Row(
                                                children: [
                                                  SizedBox(
                                                      width:
                                                          RouteManager.width /
                                                              23),
                                                  Text(
                                                    Provider.of<StartShiftPro>(
                                                            cont)
                                                        .vehicles[ind]
                                                        .model
                                                        .toString(),
                                                    style: TextStyle(
                                                      fontSize:
                                                          RouteManager.width /
                                                              20,
                                                      color: Theme.of(context).secondaryHeaderColor,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                              SizedBox(
                                                height: RouteManager.width / 40,
                                              ),
                                            ],
                                          ),
                                          Column(
                                            children: [
                                              SizedBox(
                                                  height:
                                                      RouteManager.width / 23),
                                              Row(
                                                children: [
                                                  SizedBox(
                                                      width:
                                                          RouteManager.width /
                                                              1.2),
                                                  Container(
                                                    decoration:
                                                    BoxDecoration(
                                                      color: AppColors.of(context).secondaryColor,
                                                      borderRadius:
                                                          const BorderRadius.all(
                                                              Radius.circular(
                                                                  7)),
                                                    ),
                                                    width:
                                                        RouteManager.width / 15,
                                                    height:
                                                        RouteManager.width / 15,
                                                    child: Provider.of<StartShiftPro>(
                                                                    context)
                                                                .selectedvehicleid ==
                                                            Provider.of<StartShiftPro>(
                                                                    context)
                                                                .vehicles[ind]
                                                                .id
                                                        ? const Icon(
                                                            Icons.check,
                                                          )
                                                        : const SizedBox(),
                                                  ),
                                                ],
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                                SizedBox(
                                  height: RouteManager.width / 23,
                                ),
                              ],
                            );
                          },
                        ),
                      ),
                      InkWell(
                        onTap: () async {
                          await _handleLocationPermission(context);
                          API.startShift(
                            Provider.of<HomePro>(context, listen: false).userid,
                            context,
                          ).then((value) {
                            API.postlocation = true;
                            Provider.of<StartShiftPro>(context, listen: false)
                                .selectedvehicleid = -1;
                            Navigator.of(context, rootNavigator: true).pop();
                          });
                        },
                        child: Container(
                          height: 50,
                          width: 320,
                          decoration: BoxDecoration(
                            border: Border.all(
                              color: const Color(0xfffebd23),
                            ),
                            color: const Color(0xfffebd23),
                            borderRadius: BorderRadius.circular(5),
                          ),
                          child: Center(
                            child: Text("Start Shift",
                                style: TextStyle(
                                  color: AppColors.of(context).secondaryColor,
                                  fontSize: RouteManager.width / 12,
                                  fontWeight: FontWeight.bold,
                                )),
                          ),
                        ),
                      ),
                    ],
                  ),
      ),
    );
  }
}
