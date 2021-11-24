// ignore_for_file: avoid_print

import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:moozeek_player/main.dart';
import 'package:moozeek_player/models/boxmodels.dart';
import 'package:moozeek_player/ui/widgets/songfile.dart';

class PlaylistView extends StatelessWidget {
  final String playlistName;
  const PlaylistView({
    Key? key,
    required this.playlistName,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: BackButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          color: Colors.black,
        ),
        title: Text(
          playlistName,
          style: const TextStyle(
            fontSize: 14.0,
            letterSpacing: 2.0,
            color: Colors.black,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: ValueListenableBuilder<Box<PlaylistBoxModel>>(
        valueListenable: hiveCtrl.getPlaylistsBox().listenable(),
        builder: (context, box, _) {
          final songs = box.get(playlistName)!.playlistSongsId;
          List<SongsBoxModel> dbSongs =
              hiveCtrl.getSongsBox().values.toList().cast<SongsBoxModel>();
          final viewSongs = <SongsBoxModel>[];
          for (var i = 0; i < songs.length; i++) {
            for (var song in dbSongs) {
              if (songs[i] == song.songId) {
                viewSongs.add(song);
              }
            }
          }
          print(viewSongs);
          if (viewSongs.isEmpty) {
            return const Center(
              child: Text("NO SONGS"),
            );
          }
          return ListView.builder(
            itemCount: viewSongs.length,
            itemBuilder: (context, index) {
              return SongFile(
                audioType: 3,
                playlistName: playlistName,
                album: viewSongs[index].songAlbum,
                albumArt: viewSongs[index].albumArt,
                albumId: viewSongs[index].songAlbumId,
                artists: viewSongs[index].songArtists,
                id: viewSongs[index].songId,
                isFavorite: viewSongs[index].isFavorite,
                searchTerm: "",
                songIndex: index,
                title: viewSongs[index].songTitle,
                url: viewSongs[index].songTitle,
              );
            },
          );
        },
      ),
    );
  }
}
