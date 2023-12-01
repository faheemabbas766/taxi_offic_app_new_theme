import 'dart:convert';

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
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> with TickerProviderStateMixin {
  late AnimationController controller;
  late Animation<double> animation;

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
    return Scaffold(
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
                begin: Offset(0, 0.4),
                end: Offset(0, 0),
              ),
              duration: Duration(seconds: 1),
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
    );
  }
}
