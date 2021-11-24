// ignore_for_file: avoid_print

import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:moozeek_player/main.dart';
import 'package:on_audio_query/on_audio_query.dart';

class PermissionController extends GetxController {
  bool permissionStatus = false;
  GetStorage storage = GetStorage();

  @override
  void onInit() {
    super.onInit();

    permissionStatus = storage.read('permission') ?? false;
  }

  Future<void> getPermissionStatus() async {
    if (permissionStatus) {
      hiveCtrl.fetchAllSongs();
      hiveCtrl.fetchAllAlbums();
    } else {
      await askPermission();
    }
  }

  Future<void> askPermission() async {
    if (!kIsWeb) {
      bool currentStatus = await OnAudioQuery().permissionsStatus();
      if (currentStatus) {
        storage.write('permission', true);
        hiveCtrl.fetchAllSongs();
        hiveCtrl.fetchAllAlbums();
      } else {
        bool nowStatus = await OnAudioQuery().permissionsRequest();
        if (nowStatus) {
          storage.write('permission', true);
          hiveCtrl.fetchAllSongs();
          hiveCtrl.fetchAllAlbums();
        } else {
          storage.write('permission', false);
        }
      }
    }
  }
}
