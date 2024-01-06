import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../Api & Routes/routes.dart';
import '../../providers/homepro.dart';
import '../drawer/drawer.dart';
import '../Language/appLocalizations.dart';
import 'package:http/http.dart'as http;

class ShiftDetailsScreen extends StatefulWidget {
  const ShiftDetailsScreen({super.key});

  @override
  _InviteFriendScreenState createState() => _InviteFriendScreenState();
}

class _InviteFriendScreenState extends State<ShiftDetailsScreen> {
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  List<Map<String, dynamic>> shiftInfo = [];
  bool isLoading = true;
  Future<void> fetchData() async {
    try {
      var request = http.MultipartRequest(
        'POST',
        Uri.parse("https://minicab.imdispatch.co.uk/api/get_shift_info"),
      );
      request.headers.addAll({
        'Content-type': 'multipart/form-data',
        'Accept': 'application/json',
        'token': Provider.of<HomePro>(context, listen: false).token,
      });
      request.fields.addAll({
        'id': Provider.of<HomePro>(context, listen: false).shiftid.toString(),
      });
      http.StreamedResponse response =
      await request.send().timeout(const Duration(seconds: 25), onTimeout: () {
        throw "TimeOut";
      });
      var responsed = await http.Response.fromStream(response);

      if (responsed.statusCode == 401) {
        SharedPreferences prefs = await SharedPreferences.getInstance();
        await prefs.clear();
        Navigator.of(context).pushNamedAndRemoveUntil(
          Routes.LOGIN,
              (route) => false,
        );
      }
      else if (responsed.statusCode == 200) {
        var jsonResponse = json.decode(responsed.body);
        print('Shift:::::::::::::::::::::::::::::::::::::::$jsonResponse');
        if(jsonResponse['status'] == '404'){
          isLoading = false;
          shiftInfo = [];
          setState(() {

          });
        }
        shiftInfo =
        List<Map<String, dynamic>>.from(jsonResponse['shift_info']);
        isLoading = false;
        setState(() {
        });
      } else {
        print('Request failed with status: ${responsed.statusCode}');
      }
    } catch (e) {
      print('Error fetching data: $e');
      // Handle error, show a message or retry mechanism if needed
    }
  }

  @override
  void initState() {
    super.initState();
    fetchData();
  }
  @override
  Widget build(BuildContext context) {
    Widget _buildField(String label, String value) {
      return Padding(
        padding: EdgeInsets.symmetric(vertical: 4.0),
        child: RichText(
          text: TextSpan(
            style: TextStyle(
              color: Colors.black87,
              fontSize: 16.0,
            ),
            children: [
              TextSpan(
                text: '$label: ',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              TextSpan(text: value),
            ],
          ),
        ),
      );
    }
    String _formatDateTime(String dateTimeString) {
      DateTime dateTime = DateTime.parse(dateTimeString);
      String formattedDateTime =
      DateFormat.yMMMd().add_jm().format(dateTime); // Customize the format as per your need
      return formattedDateTime;
    }
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      key: _scaffoldKey,
      drawer: SizedBox(
        width: MediaQuery.of(context).size.width * 0.75 < 400 ? MediaQuery.of(context).size.width * 0.75 : 350,
        child: const Drawer(
          child: AppDrawer(
            selectItemName: 'Shift Details',
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
                AppLocalizations.of('Shift Details'),
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
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : shiftInfo.isEmpty
          ? const Center(child: Text('No Shift Found!!!'))
          :
      Padding(
        padding: const EdgeInsets.only(left: 14, right: 14, top: 50),
        child: ListView.builder(
          itemCount: shiftInfo.length,
          itemBuilder: (context, index) {
            var shift = shiftInfo[index];
            return Card(
              margin: EdgeInsets.all(8.0),
              child: Padding(
                padding: EdgeInsets.all(8.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildField('Start Time', _formatDateTime(shift['SHF_DATE_TIME_FROM'])),
                    _buildField('End Time', _formatDateTime(shift['SHF_DATE_TIME_TO'])),
                    _buildField('Vehicle Reference', shift['SHF_VEH_REF']),
                    _buildField('Latitude', shift['SHF_LATT']),
                    _buildField('Longitude', shift['SHF_LANG']),
                    _buildField('System Date', _formatDateTime(shift['SYS_DATE'])),
                    // Add more fields as needed
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
