import 'package:get/get.dart';
import 'package:moozeek_player/ui/screens/home.dart';
import 'package:moozeek_player/ui/screens/player_screen.dart';
import 'package:moozeek_player/ui/screens/settings.dart';
import 'package:moozeek_player/ui/screens/splash.dart';

final List<GetPage<dynamic>> appRoutes = [
  GetPage(
    name: '/splash',
    page: () => const SplashScreen(),
  ),
  GetPage(
    name: '/home',
    page: () => const HomeScreen(),
  ),
  GetPage(
    name: '/settings',
    page: () => const SettingsScreen(),
  ),
  GetPage(
    name: '/player',
    page: () => const PlayerScreen(),
  ),
];
