import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../Api & Routes/routes.dart';
import '../../Entities/jobsobject.dart';
import '../../providers/homepro.dart';
import '../constance/constance.dart';
import '../drawer/drawer.dart';
import '../Language/appLocalizations.dart';
import 'package:http/http.dart'as http;
import '../jobs/completeJobDetailsScreen.dart';
import '../jobs/completedjobs.dart';
class EarningScreen extends StatefulWidget {
  const EarningScreen({super.key});

  @override
  _HistoryScreenState createState() => _HistoryScreenState();
}

class _HistoryScreenState extends State<EarningScreen> {
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  dynamic earningDetails;
  late List<bool> isSelected;
  bool isLoading = true;
  Future<void> fetchData() async {
    try {
      var request = http.MultipartRequest(
        'POST',
        Uri.parse("https://minicab.imdispatch.co.uk/api/get_user_job_info"),
      );
      request.headers.addAll({
        'Content-type': 'multipart/form-data',
        'Accept': 'application/json',
        'token': Provider.of<HomePro>(context, listen: false).token,
      });
      request.fields.addAll({
        'id': Provider.of<HomePro>(context, listen: false).userid.toString(),
        'todate': DateFormat('yyyy-MM-dd').format(toDate),
        'frmdate':DateFormat('yyyy-MM-dd').format(fromDate)
      });
      http.StreamedResponse response =
      await request.send().timeout(const Duration(seconds: 25), onTimeout: () {
        throw "TimeOut";
      });
      var responsed = await http.Response.fromStream(response);

      if (responsed.statusCode == 401) {
        SharedPreferences prefs = await SharedPreferences.getInstance();
        await prefs.clear();
        Navigator.of(context).pushNamedAndRemoveUntil(
          Routes.LOGIN,
              (route) => false,
        );
      }
      else if (responsed.statusCode == 200) {
        var jsonResponse = json.decode(responsed.body);
        print('Shift:::::::::::::::::::::::::::::::::::::::$jsonResponse');
        if(jsonResponse['status'] == '404'){
          isLoading = false;
          earningDetails = [];
          setState(() {

          });
        }
        earningDetails =jsonResponse['Userdata'];
        completedJobs = [];
        for (var i in jsonResponse['Userdata']["booking"]) {
          completedJobs.add(JobObject(
              i['BM_JOB_NO'],
              int.parse(i["BM_SN"]),
              i["CUS_NAME"]??"No Data",
              i["CUS_PHONE"]??"No Data",
              i["BM_PICKUP"]??"No Data",
              i["BM_DROP"]??"No Data",
              int.parse(i["BM_PASSENGER"]),
              i["BM_LAGGAGE"] == "1"
                  ? "Large"
                  : i["BM_LAGGAGE"] == "2"
                  ? "Small"
                  : "Hand Carry",
              i["BM_PAY_METHOD"] == "1"
                  ? "Cash"
                  : i["BM_PAY_METHOD"] == "2"
                  ? "Card"
                  : "Account",
              i["total_amount"],
              DateTime(
                int.parse(i["BM_DATE"].split(' ')[0].split('-')[0]),
                int.parse(i["BM_DATE"].split(' ')[0].split('-')[1]),
                int.parse(i["BM_DATE"].split(' ')[0].split('-')[2]),
                int.parse(i["BM_DATE"].split(' ')[1].split(':')[0]),
                int.parse(i["BM_DATE"].split(' ')[1].split(':')[1]),
                int.parse(i["BM_DATE"].split(' ')[1].split(':')[2]),
              ),
              i["BM_PICKUP_NOTE"] ?? "Default Pickup Note",
              i["BM_DROP_NOTE"] ?? "Default Drop Note",
              double.parse(i["BM_PLAT"]?? '0'),
              double.parse(i["BM_PLANG"]?? '0'),
              double.parse(i["BM_DLAT"]?? '0'),
              double.parse(i["BM_DLANG"]?? '0'),
              i["BM_DISTANCE"].toString(),
              i["BM_DISTANCE_TIME"].toString(),
              i["FLIGHT_NUMBER"].toString()
          ),);
        }
        isLoading = false;
        setState(() {
        });
      } else {
        print('Request failed with status: ${responsed.statusCode}');
      }
    } catch (e) {
      print('Error fetching data: $e');
    }
  }
  DateTime fromDate = DateTime.now();
  DateTime toDate = DateTime.now();
  @override
  void initState() {
    super.initState();
    isSelected = [false, false, false];
    fetchData();
  }

