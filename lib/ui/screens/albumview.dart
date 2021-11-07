import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:moozeek_player/helpers/hivebox.dart';
import 'package:moozeek_player/models/boxmodels.dart';
import 'package:moozeek_player/ui/widgets/songfile.dart';

class AlbumView extends StatefulWidget {
  final String albumName;
  final int albumId;
  const AlbumView({
    Key? key,
    required this.albumName,
    required this.albumId,
  }) : super(key: key);

  @override
  _AlbumViewState createState() => _AlbumViewState();
}

class _AlbumViewState extends State<AlbumView> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: BackButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          color: Colors.black,
        ),
        backgroundColor: Colors.white,
        elevation: 0,
        title: Text(
          widget.albumName.split(" ").elementAt(0).toUpperCase(),
          style: const TextStyle(
            color: Colors.black,
            fontSize: 14.0,
            letterSpacing: 2.0,
          ),
        ),
      ),
      body: ValueListenableBuilder<Box<SongsBoxModel>>(
        valueListenable: HiveHelper.getSongsBox().listenable(),
        builder: (context, box, _) {
          final songs = box.values
              .where((song) => song.songAlbumId == widget.albumId)
              .toList();
          if (songs.isEmpty) {
            return const Center(
              child: Text(
                "NO SONGS FOUND IN THIS ALBUM",
              ),
            );
          }
          return ListView.builder(
            itemCount: songs.length,
            itemBuilder: (context, index) {
              return SongFile(
                audioType: 1,
                playlistName: "",
                isFavorite: songs[index].isFavorite,
                id: songs[index].songId,
                title: songs[index].songTitle,
                album: songs[index].songAlbum,
                albumId: songs[index].songAlbumId,
                albumArt: songs[index].albumArt,
                artists: songs[index].songArtists,
                url: songs[index].songUrl,
                songIndex: index,
                searchTerm: "",
              );
            },
          );
        },
      ),
    );
  }
}
