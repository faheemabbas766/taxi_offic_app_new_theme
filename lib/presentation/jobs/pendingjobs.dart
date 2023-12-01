import 'package:flutter/material.dart';
import 'package:flutter_ringtone_player/flutter_ringtone_player.dart';
import 'package:provider/provider.dart';
import '../../Api & Routes/api.dart';
import '../../Api & Routes/routes.dart';
import '../../Entities/jobsobject.dart';
import '../../providers/homepro.dart';
import '../Language/appLocalizations.dart';
import '../constance/constance.dart';
import '../home/userDetail.dart';

List<JobObject> pendingJobs = [];
class PendingJobs extends StatefulWidget {
  const PendingJobs({super.key});

  @override
  State<PendingJobs> createState() => _PendingJobsState();
}

class _PendingJobsState extends State<PendingJobs> {
  bool isLoading = true;
  @override
  void initState() {
    super.initState();
    loadData();
  }
  Future<void> loadData() async {
    await getMyPendingJobs();
    isLoading = false;
    setState(() {});
  }
  getMyPendingJobs() async {
    if(mounted){
      while (true) {
        var val = await API.getPendingJobs(
            Provider.of<HomePro>(context, listen: false).userid,context);
        if (val) {
          break;
        }
      }
    }
  }
  @override
  Widget build(BuildContext context) {
    RouteManager.context=context;
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
      body:isLoading? const Center(child: CircularProgressIndicator(),)
          :Column(
        children:[
          const SizedBox(
            height: 10,
          ),
          Expanded(
            child: ListView.builder(
              itemCount: pendingJobs.length,
              itemBuilder: (context, index) {
                var item = pendingJobs[index];
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

                      onTap: () async {
                        API.showLoading("", context);
                        API.respondToBooking(item.bookid,
                            2, context).then((value) {
                          Navigator.of(context, rootNavigator: true).pop();
                          Navigator.of(context, rootNavigator: true).pop();
                          Navigator.of(context)
                              .pushNamed(Routes.JOBS);
                        },
                        );
                        await FlutterRingtonePlayer.play(fromAsset: 'assets/accept_tone.mp3');
                      },
                      child: Padding(
                        padding: EdgeInsets.only(right: 14, left: 14, top: 16),
                        child: Container(
                          height: 40,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            color: Theme.of(context).primaryColor,
                          ),
                          child: Center(
                            child: Text(
                              AppLocalizations.of('Accept'),
                              style: Theme.of(context).textTheme.labelLarge!.copyWith(
                                fontWeight: FontWeight.bold,
                                color: ConstanceData.secoundryFontColor,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 16,
                    ),
                  ],
                );
              },
            ),
          ),
          SizedBox(
            height: MediaQuery.of(context).padding.bottom + 16,
          )
        ],
      )
    );
  }
}
