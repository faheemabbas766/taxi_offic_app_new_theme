import 'package:file_picker/file_picker.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:taxi_app/presentation/vehicalManagement/vehicleDetailsScreen.dart';
import '../../providers/homepro.dart';
import '../Language/appLocalizations.dart';
import '../constance/constance.dart';
import 'package:http/http.dart'as http;
import 'package:fluttertoast/fluttertoast.dart'as ft;
class AddNewVehicle extends StatefulWidget {
  final VehicleDetails vehicleDetails;
  const AddNewVehicle(this.vehicleDetails, {super.key});
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
  TextEditingController numberController = TextEditingController();
  TextEditingController rhvBadgeNumberController = TextEditingController();
  String? imageInsurance,imageMot,imageVehiclePhv,imageUv;
  bool isLoading = false;
  final _formKey = GlobalKey<FormState>();
  String? selectedVehicle;

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
    SharedPreferences prefs = await SharedPreferences.getInstance();
    request.fields.addAll({
      "veh_id": widget.vehicleDetails.uvId,
      "driver_id": prefs.getString('userid')!,
      "uv_reg_num": regNumberController.text,
      "uv_mot_expiry": motExpiryController.text,
      "uv_insurance_expiry": insuranceExpiryController.text,
      "uv_vehicle_rhv_bagde_number":rhvBadgeNumberController.text,
      "uv_vehicle_rhv_bagde_expiry": phvExpiryController.text,
      "uv_color": colorController.text,
      "uv_make": makeController.text,
      "uv_number": numberController.text,
      "uv_model": modelController.text,
      "uv_log_book": logBookController.text,
      "uv_status":'1',
      "uv_car_d_ref":selectedVehicle!
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
      isLoading = false;ft.Fluttertoast.showToast(
        msg: "Request TimeOut",
        toastLength: ft.Toast.LENGTH_LONG,
      );
      setState(() {

      });
      throw "TimeOut";
    });
    if (response.statusCode == 200) {
      ft.Fluttertoast.showToast(
        msg: "Vehicle Added Successfully",
        toastLength: ft.Toast.LENGTH_LONG,
      );
      Navigator.pop(context);
      isLoading = false;
      setState(() {

      });
    } else {
      ft.Fluttertoast.showToast(
        msg: "Failed to Add Vehicle!!!",
        toastLength: ft.Toast.LENGTH_LONG,
      );
      print('Failed to send data. Error: ${response.statusCode}');
    }
  }
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    regNumberController.text = widget.vehicleDetails.uvRegNum;
    makeController.text = widget.vehicleDetails.uvMake;
    modelController.text = widget.vehicleDetails.uvModel;
    colorController.text = widget.vehicleDetails.uvColor;
    rhvBadgeNumberController.text = widget.vehicleDetails.uvVehicleRhvBadgeNumber;
    motExpiryController.text = widget.vehicleDetails.uvMotExpiry;
    insuranceExpiryController.text = widget.vehicleDetails.uvInsuranceExpiry;
    phvExpiryController.text = widget.vehicleDetails.uvVehicleRhvBadgeExpiry;
    logBookController.text = widget.vehicleDetails.uvLogBook;
    numberController.text = widget.vehicleDetails.uvNumber;
    imageInsurance = widget.vehicleDetails.uvInsuranceImage;
    imageMot =widget.vehicleDetails.uvMotImage;
    imageVehiclePhv =widget.vehicleDetails.uvVehicleRhvBadgeImage;
    imageUv = widget.vehicleDetails.uvImage;
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
      body: Form(
        key: _formKey,
        child: Padding(
          padding: const EdgeInsets.only(right: 14, left: 14, top: 10),
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
                              AppLocalizations.of('VEHICLE NUMBER'),
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
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'This Field is Required!';
                              }
                              return null;
                            },
                            decoration: InputDecoration(
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(15),
                              ),
                              labelText: 'Vehicle Number',
                            ),
                            controller: numberController,
                          ),
                        ),
                        const SizedBox(
                          height: 12,
                        ),
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
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'This Field is Required!';
                              }
                              return null;
                            },
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
                          height: 12,
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
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'This Field is Required!';
                              }
                              return null;
                            },
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
                          height: 12,
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
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'This Field is Required!';
                              }
                              return null;
                            },
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
                          height: 12,
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
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'This Field is Required!';
                              }
                              return null;
                            },
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
                          height: 12,
                        ),
                        Row(
                          children: <Widget>[
                            Text(
                              AppLocalizations.of('Rhv Badge Number'),
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
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'This Field is Required!';
                              }
                              return null;
                            },
                            decoration: InputDecoration(
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(15),
                              ),
                              labelText: 'Rhv Badge Number',
                            ),
                            controller: rhvBadgeNumberController,
                          ),
                        ),



                        const SizedBox(
                          height: 12,
                        ),
                        Row(
                          children: <Widget>[
                            Text(
                              AppLocalizations.of('Vehicle Type'),
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
                        DropdownButtonFormField<String>(
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'This Field is Required!';
                            }
                            return null;
                          },
                          decoration: InputDecoration(
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(15),
                            ),
                            labelText: 'Vehicle Type',
                          ),
                          value: selectedVehicle,
                          onChanged: (newValue) {
                            setState(() {
                              selectedVehicle = newValue!;
                            });
                          },
                          items: const [
                            DropdownMenuItem(
                              value: '1',
                              child: Text('Saloon'),
                            ),
                            DropdownMenuItem(
                              value: '2',
                              child: Text('Executive'),
                            ),
                            DropdownMenuItem(
                              value: '3',
                              child: Text('6-Seater'),
                            ),
                            DropdownMenuItem(
                              value: '4',
                              child: Text('8-Seater'),
                            ),
                          ],
                        ),



                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Row(
                            children: [
                              SizedBox(
                                height: 45,
                                width: 150,
                                child: TextFormField(
                                  keyboardType: TextInputType.datetime,
                                  onTap: () async {
                                    DateTime? dt = await showDatePicker(
                                        context: context,
                                        firstDate: DateTime(2000),
                                        lastDate: DateTime(2100));
                                    if(dt!=null){
                                      motExpiryController.text = DateFormat('dd-MM-yyyy').format(dt);
                                    }
                                  },
                                  validator: (value) {
                                    if (value == null || value.isEmpty) {
                                      return 'This Field is Required!';
                                    }
                                    return null;
                                  },
                                  decoration: InputDecoration(
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(15),
                                    ),
                                    labelText: 'MOT Expiry',
                                  ),
                                  controller: motExpiryController,
                                ),
                              ),
                              const Spacer(),
                              imageMot == ''? Icon(Icons.warning, color: Colors.red,):
                              Icon(Icons.done, color: Colors.green,),
                              const Spacer(),
                              SizedBox(
                                width: 140,
                                child: ElevatedButton(
                                    onPressed: () async {
                                      imageMot = await _imagePicker();
                                      setState(() {

                                      });
                                    },
                                    child: const Text('MOT')),
                              ),
                            ],
                          ),
                        ),


                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Row(
                            children: [
                              SizedBox(
                                height: 45,
                                width: 150,
                                child: TextFormField(
                                  validator: (value) {
                                    if (value == null || value.isEmpty) {
                                      return 'This Field is Required!';
                                    }
                                    return null;
                                  },
                                  keyboardType: TextInputType.datetime,
                                  onTap: () async {
                                    DateTime? selectedDate = await showDatePicker(
                                        context: context,
                                        firstDate: DateTime(2000),
                                        lastDate: DateTime(2100));
                                    if(selectedDate!=null){
                                      TimeOfDay? selectedTime = await showTimePicker(
                                          context: context,
                                          initialTime: TimeOfDay.now());
                                      if(selectedTime!=null){
                                        insuranceExpiryController.text =DateTime(
                                          selectedDate.year,
                                          selectedDate.month,
                                          selectedDate.day,
                                          selectedTime.hour,
                                          selectedTime.minute,
                                        ).toString().substring(0,16);
                                        if (kDebugMode) {
                                          print('Selected DateTime:::::::::::::::::${insuranceExpiryController.text}');
                                        }
                                      }
                                    }
                                  },
                                  decoration: InputDecoration(
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(15),
                                    ),
                                    labelText: 'Insurance Expiry',
                                  ),
                                  controller: insuranceExpiryController,
                                ),
                              ),
                              const Spacer(),
                              imageInsurance == ''? const Icon(Icons.warning, color: Colors.red,):
                              const Icon(Icons.done, color: Colors.green,),
                              const Spacer(),
                              SizedBox(
                                width: 140,
                                child: ElevatedButton(
                                    onPressed: () async {
                                      imageInsurance = await _imagePicker();
                                      setState(() {

                                      });
                                    },
                                    child: const Text('Insurance',)),
                              ),
                            ],
                          ),
                        ),


                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Row(
                            children: [
                              SizedBox(
                                height: 45,
                                width: 150,
                                child: TextFormField(
                                  validator: (value) {
                                    if (value == null || value.isEmpty) {
                                      return 'This Field is Required!';
                                    }
                                    return null;
                                  },
                                  keyboardType: TextInputType.datetime,
                                  onTap: () async {
                                    DateTime? dt = await showDatePicker(
                                        context: context,
                                        firstDate: DateTime(2000),
                                        lastDate: DateTime(2100));
                                    if(dt!=null){
                                      phvExpiryController.text = DateFormat('dd-MM-yyyy').format(dt);
                                    }
                                  },
                                  decoration: InputDecoration(
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(15),
                                    ),
                                    labelText: 'PHV Expiry',
                                  ),
                                  controller: phvExpiryController,
                                ),
                              ),
                              const Spacer(),
                              imageVehiclePhv == ''? const Icon(Icons.warning, color: Colors.red,):
                              const Icon(Icons.done, color: Colors.green,),
                              const Spacer(),
                              SizedBox(
                                width: 140,
                                child: ElevatedButton(
                                    onPressed: () async {
                                      imageVehiclePhv = await _imagePicker();
                                      setState(() {

                                      });
                                    },
                                    child: const Text('PHV')),
                              ),
                            ],
                          ),
                        ),


                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Row(
                            children: [
                              SizedBox(
                                height: 45,
                                width: 150,
                                child: TextFormField(
                                  validator: (value) {
                                    if (value == null || value.isEmpty) {
                                      return 'This Field is Required!';
                                    }
                                    return null;
                                  },
                                  keyboardType: TextInputType.datetime,
                                  onTap: () async {
                                    DateTime? dt = await showDatePicker(
                                        context: context,
                                        firstDate: DateTime(2000),
                                        lastDate: DateTime(2100));
                                    if(dt!=null){
                                      logBookController.text = DateFormat('dd-MM-yyyy').format(dt);
                                    }
                                  },
                                  decoration: InputDecoration(
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(15),
                                    ),
                                    labelText: 'Logbook Expiry',
                                  ),
                                  controller: logBookController,
                                ),
                              ),
                              const Spacer(),
                              imageUv == ''? const Icon(Icons.warning, color: Colors.red,):
                              const Icon(Icons.done, color: Colors.green,),
                              const Spacer(),
                              SizedBox(
                                width: 140,
                                child: ElevatedButton(
                                    onPressed: () async {
                                      imageUv = await _imagePicker();
                                      setState(() {

                                      });
                                    },
                                    child: const Text('Log Book',)),
                              ),
                            ],
                          ),
                        ),

                      ],
                    ),
                  ],
                ),
              ),
              isLoading?const Center(child: CircularProgressIndicator(),):
              GestureDetector(
                onTap: () async {
                  if (_formKey.currentState!.validate()) {
                    if(imageMot!=null && imageInsurance!=null &&
                        imageVehiclePhv!=null && imageUv!=null){
                      setState(() {
                        isLoading = true;
                      });
                    }else{
                      ft.Fluttertoast.showToast(
                        msg: "All Documents are required to complete!",
                        toastLength: ft.Toast.LENGTH_LONG,
                      );
                    }
                    await sendDataToAPI();
                  }
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
      ),
    );
  }
}