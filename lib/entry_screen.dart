import 'package:driver/auth/Internet_cubit/cubit/internet_cubit.dart';
import 'package:driver/home-screen/screen/home_screen.dart';
import 'package:driver/utils/interne_connection_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class EntryScreen extends StatefulWidget {
  const EntryScreen({super.key});

  @override
  State<EntryScreen> createState() => _EntryScreenState();
}

class _EntryScreenState extends State<EntryScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      FlutterNativeSplash.remove();
    });
  }

  @override
  Widget build(BuildContext context) {
    return InternatConnectionWidget(
      onlineWidget: const HomeScreen(),
      offlineWidget: _buildOfflineWidget(),
    );
  }

  Widget _buildOfflineWidget() {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Center(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 24.w),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.wifi_off, size: 90.sp, color: Colors.redAccent),
                SizedBox(height: 22.h),
                Text(
                  'No Internet Connection',
                  style: TextStyle(
                    fontSize: 25.sp,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 12.h),
                Text(
                  'Please check your connection and try again.',
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 18.sp, color: Colors.grey),
                ),
                SizedBox(height: 30.h),
                ElevatedButton.icon(
                  onPressed: () {
                    context.read<InternetCubit>().checkConnectivityManually();
                  },

                  icon: const Icon(Icons.refresh),
                  label: const Text("Retry"),
                  style: ElevatedButton.styleFrom(
                    padding: EdgeInsets.symmetric(
                      horizontal: 32.w,
                      vertical: 12.h,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
