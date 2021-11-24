import 'package:flutter/material.dart';
import 'package:moozeek_player/main.dart';
import 'package:moozeek_player/ui/screens/playlist_view.dart';

class PlaylistFile extends StatelessWidget {
  final String playlistName;
  final int songsCount;
  final int id;
  const PlaylistFile({
    Key? key,
    required this.id,
    required this.playlistName,
    required this.songsCount,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: const CircleAvatar(
        backgroundColor: Colors.deepPurple,
        child: Icon(
          Icons.music_note,
        ),
      ),
      title: Text(
        playlistName,
        style: const TextStyle(
          fontSize: 14.0,
          fontWeight: FontWeight.bold,
          letterSpacing: 2.0,
        ),
      ),
      subtitle: (songsCount <= 1)
          ? Text(
              "$songsCount SONG",
              style: const TextStyle(
                fontSize: 12.0,
                fontWeight: FontWeight.bold,
                letterSpacing: 1.0,
              ),
            )
          : Text(
              "$songsCount SONGS",
            ),
      trailing: IconButton(
        onPressed: () {
          showDeletePopup(context);
        },
        icon: const Icon(
          Icons.delete,
        ),
      ),
      onTap: () {
        Navigator.of(context).push(MaterialPageRoute(
            builder: (context) => PlaylistView(playlistName: playlistName)));
      },
    );
  }

  Future<void> showDeletePopup(BuildContext ctx) async {
    return showDialog(
      context: ctx,
      builder: (BuildContext buildContext) {
        return AlertDialog(
          title: const Text(
            "DELETE PLAYLIST",
            style: TextStyle(
              fontSize: 12.0,
              color: Colors.black,
              letterSpacing: 2.0,
              fontWeight: FontWeight.bold,
            ),
          ),
          content: const Text(
            "DO YOU WANT TO DELETE THE PLAYLIST",
            style: TextStyle(
              fontSize: 12.0,
              color: Colors.black,
              letterSpacing: 2.0,
              fontWeight: FontWeight.normal,
            ),
          ),
          actions: [
            TextButton.icon(
              onPressed: () {
                Navigator.of(buildContext).pop();
              },
              icon: const Icon(
                Icons.close,
              ),
              label: const Text(
                "CANCEL",
                style: TextStyle(
                  fontSize: 12.0,
                  color: Colors.black,
                  letterSpacing: 2.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            ElevatedButton.icon(
              onPressed: () {
                hiveCtrl.getPlaylistsBox().delete(playlistName);
                Navigator.of(buildContext).pop();
              },
              icon: const Icon(
                Icons.delete,
              ),
              label: const Text(
                "DELETE",
                style: TextStyle(
                  fontSize: 12.0,
                  color: Colors.white,
                  letterSpacing: 2.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}
