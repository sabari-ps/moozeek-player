import 'package:flutter/material.dart';
import 'package:moozeek_player/helpers/sharedpref.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({Key? key}) : super(key: key);

  @override
  _SettingsScreenState createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  bool notificationOn = false;
  bool darkModeOn = false;
  final snack = const SnackBar(
    content: Text(
      "COMING SOON",
      style: TextStyle(
        fontSize: 12.0,
        color: Colors.white,
        letterSpacing: 2.0,
        fontWeight: FontWeight.bold,
      ),
    ),
    behavior: SnackBarBehavior.floating,
  );

  @override
  void initState() {
    super.initState();
    if (mounted) {
      notificationOn = SharedPreferencesHelper.sharedPreferences
              .getBool('notificationStatus') ??
          true;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: BackButton(
          color: Colors.black,
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
        title: const Text(
          "SETTINGS",
          style: TextStyle(
            fontSize: 14.0,
            color: Colors.black,
            letterSpacing: 2.0,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: Column(
        children: [
          ListTile(
            leading: const Icon(
              Icons.notifications,
              color: Colors.deepPurple,
            ),
            title: const Text(
              "NOTIFICATIONS",
              style: TextStyle(
                fontSize: 12.0,
                color: Colors.black,
                letterSpacing: 2.0,
                fontWeight: FontWeight.bold,
              ),
            ),
            trailing: Switch(
                activeColor: Colors.deepPurple,
                value: notificationOn,
                onChanged: (value) async {
                  notificationOn = await SharedPreferencesHelper
                      .sharedPreferences
                      .setBool('notificationStatus', value);
                  setState(() {
                    notificationOn = SharedPreferencesHelper.sharedPreferences
                        .getBool('notificationStatus')!;
                  });
                }),
          ),
          // ListTile(
          //   leading: const Icon(
          //     Icons.dark_mode,
          //     color: Colors.deepPurple,
          //   ),
          //   title: const Text(
          //     "DARK THEME",
          //     style: TextStyle(
          //       fontSize: 12.0,
          //       color: Colors.black,
          //       letterSpacing: 2.0,
          //       fontWeight: FontWeight.bold,
          //     ),
          //   ),
          //   trailing: Switch(
          //     activeColor: Colors.deepPurple,
          //     value: darkModeOn,
          //     onChanged: (value) {
          //       setState(
          //         () {
          //           darkModeOn = value;
          //         },
          //       );
          //     },
          //   ),
          // ),
          ListTile(
            leading: const Icon(
              Icons.book,
              color: Colors.deepPurple,
            ),
            title: const Text(
              "PRIVACY & POLICIES",
              style: TextStyle(
                fontSize: 12.0,
                color: Colors.black,
                letterSpacing: 2.0,
                fontWeight: FontWeight.bold,
              ),
            ),
            onTap: () {
              ScaffoldMessenger.of(context).showSnackBar(snack);
            },
          ),
          ListTile(
            leading: const Icon(
              Icons.bookmark,
              color: Colors.deepPurple,
            ),
            title: const Text(
              "TERMS & CONDITIONS",
              style: TextStyle(
                fontSize: 12.0,
                color: Colors.black,
                letterSpacing: 2.0,
                fontWeight: FontWeight.bold,
              ),
            ),
            onTap: () {
              ScaffoldMessenger.of(context).showSnackBar(snack);
            },
          ),
          const ListTile(
            leading: Icon(
              Icons.share,
              color: Colors.deepPurple,
            ),
            title: Text(
              "SHARE THIS APP",
              style: TextStyle(
                fontSize: 12.0,
                color: Colors.black,
                letterSpacing: 2.0,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          InkWell(
            onTap: _showAbout,
            child: const ListTile(
              leading: Icon(
                Icons.info,
                color: Colors.deepPurple,
              ),
              title: Text(
                "ABOUT",
                style: TextStyle(
                  fontSize: 12.0,
                  color: Colors.black,
                  letterSpacing: 2.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Future<dynamic> _showAbout() {
    return showDialog(
      context: context,
      builder: (context) {
        return AboutDialog(
          applicationName: "Music Player",
          applicationVersion: "Version 1.0.0",
          applicationIcon: Image.asset(
            'assets/images/logo.png',
            width: 60.0,
            height: 60.0,
          ),
        );
      },
    );
  }
}
