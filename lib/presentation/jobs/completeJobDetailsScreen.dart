import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import '../../Api & Routes/api.dart';
import '../../Api & Routes/routes.dart';
import '../../Entities/jobsobject.dart';
import '../home/userDetail.dart';
class CompleteJobsDetailScreen extends StatefulWidget {
  final JobObject item;
  const CompleteJobsDetailScreen({super.key, required this.item});

  @override
  State<CompleteJobsDetailScreen> createState() => _CompleteJobsDetailScreenState();
}

class _CompleteJobsDetailScreenState extends State<CompleteJobsDetailScreen> {
  final Set<Marker> _markers = {};
  dynamic list;
  bool listLoad = true;
  final List<LatLng> _points = [];
  final Set<Polyline> polyLines = {};

  Future<void> _drawRoute() async {
    var fetchedList = await API.getJobDetails(widget.item.bookid.toString(), context);
    list = fetchedList;
    for(var item in list){
      Map<String, dynamic> destination = item;
      _points.add(LatLng(double.parse(destination['BD_LAT']), double.parse(destination['BD_LANG'])));
    }
    listLoad = false;
    for (int i = 0; i < _points.length - 1; i++) {
      polyLines.add(
        Polyline(
          polylineId: PolylineId('route$i'),
          color: Colors.blue,
          points: [
            _points[i],
            _points[i + 1],
          ],
        ),
      );
    }
    setState(() {

    });
  }
  @override
  void initState() {
    super.initState();
    _drawRoute();
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
      body: Column(
        children: <Widget>[
          userDetailbar(item,context),
          Expanded(
            child: GoogleMap(
              initialCameraPosition: CameraPosition(
                target: _points.isEmpty ? const LatLng(34, 46) : _points.first, // Use the first point as initial camera position
                zoom: 10,
              ),
              mapType: MapType.normal,
              markers: _markers,
              polylines: polyLines,
              onMapCreated: (controller) {
                setState(() {
                });
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
          contact(item,context),
          SizedBox(
            height: MediaQuery.of(context).padding.bottom,
          )
        ],
      ),
    );
  }
}