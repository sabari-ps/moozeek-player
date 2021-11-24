// ignore_for_file: avoid_print

import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:moozeek_player/main.dart';
import 'package:moozeek_player/models/boxmodels.dart';
import 'package:moozeek_player/ui/screens/favorites.dart';
import 'package:moozeek_player/ui/widgets/playlist_tile.dart';

class PlaylistsTab extends StatefulWidget {
  const PlaylistsTab({Key? key}) : super(key: key);

  @override
  _PlaylistsTabState createState() => _PlaylistsTabState();
}

class _PlaylistsTabState extends State<PlaylistsTab> {
  final TextEditingController _textEditingController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ListTile(
          onTap: () {
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (context) => const FavoritesView(),
              ),
            );
          },
          leading: const Icon(
            Icons.favorite,
            color: Colors.deepPurple,
          ),
          title: const Text(
            "FAVOURITES",
            style: TextStyle(
              fontSize: 14.0,
              fontWeight: FontWeight.bold,
              letterSpacing: 1.0,
            ),
          ),
        ),
        Center(
          child: TextButton.icon(
            onPressed: () {
              _showDialogBox(context);
            },
            icon: const Icon(
              Icons.add,
            ),
            label: const Text(
              "CREATE PLAYLIST",
              style: TextStyle(
                fontSize: 12.0,
                color: Colors.black,
                letterSpacing: 2.0,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
        ValueListenableBuilder<Box<PlaylistBoxModel>>(
          valueListenable: hiveCtrl.getPlaylistsBox().listenable(),
          builder: (context, box, _) {
            final playlists = box.values.toList().cast<PlaylistBoxModel>();
            if (playlists.isEmpty) {
              return const Center(
                child: Text(
                  "NO PLAYLISTS",
                  style: TextStyle(
                    fontSize: 12.0,
                    color: Colors.black,
                    letterSpacing: 2.0,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              );
            } else {
              return Expanded(
                child: ListView.builder(
                  itemCount: playlists.length,
                  itemBuilder: (context, index) {
                    return PlaylistFile(
                      id: index,
                      playlistName: playlists[index].playlistName,
                      songsCount: playlists[index].playlistSongsId.length,
                    );
                  },
                ),
              );
            }
          },
        ),
      ],
    );
  }

  Future<void> _showDialogBox(BuildContext ctx) async {
    return showDialog(
      context: ctx,
      builder: (BuildContext buildContext) {
        return AlertDialog(
          title: const Text(
            "CREATE PLAYLIST",
            style: TextStyle(
              fontSize: 14.0,
              fontWeight: FontWeight.bold,
              letterSpacing: 2.0,
            ),
          ),
          content: Form(
            key: _formKey,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: TextFormField(
                validator: (value) {
                  if (value!.isEmpty) {
                    return "YOU MUST ENTER A NAME";
                  }
                  return null;
                },
                controller: _textEditingController,
                style: const TextStyle(
                  fontSize: 14.0,
                ),
                autofocus: false,
                decoration: InputDecoration(
                  hintText: "ENTER PLAYLIST NAME",
                  hintStyle: const TextStyle(
                    fontSize: 12.0,
                    fontWeight: FontWeight.w600,
                    letterSpacing: 1.0,
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(
                      16.0,
                    ),
                  ),
                ),
              ),
            ),
          ),
          actions: [
            TextButton.icon(
              onPressed: () {
                _textEditingController.clear();
                Navigator.of(buildContext).pop();
              },
              icon: const Icon(
                Icons.close,
              ),
              label: const Text(
                "CLOSE",
              ),
            ),
            ElevatedButton(
              onPressed: () async {
                if (_formKey.currentState!.validate()) {
                  await _createPlaylist(_textEditingController.text, ctx);
                  _textEditingController.clear();
                }
              },
              child: const Text(
                "CREATE PLAYLIST",
                style: TextStyle(
                  fontSize: 12.0,
                  color: Colors.white,
                  letterSpacing: 2.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
            )
          ],
        );
      },
    );
  }

  Future<void> _createPlaylist(String name, BuildContext ctx) async {
    if (!hiveCtrl.getPlaylistsBox().containsKey(name)) {
      await hiveCtrl.getPlaylistsBox().put(
            name,
            PlaylistBoxModel(
              playlistName: name,
              playlistSongsId: [],
            ),
          );
    } else {
      var snack = const SnackBar(
        content: Text(
          "PLAYLIST ALREADY EXISTS",
        ),
        shape: RoundedRectangleBorder(),
      );
      ScaffoldMessenger.of(ctx).showSnackBar(snack);
    }
    Navigator.of(context).pop();
  }
}
