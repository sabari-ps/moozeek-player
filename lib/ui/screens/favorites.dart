import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:moozeek_player/main.dart';
import 'package:moozeek_player/models/boxmodels.dart';
import 'package:moozeek_player/ui/widgets/songfile.dart';

class FavoritesView extends StatefulWidget {
  const FavoritesView({Key? key}) : super(key: key);

  @override
  _FavoritesViewState createState() => _FavoritesViewState();
}

class _FavoritesViewState extends State<FavoritesView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: BackButton(
          color: Colors.black,
          onPressed: () {
            Get.back();
          },
        ),
        title: const Text(
          "FAVOURITES",
          style: TextStyle(
            fontSize: 14.0,
            color: Colors.black,
            letterSpacing: 2.0,
          ),
        ),
        centerTitle: true,
      ),
      body: ValueListenableBuilder<Box<SongsBoxModel>>(
        valueListenable: hiveCtrl.getSongsBox().listenable(),
        builder: (context, box, _) {
          final favSongs = box.values
              .where((song) => song.isFavorite == true)
              .toList()
              .cast<SongsBoxModel>();
          if (favSongs.isEmpty) {
            return const Center(
              child: Text(
                "NO FAVOURITES FOUND",
              ),
            );
          } else {
            return RefreshIndicator(
              onRefresh: hiveCtrl.fetchAllSongs,
              child: ListView.builder(
                scrollDirection: Axis.vertical,
                shrinkWrap: true,
                itemCount: favSongs.length,
                itemBuilder: (context, index) {
                  return SongFile(
                    audioType: 2,
                    searchTerm: "",
                    playlistName: "",
                    songIndex: index,
                    album: favSongs[index].songAlbum,
                    albumArt: favSongs[index].albumArt,
                    albumId: favSongs[index].songAlbumId,
                    artists: favSongs[index].songArtists,
                    id: favSongs[index].songId,
                    isFavorite: favSongs[index].isFavorite,
                    title: favSongs[index].songTitle,
                    url: favSongs[index].songUrl,
                  );
                },
              ),
            );
          }
        },
      ),
    );
  }
}
