import 'package:driver/routes/route_name.dart';
import 'package:driver/services/navigation_service.dart';
import 'package:driver/services/service_locator.dart';
import 'package:driver/utils/theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';

class CustomDrawer extends StatelessWidget {
  const CustomDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);

    return Drawer(
      backgroundColor: Theme.of(context).colorScheme.surface,
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
                style: Theme.of(context).textTheme.displayMedium?.copyWith(
                  fontSize: 18.sp,
                  fontWeight: FontWeight.bold,
                  color: Colors.white, // Use white for contrast on image
                  shadows: [
                    Shadow(
                      color: Colors.black.withOpacity(0.5),
                      offset: const Offset(1, 1),
                      blurRadius: 2,
                    ),
                  ],
                ),
              ),
            ),
          ),
          ListTile(
            title: Text('Home', style: Theme.of(context).textTheme.bodyLarge),
            leading: Icon(
              Icons.home,
              color: Theme.of(context).colorScheme.onSurface,
            ),
            onTap: () {
              Navigator.of(context).pop();
              locator<NavigationService>().navigateTo(Routes.homeScreen);
            },
          ),
          ListTile(
            title: Text(
              'Writing Exam Test',
              style: Theme.of(context).textTheme.bodyLarge,
            ),
            leading: Icon(
              Icons.text_snippet_outlined,
              color: Theme.of(context).colorScheme.onSurface,
            ),
            onTap: () {
              Navigator.of(context).pop();
              locator<NavigationService>().navigateTo(Routes.practiceScreen);
            },
          ),
          ListTile(
            title: Text(
              'Color Vision Test',
              style: Theme.of(context).textTheme.bodyLarge,
            ),
            leading: Icon(
              Icons.remove_red_eye_outlined,
              color: Theme.of(context).colorScheme.onSurface,
            ),
            onTap: () {
              Navigator.of(context).pop();
              locator<NavigationService>().navigateTo(Routes.colorVisionScreen);
            },
          ),
          ListTile(
            title: Text(
              'Online Form',
              style: Theme.of(context).textTheme.bodyLarge,
            ),
            leading: Icon(
              Icons.note_alt_rounded,
              color: Theme.of(context).colorScheme.onSurface,
            ),
            onTap: () {
              Navigator.of(context).pop();
              //  locator<NavigationService>().navigateTo(Routes.onlineFormScreen);
            },
          ),
          ListTile(
            title: Text(
              themeProvider.isDarkMode ? 'Light Mode' : 'Dark Mode',
              style: Theme.of(context).textTheme.bodyLarge,
            ),
            leading: Icon(
              themeProvider.isDarkMode
                  ? Icons.brightness_7_sharp
                  : Icons.brightness_4_sharp,
              color: Theme.of(context).colorScheme.onSurface,
            ),
            trailing: Switch(
              value: themeProvider.isDarkMode,
              onChanged: (value) {
                themeProvider.toggleTheme();
              },
             
            ),
            onTap: () {
              themeProvider.toggleTheme();
            },
          ),
        ],
      ),
    );
  }
}
