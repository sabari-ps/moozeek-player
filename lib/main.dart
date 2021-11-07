// ignore_for_file: avoid_print

import 'dart:async';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:moozeek_player/helpers/audioplayer.dart';
import 'package:moozeek_player/helpers/hivebox.dart';
import 'package:moozeek_player/helpers/sharedpref.dart';
import 'package:moozeek_player/ui/screens/home.dart';

final audioPlayerHelper = AudioPlayerHelper();
Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await HiveHelper.boxInitiliaser();
  await SharedPreferencesHelper.initialiseSharedPreferences();
  await audioPlayerHelper.initializeInitialPlaylist();

  runApp(const MusicFeverApp());
}

class MusicFeverApp extends StatelessWidget {
  const MusicFeverApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: "Music Fever Player",
      theme: ThemeData(
        visualDensity: VisualDensity.adaptivePlatformDensity,
        textTheme: GoogleFonts.poppinsTextTheme(Theme.of(context).textTheme),
      ),
      themeMode: ThemeMode.system,
      home: const SplashScreen(),
    );
  }
}

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    Timer(
      const Duration(
        seconds: 2,
      ),
      () => Navigator.of(context).pushReplacement(
        MaterialPageRoute(
          builder: (context) => const HomeScreen(),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Image.asset(
              'assets/images/logo.png',
              width: 300.0,
              height: 300.0,
            ),
            const Text(
              "A SIMPLE OFFLINE MUSIC PLAYER",
              style: TextStyle(
                fontSize: 14.0,
                letterSpacing: 3.0,
                fontWeight: FontWeight.bold,
              ),
            ),
            const Padding(
              padding: EdgeInsets.symmetric(
                horizontal: 8.0,
                vertical: 16.0,
              ),
              child: CircularProgressIndicator(
                backgroundColor: Colors.deepPurple,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
