import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:moozeek_player/main.dart';
import 'package:moozeek_player/models/boxmodels.dart';
import 'package:moozeek_player/ui/widgets/songfile.dart';

class SongsTab extends StatefulWidget {
  const SongsTab({Key? key}) : super(key: key);

  @override
  _SongsTabState createState() => _SongsTabState();
}

class _SongsTabState extends State<SongsTab> {
  final TextEditingController _textEditingController = TextEditingController();
  String searchingTerm = "";

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: 16.0,
          ),
          child: SizedBox(
            height: 48.0,
            child: TextFormField(
              controller: _textEditingController,
              onChanged: (value) {
                setState(() {
                  searchingTerm = value;
                });
              },
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                hintText: "SEARCH SONGS",
                hintStyle: TextStyle(
                  fontSize: 12.0,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 1.0,
                ),
                prefixIcon: Icon(
                  Icons.search,
                  color: Colors.deepPurple,
                ),
              ),
            ),
          ),
        ),
        (searchingTerm.isEmpty)
            ? ValueListenableBuilder<Box<SongsBoxModel>>(
                valueListenable: hiveCtrl.getSongsBox().listenable(),
                builder: (context, box, _) {
                  final songs = box.values.toList().cast<SongsBoxModel>();
                  songs.sort((a, b) => a.songTitle.compareTo(b.songTitle));
                  if (songs.isEmpty) {
                    return const Center(
                      child: Text(
                        "NO SONGS FOUND",
                      ),
                    );
                  } else {
                    return Expanded(
                      child: RefreshIndicator(
                        onRefresh: hiveCtrl.fetchAllSongs,
                        child: ListView.builder(
                          itemCount: songs.length,
                          itemBuilder: (context, index) {
                            return SongFile(
                              searchTerm: "",
                              audioType: 0,
                              playlistName: "",
                              songIndex: index,
                              isFavorite: songs[index].isFavorite,
                              id: songs[index].songId,
                              title: songs[index].songTitle,
                              album: songs[index].songAlbum,
                              albumId: songs[index].songAlbumId,
                              albumArt: songs[index].albumArt,
                              artists: songs[index].songArtists,
                              url: songs[index].songUrl,
                            );
                          },
                        ),
                      ),
                    );
                  }
                },
              )
            : ValueListenableBuilder<Box<SongsBoxModel>>(
                valueListenable: hiveCtrl.getSongsBox().listenable(),
                builder: (context, box, _) {
                  final filtered = box.values
                      .where((song) => song.songTitle
                          .toLowerCase()
                          .startsWith(searchingTerm))
                      .toList()
                      .cast<SongsBoxModel>();
                  if (filtered.isEmpty) {
                    return const Center(
                      child: Text(
                        "NO SONGS FOUND",
                      ),
                    );
                  } else {
                    return Expanded(
                      child: ListView.builder(
                        itemCount: filtered.length,
                        itemBuilder: (context, index) {
                          return SongFile(
                            audioType: 4,
                            playlistName: "",
                            searchTerm: searchingTerm,
                            isFavorite: filtered[index].isFavorite,
                            id: filtered[index].songId,
                            title: filtered[index].songTitle,
                            album: filtered[index].songAlbum,
                            albumId: filtered[index].songAlbumId,
                            albumArt: filtered[index].albumArt,
                            artists: filtered[index].songArtists,
                            url: filtered[index].songUrl,
                            songIndex: index,
                          );
                        },
                      ),
                    );
                  }
                },
              )
      ],
    );
  }
}
