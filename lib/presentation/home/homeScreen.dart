import 'package:animator/animator.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:flutter_ringtone_player/flutter_ringtone_player.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:taxi_app/presentation/home/riderList.dart';
import '../../Api & Routes/api.dart';
import '../../Api & Routes/routes.dart';
import '../../providers/homepro.dart';
import '../constance/constance.dart';
import '../drawer/drawer.dart';
import 'package:provider/provider.dart';
import '../appTheme.dart';
import '../Language/appLocalizations.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  bool isOffline = false;
  bool isLoading = false;
  late BitmapDescriptor bitmapDescriptorStartLocation;
  late BitmapDescriptor bitmapDescriptorStartLocation2;
  late BitmapDescriptor bitmapDescriptorStartLocation3;
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  var long = 73.0479;
  var lat = 34.34433;

  var lat2 = 51.509587;
  var long2 = -0.080282;

  var lat3 = 51.505944;
  var long3 = -0.087001;

  late GoogleMapController mapController;

  @override
  void initState() {
    super.initState();
    loadData();
    if(Provider.of<HomePro>(context, listen: false).shiftid!=-1) {
      setState(() {
        isOffline = true;
      });
    }
  }
  Future<void> loadData()async{
   var pos = await Geolocator.getCurrentPosition();
   lat = pos.latitude;
   long = pos.longitude;
   setState(() {

   });
}
  @override
  Widget build(BuildContext context) {
    RouteManager.context = context;
    seticonimage(context);
    seticonimage2(context);
    seticonimage3(context);
    return Container(
      color: Theme.of(context).scaffoldBackgroundColor,
      child: Scaffold(
        key: _scaffoldKey,
        drawer: SizedBox(
          width: MediaQuery.of(context).size.width * 0.75 < 400 ? MediaQuery.of(context).size.width * 0.75 : 350,
          child: const Drawer(
            child: AppDrawer(
              selectItemName: 'Home',
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
                child: !isOffline
                    ? Text(
                        AppLocalizations.of('OffLine'),
                        style: Theme.of(context).textTheme.titleLarge!.copyWith(
                              fontWeight: FontWeight.bold,
                              color: Theme.of(context).textTheme.titleLarge!.color,
                            ),
                        textAlign: TextAlign.center,
                      )
                    : Text(
                        AppLocalizations.of('Online'),
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
                child: Container(
                  alignment: Alignment.centerRight,
                  child: Switch(
                    activeColor: Theme.of(context).primaryColor,
                    value: isOffline,
                    onChanged: (bool value) async {
                      setState(() {
                        isLoading = true;
                        isOffline = value;
                      });
                      String? userid = (await SharedPreferences.getInstance()).getString("userid");
                      if(value){
                        if(await API.startShift(int.parse(userid!),context)){
                          FlutterRingtonePlayer.playNotification();
                          isOffline = value;
                        }else{
                          isOffline = !isOffline;
                          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                              content: Text(
                                  'Check your Internet connection!!!')));
                        }
                      }
                      else{
                        if(await API.stopShift(
                          int.parse(userid!),
                          Provider.of<HomePro>(context, listen: false).shiftid,
                          context,
                        )){
                          API.postlocation = false;
                        }else{
                          isOffline = !isOffline;
                          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                              content: Text(
                                  'Check your Internet connection!!!')));
                        }
                      }
                      isLoading = false;
                      setState(() {
                      });
                    },
                  ),
                ),
              ),
            ],
          ),
        ),
        body: isLoading? const Center(child: CircularProgressIndicator(),)
            :Stack(
          children: <Widget>[
            GoogleMap(
              mapType: MapType.normal,
              initialCameraPosition: CameraPosition(
                target: LatLng(lat, long),
                zoom: 20,
              ),
              onMapCreated: (GoogleMapController controller) {
                mapController = controller;
                setLDMapStyle();
              },
              markers: Set<Marker>.of(getMarkerList(context).values),
              polylines: Set<Polyline>.of(getPolyLine(context).values),
            ),
            !isOffline
                ? Column(
                    children: <Widget>[
                      offLineMode(),
                      const Expanded(
                        child: SizedBox(),
                      ),
                      myLocation(),
                      const SizedBox(
                        height: 10,
                      ),
                      offLineModeDetail(),
                      Container(
                        height: MediaQuery.of(context).padding.bottom,
                        color: Theme.of(context).scaffoldBackgroundColor,
                      )
                    ],
                  )
                : Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      const Expanded(
                        child: SizedBox(),
                      ),
                      myLocation(),
                      const SizedBox(
                        height: 10,
                      ),
                      // onLineModeDetail(),
                    ],
                  ),
          ],
        ),
      ),
    );
  }

  Widget onLineModeDetail() {
    var bootmPadding = MediaQuery.of(context).padding.bottom;
    return Padding(
      padding: EdgeInsets.only(right: 10, left: 10, bottom: bootmPadding),
      child: InkWell(
        highlightColor: Colors.transparent,
        splashColor: Colors.transparent,
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => RiderList(),
              fullscreenDialog: true,
            ),
          );
        },
        child: Stack(
          alignment: Alignment.bottomCenter,
          children: <Widget>[
            Positioned(
              top: 0,
              right: 0,
              left: 0,
              bottom: 16,
              child: Padding(
                padding: const EdgeInsets.only(right: 24, left: 24),
                child: Animator<Offset>(
                  tween: Tween<Offset>(
                    begin: Offset(0, 0.5),
                    end: Offset(0, 0),
                  ),
                  duration: Duration(seconds: 1),
                  cycles: 1,
                  builder: (context, animate, _) => SlideTransition(
                    position: animate.animation,
                    child: Container(
                      decoration: BoxDecoration(
                        color: Theme.of(context).scaffoldBackgroundColor,
                        borderRadius: BorderRadius.circular(12),
                        boxShadow: [
                          new BoxShadow(
                            color: AppTheme.isLightTheme ? Colors.black.withOpacity(0.2) : Colors.white.withOpacity(0.2),
                            blurRadius: 12,
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
            Positioned(
              top: 12,
              right: 0,
              left: 0,
              bottom: 16,
              child: Padding(
                padding: const EdgeInsets.only(right: 12, left: 12),
                child: Animator<Offset>(
                  tween: Tween<Offset>(
                    begin: Offset(0, 0.5),
                    end: Offset(0, 0),
                  ),
                  duration: Duration(milliseconds: 700),
                  cycles: 1,
                  builder: (context, animate, _) => SlideTransition(
                    position: animate.animation,
                    child: Container(
                      decoration: BoxDecoration(
                        color: Theme.of(context).scaffoldBackgroundColor,
                        borderRadius: BorderRadius.circular(12),
                        boxShadow: [
                          new BoxShadow(
                            color: AppTheme.isLightTheme ? Colors.black.withOpacity(0.2) : Colors.white.withOpacity(0.2),
                            blurRadius: 6,
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
            Animator<Offset>(
              tween: Tween<Offset>(
                begin: Offset(0, 0.4),
                end: Offset(0, 0),
              ),
              duration: const Duration(milliseconds: 700),
              cycles: 1,
              builder: (context, animate, _) => SlideTransition(
                position: animate.animation,
                child: Padding(
                  padding: const EdgeInsets.only(top: 24),
                  child: Container(
                    decoration: BoxDecoration(
                      color: Theme.of(context).scaffoldBackgroundColor,
                      borderRadius: BorderRadius.circular(12),
                      boxShadow: [
                        BoxShadow(
                          color: Theme.of(context).dividerColor,
                          blurRadius: 4,
                        ),
                      ],
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(12),
                      child: Column(
                        children: <Widget>[
                          Container(
                            padding: const EdgeInsets.all(14),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                ClipRRect(
                                  borderRadius: BorderRadius.circular(10),
                                  child: Image.asset(
                                    ConstanceData.userImage,
                                    height: 40,
                                    width: 40,
                                  ),
                                ),
                                const SizedBox(
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
                                    const SizedBox(
                                      height: 4,
                                    ),
                                    Row(
                                      children: <Widget>[
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
                                              AppLocalizations.of('ApplePay'),
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
                                            borderRadius: BorderRadius.all(
                                              Radius.circular(15),
                                            ),
                                            color: Theme.of(context).primaryColor,
                                          ),
                                          child: Center(
                                            child: Text(
                                              AppLocalizations.of('Discount'),
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
                          Divider(
                            height: 0.5,
                            color: Theme.of(context).disabledColor,
                          ),
                          Padding(
                            padding: const EdgeInsets.only(right: 14, left: 14, top: 10, bottom: 10),
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
                          Divider(
                            height: 0.5,
                            color: Theme.of(context).disabledColor,
                          ),
                          Padding(
                            padding: const EdgeInsets.only(right: 14, left: 14, top: 10, bottom: 10),
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
                          Divider(
                            height: 0.5,
                            color: Theme.of(context).disabledColor,
                          ),
                          Padding(
                            padding: const EdgeInsets.only(right: 14, left: 14, top: 10, bottom: 10),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: <Widget>[
                                Container(
                                  height: 32,
                                  width: 80,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(10),
                                    color: Theme.of(context).scaffoldBackgroundColor,
                                  ),
                                  child: Center(
                                    child: Text(
                                      AppLocalizations.of('Ignore'),
                                      style: Theme.of(context).textTheme.labelLarge!.copyWith(
                                        fontWeight: FontWeight.bold,
                                        color: Theme.of(context).disabledColor,
                                      ),
                                    ),
                                  ),
                                ),
                                const SizedBox(
                                  width: 10,
                                ),
                                Container(
                                  height: 32,
                                  width: 80,
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
                              ],
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void setLDMapStyle() async {
    // ignore: unnecessary_null_comparison
    if (mapController != null) {
      if (AppTheme.isLightTheme) {
        mapController.setMapStyle(await DefaultAssetBundle.of(context).loadString("jsonFile/lightmapstyle.json"));
      } else {
        mapController.setMapStyle(await DefaultAssetBundle.of(context).loadString("jsonFile/darkmapstyle.json"));
      }
    }
  }

  Widget offLineModeDetail() {
    return Container(
      height: 170,
      decoration: BoxDecoration(
        color: Theme.of(context).scaffoldBackgroundColor,
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(15),
          topRight: Radius.circular(15),
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.only(right: 14, left: 14),
        child: Column(
          children: <Widget>[
            const SizedBox(
              height: 8,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Container(
                  height: 4,
                  width: 50,
                  decoration: BoxDecoration(
                    color: Theme.of(context).dividerColor,
                    borderRadius: BorderRadius.circular(15),
                  ),
                ),
              ],
            ),
            const SizedBox(
              height: 8,
            ),
            Row(
              children: <Widget>[
                CircleAvatar(
                  radius: 16,
                  backgroundImage: AssetImage(
                    ConstanceData.userImage,
                  ),
                ),
                const SizedBox(
                  width: 8,
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      AppLocalizations.of('Jeremiah Curtis'),
                      style: Theme.of(context).textTheme.titleLarge!.copyWith(
                            fontWeight: FontWeight.bold,
                            color: Theme.of(context).textTheme.titleLarge!.color,
                          ),
                    ),
                    Text(
                      AppLocalizations.of('Basic level'),
                      style: Theme.of(context).textTheme.titleSmall!.copyWith(
                            fontWeight: FontWeight.bold,
                            color: Theme.of(context).primaryColor,
                          ),
                    ),
                  ],
                ),
                const Expanded(
                  child: SizedBox(),
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: <Widget>[
                    Text(
                      '\$325.00',
                      style: Theme.of(context).textTheme.titleLarge!.copyWith(
                            fontWeight: FontWeight.bold,
                            color: Theme.of(context).textTheme.titleLarge!.color,
                          ),
                    ),
                    Text(
                      AppLocalizations.of('Earned'),
                      style: Theme.of(context).textTheme.titleSmall!.copyWith(
                            fontWeight: FontWeight.bold,
                            color: Theme.of(context).primaryColor,
                          ),
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(
              height: 8,
            ),
            Container(
              height: 90,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                color: Theme.of(context).primaryColor,
              ),
              child: Padding(
                padding: const EdgeInsets.all(14),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: <Widget>[
                    Column(
                      children: <Widget>[
                        Icon(
                          FontAwesomeIcons.clock,
                          color: Theme.of(context).scaffoldBackgroundColor,
                          size: 20,
                        ),
                        const Expanded(
                          child: SizedBox(),
                        ),
                        const SizedBox(
                          height: 4,
                        ),
                        Text(
                          '10.2',
                          style: Theme.of(context).textTheme.titleMedium!.copyWith(
                                fontWeight: FontWeight.bold,
                                color: ConstanceData.secoundryFontColor,
                              ),
                        ),
                        Row(
                          children: <Widget>[
                            Text(
                              AppLocalizations.of('HOURS ONLINE'),
                              style: Theme.of(context).textTheme.bodySmall!.copyWith(
                                    fontWeight: FontWeight.bold,
                                    color: Theme.of(context).scaffoldBackgroundColor,
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
                          color: Theme.of(context).scaffoldBackgroundColor,
                          size: 20,
                        ),
                        const Expanded(
                          child: SizedBox(),
                        ),
                        const SizedBox(
                          height: 4,
                        ),
                        Text(
                          '30 KM',
                          style: Theme.of(context).textTheme.titleMedium!.copyWith(
                                fontWeight: FontWeight.bold,
                                color: ConstanceData.secoundryFontColor,
                              ),
                        ),
                        Row(
                          children: <Widget>[
                            Text(
                              AppLocalizations.of('TOTAL DISTANCE'),
                              style: Theme.of(context).textTheme.bodySmall!.copyWith(
                                    fontWeight: FontWeight.bold,
                                    color: Theme.of(context).scaffoldBackgroundColor,
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
                          color: Theme.of(context).scaffoldBackgroundColor,
                          size: 20,
                        ),
                        const Expanded(
                          child: SizedBox(),
                        ),
                        const SizedBox(
                          height: 4,
                        ),
                        Text(
                          '20',
                          style: Theme.of(context).textTheme.titleMedium!.copyWith(
                                fontWeight: FontWeight.bold,
                                color: ConstanceData.secoundryFontColor,
                              ),
                        ),
                        Row(
                          children: <Widget>[
                            Text(
                              AppLocalizations.of('TOTAL JOBS'),
                              style: Theme.of(context).textTheme.bodySmall!.copyWith(
                                    fontWeight: FontWeight.bold,
                                    color: Theme.of(context).scaffoldBackgroundColor,
                                  ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget myLocation() {
    return Padding(
      padding: const EdgeInsets.only(right: 14),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: <Widget>[
          Container(
            decoration: BoxDecoration(
              boxShadow: [
                BoxShadow(
                  color: Theme.of(context).primaryColor,
                  blurRadius: 12,
                  spreadRadius: -5,
                  offset: const Offset(0.0, 0),
                )
              ],
            ),
            child: CircleAvatar(
              radius: 20,
              backgroundColor: Theme.of(context).scaffoldBackgroundColor,
              child: Icon(
                Icons.my_location,
                color: Theme.of(context).textTheme.titleLarge!.color,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Map<PolylineId, Polyline> getPolyLine(BuildContext context) {
    Map<PolylineId, Polyline> polylines = <PolylineId, Polyline>{};
    if (isOffline) {
      List<LatLng> latlng1 = [
        LatLng(51.506115, -0.088339),
        LatLng(51.507129, -0.087974),
        LatLng(51.509693, -0.087075),
        LatLng(51.509065, -0.082206),
        LatLng(51.509159, -0.081173),
        LatLng(51.509346, -0.080675),
        LatLng(51.509540, -0.080293),
        LatLng(51.509587, -0.080282)
      ];
      List<LatLng> latlng2 = [
        LatLng(51.505951, -0.086974),
        LatLng(51.506051, -0.087634),
        LatLng(51.506115, -0.088339)
      ];
      const PolylineId polylineId = PolylineId('polylineId');
      final Polyline polyline = Polyline(
        polylineId: polylineId,
        color: Theme.of(context).primaryColor,
        consumeTapEvents: false,
        points: latlng1,
        width: 4,
        startCap: Cap.roundCap,
        endCap: Cap.roundCap,
      );

      const PolylineId polylineId1 = PolylineId('polylineId1');
      List<PatternItem> patterns1 = [PatternItem.dot, PatternItem.gap(1)];
      final Polyline polyline1 = Polyline(
        polylineId: polylineId1,
        color: Theme.of(context).primaryColor,
        consumeTapEvents: false,
        points: latlng2,
        width: 4,
        startCap: Cap.roundCap,
        endCap: Cap.roundCap,
        patterns: patterns1,
      );
      polylines.addAll({polylineId: polyline});
      polylines.addAll({polylineId1: polyline1});
    }
    return polylines;
  }

  Map<MarkerId, Marker> getMarkerList(BuildContext context) {
    seticonimage(context);
    seticonimage2(context);
    seticonimage3(context);
    Map<MarkerId, Marker> markers = <MarkerId, Marker>{};
    final MarkerId markerId1 = MarkerId("markerId1");
    final MarkerId markerId2 = MarkerId("markerId2");
    final MarkerId markerId3 = MarkerId("markerId3");
    final Marker marker1 = Marker(
      markerId: markerId1,
      position: LatLng(lat, long),
      anchor: const Offset(0.5, 0.5),
      icon: bitmapDescriptorStartLocation,
    );
    if (isOffline) {
      final Marker marker2 = Marker(
        markerId: markerId2,
        position: LatLng(lat2, long2),
        anchor: const Offset(0.5, 0.5),
        icon: bitmapDescriptorStartLocation3,
      );

      final Marker marker3 = Marker(
        markerId: markerId3,
        position: LatLng(lat3, long3),
        anchor: const Offset(0.5, 0.5),
        icon: bitmapDescriptorStartLocation2,
      );
      markers.addAll({markerId2: marker2});
      markers.addAll({markerId3: marker3});
    }
    markers.addAll({markerId1: marker1});
    return markers;
  }

  Future seticonimage3(BuildContext context) async {
    // ignore: unnecessary_null_comparison
    // if (bitmapDescriptorStartLocation3 == null) {
    final ImageConfiguration imagesStartConfiguration3 = createLocalImageConfiguration(context);
    bitmapDescriptorStartLocation3 = await BitmapDescriptor.fromAssetImage(
      imagesStartConfiguration3,
      ConstanceData.mylocation3,
    );
    setState(() {});
    // }
  }

  Future seticonimage2(BuildContext context) async {
    // ignore: unnecessary_null_comparison
    // if (bitmapDescriptorStartLocation2 == null) {
    final ImageConfiguration imagesStartConfiguration2 = createLocalImageConfiguration(context);
    bitmapDescriptorStartLocation2 = await BitmapDescriptor.fromAssetImage(
      imagesStartConfiguration2,
      ConstanceData.mylocation2,
    );
    setState(() {});
    // }
  }

  Future seticonimage(BuildContext context) async {
    // ignore: unnecessary_null_comparison
    // if (bitmapDescriptorStartLocation == null) {
    final ImageConfiguration imagesStartConfiguration = createLocalImageConfiguration(context);
    bitmapDescriptorStartLocation = await BitmapDescriptor.fromAssetImage(
      imagesStartConfiguration,
      ConstanceData.mylocation1,
    );
    setState(() {});
    // }
  }

  Widget offLineMode() {
    return Animator<double>(
      duration: const Duration(milliseconds: 400),
      cycles: 1,
      builder: (_, animatorState, __) => SizeTransition(
        sizeFactor: animatorState.animation,
        axis: Axis.horizontal,
        child: Container(
          height: AppBar().preferredSize.height,
          color: Theme.of(context).primaryColor,
          child: Padding(
            padding: const EdgeInsets.only(right: 14, left: 14),
            child: Row(
              children: <Widget>[
                DottedBorder(
                  color: ConstanceData.secoundryFontColor,
                  borderType: BorderType.Circle,
                  strokeWidth: 2,
                  child: Padding(
                    padding: const EdgeInsets.all(4),
                    child: Icon(
                      FontAwesomeIcons.cloudMoon,
                      color: ConstanceData.secoundryFontColor,
                    ),
                  ),
                ),
                const SizedBox(
                  width: 16,
                ),
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      AppLocalizations.of('You are offline !'),
                      style: Theme.of(context).textTheme.titleLarge!.copyWith(
                            fontWeight: FontWeight.bold,
                            color: ConstanceData.secoundryFontColor,
                          ),
                    ),
                    Text(
                      AppLocalizations.of('Go online to start accepting jobs.'),
                      style: Theme.of(context).textTheme.titleSmall!.copyWith(
                            color: ConstanceData.secoundryFontColor,
                          ),
                    ),
                  ],
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
