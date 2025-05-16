import 'package:driver/auth/loginScreen.dart';
import 'package:driver/home-screen/screen/home_screen.dart';
import 'package:driver/services/service_locator.dart';
import 'package:driver/services/shared_preference_service.dart';
import 'package:flutter/material.dart';

class EntryScreen extends StatefulWidget {
  const EntryScreen({super.key});

  @override
  State<EntryScreen> createState() => _EntryScreenState();
}

class _EntryScreenState extends State<EntryScreen> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    String? token = locator<SharedPrefsServices>().getString(key: 'token');

    return token == null ? const LoginScreen() : const HomeScreen();
  }
}
