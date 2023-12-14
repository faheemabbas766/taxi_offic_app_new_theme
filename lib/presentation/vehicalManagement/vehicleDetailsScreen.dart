import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';
import 'package:taxi_app/presentation/vehicalManagement/addVehicalScreen.dart';
import '../../providers/homepro.dart';
class VehicleDetails {
  final String uvId;
  final String uvRegNum;
  final String uvMotExpiry;
  final String uvImage;
  final String uvCurrentVehicle;
  final String uvLogBook;
  final String uvStatus;
  final String uvYear;
  final String uvModel;
  final String uvNumber;
  final String uvMake;
  final String userRef;
  final String uvColor;
  final String uvVehicleRhvBadgeImage;
  final String uvVehicleRhvBadgeNumber;
  final String uvVehicleRhvBadgeExpiry;
  final String uvInsuranceImage;
  final String uvInsuranceExpiry;
  final String uvInsuranceNumber;
  final String uvMotImage;
  final String uvMotNumber;
  VehicleDetails({
    required this.uvId,
    required this.uvRegNum,
    required this.uvMotExpiry,
    required this.uvImage,
    required this.uvCurrentVehicle,
    required this.uvLogBook,
    required this.uvStatus,
    required this.uvYear,
    required this.uvModel,
    required this.uvNumber,
    required this.uvMake,
    required this.userRef,
    required this.uvColor,
    required this.uvVehicleRhvBadgeImage,
    required this.uvVehicleRhvBadgeNumber,
    required this.uvVehicleRhvBadgeExpiry,
    required this.uvInsuranceImage,
    required this.uvInsuranceExpiry,
    required this.uvInsuranceNumber,
    required this.uvMotImage,
    required this.uvMotNumber,
  });

  factory VehicleDetails.fromJson(Map<String, dynamic> json) {
    return VehicleDetails(
      uvId: json['uv_id'] ?? '',
      uvRegNum: json['uv_reg_num'] ?? '',
      uvMotExpiry: json['uv_mot_expiry'] ?? '',
      uvImage: json['uv_image'] ?? '',
      uvCurrentVehicle: json['uv_current_vehicle'] ?? '',
      uvLogBook: json['uv_log_book'] ?? '',
      uvStatus: json['uv_status'] ?? '',
      uvYear: json['uv_year'] ?? '',
      uvModel: json['uv_model'] ?? '',
      uvNumber: json['uv_number'] ?? '',
      uvMake: json['uv_make'] ?? '',
      userRef: json['user_ref'] ?? '',
      uvColor: json['uv_color'] ?? '',
      uvVehicleRhvBadgeImage: json['uv_vehicle_rhv_bagde_image'] ?? '',
      uvVehicleRhvBadgeNumber: json['uv_vehicle_rhv_bagde_number'] ?? '',
      uvVehicleRhvBadgeExpiry: json['uv_vehicle_rhv_bagde_expiry'] ?? '',
      uvInsuranceImage: json['uv_insurance_image'] ?? '',
      uvInsuranceExpiry: json['uv_insurance_expiry'] ?? '',
      uvInsuranceNumber: json['uv_insurance_number'] ?? '',
      uvMotImage: json['uv_mot_image'] ?? '',
      uvMotNumber: json['uv_mot_number'] ?? '',
    );
  }
}

class VehicleDetailsScreen extends StatefulWidget {
  final int vehicleId;
  const VehicleDetailsScreen({required this.vehicleId,super.key});

  @override
  _VehicleDetailsScreenState createState() => _VehicleDetailsScreenState();
}

