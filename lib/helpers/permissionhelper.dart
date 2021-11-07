// ignore_for_file: avoid_print

import 'package:flutter/foundation.dart';
import 'package:moozeek_player/helpers/hivebox.dart';
import 'package:moozeek_player/helpers/sharedpref.dart';
import 'package:on_audio_query/on_audio_query.dart';

class PermissionHelper {
  static Future<void> askPermission() async {
    if (!kIsWeb) {
      bool status = await OnAudioQuery().permissionsStatus();
      if (!status) {
        bool st = await OnAudioQuery().permissionsRequest();
        if (st) {
          print("USER ACCEPTED THE PERMISSION REQUEST");

          SharedPreferencesHelper.sharedPreferences
              .setBool('permissionStatus', true);
          print("SHARED PREFERENCES PERMISSION STATUS UPDATED TO: $st");

          HiveHelper.fetchAllSongs();
          HiveHelper.fetchAllAlbums();
          print("SONGS AND ALBUMS FETCHED");
        } else {
          print("USER DENIED THE PERMISSION REQUEST");

          SharedPreferencesHelper.sharedPreferences
              .setBool('permissionStatus', false);
          print("SHARED PREFERENCES PERMISSION STATUS UPDATED TO: $st");
        }
      }
    }
  }
}