  @override
  Widget build(BuildContext context) {
    RouteManager.context=context;
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
      key: _scaffoldKey,
      drawer: SizedBox(
        width: MediaQuery.of(context).size.width * 0.75 < 400 ? MediaQuery.of(context).size.width * 0.75 : 350,
        child: const Drawer(
          child: AppDrawer(
            selectItemName: 'Earnings',
          ),
        ),
      ),
      appBar: AppBar(
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        automaticallyImplyLeading: false,
        title: Row(
          children: <Widget>[
            SizedBox(
              height: AppBar().preferredSize.height,
              width: AppBar().preferredSize.height + 40,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Container(
                  alignment: Alignment.centerLeft,
                  child: GestureDetector(
                    onTap: () {
                      _scaffoldKey.currentState!.openDrawer();
                    },
                    child: Icon(
                      Icons.dehaze,
                      color: Theme.of(context).textTheme.titleLarge!.color,
                    ),
                  ),
                ),
              ),
            ),
            Expanded(
              child: Text(
                AppLocalizations.of('Earnings'),
                style: Theme.of(context).textTheme.titleLarge!.copyWith(
                  fontWeight: FontWeight.bold,
                  color: Theme.of(context).textTheme.titleLarge!.color,
                ),
                textAlign: TextAlign.center,
              ),
            ),
            SizedBox(
              height: AppBar().preferredSize.height,
              width: AppBar().preferredSize.height + 40,
            ),
          ],
        ),
      ),
      body: Column(
        children: <Widget>[
          Container(
            height: 1.5,
            color: Theme.of(context).dividerColor,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ElevatedButton(
                  onPressed: () async {
                    await pickFromDate();
                    setState(() {

                    });
                  },
                  child: Text(DateFormat('dd-MM-yyyy').format(fromDate))),
              const SizedBox(width: 10,),
              ElevatedButton(
                  onPressed: () async {
                    await pickToDate();
                    fetchData();
                  },
                  child: Text(DateFormat('dd-MM-yyyy').format(toDate))),
            ],
          ),
          myButtons(),
          earningDetails.isEmpty
              ? const Center(child: Text('No Shift Found!!!'))
              :jobsAndEarns(),
          completedJobs.isEmpty? isLoading? const Center(child: CircularProgressIndicator())
              : Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  "No Jobs Taken Yet",
                  style: TextStyle(
                    fontSize: RouteManager.width / 20,
                    color: const Color.fromARGB(255, 54, 54, 54),
                  ),
                ),
              ],
            ),
          )
              : Expanded(
            child: Column(
              children:[
                const SizedBox(
                  height: 10,
                ),
                Expanded(
                  child: ListView.builder(
                    itemCount: completedJobs.length,
                    itemBuilder: (context, index) {
                      var item = completedJobs[index];
                      return Column(
                        children:[
                          Padding(
                            padding: const EdgeInsets.only(right: 6, left: 6),
                            child: InkWell(
                              highlightColor: Colors.transparent,
                              splashColor: Colors.transparent,
                              onTap: () {
                                // Navigator.push(context, MaterialPageRoute(builder: (context) => UserDetailScreen(userId: 1,),),);
                              },
                              child: Container(
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadiusDirectional.circular(16),
                                  color: Theme.of(context).scaffoldBackgroundColor,
                                ),
                                child: Column(
                                  children: <Widget>[
                                    Container(
                                      decoration: const BoxDecoration(
                                        borderRadius: BorderRadiusDirectional.only(topEnd: Radius.circular(16), topStart: Radius.circular(16)),
                                      ),
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
                                                Row(
                                                  children: <Widget>[
                                                    Container(
                                                      height: 24,
                                                      width: 100,
                                                      decoration: BoxDecoration(
                                                        borderRadius: const BorderRadius.all(
                                                          Radius.circular(15),
                                                        ),
                                                        color: Theme.of(context).primaryColor,
                                                      ),
                                                      child: Center(
                                                        child: Text(
                                                          AppLocalizations.of(item.phn),
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
                                                        borderRadius: const BorderRadius.all(
                                                          Radius.circular(15),
                                                        ),
                                                        color: Theme.of(context).primaryColor,
                                                      ),
                                                      child: Center(
                                                        child: Text(
                                                          AppLocalizations.of(item.paymentmethod),
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
                                                  '£${item.total_amount}',
                                                  style: Theme.of(context).textTheme.titleLarge!.copyWith(
                                                    fontWeight: FontWeight.bold,
                                                    color: Theme.of(context).textTheme.titleLarge!.color,
                                                  ),
                                                ),
                                                Text('${item.distance}km',
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
                                    ),
                                    Container(
                                      height: 1,
                                      width: MediaQuery.of(context).size.width,
                                      color: Theme.of(context).dividerColor,
                                    ),
                                    Padding(
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
                                              const SizedBox(
                                                height: 4,
                                              ),
                                              Text(
                                                AppLocalizations.of(item.pickupadress),
                                                style: Theme.of(context).textTheme.labelMedium!.copyWith(
                                                  fontWeight: FontWeight.bold,
                                                  color: Theme.of(context).textTheme.titleLarge!.color,
                                                ),
                                                overflow: TextOverflow.ellipsis,
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.only(right: 14, left: 14),
                                      child: Container(
                                        height: 1,
                                        width: MediaQuery.of(context).size.width,
                                        color: Theme.of(context).dividerColor,
                                      ),
                                    ),
                                    Padding(
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
                                              const SizedBox(
                                                height: 4,
                                              ),
                                              Text(
                                                AppLocalizations.of(item.dropaddress),
                                                style: Theme.of(context).textTheme.labelMedium!.copyWith(
                                                  fontWeight: FontWeight.bold,
                                                  color: Theme.of(context).textTheme.titleLarge!.color,
                                                ),
                                                overflow: TextOverflow.ellipsis,
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                    ),
                                    Container(
                                      height: 1,
                                      width: MediaQuery.of(context).size.width,
                                      color: Theme.of(context).dividerColor,
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.only(right: 14, left: 14, top: 16),
                                      child: InkWell(
                                        onTap:(){
                                          Navigator.of(context).push(MaterialPageRoute(builder: (context) => CompleteJobsDetailScreen(item:item)));
                                        },
                                        child: Container(
                                          height: 40,
                                          decoration: BoxDecoration(
                                            borderRadius: BorderRadius.circular(10),
                                            color: Theme.of(context).primaryColor,
                                          ),
                                          child: Center(
                                            child: Text(
                                              AppLocalizations.of('Show Details'),
                                              style: Theme.of(context).textTheme.labelLarge!.copyWith(
                                                fontWeight: FontWeight.bold,
                                                color: ConstanceData.secoundryFontColor,
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                    const SizedBox(
                                      height: 16,
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(
                            height: 16,
                          ),
                        ],
                      );
                    },
                  ),
                ),
                SizedBox(
                  height: MediaQuery.of(context).padding.bottom + 16,
                )
              ],
            ),
          )
        ],
      ),
    );
  }
  Widget myButtons() {
    return StatefulBuilder(
      builder: (context, setState) {
        return Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ToggleButtons(
                onPressed: (int index) {
                  setState(() {
                    for (int buttonIndex = 0; buttonIndex < isSelected.length; buttonIndex++) {
                      isSelected[buttonIndex] = (buttonIndex == index);
                    }

                    if (index == 0) {
                      fromDate = DateTime.now();
                      toDate = DateTime.now();
                    } else if (index == 1) {
                      fromDate = DateTime.now().subtract(const Duration(days: 7));
                      toDate = DateTime.now();
                    } else if (index == 2) {
                      fromDate = DateTime.now().subtract(const Duration(days: 30));
                      toDate = DateTime.now();
                    }else{

                    }
                    fetchData();
                  });
                },
                isSelected: isSelected,
                borderRadius: BorderRadius.circular(8.0),
                fillColor: Theme.of(context).primaryColor,
                selectedColor: ConstanceData.secoundryFontColor,
                color: Theme.of(context).primaryColor,
                selectedBorderColor: Theme.of(context).primaryColor,
                borderColor: Colors.grey,
                children: const <Widget>[
                  Padding(
                    padding: EdgeInsets.all(8.0),
                    child: Text('Today'),
                  ),
                  Padding(
                    padding: EdgeInsets.all(8.0),
                    child: Text('This Week'),
                  ),
                  Padding(
                    padding: EdgeInsets.all(8.0),
                    child: Text('This Month'),
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }

  Future<void> pickFromDate() async {
    final DateTime? picked = await showDatePicker(
      context: context,
      firstDate: DateTime(2020),
      lastDate: DateTime(2030),
    );
    if (picked != null && picked != fromDate) {
      setState(() {
        fromDate = picked;
      });
    }
  }

  Future<void> pickToDate() async {
    final DateTime? picked = await showDatePicker(
      context: context,
      firstDate: DateTime(2022),
      lastDate: DateTime(2030),
    );
    if (picked != null && picked != toDate) {
      setState(() {
        toDate = picked;
      });
      fetchData(); // Add this line to fetch data when toDate is changed
    }
  }
  Widget jobsAndEarns() {
    return Padding(
      padding: const EdgeInsets.all(8),
      child: Column(
        children: [
          Row(
            children: <Widget>[
              Expanded(
                child: Container(
                  decoration: BoxDecoration(
                    color: Theme.of(context).primaryColor,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Row(
                      children: <Widget>[
                        const Icon(
                          FontAwesomeIcons.carAlt,
                          size: 20,
                          color: ConstanceData.secoundryFontColor,
                        ),
                        const SizedBox(
                          width: 10,
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Row(
                              children: [
                                Text(
                                  AppLocalizations.of('Today Jobs: '),
                                  style: Theme.of(context).textTheme.labelLarge!.copyWith(
                                    fontWeight: FontWeight.bold,
                                    color: ConstanceData.secoundryFontColor,
                                  ),
                                ),
                                Text('${earningDetails['totalTodayBooking']}',
                                  style: Theme.of(context).textTheme.titleLarge!.copyWith(
                                    fontWeight: FontWeight.bold,
                                    color: ConstanceData.secoundryFontColor,
                                  ),
                                ),
                              ],
                            ),
                            Row(
                              children: [
                                Text(
                                  AppLocalizations.of('Total Jobs:   '),
                                  style: Theme.of(context).textTheme.labelLarge!.copyWith(
                                    fontWeight: FontWeight.bold,
                                    color: ConstanceData.secoundryFontColor,
                                  ),
                                ),
                                Text('${earningDetails['totalAccountjob']}',
                                  style: Theme.of(context).textTheme.titleLarge!.copyWith(
                                    fontWeight: FontWeight.bold,
                                    color: ConstanceData.secoundryFontColor,
                                  ),
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
              const SizedBox(
                width: 8,
              ),
              Expanded(
                child: Container(
                  decoration: BoxDecoration(
                      color: ConstanceData.secoundryFontColor,
                      borderRadius: BorderRadius.circular(5),
                      border: Border.all(
                        color: Theme.of(context).primaryColor,
                      )),
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Row(
                      children: <Widget>[
                        Icon(
                          FontAwesomeIcons.dollarSign,
                          size: 30,
                          color: Theme.of(context).primaryColor,
                        ),
                        const SizedBox(
                          width: 5,
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Text(
                              'Cash: ${earningDetails['totalCashjob']} £\nAccount: ${earningDetails['totalAccountjob']} £',
                              style: Theme.of(context).textTheme.titleSmall!.copyWith(
                                fontWeight: FontWeight.bold,
                                color: Theme.of(context).primaryColor,
                              ),
                            ),
                          ],
                        )
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

