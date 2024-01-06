import 'package:flutter/material.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import '../../Api & Routes/api.dart';
import '../../Api & Routes/routes.dart';
import '../../Entities/jobsobject.dart';
import '../../pages/home.dart';
import '../home/userDetail.dart';
class CompleteJobsDetailScreen extends StatefulWidget {
  final JobObject item;
  const CompleteJobsDetailScreen({super.key, required this.item});

  @override
  State<CompleteJobsDetailScreen> createState() => _CompleteJobsDetailScreenState();
}

class _CompleteJobsDetailScreenState extends State<CompleteJobsDetailScreen> {
  dynamic list;
  bool listLoad = true;
  List<LatLng> polylineCoordinates = [];
  late LatLng sourceLocation;
  late LatLng destinationLocation;

  Future<void> _drawRoute() async {
    var fetchedList = await API.getJobDetails(widget.item.bookid.toString(), context);
    list = fetchedList;
    sourceLocation = LatLng(double.parse(list[0]['BD_LAT']), double.parse(list[0]['BD_LANG']),);
    destinationLocation = LatLng(double.parse(list[list.length-1]['BD_LAT']), double.parse(list[list.length-1]['BD_LANG']),);
  }
  Future<void> getPolyPoints() async {
    PolylinePoints polylinePoints = PolylinePoints();
    PolylineResult result = await polylinePoints.getRouteBetweenCoordinates(
      'AIzaSyD7nCnza24yu8qP2q5B0o7y0Qg54oUdNE4',
      PointLatLng(sourceLocation.latitude, sourceLocation.longitude),
      PointLatLng(destinationLocation.latitude, destinationLocation.longitude),
    );

    if (result.points.isNotEmpty) {
      setState(() {
        polylineCoordinates.clear();
        for (var point in result.points) {
          polylineCoordinates.add(LatLng(point.latitude, point.longitude));
        }
        listLoad = false;
        setState(() {

        });
      });
    }
  }Future<void> loadData()async {
    await _drawRoute();
    await getPolyPoints();
  }
  @override
  void initState() {
    super.initState();
    loadData();
  }
  @override
  Widget build(BuildContext context) {
    RouteManager.context=context;
    JobObject item = widget.item;
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
            Text('#${item.bookid}', style: Theme.of(context).textTheme.titleLarge!.copyWith(
              fontWeight: FontWeight.bold,
              color: Theme.of(context).textTheme.titleLarge!.color,
            ),
            ),
            const SizedBox(
              width: 20,
            ),
          ],
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: <Widget>[
            userDetailbar(item,context),
            Column(
              children: [
                Container(
                  color: Theme.of(context).primaryColorDark,
                  child: Padding(
                    padding: const EdgeInsets.only(right: 14, left: 14),
                    child: Container(
                      height: 1,
                      width: MediaQuery.of(context).size.width,
                      color: Theme.of(context).dividerColor,
                    ),
                  ),
                ),
                Container(
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(4)
                  ),
                  child: ListTile(
                    title: Text(
                      'Pick Up',
                      style: Theme.of(context).textTheme.bodySmall!.copyWith(
                        color: Theme.of(context).disabledColor,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    subtitle: Column(
                      crossAxisAlignment:
                      CrossAxisAlignment.start,
                      children: [
                        Text(
                          item.pickupadress,
                          style: Theme.of(context).textTheme.titleSmall!.copyWith(
                            fontWeight: FontWeight.bold,
                            color: Theme.of(context).textTheme.titleLarge!.color,
                          ),
                        ),
                      ],
                    ),
                    trailing: IconButton(
                      icon: const Icon(Icons.navigation_rounded,
                          color: Colors.red),
                      onPressed: () {
                        openGoogleMapsNavigationToDestination(item.dlat, item.dlong,
                        );
                      },
                    ),
                  ),
                ),
              ],
            ),
            Column(
              children: [
                Container(
                  color: Theme.of(context).primaryColorDark,
                  child: Padding(
                    padding: const EdgeInsets.only(right: 14, left: 14),
                    child: Container(
                      height: 1,
                      width: MediaQuery.of(context).size.width,
                      color: Theme.of(context).dividerColor,
                    ),
                  ),
                ),
                Container(
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(4)
                  ),
                  child: ListTile(
                    title: Text(
                      'Drop off',
                      style: Theme.of(context).textTheme.bodySmall!.copyWith(
                        color: Theme.of(context).disabledColor,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    subtitle: Column(
                      crossAxisAlignment:
                      CrossAxisAlignment.start,
                      children: [
                        Text(
                          item.dropaddress,
                          style: Theme.of(context).textTheme.titleSmall!.copyWith(
                            fontWeight: FontWeight.bold,
                            color: Theme.of(context).textTheme.titleLarge!.color,
                          ),
                        ),
                      ],
                    ),
                    trailing: IconButton(
                      icon: const Icon(Icons.navigation_rounded,
                          color: Colors.red),
                      onPressed: () {
                        openGoogleMapsNavigationToDestination(item.plat, item.plong,
                        );
                      },
                    ),
                  ),
                ),
              ],
            ),
            listLoad
                ? const Center(child: CircularProgressIndicator())
                : Expanded(
              flex: 2,
              child: GoogleMap(
                initialCameraPosition: CameraPosition(
                  target: sourceLocation,
                  zoom: 7,
                ),
                polylines: {
                  Polyline(polylineId: const PolylineId('route'),
                    color: Colors.blue,
                    width: 8,
                    points: polylineCoordinates,),
                },
                mapType: MapType.normal,
                markers: {
                  Marker(
                    markerId: const MarkerId('source'),
                    position: sourceLocation,
                    icon: BitmapDescriptor.defaultMarkerWithHue(
                        BitmapDescriptor.hueGreen),
                    infoWindow: const InfoWindow(title: 'Start Point'),
                  ),
                  Marker(
                    markerId: const MarkerId('destination'),
                    position: destinationLocation,
                    icon: BitmapDescriptor.defaultMarkerWithHue(
                        BitmapDescriptor.hueRed),
                    infoWindow: const InfoWindow(title: 'End Point'),
                  ),
                },
              ),
            ),
            Container(
              color: Theme.of(context).scaffoldBackgroundColor,
              child: Padding(
                padding: const EdgeInsets.only(right: 14, left: 14),
                child: Flex(
                  direction: Axis.vertical,
                  children: [
                    MySeparator(
                      color: Theme.of(context).primaryColor,
                      height: 1,
                    ),
                  ],
                ),
              ),
            ),
            noted(item,context),
            Container(
              color: Theme.of(context).scaffoldBackgroundColor,
              child: Padding(
                padding: const EdgeInsets.only(right: 14, left: 14),
                child: Flex(
                  direction: Axis.vertical,
                  children: [
                    MySeparator(
                      color: Theme.of(context).primaryColor,
                      height: 1,
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(
              height: MediaQuery.of(context).padding.bottom,
            )
          ],
        ),
      ),
    );
  }
}