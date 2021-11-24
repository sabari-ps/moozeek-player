import 'dart:typed_data';
import 'package:get/get.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:flutter/material.dart';
import 'package:moozeek_player/main.dart';
import 'package:moozeek_player/models/boxmodels.dart';
import 'package:moozeek_player/ui/screens/player_screen.dart';
import 'package:on_audio_query/on_audio_query.dart';

class SongFile extends StatelessWidget {
  final int audioType;
  final int id;
  final int songIndex;
  final String title;
  final String? artists;
  final String? album;
  final int? albumId;
  final String url;
  final Uint8List? albumArt;
  final bool isFavorite;
  final String? searchTerm;
  final String? playlistName;
  const SongFile({
    Key? key,
    required this.audioType,
    required this.isFavorite,
    required this.id,
    required this.title,
    required this.album,
    required this.albumId,
    required this.albumArt,
    required this.artists,
    required this.url,
    required this.songIndex,
    required this.searchTerm,
    required this.playlistName,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(
        vertical: 4.0,
      ),
      child: ListTile(
        leading: QueryArtworkWidget(
          id: id,
          type: ArtworkType.AUDIO,
          nullArtworkWidget: ClipRRect(
            borderRadius: BorderRadius.circular(50.0),
            child: Image.asset(
              'assets/images/no_album_art.png',
              width: 48.0,
              height: 48.0,
            ),
          ),
        ),
        title: Text(
          title.toUpperCase(),
          overflow: TextOverflow.ellipsis,
          style: const TextStyle(
            fontSize: 12.0,
            letterSpacing: 1.0,
            fontWeight: FontWeight.bold,
          ),
        ),
        subtitle: Text(
          artists!.toUpperCase(),
          overflow: TextOverflow.ellipsis,
          style: const TextStyle(
            fontSize: 10.0,
            letterSpacing: 1.0,
            fontWeight: FontWeight.bold,
          ),
        ),
        trailing: (audioType != 3)
            ? IconButton(
                onPressed: () {
                  showSongOptions(context);
                },
                icon: const Icon(
                  Icons.more_vert,
                ),
              )
            : IconButton(
                onPressed: () {
                  _showDeletePop(context);
                },
                icon: const Icon(
                  Icons.delete,
                ),
              ),
        onTap: () async {
          if (audioType == 0) {
            await playerCtrl.initializeInitialPlaylist();
            await playerCtrl.playSongAtIndex(songIndex);
            routesCtrl.toPlayerScreen();
          } else if (audioType == 1) {
            await playerCtrl.initializeAudiosToPlay(1, songIndex, albumId);
            await playerCtrl.playSongAtIndex(songIndex);
            routesCtrl.toPlayerScreen();
          } else if (audioType == 2) {
            await playerCtrl.initializeAudiosToPlay(2, songIndex);
            await playerCtrl.playSongAtIndex(songIndex);
            routesCtrl.toPlayerScreen();
          } else if (audioType == 4) {
            await playerCtrl.initializeAudiosToPlay(
                4, songIndex, 0, searchTerm);
            await playerCtrl.playSongAtIndex(songIndex);
            routesCtrl.toPlayerScreen();
          } else if (audioType == 3) {
            await playerCtrl.initializeAudiosToPlay(
                3, songIndex, 0, playlistName!);
            await playerCtrl.playSongAtIndex(songIndex);
            routesCtrl.toPlayerScreen();
          }
        },
      ),
    );
  }

