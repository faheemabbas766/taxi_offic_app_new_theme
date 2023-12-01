import 'package:file_picker/file_picker.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/homepro.dart';
import '../Language/appLocalizations.dart';
import '../constance/constance.dart';
import 'package:http/http.dart'as http;
import 'package:fluttertoast/fluttertoast.dart'as ft;
class AddNewVehicle extends StatefulWidget {
  const AddNewVehicle({super.key});
  @override
  _AddNewVehicleState createState() => _AddNewVehicleState();
}

class _AddNewVehicleState extends State<AddNewVehicle> {
  TextEditingController regNumberController = TextEditingController();
  TextEditingController makeController = TextEditingController();
  TextEditingController modelController = TextEditingController();
  TextEditingController colorController = TextEditingController();
  TextEditingController motExpiryController = TextEditingController();
  TextEditingController insuranceExpiryController = TextEditingController();
  TextEditingController phvExpiryController = TextEditingController();
  TextEditingController logBookController = TextEditingController();
  String? imageInsurance,imageMot,imageVehiclePhv,imageUv;

  Future<String?> _imagePicker() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['jpg', 'png'],
    );
    if (result != null) {
      return result.files.single.path;
    }
    return null;
  }
  Future<void> sendDataToAPI() async {
    var request = http.MultipartRequest(
      'POST',
      Uri.parse(
          "https://minicab.imdispatch.co.uk/api/addvehicle"),
    );
    request.headers.addAll({
      'Content-type': 'multipart/form-data',
      'Accept': 'application/json',
      'token': Provider.of<HomePro>(context, listen: false).token,
    });
    request.fields.addAll({
      "uv_reg_num": regNumberController.text,
      "uv_mot_expiry": motExpiryController.text,
      "uv_insurance_expiry": insuranceExpiryController.text,
      "uv_vehicle_rhv_bagde_expiry": phvExpiryController.text,
      "uv_color": colorController.text,
      "uv_make": makeController.text,
      "uv_number": regNumberController.text,
      "uv_model": modelController.text,
      "uv_log_book": logBookController.text,
      "uv_current_vehicle": "0",
    });
    request.files.add(await http.MultipartFile.fromPath(
      'uv_insurance_image',
      imageInsurance!,
      filename: 'uv_insurance_image', // Preserve the original file name and extension
    ));
    request.files.add(await http.MultipartFile.fromPath(
      'uv_mot_image',
      imageMot!,
      filename: 'uv_mot_image', // Preserve the original file name and extension
    ));
    request.files.add(await http.MultipartFile.fromPath(
      'uv_vehicle_rhv_bagde_image',
      imageVehiclePhv!,
      filename: 'uv_vehicle_rhv_bagde_image', // Preserve the original file name and extension
    ));
    request.files.add(await http.MultipartFile.fromPath(
      'uv_image',
      imageUv!,
      filename: 'uv_image', // Preserve the original file name and extension
    ));
    http.StreamedResponse response;
    response = await request.send().timeout(const Duration(seconds: 25), onTimeout: () {
      throw "TimeOut";
    });
    if (response.statusCode == 200) {
      if (kDebugMode) {
        print('Data sent successfully');
        ft.Fluttertoast.showToast(
          msg: "Vehicle Added Successfully",
          toastLength: ft.Toast.LENGTH_LONG,
        );
        Navigator.pop(context);
      }
    } else {
      if (kDebugMode) {
        print('Failed to send data. Error: ${response.statusCode}');
      }
    }
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
              AppLocalizations.of('Add a new vehicle'),
              style: Theme.of(context).textTheme.titleLarge!.copyWith(
                fontWeight: FontWeight.bold,
                color: Theme.of(context).textTheme.titleLarge!.color,
              ),
            ),
            const SizedBox(),
          ],
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.only(right: 14, left: 14, top: 14),
        child: Column(
          children: <Widget>[
            Expanded(
              child: ListView(
                children: <Widget>[
                  Column(
                    children: <Widget>[
                      Row(
                        children: <Widget>[
                          Text(
                            AppLocalizations.of('VEHICLE MAKE'),
                            style: Theme.of(context).textTheme.bodySmall!.copyWith(
                              fontWeight: FontWeight.bold,
                              color: Theme.of(context).disabledColor,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(
                        height: 8,
                      ),
                      SizedBox(
                        height: 45,
                        child: TextFormField(
                          decoration: InputDecoration(
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(15),
                            ),
                            labelText: 'Vehicle Make',
                          ),
                          controller: makeController,
                        ),
                      ),
                      const SizedBox(
                        height: 16,
                      ),
                      Row(
                        children: <Widget>[
                          Text(
                            AppLocalizations.of('Registration No'),
                            style: Theme.of(context).textTheme.bodySmall!.copyWith(
                              fontWeight: FontWeight.bold,
                              color: Theme.of(context).disabledColor,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(
                        height: 8,
                      ),
                      SizedBox(
                        height: 45,
                        child: TextFormField(
                          decoration: InputDecoration(
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(15),
                            ),
                            labelText: 'Registration No',
                          ),
                          controller: regNumberController,
                        ),
                      ),
                      const SizedBox(
                        height: 16,
                      ),
                      Row(
                        children: <Widget>[
                          Text(
                            AppLocalizations.of('Model'),
                            style: Theme.of(context).textTheme.bodySmall!.copyWith(
                              fontWeight: FontWeight.bold,
                              color: Theme.of(context).disabledColor,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(
                        height: 8,
                      ),
                      SizedBox(
                        height: 45,
                        child: TextFormField(
                          decoration: InputDecoration(
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(15),
                            ),
                            labelText: 'Model',
                          ),
                          controller: modelController,
                        ),
                      ),
                      const SizedBox(
                        height: 16,
                      ),
                      Row(
                        children: <Widget>[
                          Text(
                            AppLocalizations.of('Color'),
                            style: Theme.of(context).textTheme.bodySmall!.copyWith(
                              fontWeight: FontWeight.bold,
                              color: Theme.of(context).disabledColor,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(
                        height: 8,
                      ),
                      SizedBox(
                        height: 45,
                        child: TextFormField(
                          decoration: InputDecoration(
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(15),
                            ),
                            labelText: 'Color',
                          ),
                          controller: colorController,
                        ),
                      ),
                      const SizedBox(
                        height: 16,
                      ),
                      Row(
                        children: <Widget>[
                          Text(
                            AppLocalizations.of('MOT Expiry'),
                            style: Theme.of(context).textTheme.bodySmall!.copyWith(
                              fontWeight: FontWeight.bold,
                              color: Theme.of(context).disabledColor,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(
                        height: 8,
                      ),
                      SizedBox(
                        height: 45,
                        child: TextFormField(
                          decoration: InputDecoration(
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(15),
                            ),
                            labelText: 'MOT Expiry',
                          ),
                          controller: motExpiryController,
                        ),
                      ),
                      const SizedBox(
                        height: 16,
                      ),
                      Row(
                        children: <Widget>[
                          Text(
                            AppLocalizations.of('Insurance Expiry'),
                            style: Theme.of(context).textTheme.bodySmall!.copyWith(
                              fontWeight: FontWeight.bold,
                              color: Theme.of(context).disabledColor,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(
                        height: 8,
                      ),
                      SizedBox(
                        height: 45,
                        child: TextFormField(
                          decoration: InputDecoration(
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(15),
                            ),
                            labelText: 'Insurance Expiry',
                          ),
                          controller: insuranceExpiryController,
                        ),
                      ),
                      const SizedBox(
                        height: 16,
                      ),
                      Row(
                        children: <Widget>[
                          Text(
                            AppLocalizations.of('PHV Expiry'),
                            style: Theme.of(context).textTheme.bodySmall!.copyWith(
                              fontWeight: FontWeight.bold,
                              color: Theme.of(context).disabledColor,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(
                        height: 8,
                      ),
                      Row(
                        children: [
                          SizedBox(
                            height: 45,
                            width: 150,
                            child: TextFormField(
                              decoration: InputDecoration(
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(15),
                                ),
                                labelText: 'PHV Expiry',
                              ),
                              controller: phvExpiryController,
                            ),
                          ),
                          ElevatedButton(
                              onPressed: () async {
                                imageVehiclePhv = await _imagePicker();
                                setState(() {

                                });
                              },
                              child: const Text('Phv Badge Upload')),
                        ],
                      ),
                      Row(
                        children: [
                          Column(
                            children: [
                              const SizedBox(
                                height: 16,
                              ),
                              imageInsurance==null? const Text('Select a Image'):
                              Text(imageInsurance!.substring(imageInsurance!.length-10)),
                              ElevatedButton(
                                  onPressed: () async {
                                    imageInsurance = await _imagePicker();
                                    setState(() {

                                    });
                                  },
                                  child: const Text('Insurance')),
                            ],
                          ),
                          const Spacer(),
                          Column(
                            children: [
                              const SizedBox(
                                height: 16,
                              ),
                              imageMot==null? const Text('Select a Image'):
                              Text(imageMot!.substring(imageMot!.length-10)),
                              ElevatedButton(
                                  onPressed: () async {
                                    imageMot = await _imagePicker();
                                    setState(() {

                                    });
                                  },
                                  child: const Text('MOT')),
                            ],
                          )
                        ],
                      ),
                    ],
                  ),
                ],
              ),
            ),
            ElevatedButton(
                onPressed: () async {
                  imageUv = await _imagePicker();
                  setState(() {

                  });
                },
                child: const Text('LogBook')),
            GestureDetector(
              onTap: () {
                sendDataToAPI();
              },
              child: Container(
                height: 40,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color: Theme.of(context).primaryColor,
                ),
                child: Center(
                  child: Text(
                    AppLocalizations.of('COMPLETE'),
                    style: Theme.of(context).textTheme.labelLarge!.copyWith(
                      fontWeight: FontWeight.bold,
                      color: ConstanceData.secoundryFontColor,
                    ),
                  ),
                ),
              ),
            ),
            SizedBox(
              height: MediaQuery.of(context).padding.bottom + 16,
            )
          ],
        ),
      ),
    );
  }
}