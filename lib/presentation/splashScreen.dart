import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart'as http;
import 'package:animator/animator.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../Api & Routes/api.dart';
import '../Api & Routes/routes.dart';
import '../providers/homepro.dart';
import 'Language/LanguageData.dart';
import 'constance/constance.dart' as constance;
import 'constance/constance.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> with TickerProviderStateMixin {
  late AnimationController controller;
  late Animation<double> animation;
  Future<void>getUserInfo(int userId)async {
    var headers = {
      'token': Provider.of<HomePro>(context, listen: false).token,
    };
    var request = http.MultipartRequest('POST', Uri.parse('https://minicab.imdispatch.co.uk/api/getsingleuserdetail'));
    request.fields.addAll({
      'driver_id': userId.toString(),
    });

    request.headers.addAll(headers);

    http.StreamedResponse response = await request.send();

    if (response.statusCode == 200) {
      String responseData = await response.stream.bytesToString();
      handleSuccessResponse(responseData);
    }
    else {
      if (kDebugMode) {
        print(response.reasonPhrase);
      }
    }

  }
  void handleSuccessResponse(String responseData) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    Map<String, dynamic> responseMap = json.decode(responseData);
    Map<String, dynamic> userData = responseMap['Userdata'];
    print(userData.toString());
    totalHours = userData['totalHours'].toString();
    totalTodayBooking = userData['totalTodayBooking'].toString();
    totalEarning = userData['totalEarning'].toString();
    totalDistance = userData['totalDistance'].toString();
    userName = userData['userName'];
    prefs.setString('totalHours', totalHours);
    prefs.setString('totalTodayBooking', totalTodayBooking);
    prefs.setString('totalEarning', totalEarning);
    prefs.setString('totalDistance', totalDistance);
    prefs.setString('userName', userName);
    print('User INFOOOOOOOOOOOOOO Done:::::::::::::::::::');
  }

  @override
  initState() {
    super.initState();
    myContext = context;
    controller = AnimationController(
        duration: const Duration(milliseconds: 1000),
        animationBehavior: AnimationBehavior.normal,
        vsync: this);
    animation = CurvedAnimation(parent: controller, curve: Curves.easeIn);
    animation.addStatusListener((status) async {
      if (status == AnimationStatus.completed) {
        SharedPreferences prefs = await SharedPreferences.getInstance();
        if (prefs.getString('username') != null && prefs.getString('userid') != null
            && prefs.getString('token') != null) {
          Provider.of<HomePro>(context, listen: false).userid =
              int.parse(prefs.getString('userid').toString());
          Provider.of<HomePro>(context, listen: false).username =
              prefs.getString('username').toString();
          Provider.of<HomePro>(context, listen: false).token =
              prefs.getString('token').toString();
          var val = await API.getShift(
              Provider.of<HomePro>(context, listen: false).userid,
              context);
          if (val) {
            if (Provider.of<HomePro>(context, listen: false)
                .shiftid !=
                -1) {
              API.postlocation = true;
            }
          }
          await getUserInfo(Provider.of<HomePro>(context, listen: false).userid);
          Navigator.pushReplacementNamed(context, Routes.HOME);
        }else
          Navigator.pushReplacementNamed(context, Routes.LOGIN);
        _loadNextScreen();
      }
    });
    controller.forward();
  }

  late BuildContext myContext;

  _loadNextScreen() async {
    if (mounted) return;
    constance.allTextData = AllTextData.fromJson(json.decode(await DefaultAssetBundle.of(myContext).loadString("jsonFile/languagetext.json")));
    Navigator.pushReplacementNamed(context, Routes.ENABLELOCATION);
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Theme.of(context).primaryColor,
        body: Center(
          child: Column(
            children: <Widget>[
              const Expanded(
                child: SizedBox(),
                flex: 1,
              ),
              FadeTransition(
                opacity: animation,
                child: Container(
                  height: 100,
                  width: 100,
                  decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.background,
                    borderRadius: BorderRadius.circular(22),
                  ),
                  child: Image.asset(
                    ConstanceData.taxi,
                    fit: BoxFit.cover,
                    height: 100,
                    width: 100,
                    color: Theme.of(context).primaryColor,
                  ),
                ),
              ),
              SizedBox(
                height: 2.1,
              ),
              Container(
                height: 1,
                width: 90,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.7),
                      blurRadius: 5,
                    ),
                  ],
                ),
              ),
              const SizedBox(
                height: 10,
              ),
              FadeTransition(
                opacity: animation,
                child: Text(
                  'MyCab Driver',
                  style: Theme.of(context).textTheme.headlineMedium!.copyWith(
                    color: Theme.of(context).colorScheme.background,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              Expanded(
                child: SizedBox(),
                flex: 2,
              ),
              CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(Theme.of(context).colorScheme.background),
                strokeWidth: 2,
              ),
              Animator<Offset>(
                tween: Tween<Offset>(
                  begin: const Offset(0, 0.4),
                  end: const Offset(0, 0),
                ),
                duration: const Duration(seconds: 1),
                cycles: 1,
                builder: (context, animate, _) => SlideTransition(
                  position: animate.animation,
                  child: Image.asset(
                    ConstanceData.splashBackground,
                    fit: BoxFit.cover,
                    color: Colors.white.withOpacity(0.2),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
String totalHours = '';
String totalTodayBooking = '';
String totalEarning = '';
String totalDistance = '';
String userName = '';