import 'package:flutter/material.dart';
import 'package:flutter_ringtone_player/flutter_ringtone_player.dart';
import 'package:provider/provider.dart';
import 'package:taxi_app/Api & Routes/api.dart';
import 'package:taxi_app/Api & Routes/routes.dart';
import 'package:taxi_app/presentation/home/userDetail.dart';
import 'package:taxi_app/providers/currentjobspro.dart';
import 'package:taxi_app/providers/homepro.dart';
import 'package:url_launcher/url_launcher.dart';
import '../Language/appLocalizations.dart';
import '../constance/constance.dart';
import '../providers/themepro.dart';
class CurrentJobs extends StatefulWidget {
  const CurrentJobs({super.key});
  @override
  State<CurrentJobs> createState() => _CurrentJobsState();
}

class _CurrentJobsState extends State<CurrentJobs> {
  @override
  void initState() {
    super.initState();
    getMyCurrentJobs();
  }

  getMyCurrentJobs() async {
    if (mounted) {
      while (true) {
        Provider.of<CurrentJobsPro>(context, listen: false).isloaded = false;
        Provider.of<CurrentJobsPro>(context, listen: false).notifyListenerz();
        var val = await API.getCurrentJobs(Provider.of<HomePro>(context, listen: false).userid, context);
        if( Provider.of<CurrentJobsPro>(context, listen: false).jobs.isNotEmpty){
          Navigator.push(context, MaterialPageRoute(builder: (context) => UserDetailScreen(
              item: Provider.of<CurrentJobsPro>(context, listen: false).jobs[0])));
        }
        if (val) {
          Provider.of<CurrentJobsPro>(context, listen: false).isloaded = true;
          Provider.of<CurrentJobsPro>(context, listen: false).notifyListenerz();
          break;
        }
      }
    }
  }
  Future<void> openGoogleMapsNavigationToDestination(
      double latitude, double longitude) async {
    final url = "google.navigation:q=$latitude,$longitude";
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.of(context).secondaryDimColor,
      body: Provider.of<CurrentJobsPro>(context).isloaded
          ? Provider.of<CurrentJobsPro>(context).jobs.isEmpty
          ? Center(
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
            SizedBox(height: RouteManager.width / 23),
            InkWell(
              onTap: () async {
                Provider.of<CurrentJobsPro>(context, listen: false)
                    .isloaded = false;
                Provider.of<CurrentJobsPro>(context, listen: false)
                    .notifyListenerz();
                await getMyCurrentJobs();
              },
              child: Text(
                "Tap Here to Refresh",
                style: TextStyle(
                  fontSize: RouteManager.width / 18,
                  color: Colors.blue,
                ),
              ),
            ),
          ],
        ),
      )
          : Container(
        padding: EdgeInsets.only(
          top: RouteManager.width / 80,
          left: RouteManager.width / 80,
        ),
        child: ListView.builder(
          itemCount: Provider.of<CurrentJobsPro>(context).jobs.length,
          itemBuilder: (context, index) {
            var item = Provider.of<CurrentJobsPro>(context).jobs[index];
            return Column(
              children:[
                Padding(
                  padding: EdgeInsets.only(right: 6, left: 6),
                  child: InkWell(
                    highlightColor: Colors.transparent,
                    splashColor: Colors.transparent,
                    onTap: () {
                      Navigator.push(context, MaterialPageRoute(builder: (context) => UserDetailScreen(item: item),),);
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
                                  ClipRRect(
                                    borderRadius: BorderRadius.circular(10),
                                    child: Image.asset(
                                      ConstanceData.user8,
                                      height: 50,
                                      width: 50,
                                    ),
                                  ),
                                  const SizedBox(
                                    width: 8,
                                  ),
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
                                        '\$${item.total_amount}',
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
                                    const SizedBox(
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
                          Container(
                            height: 1,
                            width: MediaQuery.of(context).size.width,
                            color: Theme.of(context).dividerColor,
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 16,),
                InkWell(
                  onTap: (){
                    Navigator.push(context, MaterialPageRoute(builder: (context) => UserDetailScreen(
                        item: Provider.of<CurrentJobsPro>(context, listen: false).jobs[0])));
                  },
                  child: Padding(
                    padding: const EdgeInsets.only(right: 14, left: 14, top: 16),
                    child: Container(
                      height: 40,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        color: Theme.of(context).primaryColor,
                      ),
                      child: Center(
                        child: Text(
                          AppLocalizations.of('Open'),
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
            );
          },
        ),
      )
          : const Center(child: CircularProgressIndicator()),
    );
  }
}