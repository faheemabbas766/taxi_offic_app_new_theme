import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';
import 'package:taxi_app/presentation/vehicalManagement/addVehicalScreen.dart';
import 'package:taxi_app/presentation/vehicalManagement/vehicleDetailsScreen.dart';
import '../../Api & Routes/api.dart';
import '../../providers/homepro.dart';
import '../../providers/startshiftpro.dart';
import '../Language/appLocalizations.dart';
import '../constance/constance.dart';

class VehicleManagement extends StatefulWidget {
  const VehicleManagement({super.key});
  @override
  _VehicleManagementState createState() => _VehicleManagementState();
}

class _VehicleManagementState extends State<VehicleManagement> {
  @override
  void initState() {
    super.initState();
    loadData();
  }
  void loadData() async {
    await API.getVehicles(Provider.of<HomePro>(context, listen: false).userid, context);
    setState(() {

    });
  }
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
            Text(
              AppLocalizations.of('Vehicle Management'),
              style: Theme.of(context).textTheme.titleLarge!.copyWith(
                    fontWeight: FontWeight.bold,
                    color: Theme.of(context).textTheme.titleLarge!.color,
                  ),
            ),
            const SizedBox(),
          ],
        ),
      ),
      body: ListView.builder(
        itemCount: Provider.of<StartShiftPro>(context, listen: false).vehicles.length,
        itemBuilder: (context, index) {
          var item = Provider.of<StartShiftPro>(context, listen: false).vehicles[index];
          return Padding(
            padding: const EdgeInsets.all(8.0),
            child: InkWell(
              onTap: (){
                Navigator.of(context).push(
                    MaterialPageRoute(builder: (context) => VehicleDetailsScreen(vehicleId: item.id),));
              },
              child: Card(
                elevation: 4,
                margin: const EdgeInsets.all(0),
                color: Theme.of(context).scaffoldBackgroundColor,
                child: Padding(
                  padding: const EdgeInsets.all(14),
                  child: Row(
                    children: <Widget>[
                      Column(
                        children: <Widget>[
                          CircleAvatar(
                            backgroundColor: Theme.of(context).primaryColor,
                            radius: 30,
                            child: Icon(
                              FontAwesomeIcons.filePdf,
                              color: ConstanceData.secoundryFontColor,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(
                        width: 8,
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Text(
                            AppLocalizations.of(item.make),
                            style: Theme.of(context).textTheme.titleLarge!.copyWith(
                              fontWeight: FontWeight.bold,
                              color: Theme.of(context).textTheme.titleLarge!.color,
                            ),
                          ),
                          const SizedBox(
                            height: 2,
                          ),
                          Text(
                            item.model,
                            style: Theme.of(context).textTheme.titleSmall!.copyWith(
                              fontWeight: FontWeight.bold,
                              color: Theme.of(context).disabledColor,
                            ),
                          ),
                        ],
                      ),
                      const Expanded(child: SizedBox()),
                      item.status=='1'?Icon(
                        Icons.check_circle,
                        size: 28,
                        color: Theme.of(context).primaryColor,
                      ):Container()
                    ],
                  ),
                ),
              ),
            ),
          );
        },
      ),
      floatingActionButton:FloatingActionButton(
          backgroundColor: Theme.of(context).primaryColor,
          onPressed: (){
            Navigator.push(context, MaterialPageRoute(builder: (context) => AddNewVehicle(
                VehicleDetails(userRef: '', uvColor: '',uvCurrentVehicle: '',
                    uvId: '',uvImage: '',uvInsuranceExpiry: '',uvInsuranceImage: '',
                uvInsuranceNumber:'',uvLogBook:'',uvMake: '',uvModel: '',uvMotExpiry:'',uvMotImage: '',
                uvMotNumber: '',uvNumber:'',uvRegNum: '',uvStatus: '',uvVehicleRhvBadgeExpiry: '',
                uvVehicleRhvBadgeImage: '',uvVehicleRhvBadgeNumber: '',uvYear: '' )),));
          },
          child: const Icon(Icons.add)
      ),
    );
  }
}
