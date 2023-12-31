import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import '../../Api & Routes/routes.dart';
import '../../Entities/jobsobject.dart';
import '../constance/constance.dart';
import '../home/userDetail.dart';
import '../home/chatScreen.dart';
import '../Language/appLocalizations.dart';

class RiderList extends StatefulWidget {
  @override
  _RiderListState createState() => _RiderListState();
}

class _RiderListState extends State<RiderList> {
  @override
  Widget build(BuildContext context) {
    RouteManager.context=context;
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
                  Icons.close,
                  color: Theme.of(context).textTheme.titleLarge!.color,
                ),
              ),
            ),
            Text(
              'Online',
              style: Theme.of(context).textTheme.titleLarge!.copyWith(
                    fontWeight: FontWeight.bold,
                    color: Theme.of(context).textTheme.titleLarge!.color,
                  ),
            ),
            InkWell(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => ChatScreen(),
                  ),
                );
              },
              child: SizedBox(
                child: Icon(
                  FontAwesomeIcons.facebookMessenger,
                  color: Theme.of(context).textTheme.titleLarge!.color,
                ),
              ),
            ),
          ],
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            Container(
              height: AppBar().preferredSize.height,
              color: Theme.of(context).disabledColor,
              child: Padding(
                padding: const EdgeInsets.only(right: 14, left: 14),
                child: Row(
                  children: <Widget>[
                    Text(
                      AppLocalizations.of('You have 10 new requess !!!'),
                      style: Theme.of(context).textTheme.titleMedium!.copyWith(
                            fontWeight: FontWeight.bold,
                            color: ConstanceData.secoundryFontColor,
                          ),
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(
              height: 10,
            ),
            Column(
              children: <Widget>[
                Padding(
                  padding: EdgeInsets.only(right: 6, left: 6),
                  child: InkWell(
                    highlightColor: Colors.transparent,
                    splashColor: Colors.transparent,
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => UserDetailScreen(
                            item: JobObject(
                                '1111',
                                999,
                                'faheem',
                                '34343434',
                                'islamabad',
                                'rawalpindi',
                                1,
                                'luggage',
                                'paymentmethod',
                                'total_amount',
                                DateTime.now(),
                                'pickupnote',
                                '',
                                1,
                                1,
                                1,
                                1,
                                1.toString(),
                                'duration','ere'),
                          ),
                        ),
                      );
                    },
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadiusDirectional.circular(16),
                        color: Theme.of(context).scaffoldBackgroundColor,
                      ),
                      child: Column(
                        children: <Widget>[
                          Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadiusDirectional.only(topEnd: Radius.circular(16), topStart: Radius.circular(16)),
                            ),
                            child: Padding(
                              padding: const EdgeInsets.all(14),
                              child: Row(
                                children: <Widget>[
                                  ClipRRect(
                                    borderRadius: BorderRadius.circular(10),
                                    child: Image.asset(
                                      ConstanceData.user8,
                                      height: 50,
                                      width: 50,
                                    ),
                                  ),
                                  SizedBox(
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
                                      SizedBox(
                                        height: 4,
                                      ),
                                      Row(
                                        children: <Widget>[
                                          Container(
                                            height: 24,
                                            width: 74,
                                            child: Center(
                                              child: Text(
                                                AppLocalizations.of('ApplePay'),
                                                style: Theme.of(context).textTheme.labelLarge!.copyWith(
                                                      fontWeight: FontWeight.bold,
                                                      color: ConstanceData.secoundryFontColor,
                                                    ),
                                              ),
                                            ),
                                            decoration: BoxDecoration(
                                              borderRadius: BorderRadius.all(
                                                Radius.circular(15),
                                              ),
                                              color: Theme.of(context).primaryColor,
                                            ),
                                          ),
                                          SizedBox(
                                            width: 4,
                                          ),
                                          Container(
                                            height: 24,
                                            width: 74,
                                            child: Center(
                                              child: Text(
                                                AppLocalizations.of('Discount'),
                                                style: Theme.of(context).textTheme.labelLarge!.copyWith(
                                                      fontWeight: FontWeight.bold,
                                                      color: ConstanceData.secoundryFontColor,
                                                    ),
                                              ),
                                            ),
                                            decoration: BoxDecoration(
                                              borderRadius: BorderRadius.all(
                                                Radius.circular(15),
                                              ),
                                              color: Theme.of(context).primaryColor,
                                            ),
                                          )
                                        ],
                                      )
                                    ],
                                  ),
                                  Expanded(
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
                                    SizedBox(
                                      height: 4,
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
                                    SizedBox(
                                      height: 4,
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
                          Container(
                            height: 1,
                            width: MediaQuery.of(context).size.width,
                            color: Theme.of(context).dividerColor,
                          ),
                          Padding(
                            padding: const EdgeInsets.only(right: 14, left: 14, top: 16),
                            child: Container(
                              height: 40,
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
                          SizedBox(
                            height: 16,
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  height: 16,
                ),
                Padding(
                  padding: EdgeInsets.only(right: 6, left: 6),
                  child: InkWell(
                    highlightColor: Colors.transparent,
                    splashColor: Colors.transparent,
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => UserDetailScreen(item: JobObject(
                              '999',1111,
                              'faheem',
                              '34343434',
                              'islamabad',
                              'rawalpindi',
                              1,
                              'luggage',
                              'paymentmethod',
                              'total_amount',
                              DateTime.now(),
                              'pickupnote',
                              '',
                              1,
                              1,
                              1,
                              1,
                              1.toString(),
                              'duration','343433'),
                          ),
                        ),
                      );
                    },
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadiusDirectional.circular(16),
                        color: Theme.of(context).scaffoldBackgroundColor,
                      ),
                      child: Column(
                        children: <Widget>[
                          Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadiusDirectional.only(topEnd: Radius.circular(16), topStart: Radius.circular(16)),
                            ),
                            child: Padding(
                              padding: const EdgeInsets.all(14),
                              child: Row(
                                children: <Widget>[
                                  ClipRRect(
                                    borderRadius: BorderRadius.circular(10),
                                    child: Image.asset(
                                      ConstanceData.user1,
                                      height: 50,
                                      width: 50,
                                    ),
                                  ),
                                  SizedBox(
                                    width: 8,
                                  ),
                                  Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: <Widget>[
                                      Text(
                                        AppLocalizations.of('Callie Greer'),
                                        style: Theme.of(context).textTheme.titleLarge!.copyWith(
                                              fontWeight: FontWeight.bold,
                                              color: Theme.of(context).textTheme.titleLarge!.color,
                                            ),
                                      ),
                                      SizedBox(
                                        height: 4,
                                      ),
                                      Row(
                                        children: <Widget>[
                                          Container(
                                            height: 24,
                                            width: 74,
                                            child: Center(
                                              child: Text(
                                                AppLocalizations.of('ApplePay'),
                                                style: Theme.of(context).textTheme.labelLarge!.copyWith(
                                                      fontWeight: FontWeight.bold,
                                                      color: ConstanceData.secoundryFontColor,
                                                    ),
                                              ),
                                            ),
                                            decoration: BoxDecoration(
                                              borderRadius: BorderRadius.all(
                                                Radius.circular(15),
                                              ),
                                              color: Theme.of(context).primaryColor,
                                            ),
                                          ),
                                          SizedBox(
                                            width: 4,
                                          ),
                                          Container(
                                            height: 24,
                                            width: 74,
                                            child: Center(
                                              child: Text(
                                                AppLocalizations.of('Discount'),
                                                style: Theme.of(context).textTheme.labelLarge!.copyWith(
                                                      fontWeight: FontWeight.bold,
                                                      color: ConstanceData.secoundryFontColor,
                                                    ),
                                              ),
                                            ),
                                            decoration: BoxDecoration(
                                              borderRadius: BorderRadius.all(
                                                Radius.circular(15),
                                              ),
                                              color: Theme.of(context).primaryColor,
                                            ),
                                          )
                                        ],
                                      )
                                    ],
                                  ),
                                  Expanded(
                                    child: SizedBox(),
                                  ),
                                  Column(
                                    crossAxisAlignment: CrossAxisAlignment.end,
                                    children: <Widget>[
                                      Text(
                                        '\$20.00',
                                        style: Theme.of(context).textTheme.titleLarge!.copyWith(
                                              fontWeight: FontWeight.bold,
                                              color: Theme.of(context).textTheme.titleLarge!.color,
                                            ),
                                      ),
                                      Text(
                                        '1.5 km',
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
                                    SizedBox(
                                      height: 4,
                                    ),
                                    Text(
                                      AppLocalizations.of('62 Kobe Trafficway'),
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
                                    SizedBox(
                                      height: 4,
                                    ),
                                    Text(
                                      AppLocalizations.of('280, AB Sunny willa'),
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
                          Container(
                            height: 1,
                            width: MediaQuery.of(context).size.width,
                            color: Theme.of(context).dividerColor,
                          ),
                          Padding(
                            padding: const EdgeInsets.only(right: 14, left: 14, top: 16),
                            child: Container(
                              height: 40,
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
                          SizedBox(
                            height: 16,
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  height: 16,
                ),
                Padding(
                  padding: EdgeInsets.only(right: 6, left: 6),
                  child: InkWell(
                    highlightColor: Colors.transparent,
                    splashColor: Colors.transparent,
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => UserDetailScreen(
                            item: JobObject(
                                '2',
                                999,
                                'faheem',
                                '34343434',
                                'islamabad',
                                'rawalpindi',
                                1,
                                'luggage',
                                'paymentmethod',
                                'total_amount',
                                DateTime.now(),
                                'pickupnote',
                                '',
                                1,
                                1,
                                1,
                                1,
                                1.toString(),
                                'duration','ere'),
                          ),
                        ),
                      );
                    },
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadiusDirectional.circular(16),
                        color: Theme.of(context).scaffoldBackgroundColor,
                      ),
                      child: Column(
                        children: <Widget>[
                          Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadiusDirectional.only(topEnd: Radius.circular(16), topStart: Radius.circular(16)),
                            ),
                            child: Padding(
                              padding: const EdgeInsets.all(14),
                              child: Row(
                                children: <Widget>[
                                  ClipRRect(
                                    borderRadius: BorderRadius.circular(10),
                                    child: Image.asset(
                                      ConstanceData.user2,
                                      height: 50,
                                      width: 50,
                                    ),
                                  ),
                                  SizedBox(
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
                                      SizedBox(
                                        height: 4,
                                      ),
                                      Row(
                                        children: <Widget>[
                                          Container(
                                            height: 24,
                                            width: 74,
                                            child: Center(
                                              child: Text(
                                                AppLocalizations.of('ApplePay'),
                                                style: Theme.of(context).textTheme.labelLarge!.copyWith(
                                                      fontWeight: FontWeight.bold,
                                                      color: ConstanceData.secoundryFontColor,
                                                    ),
                                              ),
                                            ),
                                            decoration: BoxDecoration(
                                              borderRadius: BorderRadius.all(
                                                Radius.circular(15),
                                              ),
                                              color: Theme.of(context).primaryColor,
                                            ),
                                          ),
                                          SizedBox(
                                            width: 4,
                                          ),
                                          Container(
                                            height: 24,
                                            width: 74,
                                            child: Center(
                                              child: Text(
                                                AppLocalizations.of('Discount'),
                                                style: Theme.of(context).textTheme.labelLarge!.copyWith(
                                                      fontWeight: FontWeight.bold,
                                                      color: ConstanceData.secoundryFontColor,
                                                    ),
                                              ),
                                            ),
                                            decoration: BoxDecoration(
                                              borderRadius: BorderRadius.all(
                                                Radius.circular(15),
                                              ),
                                              color: Theme.of(context).primaryColor,
                                            ),
                                          )
                                        ],
                                      )
                                    ],
                                  ),
                                  Expanded(
                                    child: SizedBox(),
                                  ),
                                  Column(
                                    crossAxisAlignment: CrossAxisAlignment.end,
                                    children: <Widget>[
                                      Text(
                                        '\$10.00',
                                        style: Theme.of(context).textTheme.titleLarge!.copyWith(
                                              fontWeight: FontWeight.bold,
                                              color: Theme.of(context).textTheme.titleLarge!.color,
                                            ),
                                      ),
                                      Text(
                                        '0.5 km',
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
                                    SizedBox(
                                      height: 4,
                                    ),
                                    Text(
                                      AppLocalizations.of('25 Lcie Park Suite'),
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
                                    SizedBox(
                                      height: 4,
                                    ),
                                    Text(
                                      AppLocalizations.of('187/ William St, London, UK'),
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
                          Container(
                            height: 1,
                            width: MediaQuery.of(context).size.width,
                            color: Theme.of(context).dividerColor,
                          ),
                          Padding(
                            padding: const EdgeInsets.only(right: 14, left: 14, top: 16),
                            child: Container(
                              height: 40,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10),
                                color: Theme.of(context).primaryColor,
                              ),
                              child: Center(
                                child: Text(
                                  'Accept',
                                  style: Theme.of(context).textTheme.labelLarge!.copyWith(
                                        fontWeight: FontWeight.bold,
                                        color: ConstanceData.secoundryFontColor,
                                      ),
                                ),
                              ),
                            ),
                          ),
                          SizedBox(
                            height: 16,
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(
              height: MediaQuery.of(context).padding.bottom + 16,
            )
          ],
        ),
      ),
    );
  }
}
