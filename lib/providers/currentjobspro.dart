import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../Entities/jobsobject.dart';

class CurrentJobsPro with ChangeNotifier {
  bool isloaded = false;
  List<JobObject> jobs = [];
  void clearAll() {
    isloaded = false;
    jobs = [];
    // notifyListeners();
  }

  notifyListenerz() {
    notifyListeners();
  }
}
