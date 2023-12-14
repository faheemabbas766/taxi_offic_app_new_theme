import 'package:flutter/material.dart';
import 'package:taxi_app/presentation/splashScreen.dart';
import '../../main.dart';
import '../Language/appLocalizations.dart';
import '../constance/constance.dart';
import '../constance/constance.dart' as constance;
import 'editProfileScreen.dart';

class MyProfile extends StatefulWidget {
  const MyProfile({super.key});

  @override
  _MyProfileState createState() => _MyProfileState();
}

class _MyProfileState extends State<MyProfile> {
  @override
  Widget build(BuildContext context) {
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
            InkWell(
              onTap: (){
                Navigator.of(context).push(MaterialPageRoute(builder: (context) => const EditProfileScreen(),));
              },
              child: Text(
                AppLocalizations.of('Edit'),
                style: Theme.of(context).textTheme.titleLarge!.copyWith(
                      fontWeight: FontWeight.bold,
                      color: Theme.of(context).primaryColor,
                    ),
              ),
            ),
          ],
        ),
      ),
      body: Column(
        children: <Widget>[
          Expanded(
            flex: 2,
            child: Container(
              color: Theme.of(context).scaffoldBackgroundColor,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      CircleAvatar(
                        radius: MediaQuery.of(context).size.width <= 320 ? 36 : 46,
                        child: ClipRRect(
                          borderRadius: MediaQuery.of(context).size.width <= 320 ? BorderRadius.circular(40) : BorderRadius.circular(60),
                          child: Image.asset(
                            ConstanceData.user3,
                          ),
                        ),
                      ),
                      Text(userName,
                        style: Theme.of(context).textTheme.titleLarge!.copyWith(
                              fontWeight: FontWeight.bold,
                              color: Theme.of(context).textTheme.titleLarge!.color,
                            ),
                      ),
                      Text(
                        'Driver',
                        style: Theme.of(context).textTheme.titleSmall!.copyWith(
                              fontWeight: FontWeight.bold,
                              color: Theme.of(context).disabledColor,
                            ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(right: 14, left: 14, top: 10, bottom: 10),
            child: Row(
              children: <Widget>[
                Text(
                  AppLocalizations.of('INFORMATION'),
                  style: Theme.of(context).textTheme.titleSmall!.copyWith(
                        fontWeight: FontWeight.bold,
                        color: Theme.of(context).disabledColor,
                      ),
                ),
              ],
            ),
          ),
          Expanded(
            flex: 3,
            child: ListView(
              children: <Widget>[
                Container(
                  color: Theme.of(context).scaffoldBackgroundColor,
                  child: Column(
                    children: <Widget>[
                      Padding(
                        padding: const EdgeInsets.only(right: 10, left: 14, top: 8, bottom: 8),
                        child: Row(
                          children: <Widget>[
                            Text(
                              AppLocalizations.of('First Name'),
                              style: Theme.of(context).textTheme.titleMedium!.copyWith(
                                fontWeight: FontWeight.bold,
                                color: Theme.of(context).textTheme.titleLarge!.color,
                              ),
                            ),
                            const Expanded(child: SizedBox()),
                            Text(
                              'Faheem',
                              style: Theme.of(context).textTheme.titleSmall!.copyWith(
                                fontWeight: FontWeight.bold,
                                color: Theme.of(context).disabledColor,
                              ),
                            ),
                            const SizedBox(
                              width: 4,
                            ),
                          ],
                        ),
                      ),
                      Container(
                        height: 1,
                        color: Theme.of(context).dividerColor,
                      ),
                      Padding(
                        padding: const EdgeInsets.only(right: 10, left: 14, top: 8, bottom: 8),
                        child: Row(
                          children: <Widget>[
                            Text(
                              AppLocalizations.of('Last Name'),
                              style: Theme.of(context).textTheme.titleMedium!.copyWith(
                                fontWeight: FontWeight.bold,
                                color: Theme.of(context).textTheme.titleLarge!.color,
                              ),
                            ),
                            Expanded(child: SizedBox()),
                            Text(
                              'Abbas',
                              style: Theme.of(context).textTheme.titleSmall!.copyWith(
                                fontWeight: FontWeight.bold,
                                color: Theme.of(context).disabledColor,
                              ),
                            ),
                            const SizedBox(
                              width: 4,
                            ),
                            
                          ],
                        ),
                      ),
                      Container(
                        height: 1,
                        color: Theme.of(context).dividerColor,
                      ),
                      Padding(
                        padding: const EdgeInsets.only(right: 10, left: 14, top: 8, bottom: 8),
                        child: Row(
                          children: <Widget>[
                            Text(
                              AppLocalizations.of('Driver Call Sign:'),
                              style: Theme.of(context).textTheme.titleMedium!.copyWith(
                                fontWeight: FontWeight.bold,
                                color: Theme.of(context).textTheme.titleLarge!.color,
                              ),
                            ),
                            Expanded(child: SizedBox()),
                            Text(
                              '22',
                              style: Theme.of(context).textTheme.titleSmall!.copyWith(
                                fontWeight: FontWeight.bold,
                                color: Theme.of(context).disabledColor,
                              ),
                            ),
                            const SizedBox(
                              width: 4,
                            ),
                            
                          ],
                        ),
                      ),
                      Container(
                        height: 1,
                        color: Theme.of(context).dividerColor,
                      ),
                      Padding(
                        padding: const EdgeInsets.only(right: 10, left: 14, top: 8, bottom: 8),
                        child: Row(
                          children: <Widget>[
                            Text(
                              AppLocalizations.of('Phone number'),
                              style: Theme.of(context).textTheme.titleMedium!.copyWith(
                                    fontWeight: FontWeight.bold,
                                    color: Theme.of(context).textTheme.titleLarge!.color,
                                  ),
                            ),
                            Expanded(child: SizedBox()),
                            Text(
                              '567-367-0088',
                              style: Theme.of(context).textTheme.titleSmall!.copyWith(
                                    fontWeight: FontWeight.bold,
                                    color: Theme.of(context).disabledColor,
                                  ),
                            ),
                            SizedBox(
                              width: 4,
                            ),
                            
                          ],
                        ),
                      ),
                      Container(
                        height: 1,
                        color: Theme.of(context).dividerColor,
                      ),
                      Padding(
                        padding: const EdgeInsets.only(right: 10, left: 14, top: 8, bottom: 8),
                        child: Row(
                          children: <Widget>[
                            Text(
                              AppLocalizations.of('Email'),
                              style: Theme.of(context).textTheme.titleMedium!.copyWith(
                                    fontWeight: FontWeight.bold,
                                    color: Theme.of(context).textTheme.titleLarge!.color,
                                  ),
                            ),
                            Expanded(child: SizedBox()),
                            Text(
                              'Freeslab88@gmail.com',
                              style: Theme.of(context).textTheme.titleSmall!.copyWith(
                                    fontWeight: FontWeight.bold,
                                    color: Theme.of(context).disabledColor,
                                  ),
                            ),
                            SizedBox(
                              width: 4,
                            ),
                            
                          ],
                        ),
                      ),
                      Container(
                        height: 1,
                        color: Theme.of(context).dividerColor,
                      ),
                      Padding(
                        padding: const EdgeInsets.only(right: 10, left: 14, top: 8, bottom: 8),
                        child: Row(
                          children: <Widget>[
                            Text(
                              AppLocalizations.of('Gender'),
                              style: Theme.of(context).textTheme.titleMedium!.copyWith(
                                    fontWeight: FontWeight.bold,
                                    color: Theme.of(context).textTheme.titleLarge!.color,
                                  ),
                            ),
                            Expanded(child: SizedBox()),
                            Text(
                              AppLocalizations.of('Female'),
                              style: Theme.of(context).textTheme.titleSmall!.copyWith(
                                    fontWeight: FontWeight.bold,
                                    color: Theme.of(context).disabledColor,
                                  ),
                            ),
                            SizedBox(
                              width: 4,
                            ),
                            
                          ],
                        ),
                      ),
                      Container(
                        height: 1,
                        color: Theme.of(context).dividerColor,
                      ),
                      Padding(
                        padding: const EdgeInsets.only(right: 10, left: 14, top: 8, bottom: 8),
                        child: Row(
                          children: <Widget>[
                            Text(
                              AppLocalizations.of('Birthday'),
                              style: Theme.of(context).textTheme.titleMedium!.copyWith(
                                fontWeight: FontWeight.bold,
                                color: Theme.of(context).textTheme.titleLarge!.color,
                              ),
                            ),
                            Expanded(child: SizedBox()),
                            Text(
                              'April 16,1988',
                              style: Theme.of(context).textTheme.titleSmall!.copyWith(
                                fontWeight: FontWeight.bold,
                                color: Theme.of(context).disabledColor,
                              ),
                            ),
                            SizedBox(
                              width: 4,
                            ),
                            
                          ],
                        ),
                      ),
                      Container(
                        height: 1,
                        color: Theme.of(context).dividerColor,
                      ),
                      Padding(
                        padding: const EdgeInsets.only(right: 10, left: 14, top: 8, bottom: 8),
                        child: Row(
                          children: <Widget>[
                            Text(
                              AppLocalizations.of('NI Number'),
                              style: Theme.of(context).textTheme.titleMedium!.copyWith(
                                fontWeight: FontWeight.bold,
                                color: Theme.of(context).textTheme.titleLarge!.color,
                              ),
                            ),
                            Expanded(child: SizedBox()),
                            Text(
                              'ABC~123',
                              style: Theme.of(context).textTheme.titleSmall!.copyWith(
                                fontWeight: FontWeight.bold,
                                color: Theme.of(context).disabledColor,
                              ),
                            ),
                            SizedBox(
                              width: 4,
                            ),
                            
                          ],
                        ),
                      ),
                      Container(
                        height: 1,
                        color: Theme.of(context).dividerColor,
                      ),
                      Padding(
                        padding: const EdgeInsets.only(right: 10, left: 14, top: 8, bottom: 8),
                        child: Row(
                          children: <Widget>[
                            Text(
                              AppLocalizations.of('Address'),
                              style: Theme.of(context).textTheme.titleMedium!.copyWith(
                                fontWeight: FontWeight.bold,
                                color: Theme.of(context).textTheme.titleLarge!.color,
                              ),
                            ),
                            Expanded(child: SizedBox()),
                            Text(
                              'ABC~123',
                              style: Theme.of(context).textTheme.titleSmall!.copyWith(
                                fontWeight: FontWeight.bold,
                                color: Theme.of(context).disabledColor,
                              ),
                            ),
                            SizedBox(
                              width: 4,
                            ),
                            
                          ],
                        ),
                      ),
                      Container(
                        height: 1,
                        color: Theme.of(context).dividerColor,
                      ),
                      Padding(
                        padding: const EdgeInsets.only(right: 10, left: 14, top: 8, bottom: 8),
                        child: Row(
                          children: <Widget>[
                            Text(
                              AppLocalizations.of('Postal Code'),
                              style: Theme.of(context).textTheme.titleMedium!.copyWith(
                                fontWeight: FontWeight.bold,
                                color: Theme.of(context).textTheme.titleLarge!.color,
                              ),
                            ),
                            Expanded(child: SizedBox()),
                            Text(
                              '44000',
                              style: Theme.of(context).textTheme.titleSmall!.copyWith(
                                fontWeight: FontWeight.bold,
                                color: Theme.of(context).disabledColor,
                              ),
                            ),
                            SizedBox(
                              width: 4,
                            ),
                            
                          ],
                        ),
                      ),
                      Container(
                        height: 1,
                        color: Theme.of(context).dividerColor,
                      ),
                      Padding(
                        padding: const EdgeInsets.only(right: 10, left: 14, top: 8, bottom: 8),
                        child: Row(
                          children: <Widget>[
                            Text(
                              AppLocalizations.of('Home Tel No'),
                              style: Theme.of(context).textTheme.titleMedium!.copyWith(
                                fontWeight: FontWeight.bold,
                                color: Theme.of(context).textTheme.titleLarge!.color,
                              ),
                            ),
                            Expanded(child: SizedBox()),
                            Text(
                              '42323232',
                              style: Theme.of(context).textTheme.titleSmall!.copyWith(
                                fontWeight: FontWeight.bold,
                                color: Theme.of(context).disabledColor,
                              ),
                            ),
                            SizedBox(
                              width: 4,
                            ),
                            
                          ],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(right: 10, left: 14, top: 8, bottom: 8),
                        child: Row(
                          children: <Widget>[
                            Text(
                              AppLocalizations.of('Driving Licence No & Exp'),
                              style: Theme.of(context).textTheme.titleMedium!.copyWith(
                                fontWeight: FontWeight.bold,
                                color: Theme.of(context).textTheme.titleLarge!.color,
                              ),
                            ),
                            Expanded(child: SizedBox()),
                            Text(
                              'ABC~123 23 oct 2024',
                              style: Theme.of(context).textTheme.titleSmall!.copyWith(
                                fontWeight: FontWeight.bold,
                                color: Theme.of(context).disabledColor,
                              ),
                            ),
                            SizedBox(
                              width: 4,
                            ),
                            
                          ],
                        ),
                      ),
                      Container(
                        height: 1,
                        color: Theme.of(context).dividerColor,
                      ),
                      Padding(
                        padding: const EdgeInsets.only(right: 10, left: 14, top: 8, bottom: 8),
                        child: Row(
                          children: <Widget>[
                            Text(
                              AppLocalizations.of('Phv Badge No & Expiry'),
                              style: Theme.of(context).textTheme.titleMedium!.copyWith(
                                fontWeight: FontWeight.bold,
                                color: Theme.of(context).textTheme.titleLarge!.color,
                              ),
                            ),
                            Expanded(child: SizedBox()),
                            Text(
                              '',
                              style: Theme.of(context).textTheme.titleSmall!.copyWith(
                                fontWeight: FontWeight.bold,
                                color: Theme.of(context).disabledColor,
                              ),
                            ),
                            SizedBox(
                              width: 4,
                            ),
                            
                          ],
                        ),
                      ),
                      Container(
                        height: 1,
                        color: Theme.of(context).dividerColor,
                      ),
                      Padding(
                        padding: const EdgeInsets.only(right: 10, left: 14, top: 8, bottom: 8),
                        child: Row(
                          children: <Widget>[
                            Text(
                              AppLocalizations.of('Passport No & Expiry'),
                              style: Theme.of(context).textTheme.titleMedium!.copyWith(
                                fontWeight: FontWeight.bold,
                                color: Theme.of(context).textTheme.titleLarge!.color,
                              ),
                            ),
                            Expanded(child: SizedBox()),
                            Text(
                              'ABC~123',
                              style: Theme.of(context).textTheme.titleSmall!.copyWith(
                                fontWeight: FontWeight.bold,
                                color: Theme.of(context).disabledColor,
                              ),
                            ),
                            SizedBox(
                              width: 4,
                            ),
                            
                          ],
                        ),
                      ),
                      Container(
                        height: 1,
                        color: Theme.of(context).dividerColor,
                      ),

                      Container(
                        height: 1,
                        color: Theme.of(context).dividerColor,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  openShowPopupLanguage() {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Center(
              child: Text(
                AppLocalizations.of('Select Language'),
                style: Theme.of(context).textTheme.titleSmall!.copyWith(
                      fontWeight: FontWeight.bold,
                      color: Theme.of(context).textTheme.titleLarge!.color,
                      fontSize: 18,
                    ),
              ),
            ),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                Container(
                  height: 1,
                  color: Theme.of(context).dividerColor,
                ),
                SizedBox(
                  height: 8,
                ),
                InkWell(
                  highlightColor: Colors.transparent,
                  splashColor: Colors.transparent,
                  onTap: () {
                    selectLanguage('en');
                    Navigator.of(context).pop();
                  },
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Text(
                        'English',
                        style: Theme.of(context).textTheme.titleSmall!.copyWith(
                              fontWeight: FontWeight.bold,
                              color: Theme.of(context).disabledColor,
                              fontSize: 16,
                            ),
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  height: 8,
                ),
                Container(
                  height: 1,
                  color: Theme.of(context).dividerColor,
                ),
                SizedBox(
                  height: 8,
                ),
                InkWell(
                  highlightColor: Colors.transparent,
                  splashColor: Colors.transparent,
                  onTap: () {
                    selectLanguage('fr');
                    Navigator.of(context).pop();
                  },
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Text(
                        AppLocalizations.of('French'),
                        style: Theme.of(context).textTheme.titleSmall!.copyWith(
                              fontWeight: FontWeight.bold,
                              color: Theme.of(context).disabledColor,
                              fontSize: 16,
                            ),
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  height: 8,
                ),
                Container(
                  height: 1,
                  color: Theme.of(context).dividerColor,
                ),
                SizedBox(
                  height: 8,
                ),
                InkWell(
                  highlightColor: Colors.transparent,
                  splashColor: Colors.transparent,
                  onTap: () {
                    selectLanguage('ar');
                    Navigator.of(context).pop();
                  },
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Text(
                        AppLocalizations.of('Arabic'),
                        style: Theme.of(context).textTheme.titleSmall!.copyWith(
                              fontWeight: FontWeight.bold,
                              color: Theme.of(context).disabledColor,
                              fontSize: 16,
                            ),
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  height: 8,
                ),
                Container(
                  height: 1,
                  color: Theme.of(context).dividerColor,
                ),
                SizedBox(
                  height: 8,
                ),
                InkWell(
                  highlightColor: Colors.transparent,
                  splashColor: Colors.transparent,
                  onTap: () {
                    selectLanguage('ja');
                    Navigator.of(context).pop();
                  },
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Text(
                        AppLocalizations.of('Japanese'),
                        style: Theme.of(context).textTheme.titleSmall!.copyWith(
                              fontWeight: FontWeight.bold,
                              color: Theme.of(context).disabledColor,
                              fontSize: 16,
                            ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          );
        });
  }

  selectLanguage(String languageCode) {
    constance.locale = languageCode;
    MyApp.setCustomLanguage(context, languageCode);
  }
}
