import 'dart:convert';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart'as http;
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:taxi_app/presentation/splashScreen.dart';
import '../../Api & Routes/routes.dart';
import '../../providers/homepro.dart';
import '../Language/appLocalizations.dart';
import '../constance/constance.dart';
import 'package:fluttertoast/fluttertoast.dart'as ft;

import '../drawer/drawer.dart';

class MyProfile extends StatefulWidget {
  const MyProfile({super.key});

  @override
  _MyProfileState createState() => _MyProfileState();
}

class _MyProfileState extends State<MyProfile> {
  TextEditingController phoneController = TextEditingController();
  TextEditingController hPhoneController = TextEditingController();
  TextEditingController niNumberController = TextEditingController();
  TextEditingController licenceNumberController = TextEditingController();
  TextEditingController licenceExpiryController = TextEditingController();
  TextEditingController phvNumberController = TextEditingController();
  TextEditingController phvExpiryController = TextEditingController();
  TextEditingController passportNumberController = TextEditingController();
  TextEditingController passportExpiryController = TextEditingController();
  TextEditingController biometricNumberController = TextEditingController();
  TextEditingController biometricExpiryController = TextEditingController();
  TextEditingController addressController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  String? empLicNumExpImage,empDriPhvExpImage,empPassportExpImage,empBiometricExpImage;
  bool isLoading = false;
  bool isEditable = false;
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
          "https://minicab.imdispatch.co.uk/api/saveuserprofile"),
    );
    request.headers.addAll({
      'Content-type': 'multipart/form-data',
      'Accept': 'application/json',
      'token': Provider.of<HomePro>(context, listen: false).token,
    });
    SharedPreferences prefs = await SharedPreferences.getInstance();
    request.fields.addAll({
      'id': prefs.getString('userid').toString(),
      'email':emailController.text,
      'phone': phoneController.text,
      'h_phone': hPhoneController.text,
      'ni_number': niNumberController.text,
      'licence_number': licenceNumberController.text,
      'licence_expiry': licenceExpiryController.text,
      'phv_number': phvNumberController.text,
      'phv_expiry': phvExpiryController.text,
      'passport_number': passportNumberController.text,
      'passport_expiry': passportExpiryController.text,
      'biometric_number': biometricNumberController.text,
      'biometric_expiry': biometricExpiryController.text,
      'address': addressController.text,
    });
    request.files.add(await http.MultipartFile.fromPath(
      'EMP_LICENCE_NUM_EXPIRY_IMAGE',
      empLicNumExpImage!,
      filename: 'EMP_LICENCE_NUM_EXPIRY_IMAGE', // Preserve the original file name and extension
    ));
    request.files.add(await http.MultipartFile.fromPath(
      'EMP_DRIVER_PHV_BADGE_EXPIRY_IMAGE',
      empDriPhvExpImage!,
      filename: 'EMP_DRIVER_PHV_BADGE_EXPIRY_IMAGE', // Preserve the original file name and extension
    ));
    request.files.add(await http.MultipartFile.fromPath(
      'EMP_PASSPORT_EXPIRY_IMAGE',
      empPassportExpImage!,
      filename: 'EMP_PASSPORT_EXPIRY_IMAGE', // Preserve the original file name and extension
    ));
    request.files.add(await http.MultipartFile.fromPath(
      'EMP_BIOMETRIC_EXPIRY_IMAGE',
      empBiometricExpImage!,
      filename: 'EMP_BIOMETRIC_EXPIRY_IMAGE', // Preserve the original file name and extension
    ));
    http.StreamedResponse response;
    response = await request.send().timeout(const Duration(seconds: 25), onTimeout: () {
      isLoading = false;
      ft.Fluttertoast.showToast(
        msg: "Request TimeOut",
        toastLength: ft.Toast.LENGTH_LONG,
      );
      setState(() {

      });
      throw "TimeOut";
    });
    if (response.statusCode == 200) {
      ft.Fluttertoast.showToast(
        msg: "Profile Updated Successfully",
        toastLength: ft.Toast.LENGTH_LONG,
      );
      Navigator.pop(context);
      isLoading = false;
      setState(() {

      });
    } else {
      ft.Fluttertoast.showToast(
        msg: "Failed to Update Profile!!!",
        toastLength: ft.Toast.LENGTH_LONG,
      );
      if (kDebugMode) {
        print('Failed to send data. Error: ${response.statusCode}');
      }
    }
  }



  dynamic data;
  bool loading = true;
  @override
  void initState() {
    super.initState();
    loadData();
  }
  Future<void> loadData()async{
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final response = await http.post(
      Uri.parse("https://minicab.imdispatch.co.uk/api/getuserprofile"),
      headers: <String, String>{
        'Content-Type': 'application/x-www-form-urlencoded', // Modify as needed
        'Accept': 'application/json', // Add Accept header
        'token': Provider.of<HomePro>(context, listen: false).token, // Replace with your token source
      },
      body: {
        "id": prefs.getString('userid').toString(),
      },
    );
    if (response.statusCode == 401) {
      SharedPreferences.getInstance().then((prefs) {
        prefs.clear();
      });
      Navigator.of(context).pushNamedAndRemoveUntil(
        Routes.LOGIN,
            (route) => false,
      );
    }

    if (response.statusCode == 200) {
      data = jsonDecode(response.body);
      print(data.toString());
      phoneController.text = data['profile']['emp_phone'].toString();
      hPhoneController.text = data['profile']['emp_home_number'].toString();
      niNumberController.text = data['profile']['EMP_NI_NUMBER'].toString();
      licenceNumberController.text = data['profile']['EMP_LICENCE_NUM'].toString();
      licenceExpiryController.text = data['profile']['emp_phone'].toString();
      phvNumberController.text = data['profile']['EMP_PHV_BADGE_NUMBER'].toString();
      phvExpiryController.text = data['profile']['EMP_DRIVER_PHV_BADGE_EXPIRY'].toString();
      passportNumberController.text = data['profile']['EMP_PASSPORT_NUMBER'].toString();
      passportExpiryController.text = data['profile']['EMP_PASSPORT_EXPIRY'].toString();
      biometricNumberController.text = data['profile']['EMP_BIO_METRIC_NUMBER'].toString();
      biometricExpiryController.text = data['profile']['EMP_BIOMETRIC_EXPIRY'].toString();
      addressController.text = data['profile']['emp_address'].toString();
      emailController.text = data['profile']['email'].toString();
      empLicNumExpImage = data['profile']['EMP_LICENCE_NUM_EXPIRY_IMAGE'];
      empDriPhvExpImage = data['profile']['EMP_DRIVER_PHV_BADGE_EXPIRY_IMAGE'];
      empBiometricExpImage = data['profile']['EMP_BIOMETRIC_EXPIRY_IMAGE'];
      empPassportExpImage = data['profile']['EMP_PASSPORT_EXPIRY_IMAGE'];
      loading = false;
      setState(() {
      });
    }
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
      drawer: SizedBox(
        width: MediaQuery.of(context).size.width * 0.75 < 400 ? MediaQuery.of(context).size.width * 0.75 : 350,
        child: const Drawer(
          child: AppDrawer(
            selectItemName: 'Account',
          ),
        ),
      ),
      appBar: AppBar(
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        title: InkWell(
          onTap: () async {
            if(isEditable){
              if (_formKey.currentState!.validate()) {
                if(empDriPhvExpImage!=null && empLicNumExpImage!=null &&
                    empBiometricExpImage!=null && empPassportExpImage!=null){
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
            }
            isEditable = !isEditable;
            setState(() {
            });
          },
          child: Text(
            AppLocalizations.of(isEditable?'Save':'Edit'),
            style: Theme.of(context).textTheme.titleLarge!.copyWith(
              fontWeight: FontWeight.bold,
              color: Theme.of(context).primaryColor,
            ),
          ),
        ),
      ),
      body:loading?const Center(child: CircularProgressIndicator(),)
          :Column(
        children: <Widget>[
          Container(
            color: Theme.of(context).scaffoldBackgroundColor,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    CircleAvatar(
                      radius: MediaQuery.of(context).size.width <= 320 ? 36 : 46,
                      child: ClipRRect(
                        borderRadius: MediaQuery.of(context).size.width <= 320 ? BorderRadius.circular(40) : BorderRadius.circular(60),
                        child: Image.asset(
                          ConstanceData.user3,
                        ),
                      ),
                    ),
                    Text(userName,
                      style: Theme.of(context).textTheme.titleLarge!.copyWith(
                        fontWeight: FontWeight.bold,
                        color: Theme.of(context).textTheme.titleLarge!.color,
                      ),
                    ),
                    Text(
                      data['profile']['emp_id'],
                      style: Theme.of(context).textTheme.titleSmall!.copyWith(
                        fontWeight: FontWeight.bold,
                        color: Theme.of(context).disabledColor,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(right: 14, left: 14, top: 10, bottom: 10),
            child: Row(
              children: <Widget>[
                Text(
                  AppLocalizations.of('INFORMATION'),
                  style: Theme.of(context).textTheme.titleSmall!.copyWith(
                    fontWeight: FontWeight.bold,
                    color: Theme.of(context).disabledColor,
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: Form(
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
                                    AppLocalizations.of('PHONE'),
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
                                  enabled: isEditable,
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
                                    labelText: 'Phone',
                                  ),
                                  controller: phoneController,
                                ),
                              ),
                              const SizedBox(
                                height: 12,
                              ),
            
            
                              Row(
                                children: <Widget>[
                                  Text(
                                    AppLocalizations.of('EMAIL'),
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
                                  enabled: isEditable,
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
                                    labelText: 'Email',
                                  ),
                                  controller: emailController,
                                ),
                              ),
                              const SizedBox(
                                height: 12,
                              ),
            
            
                              Row(
                                children: <Widget>[
                                  Text(
                                    AppLocalizations.of('Home Phone'),
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
                                  enabled: isEditable,
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
                                    labelText: 'Home Phone',
                                  ),
                                  controller: hPhoneController,
                                ),
                              ),
                              const SizedBox(
                                height: 12,
                              ),
                              Row(
                                children: <Widget>[
                                  Text(
                                    AppLocalizations.of('NI NUMBER'),
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
                                  enabled: isEditable,
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
                                    labelText: 'Ni Number',
                                  ),
                                  controller: niNumberController,
                                ),
                              ),
            
                              const SizedBox(
                                height: 12,
                              ),
                              Row(
                                children: <Widget>[
                                  Text(
                                    AppLocalizations.of('LICENCE NUMBER'),
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
                                  enabled: isEditable,
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
                                    labelText: 'Licence Number',
                                  ),
                                  controller: licenceNumberController,
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
                                  enabled: isEditable,
                                        keyboardType: TextInputType.datetime,
                                        onTap: () async {
                                          DateTime? dt = await showDatePicker(
                                              context: context,
                                              firstDate: DateTime(2000),
                                              lastDate: DateTime(2100));
                                          if(dt!=null){
                                            licenceExpiryController.text = DateFormat('dd-MM-yyyy').format(dt);
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
                                          labelText: 'Licence Expiry',
                                        ),
                                        controller: licenceExpiryController,
                                      ),
                                    ),
                                    const Spacer(),
                                    empLicNumExpImage == null? const Icon(Icons.warning, color: Colors.red,):
                                    const Icon(Icons.done, color: Colors.green,),
                                    const Spacer(),
                                    isEditable? SizedBox(
                                      width: 140,
                                      child: ElevatedButton(
                                          onPressed: () async {
                                            empDriPhvExpImage = await _imagePicker();
                                            setState(() {
            
                                            });
                                          },
                                          child: const Text('Licence Pic'))
                                    ):Container()
                                  ],
                                ),
                              ),
            
            
            
            
            
                              const SizedBox(
                                height: 12,
                              ),
                              Row(
                                children: <Widget>[
                                  Text(
                                    AppLocalizations.of('PHV NUMBER'),
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
                                  enabled: isEditable,
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
                                    labelText: 'Phv Number',
                                  ),
                                  controller: phvNumberController,
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
                                  enabled: isEditable,
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
                                          labelText: 'Phv Expiry',
                                        ),
                                        controller: phvExpiryController,
                                      ),
                                    ),
                                    const Spacer(),
                                    empDriPhvExpImage == null? const Icon(Icons.warning, color: Colors.red,):
                                    const Icon(Icons.done, color: Colors.green,),
                                    const Spacer(),
                                    isEditable? SizedBox(
                                      width: 140,
                                      child: ElevatedButton(
                                          onPressed: () async {
                                            empDriPhvExpImage = await _imagePicker();
                                            setState(() {
            
                                            });
                                          },
                                          child: const Text('Phv Badge')),
                                    ):Container()
                                  ],
                                ),
                              ),
            
            
            
            
            
                              const SizedBox(
                                height: 12,
                              ),
                              Row(
                                children: <Widget>[
                                  Text(
                                    AppLocalizations.of('PASSPORT NUMBER'),
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
                                  enabled: isEditable,
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
                                    labelText: 'Passport Number',
                                  ),
                                  controller: passportNumberController,
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
                                  enabled: isEditable,
                                        keyboardType: TextInputType.datetime,
                                        onTap: () async {
                                          DateTime? dt = await showDatePicker(
                                              context: context,
                                              firstDate: DateTime(2000),
                                              lastDate: DateTime(2100));
                                          if(dt!=null){
                                            passportExpiryController.text = DateFormat('dd-MM-yyyy').format(dt);
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
                                          labelText: 'Passport Expiry',
                                        ),
                                        controller: passportExpiryController,
                                      ),
                                    ),
                                    const Spacer(),
                                    empPassportExpImage == null? const Icon(Icons.warning, color: Colors.red,):
                                    const Icon(Icons.done, color: Colors.green,),
                                    const Spacer(),
                                    isEditable? SizedBox(
                                      width: 140,
                                      child: ElevatedButton(
                                          onPressed: () async {
                                            empPassportExpImage = await _imagePicker();
                                            setState(() {
            
                                            });
                                          },
                                          child: const Text('Passport')),
                                    ): Container()
                                  ],
                                ),
                              ),
            
            
            
                              const SizedBox(
                                height: 12,
                              ),
                              Row(
                                children: <Widget>[
                                  Text(
                                    AppLocalizations.of('BIOMETRIC NUMBER'),
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
                                  enabled: isEditable,
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
                                    labelText: 'Biometric Number',
                                  ),
                                  controller: biometricNumberController,
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
                                  enabled: isEditable,
                                        keyboardType: TextInputType.datetime,
                                        onTap: () async {
                                          DateTime? dt = await showDatePicker(
                                              context: context,
                                              firstDate: DateTime(2000),
                                              lastDate: DateTime(2100));
                                          if(dt!=null){
                                            biometricExpiryController.text = DateFormat('dd-MM-yyyy').format(dt);
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
                                          labelText: 'Passport Expiry',
                                        ),
                                        controller: biometricExpiryController,
                                      ),
                                    ),
                                    const Spacer(),
                                    empBiometricExpImage == null? const Icon(Icons.warning, color: Colors.red,):
                                    const Icon(Icons.done, color: Colors.green,),
                                    const Spacer(),
                                    isEditable? SizedBox(
                                      width: 140,
                                      child: ElevatedButton(
                                          onPressed: () async {
                                            empBiometricExpImage = await _imagePicker();
                                            setState(() {
            
                                            });
                                          },
                                          child: const Text('Biometric')),
                                    ):Container()
                                  ],
                                ),
                              ),
                            ],
                          ),
                          Row(
                            children: <Widget>[
                              Text(
                                AppLocalizations.of('ADDRESS'),
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
                            height: 100,
                            child: TextFormField(
                              enabled: isEditable,
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'This Field is Required!';
                                }
                                return null;
                              },
                              decoration: InputDecoration(
                                helperMaxLines: 2,
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(15),
                                ),
                                labelText: 'Address',
                              ),
                              maxLines: null, // Set to null or any value greater than 1 for multiple lines
                              controller: addressController,
                            ),
                          ),
                          const SizedBox(
                            height: 12,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
