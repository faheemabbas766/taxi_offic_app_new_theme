import 'dart:convert';
import 'package:animator/animator.dart';
import 'package:fluttertoast/fluttertoast.dart'as ft;
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../Api & Routes/api.dart';
import '../../Api & Routes/routes.dart';
import '../../providers/homepro.dart';
import '../Language/appLocalizations.dart';
import '../constance/constance.dart';
import 'package:http/http.dart'as http;

import '../splashScreen.dart';
class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  TextEditingController companyId = TextEditingController();
  TextEditingController username = TextEditingController();
  TextEditingController pwd = TextEditingController();
  bool obscure = true;
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
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
      body: InkWell(
        highlightColor: Colors.transparent,
        splashColor: Colors.transparent,
        onTap: () {
          FocusScope.of(context).requestFocus(FocusNode());
        },
        child: Stack(
          children:[
            Container(
              height: 250,
              color: Theme.of(context).primaryColor,
              child: Animator<Offset>(
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
                    fit: BoxFit.fill,
                    color: Colors.white.withOpacity(0.2),
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(right: 14, left: 14),
              child: SingleChildScrollView(
                child: SizedBox(
                  height: MediaQuery.of(context).size.height,
                  child: Column(
                    children: <Widget>[
                      const Expanded(
                        flex: 1,
                        child: SizedBox(),
                      ),
                      Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(15),
                          color: Theme.of(context).scaffoldBackgroundColor,
                          border: Border.all(color: Theme.of(context).primaryColor, width: 1.5),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.only(top: 20, left: 18, right: 18),
                          child: Column(
                            children: <Widget>[
                              Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  Text(
                                    AppLocalizations.of('Login'),
                                    style: Theme.of(context).textTheme.headlineMedium!.copyWith(
                                      fontWeight: FontWeight.bold,
                                      color: Theme.of(context).textTheme.titleLarge!.color,
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(top: 10),
                                    child: Text(
                                      AppLocalizations.of(' With Your'),
                                      style: Theme.of(context).textTheme.headlineSmall!.copyWith(
                                        color: Theme.of(context).textTheme.titleLarge!.color,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  Text(
                                    AppLocalizations.of('Company ID and Driver ID'),
                                    style: Theme.of(context).textTheme.headlineSmall!.copyWith(
                                      color: Theme.of(context).textTheme.titleLarge!.color,
                                    ),
                                  ),
                                ],
                              ),

                              SizedBox(
                                height: 20,
                              ),
                              Container(
                                height: 40,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.all(Radius.circular(10)),
                                  border: Border.all(color: Theme.of(context).dividerColor),
                                  color: Theme.of(context).colorScheme.background,
                                ),
                                child: Row(
                                  children: <Widget>[
                                    Expanded(
                                      child: TextFormField(
                                        controller: companyId,
                                        autofocus: true,
                                        style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                                          color: Theme.of(context).textTheme.titleLarge!.color,
                                        ),
                                        keyboardType: TextInputType.number,
                                        decoration: InputDecoration(
                                          hintText: 'Company ID',
                                          hintStyle: Theme.of(context).textTheme.bodyMedium!.copyWith(
                                            color: Theme.of(context).dividerColor,
                                          ),
                                          border: InputBorder.none,
                                          prefixIcon: Icon(Icons.workspaces_rounded,
                                              color: Colors.red),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              SizedBox(
                                height: 20,
                              ),
                              Container(
                                height: 40,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.all(Radius.circular(10)),
                                  border: Border.all(color: Theme.of(context).dividerColor),
                                  color: Theme.of(context).colorScheme.background,
                                ),
                                child: Row(
                                  children: <Widget>[
                                    Expanded(
                                      child: TextFormField(
                                        controller: username,
                                        autofocus: false,
                                        style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                                          color: Theme.of(context).textTheme.titleLarge!.color,
                                        ),
                                        keyboardType: TextInputType.text,
                                        decoration: InputDecoration(
                                          hintText: 'Driver ID',
                                          hintStyle: Theme.of(context).textTheme.bodyMedium!.copyWith(
                                            color: Theme.of(context).dividerColor,
                                          ),
                                          border: InputBorder.none,
                                          prefixIcon: Icon(Icons.person, color: Colors.red),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              SizedBox(
                                height: 20,
                              ),
                              Container(
                                height: 40,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.all(Radius.circular(10)),
                                  border: Border.all(color: Theme.of(context).dividerColor),
                                  color: Theme.of(context).colorScheme.background,
                                ),
                                child: Row(
                                  children: <Widget>[
                                    Expanded(
                                      child: TextFormField(
                                        controller: pwd,
                                        autofocus: false,
                                        style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                                          color: Theme.of(context).textTheme.titleLarge!.color,
                                        ),
                                        keyboardType: TextInputType.text,
                                        obscureText: obscure,
                                        decoration: InputDecoration(
                                          hintStyle: Theme.of(context).textTheme.bodyMedium!.copyWith(
                                            color: Theme.of(context).dividerColor,
                                          ),
                                          border: InputBorder.none,
                                          hintText: "Enter Password",
                                          prefixIcon: const Icon(Icons.lock_open,
                                              color: Colors.red),
                                          suffixIcon: IconButton(
                                            icon: Icon(obscure ? Icons.visibility_off
                                                  : Icons.visibility,
                                              color: Colors.black54,
                                            ),
                                            onPressed: () {
                                              setState(() {
                                                obscure = !obscure;
                                              });
                                            },
                                          ),
                                        ),

                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              SizedBox(
                                height: 20,
                              ),
                              InkWell(
                                highlightColor: Colors.transparent,
                                splashColor: Colors.transparent,
                                onTap: () async {
                                  if (companyId.text == "" ||
                                      username.text == "" ||
                                      pwd.text == "") {
                                    ft.Fluttertoast.showToast(
                                      msg: "Please Fill all Fields",
                                      toastLength: ft.Toast.LENGTH_LONG,
                                    );
                                    return;
                                  }
                                  API.showLoading('Signing In', context);
                                  API
                                      .logIn(username.text, companyId.text, pwd.text,
                                      context)
                                      .then((value) {
                                    if (value) {
                                      SharedPreferences.getInstance().then((prefs) {prefs.clear();
                                      prefs.setString('username', username.text.toString()).then((value) {prefs.setString('userid',
                                        Provider.of<HomePro>(context, listen: false).userid.toString(),).then(
                                            (value) {prefs.setString('token', Provider.of<HomePro>(context, listen: false).token).then(
                                              (value) async {

                                                await getUserInfo(Provider.of<HomePro>(context, listen: false).userid);
                                            if (kDebugMode) {
                                              print(
                                                "SHARED PREFERENCES SAVEDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDD",
                                              );
                                            }

                                            Navigator.of(context).pushNamedAndRemoveUntil(
                                              Routes.HOME,
                                                  (route) => false,
                                            );
                                          },
                                        );
                                        },
                                      );
                                      },
                                      );
                                      },
                                      );
                                    } else {
                                      Navigator.of(context, rootNavigator: true)
                                          .pop();
                                    }
                                  });
                                  print(
                                      "AYAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAa");
                                  return;
                                },
                                child: Container(
                                  height: 40,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(10),
                                    color: Theme.of(context).textTheme.titleLarge!.color,
                                  ),
                                  child: Center(
                                    child: Text(
                                      AppLocalizations.of('Log In'),
                                      style: Theme.of(context).textTheme.labelLarge!.copyWith(
                                        fontWeight: FontWeight.bold,
                                        color: Theme.of(context).scaffoldBackgroundColor,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                              const SizedBox(
                                height: 20,
                              ),
                            ],
                          ),
                        ),
                      ),
                      const Expanded(
                        child: SizedBox(),
                        flex: 3,
                      ),
                    ],
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
