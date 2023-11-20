import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:taxi_app/Api & Routes/api.dart';
import 'package:taxi_app/Api & Routes/routes.dart';
import 'package:taxi_app/presentation/home/userDetail.dart';
import 'package:taxi_app/providers/currentjobspro.dart';
import 'package:taxi_app/providers/homepro.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:velocity_x/velocity_x.dart';
import '../../Entities/jobsobject.dart';
import '../providers/themepro.dart';

List<JobObject> currentJobs = [];
class CurrentJobs extends StatefulWidget {
  const CurrentJobs({super.key});
  @override
  State<CurrentJobs> createState() => _CurrentJobsState();
}

class _CurrentJobsState extends State<CurrentJobs> {
  bool isLoading = true;
  @override
  void initState() {
    super.initState();
    fetchData();
  }
  Future<void> fetchData() async {
    await getMyCurrentJobs();
    setState(() {
      isLoading = false;
    });
}
  Future<void> getMyCurrentJobs() async {
    while (true) {
      print('helowwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwww');
      final homePro = Provider.of<HomePro>(context, listen: false);
      final val = await API.getCurrentJobs(homePro.userid, context);
      if (val) {
        break;
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
    RouteManager.context=context;
    return Scaffold(
      backgroundColor: AppColors.of(context).secondaryDimColor,
      body: isLoading ? currentJobs.isEmpty
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
          itemBuilder: (cont, index) {
            return InkWell(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => UserDetailScreen(
                        item: Provider.of<CurrentJobsPro>(context).jobs[0])),
                );
              },
              child: Column(
                children: [
                  SizedBox(
                    height: RouteManager.width / 80,
                  ),
                  Card(
                    color: AppColors.of(context).primaryColor,
                    child: Stack(
                      children: [
                        Column(
                          children: [
                            SizedBox(
                              height: RouteManager.width / 20,
                            ),
                            Container(
                              color: AppColors.of(context).secondaryColor,
                              width: RouteManager.width / 300,
                              height: RouteManager.width / 3,
                            ),
                          ],
                        ),
                        Column(
                          children: [
                            SizedBox(
                              height: RouteManager.width / 6.4,
                            ),
                            80.heightBox,
                            Row(
                              mainAxisAlignment:
                              MainAxisAlignment.start,
                              children: [
                                5.widthBox,
                                Image.asset(
                                  'assets/money.png',
                                  width: 14,
                                  height: 14,
                                ),
                                const SizedBox(
                                  width: 10,
                                ),
                                Text(
                                  "${Provider.of<CurrentJobsPro>(context).jobs[index].total_amount} £",
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: const Color.fromARGB(
                                        255, 47, 150, 44),
                                    fontSize:
                                    RouteManager.width / 20,
                                  ),
                                ),
                                SizedBox(
                                    width: RouteManager.width / 80),
                              ],
                            ),
                          ],
                        ),
                        Column(
                          children: [
                            Row(
                              mainAxisAlignment:
                              MainAxisAlignment.start,
                              children: [
                                const Padding(
                                  padding: EdgeInsets.symmetric(
                                    horizontal: 5,
                                    vertical: 5,
                                  ),
                                  child: Icon(Icons.person),
                                ),
                                const SizedBox(
                                  width: 10,
                                ),
                                Text(
                                  Provider.of<CurrentJobsPro>(
                                      context)
                                      .jobs[index]
                                      .name,
                                  style: TextStyle(
                                    fontWeight: FontWeight.w500,
                                    fontSize:
                                    RouteManager.width / 23,
                                    color: AppColors.of(context).secondaryColor,
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(
                                height: RouteManager.width / 30),
                            Stack(
                              children: [
                                SizedBox(
                                    width: RouteManager.width / 30),
                                Icon(
                                  Icons.location_on_outlined,
                                  color: Colors.red,
                                  size: RouteManager.width / 16,
                                ),
                                Row(
                                  children: [
                                    SizedBox(width: RouteManager.width / 14),
                                    SizedBox(width: RouteManager.width / 1.51,
                                      child: Text(
                                        Provider.of<CurrentJobsPro>(
                                            context,
                                            listen: false)
                                            .jobs[index]
                                            .dropaddress,
                                        style: TextStyle(
                                          fontWeight:
                                          FontWeight.bold,
                                          color: AppColors.of(context).secondaryColor,
                                          fontSize: 14,
                                        ),
                                        maxLines: 2,
                                        overflow:
                                        TextOverflow.ellipsis,
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                            SizedBox(height: RouteManager.width / 40),
                            SizedBox(height: RouteManager.width / 60,
                            ),
                            Stack(
                              children: [
                                SizedBox(width: RouteManager.width / 30),
                                Icon(
                                  Icons.location_on_outlined,
                                  color: Colors.green,
                                  size: RouteManager.width / 16,
                                ),
                                Row(
                                  children: [
                                    SizedBox(width: RouteManager.width / 14),
                                    Text(
                                      Provider.of<CurrentJobsPro>(
                                          context,
                                          listen: false)
                                          .jobs[index]
                                          .pickupadress,
                                      style: TextStyle(
                                        fontWeight:
                                        FontWeight.bold,
                                        color: AppColors.of(context).secondaryColor,
                                        fontSize:14,
                                      ),
                                      maxLines: 2,
                                      overflow:
                                      TextOverflow.ellipsis,
                                    ),
                                  ],
                                ),
                              ],
                            ),
                            SizedBox(height: RouteManager.width / 500),
                          ],
                        ),
                      ],
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      12.widthBox,
                      Image.asset("assets/Line.png"),
                    ],
                  ),
                ],
              ),
            );
          },
        ),
      ) : const Center(child: CircularProgressIndicator()),
    );
  }
}