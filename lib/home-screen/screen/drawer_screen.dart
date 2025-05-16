import 'package:flutter/material.dart';

class CustomDrawer extends StatelessWidget {
  const CustomDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: const [
          DrawerHeader(
            child: Text(
              'Nepali Driving License App',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
          ),
          ListTile(
            title: Text('Home'),
            leading: Icon(Icons.home),
          ),
          ListTile(
            title: Text('Writing Exam Test'),
            leading: Icon(Icons.text_snippet_outlined),
          ),
          ListTile(
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
