import 'dart:async';

import 'package:get/get.dart';

class RoutesController extends GetxController {
  void splashScreen() {
    Timer(
      const Duration(
        milliseconds: 3000,
      ),
      toHomeScreen,
    );
  }

  void toHomeScreen() => Get.offNamed('/home');
  void toPlayerScreen() => Get.toNamed('/player');
  void toSettingsScreen() => Get.toNamed('/settings');
  void goBack() => Get.back();
}
