import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import '../../Api & Routes/global.dart';
import '../../Api & Routes/routes.dart';
import '../constance/constance.dart';
import '../Language/appLocalizations.dart';

class EnableLocation extends StatefulWidget {
  @override
  _EnableLocationState createState() => _EnableLocationState();
}

class _EnableLocationState extends State<EnableLocation> with TickerProviderStateMixin {
  late AnimationController controller;
  late Animation<double> animation;
  @override
  initState() {
    super.initState();
    controller = AnimationController(duration: const Duration(milliseconds: 700), vsync: this);
    animation = CurvedAnimation(parent: controller, curve: Curves.easeIn);
    controller.forward();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          children: <Widget>[
            const Expanded(
              child: SizedBox(),
              flex: 4,
            ),
            FadeTransition(
              opacity: animation,
              child: Image.asset(
                ConstanceData.enableLocation,
                fit: BoxFit.cover,
                height: 200,
                width: 200,
              ),
            ),
            const Expanded(
              child: SizedBox(),
              flex: 3,
            ),
            Text(
              AppLocalizations.of('Enable Your Location'),
              style: Theme.of(context).textTheme.headlineMedium!.copyWith(
                    color: Theme.of(context).textTheme.titleLarge!.color,
                    fontWeight: FontWeight.bold,
                  ),
              textAlign: TextAlign.center,
            ),
            Padding(
              padding: EdgeInsets.only(left: 14, right: 14),
              child: Text(
                AppLocalizations.of('Turn on your location and permission to continue.'),
                style: Theme.of(context).textTheme.titleSmall!.copyWith(
                      color: Theme.of(context).textTheme.titleLarge!.color,
                    ),
                textAlign: TextAlign.center,
              ),
            ),
            Expanded(
              child: SizedBox(),
              flex: 2,
            ),
            Padding(
              padding: EdgeInsets.only(right: 50, left: 50),
              child: InkWell(
                highlightColor: Colors.transparent,
                splashColor: Colors.transparent,
                onTap: () async {
                  if(await Global.handleLocationPermission(context))
                    Navigator.pushReplacementNamed(context, Routes.LOGIN);
                  else
                    print('Field to on Location....');
                },
                child: Container(
                  height: 40,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color: Theme.of(context).primaryColor,
                  ),
                  child: Center(
                    child: Text(
                      AppLocalizations.of('USE MY LOCATION'),
                      style: Theme.of(context).textTheme.labelLarge!.copyWith(
                            fontWeight: FontWeight.bold,
                            color: ConstanceData.secoundryFontColor,
                          ),
                    ),
                  ),
                ),
              ),
            ),
            Expanded(
              child: SizedBox(),
              flex: 1,
            ),
            SizedBox(
              height: 20,
            ),
          ],
        ),
      ),
    );
  }
}