  Future<void> showSongOptions(BuildContext ctx) async {
    return showDialog(
      context: ctx,
      builder: (BuildContext buildContext) {
        return SimpleDialog(
          title: const Text(
            "SONG OPTIONS",
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 14.0,
              letterSpacing: 1.0,
              color: Colors.deepPurple,
              fontWeight: FontWeight.bold,
            ),
          ),
          children: [
            SimpleDialogOption(
              child: Text(
                (isFavorite) ? "REMOVE FROM FAVOURITES" : "ADD TO FAVOURITES",
                style: const TextStyle(
                  fontSize: 12.0,
                  letterSpacing: 1.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
              onPressed: () async {
                if (!isFavorite) {
                  await hiveCtrl.addToFavorites(id);
                  routesCtrl.goBack();
                } else {
                  await hiveCtrl.removeFromFavorites(id);
                  routesCtrl.goBack();
                }
              },
            ),
            SimpleDialogOption(
              child: const Text(
                "ADD TO PLAYLIST",
                style: TextStyle(
                  fontSize: 12.0,
                  letterSpacing: 1.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
              onPressed: () async {
                await showPlaylists(ctx);
                routesCtrl.goBack();
              },
            ),
          ],
        );
      },
    );
  }

  Future<void> showPlaylists(BuildContext ctx) async {
    return showDialog(
      context: ctx,
      builder: (BuildContext buildContext) {
        return AlertDialog(
          title: const Text(
            "PLAYLISTS",
            style: TextStyle(
              fontSize: 12.0,
              letterSpacing: 1.0,
              fontWeight: FontWeight.bold,
            ),
          ),
          content: ValueListenableBuilder<Box<PlaylistBoxModel>>(
            valueListenable: hiveCtrl.getPlaylistsBox().listenable(),
            builder: (context, box, _) {
              final lists = box.values.toList().cast<PlaylistBoxModel>();
              if (lists.isEmpty) {
                return TextButton.icon(
                  onPressed: () {},
                  icon: const Icon(
                    Icons.add,
                  ),
                  label: const Text(
                    "CREATE PLAYLIST",
                    style: TextStyle(
                      fontSize: 12.0,
                      letterSpacing: 1.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                );
              } else {
                return SizedBox(
                  width: double.maxFinite,
                  child: ListView.builder(
                    itemCount: lists.length,
                    itemBuilder: (context, index) {
                      return SimpleDialogOption(
                        child: Text(
                          lists[index].playlistName,
                        ),
                        onPressed: () async {
                          await hiveCtrl.addToPlaylist(
                              lists[index].playlistName, id);
                          routesCtrl.goBack();
                        },
                      );
                    },
                  ),
                );
              }
            },
          ),
          actions: [
            TextButton.icon(
              onPressed: () {
                routesCtrl.goBack();
              },
              icon: const Icon(
                Icons.close,
              ),
              label: const Text(
                "CLOSE",
                style: TextStyle(
                  fontSize: 12.0,
                  letterSpacing: 1.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  Future<void> _showDeletePop(BuildContext ct) async {
    return showDialog(
      context: ct,
      builder: (BuildContext ctx) {
        return AlertDialog(
          title: const Text(
            "DELETE FROM PLAYLIST",
            style: TextStyle(
              fontSize: 14.0,
              letterSpacing: 1.0,
              fontWeight: FontWeight.bold,
            ),
          ),
          content: const Text(
            "DO YOU WANT TO DELETE THIS SONG FROM THE PLAYLIST",
            style: TextStyle(
              fontSize: 12.0,
              letterSpacing: 1.0,
              fontWeight: FontWeight.bold,
            ),
          ),
          actions: [
            TextButton.icon(
              onPressed: () {
                routesCtrl.goBack();
              },
              icon: const Icon(
                Icons.close,
              ),
              label: const Text(
                "CLOSE",
                style: TextStyle(
                  fontSize: 12.0,
                  letterSpacing: 1.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            ElevatedButton.icon(
              onPressed: () async {
                await hiveCtrl.deleteFromPlaylist(
                  id,
                  playlistName!,
                );
                routesCtrl.goBack();
              },
              icon: const Icon(
                Icons.delete,
              ),
              label: const Text(
                "DELETE",
                style: TextStyle(
                  fontSize: 12.0,
                  letterSpacing: 1.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
            )
          ],
        );
      },
    );
  }
}
