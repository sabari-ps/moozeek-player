import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:moozeek_player/main.dart';
import 'package:moozeek_player/models/boxmodels.dart';
import 'package:moozeek_player/ui/screens/albumview.dart';
import 'package:on_audio_query/on_audio_query.dart';

class AlbumsTab extends StatefulWidget {
  const AlbumsTab({Key? key}) : super(key: key);

  @override
  _AlbumsTabState createState() => _AlbumsTabState();
}

class _AlbumsTabState extends State<AlbumsTab> {
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
              autofocus: false,
              onChanged: (value) {
                setState(() {
                  searchingTerm = value;
                });
              },
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                hintText: "SEARCH ALBUMS",
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
            ? ValueListenableBuilder<Box<AlbumsBoxModel>>(
                valueListenable: hiveCtrl.getAlbums().listenable(),
                builder: (context, box, _) {
                  final albums = box.values.toList().cast<AlbumsBoxModel>();
                  if (albums.isEmpty) {
                    return const Center(
                      child: Text(
                        "NO ALBUMS FOUND",
                      ),
                    );
                  }
                  return Expanded(
                    child: RefreshIndicator(
                      onRefresh: hiveCtrl.fetchAllAlbums,
                      child: ListView.builder(
                        itemCount: albums.length,
                        itemBuilder: (context, index) {
                          return ListTile(
                            leading: QueryArtworkWidget(
                              id: albums[index].albumId,
                              type: ArtworkType.ALBUM,
                              nullArtworkWidget: const CircleAvatar(
                                radius: 24.0,
                                backgroundColor: Colors.deepPurple,
                                child: Icon(
                                  Icons.music_note,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                            title: Text(
                              albums[index]
                                  .albumName
                                  .split(" ")
                                  .first
                                  .toUpperCase(),
                              style: const TextStyle(
                                fontSize: 12.0,
                                fontWeight: FontWeight.bold,
                                letterSpacing: 1.0,
                              ),
                            ),
                            subtitle: Text(
                              (albums[index].albumSongs <= 1)
                                  ? "${albums[index].albumSongs.toString()} SONG"
                                  : "${albums[index].albumSongs.toString()} SONGS",
                              style: const TextStyle(
                                fontSize: 10.0,
                                fontWeight: FontWeight.bold,
                                letterSpacing: 1.0,
                              ),
                            ),
                            onTap: () {
                              Navigator.of(context).push(
                                MaterialPageRoute(
                                  builder: (context) => AlbumView(
                                    albumName: albums[index].albumName,
                                    albumId: albums[index].albumId,
                                  ),
                                ),
                              );
                            },
                          );
                        },
                      ),
                    ),
                  );
                },
              )
            : ValueListenableBuilder<Box<AlbumsBoxModel>>(
                valueListenable: hiveCtrl.getAlbums().listenable(),
                builder: (context, box, _) {
                  final filtered = box.values
                      .where(
                        (album) => album.albumName.toLowerCase().contains(
                              searchingTerm.toLowerCase(),
                            ),
                      )
                      .toList();
                  if (filtered.isEmpty) {
                    return const Center(
                      child: Text(
                        "NO ALBUM FOUND",
                      ),
                    );
                  }
                  return Expanded(
                      child: ListView.builder(
                    itemCount: filtered.length,
                    itemBuilder: (context, index) {
                      return ListTile(
                        leading: QueryArtworkWidget(
                          id: filtered[index].albumId,
                          type: ArtworkType.ALBUM,
                          nullArtworkWidget: const CircleAvatar(
                            radius: 24.0,
                            backgroundColor: Colors.deepPurple,
                            child: Icon(
                              Icons.music_note,
                              color: Colors.white,
                            ),
                          ),
                        ),
                        title: Text(
                          filtered[index]
                              .albumName
                              .split(" ")
                              .first
                              .toUpperCase(),
                          style: const TextStyle(
                            fontSize: 12.0,
                            fontWeight: FontWeight.bold,
                            letterSpacing: 1.0,
                          ),
                        ),
                        subtitle: Text(
                          (filtered[index].albumSongs <= 1)
                              ? "${filtered[index].albumSongs.toString()} SONG"
                              : "${filtered[index].albumSongs.toString()} SONGS",
                          style: const TextStyle(
                            fontSize: 10.0,
                            fontWeight: FontWeight.bold,
                            letterSpacing: 1.0,
                          ),
                        ),
                        onTap: () {
                          Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (context) => AlbumView(
                                albumName: filtered[index].albumName,
                                albumId: filtered[index].albumId,
                              ),
                            ),
                          );
                        },
                      );
                    },
                  ));
                })
      ],
    );
  }
}
