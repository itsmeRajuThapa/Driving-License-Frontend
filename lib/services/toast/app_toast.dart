import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

class AppToasts {
  showToast({
    required String message,
    Color? backgroundColor,
    bool isSuccess = true,
  }) {
    Fluttertoast.showToast(
      msg: message,
      // textColor: Colors.white,
      backgroundColor:
          backgroundColor ?? (isSuccess ? Colors.green : Colors.red),
      gravity: ToastGravity.BOTTOM,
      fontSize: 11,
    );
  }
}
