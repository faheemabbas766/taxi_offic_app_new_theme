import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_ringtone_player/flutter_ringtone_player.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../Api & Routes/api.dart';
import '../../Api & Routes/routes.dart';
import '../../Entities/jobsobject.dart';
import '../../pages/home.dart';
import '../../providers/currentjobspro.dart';
import '../../providers/homepro.dart';
import '../appTheme.dart';
import '../constance/constance.dart';
import '../Language/appLocalizations.dart';

class UserDetailScreen extends StatefulWidget {
  final JobObject item;
  const UserDetailScreen({super.key, required this.item});
  @override
  _UserDetailScreenState createState() => _UserDetailScreenState();
}

class _UserDetailScreenState extends State<UserDetailScreen> {
  Future<void> getMyCurrentJobs() async {
    if (mounted) {
      while (true) {
        final currentJobsPro = Provider.of<CurrentJobsPro>(context, listen: false);
        currentJobsPro.isloaded = false;
        currentJobsPro.notifyListenerz();
        final homePro = Provider.of<HomePro>(context, listen: false);
        final val = await API.getCurrentJobs(homePro.userid, context);
        if (val) {
          currentJobsPro.isloaded = true;
          currentJobsPro.notifyListenerz();
          break;
        }
      }
    }
  }
  dynamic list;
  bool listLoad = true;
  int index = 0;
  bool isLoading = false;
  Future<void> fetchData() async {
    var fetchedList = await API.getJobDetails(
        Provider.of<CurrentJobsPro>(context, listen: false).jobs[index].bookid.toString(), context);
    list = fetchedList;
    listLoad = false;
    setState(() {});
  }

