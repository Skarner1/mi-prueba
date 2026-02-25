import 'package:fluttertoast/fluttertoast.dart';
import 'package:flutter/material.dart';

class AppToast {
  static void success(String msg) {
    Fluttertoast.showToast(
      msg: msg,
      backgroundColor: Colors.black87,
      textColor: Colors.white,
      toastLength: Toast.LENGTH_SHORT,
    );
  }

  static void error(String msg) {
    Fluttertoast.showToast(
      msg: msg,
      backgroundColor: Colors.red.shade700,
      textColor: Colors.white,
      toastLength: Toast.LENGTH_SHORT,
    );
  }
}