class _VehicleDetailsScreenState extends State<VehicleDetailsScreen> {
  late Future<VehicleDetails> _vehicleDetails;
  Future<VehicleDetails> fetchVehicleDetails() async {
    var headers = {
      'Content-Type': 'application/x-www-form-urlencoded',
      'Accept': 'application/json',
      'token': Provider.of<HomePro>(context, listen: false).token,
    };

    var request = http.MultipartRequest('POST', Uri.parse('https://minicab.imdispatch.co.uk/api/getveh'));
    request.fields.addAll({
      'id': widget.vehicleId.toString(),
    });
    request.headers.addAll(headers);
    http.StreamedResponse response = await request.send();
    if (response.statusCode == 200) {
      final responseBody = await response.stream.bytesToString();
      final Map<String, dynamic> responseData = json.decode(responseBody);
      final Map<String, dynamic> shiftData = responseData['Shiftdata'];
      return VehicleDetails.fromJson(shiftData);
    } else {
      throw Exception('Failed to load vehicle details');
    }
  }
  @override
  void initState() {
    super.initState();
    _vehicleDetails = fetchVehicleDetails();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Center(child: Text('Vehicle Details')),
        actions: [
          const Text('Edit'),
          IconButton(onPressed: (){
            showDialog(
              context: context,
              builder: (BuildContext context) {
                return AlertDialog(
                  title: const Text('Are you sure?'),
                  content: const Text('This operation cannot be undone. You have to update all information again.'),
                  actions: <Widget>[
                    ElevatedButton(
                      child: const Text('CANCEL'),
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                    ),
                    ElevatedButton(
                      child: const Text('CONFIRM'),
                      onPressed: () async {
                        final vehicle = await _vehicleDetails;
                        Navigator.of(context).push(MaterialPageRoute(builder: (context) => AddNewVehicle(vehicle),));
                      },
                    ),
                  ],
                );
              },
            );
          }, icon: Icon(Icons.edit)),
        ],
      ),
      body: FutureBuilder<VehicleDetails>(
        future: _vehicleDetails,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else {
            final vehicle = snapshot.data!;
            return SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Card(
                  elevation: 4,
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _buildDetailTile('Registration Number', vehicle.uvRegNum,'Make', vehicle.uvMake),
                        _buildDetailTile('Model', vehicle.uvModel,'Color', vehicle.uvColor),
                        _buildDetailTile('MOT Expiry', vehicle.uvMotExpiry,'Insurance Expiry', vehicle.uvInsuranceExpiry),
                        _buildDetailTile('UV ID', vehicle.uvId,'Current Vehicle', vehicle.uvCurrentVehicle),
                        _buildDetailTile('Log Book', vehicle.uvLogBook,'Status', vehicle.uvStatus),
                        _buildDetailTile('Year', vehicle.uvYear,'Number', vehicle.uvNumber),
                        _buildDetailTile('Badge Number', vehicle.uvVehicleRhvBadgeNumber,'Badge Expiry', vehicle.uvVehicleRhvBadgeExpiry),
                        _buildDetailTile('Insurance Number', vehicle.uvInsuranceNumber,'MOT Number', vehicle.uvMotNumber),
                        _buildDetailTile('User Reference', vehicle.userRef,'',''),
                        _buildImageTile('Badge Image', vehicle.uvVehicleRhvBadgeImage),
                        _buildImageTile('Insurance Image', vehicle.uvInsuranceImage),
                        _buildImageTile('MOT Image', vehicle.uvMotImage),
                        _buildImageTile('LogBook Image', vehicle.uvImage),
                      ],
                    ),
                  ),
                ),
              ),
            );
          }
        },
      ),
    );
  }

  Widget _buildDetailTile(String title1, String value1, String title2, String value2) {
    return Row(
      children: [
        Expanded(
          child: ListTile(
            title: Text(
              title1,
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
            subtitle: Text(value1),
          ),
        ),
        Expanded(
          child: ListTile(
            title: Text(
              title2,
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
            subtitle: Text(value2),
          ),
        ),
      ],
    );
  }

  Widget _buildImageTile(String title, String? imageUrl) {
    return Column(
      children: [
        imageUrl != null
            ? Row(
          children: [
            Expanded(
              flex: 4,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Image.network(
                  imageUrl,
                  width: 300,
                  height: 250,
                  fit: BoxFit.fill,
                ),
              ),
            ),
            Expanded(
              flex: 2,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(title, style: const TextStyle(color: Colors.grey),
                ),
              ),
            ),
          ],
        )
            : Text(title),
      ],
    );
  }
}