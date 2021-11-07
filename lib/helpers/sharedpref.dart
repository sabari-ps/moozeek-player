// ignore_for_file: avoid_print

import 'package:moozeek_player/helpers/hivebox.dart';
import 'package:moozeek_player/helpers/permissionhelper.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SharedPreferencesHelper {
  static late SharedPreferences sharedPreferences;

  // == Initialisation ==
  static Future<void> initialiseSharedPreferences() async {
    sharedPreferences = await SharedPreferences.getInstance();
    print("SUCCESS: Shared Preferences initialised successfully.");

    await getPermissionStatus();
  }

  static Future<void> getPermissionStatus() async {
    bool initialPermission =
        sharedPreferences.getBool('permissionStatus') ?? false;
    if (initialPermission) {
      print("INITIAL PERMISSION STATUS : $initialPermission");

      await HiveHelper.fetchAllSongs();
      print("SUCCESS: Fetched All Songs from Hive Box");

      await HiveHelper.fetchAllAlbums();
      print("SUCCESS: Fetched All Albums from Hive Box");
    } else {
      print("INITIAL PERMISSION STATUS : $initialPermission");
      print("SO ASKING USER PERMISSION");

      await PermissionHelper.askPermission();
    }
  }
}
