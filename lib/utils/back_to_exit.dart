import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';

class BackToExit extends StatefulWidget {
  final Widget child;
  final bool showWarning;
  const BackToExit({super.key, required this.child, this.showWarning = true});

  @override
  State<BackToExit> createState() => _BackToExitState();
}

class _BackToExitState extends State<BackToExit> {
  DateTime? _currentBackPressTime;
  Future<bool> _onWillPop() {
    DateTime now = DateTime.now();
    if (_currentBackPressTime == null ||
        now.difference(_currentBackPressTime!) > const Duration(seconds: 2)) {
      _currentBackPressTime = now;
      Fluttertoast.showToast(
          msg: "Tap back again  to exit app.",
          backgroundColor: Colors.black,
          textColor: Colors.white,
          gravity: ToastGravity.BOTTOM,
          fontSize: 14);
      return Future.value(false);
    } else {
      if (Platform.isAndroid) {
        SystemNavigator.pop();
      } else if (Platform.isIOS) {
        exit(0);
      }
      return Future.value(false);
    }
  }

  @override
  Widget build(BuildContext context) {
    // ignore: deprecated_member_use
    return WillPopScope(onWillPop: _onWillPop, child: widget.child);
  }
}
