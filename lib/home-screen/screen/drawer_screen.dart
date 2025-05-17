import 'package:driver/routes/route_name.dart';
import 'package:driver/services/navigation_service.dart';
import 'package:driver/services/service_locator.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class CustomDrawer extends StatelessWidget {
  const CustomDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          DrawerHeader(
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage('assets/bike.jpg'),
                fit: BoxFit.fill,
              ),
            ),
            child: Align(
              alignment: Alignment.bottomLeft,
              child: Text(
                'Nepali Driving License App',
                style: TextStyle(
                  fontSize: 18.sp,
                  fontWeight: FontWeight.bold,
                  color: const Color.fromARGB(255, 96, 239, 153),
                  shadows: [
                    Shadow(
                      color: Colors.amber,
                      offset: Offset(1, 1),
                      blurRadius: 2,
                    ),
                  ],
                ),
              ),
            ),
          ),

          ListTile(
            title: Text('Home'),
            leading: Icon(Icons.home),
            onTap: () {
              Navigator.of(context).pop();
            },
          ),
          ListTile(
            title: Text('Writing Exam Test'),
            leading: Icon(Icons.text_snippet_outlined),
          ),
          ListTile(
            onTap: () {
              Navigator.of(context).pop();
              locator<NavigationService>().navigateTo(Routes.colorVisionScreen);
            },
            title: Text('Color Vision Test'),
            leading: Icon(Icons.remove_red_eye_outlined),
          ),
          ListTile(
            title: Text('Online Form'),
            leading: Icon(Icons.note_alt_rounded),
          ),
        ],
      ),
    );
  }
}
