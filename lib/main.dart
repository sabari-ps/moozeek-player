// ignore_for_file: avoid_print

import 'dart:async';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:moozeek_player/configs/routes.dart';
import 'package:moozeek_player/controllers/hive_controller.dart';
import 'package:moozeek_player/controllers/permission_controller.dart';
import 'package:moozeek_player/controllers/player_controller.dart';
import 'package:moozeek_player/controllers/routes_controller.dart';
import 'package:moozeek_player/ui/screens/home.dart';

final permissionCtrl = Get.put(PermissionController());
final hiveCtrl = Get.put(HiveBoxController());
final playerCtrl = Get.put(PlayerController());
final routesCtrl = Get.put(RoutesController());
Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  routesCtrl.splashScreen();
  await hiveCtrl.boxInitiliaser();
  await GetStorage.init();
  await playerCtrl.getNotificationStatus();
  await permissionCtrl.getPermissionStatus();
  await playerCtrl.initializeInitialPlaylist();

  runApp(const MusicFeverApp());
}

class MusicFeverApp extends StatelessWidget {
  const MusicFeverApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      title: "Music Fever Player",
      theme: ThemeData(
        visualDensity: VisualDensity.adaptivePlatformDensity,
        textTheme: GoogleFonts.poppinsTextTheme(Theme.of(context).textTheme),
      ),
      initialRoute: '/splash',
      getPages: appRoutes,
      home: const HomeScreen(),
    );
  }
}
