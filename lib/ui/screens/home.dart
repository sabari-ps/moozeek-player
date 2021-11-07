import 'package:flutter/material.dart';
import 'package:moozeek_player/ui/screens/player_screen.dart';
import 'package:moozeek_player/ui/screens/settings.dart';
import 'package:moozeek_player/ui/tabs/albums.dart';
import 'package:moozeek_player/ui/tabs/playlists.dart';
import 'package:moozeek_player/ui/tabs/songs.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        resizeToAvoidBottomInset: true,
        appBar: AppBar(
          backgroundColor: Colors.white,
          elevation: 0,
          leading: Image.asset(
            'assets/images/logo.png',
            width: 48.0,
            height: 48.0,
          ),
          title: const Text(
            "MOOZEEK",
            style: TextStyle(
              fontSize: 16.0,
              fontWeight: FontWeight.bold,
              color: Colors.black,
              letterSpacing: 3.0,
            ),
          ),
          actions: [
            IconButton(
              onPressed: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => const SettingsScreen(),
                  ),
                );
              },
              icon: const Icon(
                Icons.settings,
                color: Colors.black,
              ),
            ),
          ],
          bottom: const TabBar(
            labelColor: Colors.deepPurple,
            unselectedLabelColor: Colors.grey,
            labelStyle: TextStyle(
              letterSpacing: 1.0,
              fontWeight: FontWeight.bold,
            ),
            tabs: [
              Tab(
                text: "SONGS",
              ),
              Tab(
                text: "ALBUMS",
              ),
              Tab(
                text: "PLAYLISTS",
              ),
            ],
          ),
        ),
        body: const Padding(
          padding: EdgeInsets.symmetric(
            horizontal: 16.0,
            vertical: 8.0,
          ),
          child: TabBarView(
            children: [
              SongsTab(),
              AlbumsTab(),
              PlaylistsTab(),
            ],
          ),
        ),
        floatingActionButton: FloatingActionButton(
          backgroundColor: Colors.deepPurple,
          onPressed: () {
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (context) => const PlayerScreen(),
              ),
            );
          },
          child: const Icon(
            Icons.play_arrow,
          ),
        ),
      ),
    );
  }
}
