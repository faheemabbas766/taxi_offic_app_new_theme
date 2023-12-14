import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:taxi_app/presentation/jobs/jobview.dart';
import 'package:taxi_app/presentation/splashScreen.dart';
import '../../Api & Routes/routes.dart';
import '../../providers/homepro.dart';
import '../Language/appLocalizations.dart';
import '../constance/constance.dart';

class AppDrawer extends StatefulWidget {
  final String selectItemName;

  const AppDrawer({super.key, required this.selectItemName});
  @override
  _AppDrawerState createState() => _AppDrawerState();
}

class _AppDrawerState extends State<AppDrawer> {
  String userName = '';
  @override
  void initState() {
    super.initState();
    _loadUserName();
  }
  void _loadUserName() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      userName = prefs.getString('userName') ?? '';
    });
  }
  @override
  Widget build(BuildContext context) {
    RouteManager.context=context;
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
      body: Column(
        children: <Widget>[
          Expanded(
            flex: 1,
            child: Container(
              color: Theme.of(context).primaryColor,
              child: Column(
                children: <Widget>[
                  const Expanded(
                    flex: 2,
                    child: SizedBox(),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(right: 14, left: 14),
                    child: Row(
                      children: <Widget>[
                        CircleAvatar(
                          backgroundColor: Colors.white,
                          radius: 30,
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(50),
                            child: Image.asset(
                              ConstanceData.userImage,
                              fit: BoxFit.fill,
                            ),
                          ),
                        ),
                        const SizedBox(
                          width: 8,
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Text(
                              AppLocalizations.of(userName),
                              style: Theme.of(context)
                                  .textTheme
                                  .titleLarge!
                                  .copyWith(
                                    fontWeight: FontWeight.bold,
                                    color: ConstanceData.secoundryFontColor,
                                  ),
                            ),
                            const SizedBox(
                              height: 4,
                            ),
                            Container(
                              padding: const EdgeInsets.all(2),
                              decoration: BoxDecoration(
                                color:
                                    Theme.of(context).scaffoldBackgroundColor,
                                borderRadius: BorderRadius.circular(16),
                              ),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: <Widget>[
                                  const Icon(
                                    Icons.star,
                                    size: 10,
                                  ),
                                  Text(
                                    'ID-${Provider.of<HomePro>(context, listen: false).userid}',
                                    style: Theme.of(context)
                                        .textTheme
                                        .labelLarge!
                                        .copyWith(
                                          fontWeight: FontWeight.bold,
                                          color: Theme.of(context)
                                              .textTheme
                                              .titleLarge!
                                              .color,
                                        ),
                                  ),
                                ],
                              ),
                            )
                          ],
                        ),
                      ],
                    ),
                  ),
                  const Expanded(
                    flex: 1,
                    child: SizedBox(),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: <Widget>[
                      Column(
                        children: <Widget>[
                          Icon(
                            FontAwesomeIcons.clock,
                            color: ConstanceData.secoundryFontColor,
                            size: 18,
                          ),
                          const SizedBox(
                            height: 4,
                          ),
                          Text(
                            totalHours,
                            style:
                                Theme.of(context).textTheme.titleMedium!.copyWith(
                                      fontWeight: FontWeight.bold,
                                      color: ConstanceData.secoundryFontColor,
                                    ),
                          ),
                          Row(
                            children: <Widget>[
                              Text(
                                AppLocalizations.of('Hour online'),
                                style: Theme.of(context)
                                    .textTheme
                                    .bodySmall!
                                    .copyWith(
                                      fontWeight: FontWeight.bold,
                                      color: ConstanceData.secoundryFontColor,
                                    ),
                              ),
                            ],
                          ),
                        ],
                      ),
                      Column(
                        children: <Widget>[
                          Icon(
                            FontAwesomeIcons.tachometerAlt,
                            color: ConstanceData.secoundryFontColor,
                            size: 18,
                          ),
                          const SizedBox(
                            height: 4,
                          ),
                          Text(
                            '$totalDistance KM',
                            style:
                                Theme.of(context).textTheme.titleMedium!.copyWith(
                                      fontWeight: FontWeight.bold,
                                      color: ConstanceData.secoundryFontColor,
                                    ),
                          ),
                          Row(
                            children: <Widget>[
                              Text(
                                AppLocalizations.of('Total Distance'),
                                style: Theme.of(context)
                                    .textTheme
                                    .bodySmall!
                                    .copyWith(
                                      fontWeight: FontWeight.bold,
                                      color: ConstanceData.secoundryFontColor,
                                    ),
                              ),
                            ],
                          ),
                        ],
                      ),
                      Column(
                        children: <Widget>[
                          Icon(
                            FontAwesomeIcons.rocket,
                            color: ConstanceData.secoundryFontColor,
                            size: 20,
                          ),
                          const SizedBox(
                            height: 4,
                          ),
                          Text(
                            totalTodayBooking,
                            style:
                                Theme.of(context).textTheme.titleMedium!.copyWith(
                                      fontWeight: FontWeight.bold,
                                      color: ConstanceData.secoundryFontColor,
                                    ),
                          ),
                          Row(
                            children: <Widget>[
                              Text(
                                AppLocalizations.of('Total Job'),
                                style: Theme.of(context)
                                    .textTheme
                                    .bodySmall!
                                    .copyWith(
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
                  SizedBox(
                    height: 8,
                  )
                ],
              ),
            ),
          ),
          Expanded(
            flex: 2,
            child: columDetail(),
          )
        ],
      ),
    );
  }

  Widget columDetail() {
    return Container(
      color: Theme.of(context).scaffoldBackgroundColor,
      child: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.only(left: 16),
          child: Column(
            children: <Widget>[
              const SizedBox(
                height: 26,
              ),
              InkWell(
                highlightColor: Colors.transparent,
                splashColor: Colors.transparent,
                onTap: () {
                  Navigator.pop(context);
                  if (widget.selectItemName != 'Home') {
                    Navigator.pushNamed(context, Routes.HOME);
                  }
                },
                child: Row(
                  children: <Widget>[
                    widget.selectItemName == 'Home'
                        ? selectedData()
                        : const SizedBox(),
                    Icon(
                      Icons.home,
                      size: 28,
                      color: widget.selectItemName == 'Home'
                          ? Theme.of(context).primaryColor
                          : Theme.of(context).dividerColor,
                    ),
                    const SizedBox(
                      width: 8,
                    ),
                    Text(
                      AppLocalizations.of('Home'),
                      style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                            fontWeight: FontWeight.bold,
                            color: Theme.of(context).textTheme.titleLarge!.color,
                          ),
                    ),
                  ],
                ),
              ),
              const SizedBox(
                height: 32,
              ),
              InkWell(
                highlightColor: Colors.transparent,
                splashColor: Colors.transparent,
                onTap: () {
                  Navigator.pop(context);
                  if (widget.selectItemName != 'Jobs') {
                    Navigator.of(context).push(MaterialPageRoute(builder: (context) => JobView(),));
                  }
                },
                child: Padding(
                  padding: const EdgeInsets.only(left: 4),
                  child: Row(
                    children: <Widget>[
                      widget.selectItemName == 'Jobs'
                          ? selectedData()
                          : const SizedBox(),
                      Icon(
                        FontAwesomeIcons.wallet,
                        size: 20,
                        color: widget.selectItemName == 'Jobs'
                            ? Theme.of(context).primaryColor
                            : Theme.of(context).dividerColor,
                      ),
                      const SizedBox(
                        width: 10,
                      ),
                      Text(
                        AppLocalizations.of('Jobs'),
                        style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                              fontWeight: FontWeight.bold,
                              color:
                                  Theme.of(context).textTheme.titleLarge!.color,
                            ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(
                height: 32,
              ),
              InkWell(
                highlightColor: Colors.transparent,
                splashColor: Colors.transparent,
                onTap: () {
                  Navigator.pop(context);
                  if (widget.selectItemName != 'Account') {
                    Navigator.pushNamed(context, Routes.ACCOUNT);
                  }
                },
                child: Padding(
                  padding: const EdgeInsets.only(left: 4),
                  child: Row(
                    children: <Widget>[
                      widget.selectItemName == 'Account'
                          ? selectedData()
                          : const SizedBox(),
                      Icon(
                        FontAwesomeIcons.person,
                        size: 20,
                        color: widget.selectItemName == 'Account'
                            ? Theme.of(context).primaryColor
                            : Theme.of(context).dividerColor,
                      ),
                      const SizedBox(
                        width: 10,
                      ),
                      Text(
                        AppLocalizations.of('Account'),
                        style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                              fontWeight: FontWeight.bold,
                              color:
                                  Theme.of(context).textTheme.titleLarge!.color,
                            ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(
                height: 32,
              ),
              InkWell(
                highlightColor: Colors.transparent,
                splashColor: Colors.transparent,
                onTap: () {
                  Navigator.pop(context);
                  if (widget.selectItemName != 'Vehicles') {
                    Navigator.pushNamed(context, Routes.VEHICLES);
                  }
                },
                child: Padding(
                  padding: const EdgeInsets.only(left: 4),
                  child: Row(
                    children: <Widget>[
                      widget.selectItemName == 'Vehicles'
                          ? selectedData()
                          : const SizedBox(),
                      Icon(
                        FontAwesomeIcons.solidBell,
                        size: 20,
                        color: widget.selectItemName == 'Vehicles'
                            ? Theme.of(context).primaryColor
                            : Theme.of(context).dividerColor,
                      ),
                      const SizedBox(
                        width: 10,
                      ),
                      Text(
                        AppLocalizations.of('Vehicles'),
                        style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                              fontWeight: FontWeight.bold,
                              color:
                                  Theme.of(context).textTheme.titleLarge!.color,
                            ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(
                height: 32,
              ),
              InkWell(
                highlightColor: Colors.transparent,
                splashColor: Colors.transparent,
                onTap: () {
                  Navigator.pop(context);
                  if (widget.selectItemName != 'Setting') {
                    Navigator.pushNamed(context, Routes.SETTING);
                  }
                },
                child: Padding(
                  padding: const EdgeInsets.only(left: 4),
                  child: Row(
                    children: <Widget>[
                      widget.selectItemName == 'Setting'
                          ? selectedData()
                          : SizedBox(),
                      Icon(
                        FontAwesomeIcons.cog,
                        size: 20,
                        color: widget.selectItemName == 'Setting'
                            ? Theme.of(context).primaryColor
                            : Theme.of(context).dividerColor,
                      ),
                      SizedBox(
                        width: 10,
                      ),
                      Text(
                        AppLocalizations.of('Settings'),
                        style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                              fontWeight: FontWeight.bold,
                              color:
                                  Theme.of(context).textTheme.titleLarge!.color,
                            ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(
                height: 32,
              ),
              InkWell(
                highlightColor: Colors.transparent,
                splashColor: Colors.transparent,
                onTap: () {
                  SharedPreferences.getInstance().then((prefs) {
                    prefs.clear();
                  });
                  Navigator.pushNamed(context, Routes.LOGIN);
                },
                child: Padding(
                  padding: const EdgeInsets.only(left: 4),
                  child: Row(
                    children: <Widget>[
                      Icon(
                        FontAwesomeIcons.signOutAlt,
                        size: 20,
                        color: Theme.of(context).dividerColor,
                      ),
                      SizedBox(
                        width: 10,
                      ),
                      Text(
                        AppLocalizations.of('Logout'),
                        style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                              fontWeight: FontWeight.bold,
                              color:
                                  Theme.of(context).textTheme.titleLarge!.color,
                            ),
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(
                height: MediaQuery.of(context).padding.bottom + 16,
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget selectedData() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Container(
          height: 28,
          width: 4,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            color: Theme.of(context).primaryColor,
          ),
        ),
        SizedBox(
          width: 10,
        ),
      ],
    );
  }
}
