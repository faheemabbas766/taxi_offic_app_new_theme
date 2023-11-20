import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import '../constance/constance.dart';
import '../drawer/drawer.dart';
import '../Language/appLocalizations.dart';
import 'friendsList.dart';

class InviteFriendScreen extends StatefulWidget {
  @override
  _InviteFriendScreenState createState() => _InviteFriendScreenState();
}

class _InviteFriendScreenState extends State<InviteFriendScreen> {
  var _scaffoldKey = new GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      key: _scaffoldKey,
      drawer: SizedBox(
        width: MediaQuery.of(context).size.width * 0.75 < 400 ? MediaQuery.of(context).size.width * 0.75 : 350,
        child: Drawer(
          child: AppDrawer(
            selectItemName: 'Invite',
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
                AppLocalizations.of('Invite Friends'),
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
          Expanded(
            child: ListView(
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.only(left: 14, right: 14, top: 50),
                  child: Column(
                    children: <Widget>[
                      CircleAvatar(
                        backgroundColor: Theme.of(context).primaryColor,
                        radius: 64,
                        child: Padding(
                          padding: const EdgeInsets.only(right: 10),
                          child: Icon(
                            FontAwesomeIcons.users,
                            color: Theme.of(context).scaffoldBackgroundColor,
                            size: 50,
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 16,
                      ),
                      Text(
                        AppLocalizations.of('Invite Friends'),
                        style: Theme.of(context).textTheme.headlineSmall!.copyWith(
                              fontWeight: FontWeight.bold,
                              color: Theme.of(context).textTheme.titleLarge!.color,
                            ),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Text(
                            AppLocalizations.of('Earn up to'),
                            style: Theme.of(context).textTheme.titleLarge!.copyWith(
                                  color: Theme.of(context).textTheme.titleLarge!.color,
                                ),
                          ),
                          Text(
                            ' \$150 ',
                            style: Theme.of(context).textTheme.headlineSmall!.copyWith(
                                  fontWeight: FontWeight.bold,
                                  color: Theme.of(context).textTheme.titleLarge!.color,
                                ),
                          ),
                          Text(
                            AppLocalizations.of('a day'),
                            style: Theme.of(context).textTheme.titleLarge!.copyWith(
                                  color: Theme.of(context).textTheme.titleLarge!.color,
                                ),
                          ),
                        ],
                      ),
                      SizedBox(
                        height: 32,
                      ),
                      Text(
                        AppLocalizations.of('When your friend sign up with your referral code, you can receive up to \$150 a day.'),
                        style: Theme.of(context).textTheme.titleMedium!.copyWith(
                              color: Theme.of(context).textTheme.titleLarge!.color,
                              fontWeight: FontWeight.bold,
                            ),
                        textAlign: TextAlign.center,
                      ),
                      SizedBox(
                        height: 32,
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 14),
                        child: Row(
                          children: <Widget>[
                            Text(
                              AppLocalizations.of('SHARE YOUR INVITE CODE'),
                              style: Theme.of(context).textTheme.titleSmall!.copyWith(
                                    color: Theme.of(context).disabledColor,
                                    fontWeight: FontWeight.bold,
                                  ),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(
                        height: 16,
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 14, right: 14),
                        child: Container(
                          height: 40,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            color: Theme.of(context).disabledColor,
                          ),
                          child: Center(
                            child: Text(
                              AppLocalizations.of('CAB1234'),
                              style: Theme.of(context).textTheme.labelLarge!.copyWith(
                                    fontWeight: FontWeight.bold,
                                    color: Theme.of(context).textTheme.titleLarge!.color,
                                  ),
                            ),
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 16,
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 14, right: 14),
                        child: InkWell(
                          highlightColor: Colors.transparent,
                          splashColor: Colors.transparent,
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => FriendsList(),
                              ),
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
                                AppLocalizations.of('INVITE'),
                                style: Theme.of(context).textTheme.labelLarge!.copyWith(
                                      fontWeight: FontWeight.bold,
                                      color: ConstanceData.secoundryFontColor,
                                    ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          SizedBox(
            height: MediaQuery.of(context).padding.bottom + 16,
          )
        ],
      ),
    );
  }
}