  @override
  void initState() {
    super.initState();
    fetchData();
  }
  @override
  Widget build(BuildContext context) {
    RouteManager.context=context;
    JobObject item = widget.item;
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
      appBar: AppBar(
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        automaticallyImplyLeading: false,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            InkWell(
              highlightColor: Colors.transparent,
              splashColor: Colors.transparent,
              onTap: () {
                Navigator.of(context).pop();
              },
              child: SizedBox(
                child: Icon(
                  Icons.arrow_back_ios,
                  color: Theme.of(context).textTheme.titleLarge!.color,
                ),
              ),
            ),
            Text('#${item.invoiceId}', style: Theme.of(context).textTheme.titleLarge!.copyWith(
                    fontWeight: FontWeight.bold,
                    color: Theme.of(context).textTheme.titleLarge!.color,
                  ),
            ),
            const SizedBox(
              width: 20,
            ),
          ],
        ),
      ),
      body: Column(
        children: <Widget>[
          Expanded(
            child: ListView(
              children: <Widget>[
                userDetailbar(item,context),
                listLoad? const Center(child: CircularProgressIndicator(),)
                    :Container(
                  color: HexColor('#F4F6F7'),
                  height: RouteManager.height / 3,
                  child: ListView.builder(
                    itemCount: list.length,
                    itemBuilder: (context, index) {
                      Map<String, dynamic> destination = list[index];
                      bool isFirstStop = index == 0;
                      bool isLastStop = index == list.length - 1;
                      String title;
                      Color navigationColor;
                      String address =
                          destination['BD_LOCATION'] ?? "No Location";

                      if (isFirstStop) {
                        title = "Pick Up";
                        navigationColor = Colors.green;
                      } else if (isLastStop) {
                        title = "Destination";
                        navigationColor = Colors.red;
                      } else {
                        title = "Stop $index";
                        navigationColor = Colors.blue;
                      }
                      return Column(
                        children: [
                          Container(
                            color: Theme.of(context).primaryColorDark,
                            child: Padding(
                              padding: const EdgeInsets.only(right: 14, left: 14),
                              child: Container(
                                height: 1,
                                width: MediaQuery.of(context).size.width,
                                color: Theme.of(context).dividerColor,
                              ),
                            ),
                          ),
                          Container(
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(4)
                            ),
                            child: ListTile(
                              title: Text(
                                title,
                                style: Theme.of(context).textTheme.bodySmall!.copyWith(
                                  color: Theme.of(context).disabledColor,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              subtitle: Column(
                                crossAxisAlignment:
                                CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    address,
                                    style: Theme.of(context).textTheme.titleSmall!.copyWith(
                                      fontWeight: FontWeight.bold,
                                      color: Theme.of(context).textTheme.titleLarge!.color,
                                    ),
                                  ),
                                ],
                              ),
                              trailing: IconButton(
                                icon: Icon(Icons.navigation_rounded,
                                    color: navigationColor),
                                onPressed: () {
                                  openGoogleMapsNavigationToDestination(
                                    double.parse(destination['BD_LAT']),
                                    double.parse(destination['BD_LANG']),
                                  );
                                },
                              ),
                            ),
                          ),
                          title=='Destination'?Container(
                            height: 1,
                            width: MediaQuery.of(context).size.width,
                            color: Theme.of(context).dividerColor,
                          ): Container()
                        ],
                      );
                    },
                  ),
                ),
                Container(
                  color: Theme.of(context).scaffoldBackgroundColor,
                  child: Padding(
                    padding: const EdgeInsets.only(right: 14, left: 14),
                    child: Flex(
                      direction: Axis.vertical,
                      children: [
                        MySeparator(
                          color: Theme.of(context).primaryColor,
                          height: 1,
                        ),
                      ],
                    ),
                  ),
                ),
                noted(item,context),
                Container(
                  color: Theme.of(context).scaffoldBackgroundColor,
                  child: Padding(
                    padding: const EdgeInsets.only(right: 14, left: 14),
                    child: Flex(
                      direction: Axis.vertical,
                      children: [
                        MySeparator(
                          color: Theme.of(context).primaryColor,
                          height: 1,
                        ),
                      ],
                    ),
                  ),
                ),
                contact(item,context),
                isLoading? const Center(child: CircularProgressIndicator())
                    :pickup(item,context),

              ],
            ),
          ),
          SizedBox(
            height: MediaQuery.of(context).padding.bottom,
          )
        ],
      ),
    );
  }

  Widget pickup(JobObject item, BuildContext context) {
    return Container(
      color: Theme.of(context).scaffoldBackgroundColor,
      child: Padding(
        padding: const EdgeInsets.only(right: 14, left: 14, top: 16, bottom: 16),
        child: InkWell(
          highlightColor: Colors.transparent,
          splashColor: Colors.transparent,
          // onTap: () {
          //
          //   // Navigator.push(
          //   //   context,
          //   //   MaterialPageRoute(
          //   //     builder: (context) => PickupScreen(),
          //   //   ),
          //   // );
          // },
          onTap: () {
            setState(() {
              FlutterRingtonePlayer().stop();
              isLoading = true;
            });
            if (kDebugMode) {
              print(Provider.of<CurrentJobsPro>(context, listen: false).jobs[index].status);
            }
            int mapStatus(int currentStatus) {
              if (currentStatus == 1){
                return 2;
              } else if(currentStatus == 2) {
                return 11;
              } else if (currentStatus == 11) {
                return 9;
              } else if (currentStatus == 9) {
                return 6;
              } else {
                return currentStatus;
              }
            }
            API.respondToBooking(
                Provider.of<CurrentJobsPro>(context, listen: false).jobs[index].bookid,
                mapStatus(Provider.of<CurrentJobsPro>(context, listen: false).jobs[index].status) ,
                context).then(
                  (value) async {
                if (value) {
                  if(Provider.of<CurrentJobsPro>(context, listen: false).jobs[index].status==9){
                    await getMyCurrentJobs();
                    Navigator.pop(context);
                  }
                  Provider.of<CurrentJobsPro>(context, listen: false).notifyListenerz();
                }
                await fetchData();
                await getMyCurrentJobs();
                isLoading = false;
                setState(() {
                });
              },
            );
          },
          child: Container(
            height: 40,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              color: Theme.of(context).primaryColor,
            ),
            child: Center(
              child: Text(
                AppLocalizations.of((Provider.of<CurrentJobsPro>(context).jobs[index].status == 1)
                    ? 'Accept'
                    : (Provider.of<CurrentJobsPro>(context).jobs[index].status == 2)
                    ? 'Arrived'
                    : (Provider.of<CurrentJobsPro>(context).jobs[index].status == 11)
                    ? 'POB'
                    : 'Finish'),
                style: Theme.of(context).textTheme.labelLarge!.copyWith(
                  fontWeight: FontWeight.bold,
                  color: ConstanceData.secoundryFontColor,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
void _launchPhoneDialer(String phoneNumber) async {
  String url = 'tel:$phoneNumber';
  try {
    await launch(url);
  } on PlatformException catch (e) {
    print("Failed to launch Phone: $e");
  }
}
void _launchMessageApp(String phoneNumber) async {
  String url = 'sms:$phoneNumber';
  try {
    await launch(url);
  } on PlatformException catch (e) {
    if (kDebugMode) {
      print("Failed to launch SMS: $e");
    }
  }
}

Widget contact(JobObject item, BuildContext context) {
  return InkWell(
    onTap:(){
      _launchPhoneDialer(item.phn);
    },
    child: Container(
      color: Theme.of(context).scaffoldBackgroundColor,
      child: Padding(
        padding: const EdgeInsets.all(14),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: <Widget>[
            Container(
              height: 70,
              width: 80,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(16),
                color: HexColor("#4CE4B1"),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  const Icon(
                    Icons.call,
                    color: Colors.white,
                  ),
                  const SizedBox(
                    height: 8,
                  ),
                  Text(
                    AppLocalizations.of('Call'),
                    style: Theme.of(context).textTheme.labelLarge!.copyWith(
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
            ),
            InkWell(
              onTap: (){
                print('Message Printed!!!!!!!!!!!');
                _launchMessageApp(item.phn);
              },
              child: Container(
                height: 70,
                width: 80,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(16),
                  color: HexColor("#4252FF"),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    const Icon(
                      FontAwesomeIcons.facebookMessenger,
                      color: Colors.white,
                    ),
                    const SizedBox(
                      height: 8,
                    ),
                    Text(
                      AppLocalizations.of('Message'),
                      style: Theme.of(context).textTheme.labelLarge!.copyWith(
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            InkWell(
              onTap: () {
                FlutterRingtonePlayer().stop();
                API.showLoading("", context);
                API.respondToBooking(item.bookid, 7, context).then((value) async {
                  Navigator.of(context, rootNavigator: true).pop();
                  Navigator.pushReplacementNamed(context, Routes.HOME);
                  await FlutterRingtonePlayer().play(fromAsset: 'assets/cancel_tone.wav');
                },
                );
              },
              child: Container(
                height: 70,
                width: 80,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(16),
                  color: HexColor("#BEC2CE"),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    const Icon(
                      Icons.delete_forever,
                      color: Colors.white,
                    ),
                    Text(
                      AppLocalizations.of(AppLocalizations.of(Provider.of<CurrentJobsPro>(context, listen: false).jobs[0].status==1?'Reject':'Cancel')),
                      style: Theme.of(context).textTheme.labelLarge!.copyWith(
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    ),
  );
}

Widget tripFare(JobObject item, BuildContext context) {
  return Container(
    color: Theme.of(context).scaffoldBackgroundColor,
    child: Padding(
      padding: const EdgeInsets.only(right: 14, left: 14, bottom: 8, top: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            AppLocalizations.of('TRIP FARE'),
            style: Theme.of(context).textTheme.bodySmall!.copyWith(
              color: Theme.of(context).disabledColor,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(
            height: 8,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Text(
                AppLocalizations.of('ABC'),
                style: Theme.of(context).textTheme.titleSmall!.copyWith(
                  fontWeight: FontWeight.bold,
                  color: Theme.of(context).textTheme.titleLarge!.color,
                ),
              ),
              Text(
                '\$15.00',
                style: Theme.of(context).textTheme.titleSmall!.copyWith(
                  fontWeight: FontWeight.bold,
                  color: Theme.of(context).textTheme.titleLarge!.color,
                ),
              ),
            ],
          ),
          SizedBox(
            height: 8,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Text(
                AppLocalizations.of(item.paymentmethod),
                style: Theme.of(context).textTheme.titleSmall!.copyWith(
                  fontWeight: FontWeight.bold,
                  color: Theme.of(context).textTheme.titleLarge!.color,
                ),
              ),
              Text(
                '\$10.00',
                style: Theme.of(context).textTheme.titleSmall!.copyWith(
                  fontWeight: FontWeight.bold,
                  color: Theme.of(context).textTheme.titleLarge!.color,
                ),
              ),
            ],
          ),
          const SizedBox(
            height: 8,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Text(
                AppLocalizations.of('Paid amount'),
                style: Theme.of(context).textTheme.titleSmall!.copyWith(
                  fontWeight: FontWeight.bold,
                  color: Theme.of(context).textTheme.titleLarge!.color,
                ),
              ),
              Text(
                '£${item.total_amount}',
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
  );
}

Widget noted(JobObject item, BuildContext context) {
  return Container(
    color: Theme.of(context).scaffoldBackgroundColor,
    child: Padding(
      padding: const EdgeInsets.only(right: 14, left: 14, bottom: 8, top: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Wrap(
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  children: [
                    Text(
                      AppLocalizations.of('Passengers: ${item.passengers}'),
                      style: Theme.of(context).textTheme.bodySmall!.copyWith(
                        fontWeight: FontWeight.bold,
                        color: Theme.of(context).textTheme.titleSmall!.color,
                      ),
                    ),
                    const Spacer(),
                    Text(
                      AppLocalizations.of('Large Luggage: ${item.luggage}'),
                      style: Theme.of(context).textTheme.bodySmall!.copyWith(
                        fontWeight: FontWeight.bold,
                        color: Theme.of(context).textTheme.titleSmall!.color,
                      ),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  children: [
                    Text(
                      AppLocalizations.of('Flight NO: ${item.flightNo}'),
                      style: Theme.of(context).textTheme.bodySmall!.copyWith(
                        fontWeight: FontWeight.bold,
                        color: Theme.of(context).textTheme.titleSmall!.color,
                      ),
                    ),
                    const Spacer(),
                    Text(
                      AppLocalizations.of('Small Luggage: ${item.luggage}'),
                      style: Theme.of(context).textTheme.bodySmall!.copyWith(
                        fontWeight: FontWeight.bold,
                        color: Theme.of(context).textTheme.titleSmall!.color,
                      ),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  children: [
                    Text(
                      AppLocalizations.of('Notes: ${item.pickupnote}${item.dropnote}'),
                      style: Theme.of(context).textTheme.bodySmall!.copyWith(
                        fontWeight: FontWeight.bold,
                        color: Theme.of(context).textTheme.titleSmall!.color,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    ),
  );
}

Widget dropOffAddress(JobObject item, BuildContext context) {
  return Container(
    color: Theme.of(context).scaffoldBackgroundColor,
    child: Padding(
      padding: const EdgeInsets.only(right: 14, left: 14, bottom: 8, top: 8),
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
              SizedBox(
                height: 4,
              ),
              Text(
                AppLocalizations.of(item.dropaddress),
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
  );
}

Widget pickupAddress(JobObject item, BuildContext context) {
  return Container(
    color: Theme.of(context).scaffoldBackgroundColor,
    child: Padding(
      padding: const EdgeInsets.only(right: 14, left: 14, bottom: 8, top: 8),
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
              SizedBox(
                height: 4,
              ),
              Text(
                AppLocalizations.of(item.pickupadress),
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
  );
}

Widget userDetailbar(JobObject item, BuildContext context) {
  return Container(
    color: HexColor("#BEC2CE"),
    child: Padding(
      padding: const EdgeInsets.all(14),
      child: Row(
        children: <Widget>[
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text(
                AppLocalizations.of(item.name),
                style: Theme.of(context).textTheme.titleLarge!.copyWith(
                  fontWeight: FontWeight.bold,
                  color: Theme.of(context).textTheme.titleLarge!.color,
                ),
              ),
              const SizedBox(
                height: 4,
              ),
              Text(DateFormat('dd-MM-yyy').format(DateTime.parse(item.date.toString())),
                style: Theme.of(context).textTheme.titleSmall!.copyWith(
                  fontWeight: FontWeight.bold,
                  color: Theme.of(context).primaryColor,
                ),
              ),
              Text('${DateFormat('HH:mm').format(DateTime.parse(item.date.toString()))} hrs',
                style: Theme.of(context).textTheme.titleSmall!.copyWith(
                  fontWeight: FontWeight.bold,
                  color: Theme.of(context).primaryColor,
                ),
              ),
            ],
          ),
          Spacer(),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: <Widget>[
              Text(
                '£${item.total_amount}',
                style: Theme.of(context).textTheme.headlineLarge!.copyWith(
                  fontWeight: FontWeight.bold,
                  color: Theme.of(context).primaryColor,
                ),
              ),
              Text(
                '${item.distance} Miles',
                style: Theme.of(context).textTheme.titleSmall!.copyWith(
                  fontWeight: FontWeight.bold,
                  color: Theme.of(context).textTheme.titleSmall!.color,
                ),
              ),
              Container(
                height: 24,
                width: 85,
                color: Theme.of(context).primaryColor,
                child: Center(
                  child: Text(
                    AppLocalizations.of(item.paymentmethod),
                    style: Theme.of(context).textTheme.labelLarge!.copyWith(
                      fontWeight: FontWeight.bold,
                      color: ConstanceData.secoundryFontColor,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    ),
  );
}

class MySeparator extends StatelessWidget {
  final double height;
  final Color color;

  const MySeparator({super.key, this.height = 1, this.color = Colors.black});

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (BuildContext context, BoxConstraints constraints) {
        final boxWidth = constraints.constrainWidth();
        const dashWidth = 4.0;
        final dashHeight = height;
        final dashCount = (boxWidth / (2 * dashWidth)).floor();
        return Flex(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          direction: Axis.horizontal,
          children: List.generate(dashCount, (_) {
            return SizedBox(
              width: dashWidth,
              height: dashHeight,
              child: DecoratedBox(
                decoration: BoxDecoration(color: color),
              ),
            );
          }),
        );
      },
    );
  }
}
