import 'package:flutter/material.dart';
import 'package:moozeek_player/main.dart';
import 'package:on_audio_query/on_audio_query.dart';

class PlayerScreen extends StatefulWidget {
  const PlayerScreen({Key? key}) : super(key: key);

  @override
  _PlayerScreenState createState() => _PlayerScreenState();
}

class _PlayerScreenState extends State<PlayerScreen> {
  bool isPlaying = false;
  String songTitle = "UNKNOWN TITLE";
  String songArtists = "UNKNOWN ARTISTS";
  bool notificationStatus = false;
  int songId = 0;
  bool isShuffling = false;

  @override
  void initState() {
    super.initState();
    audioPlayerHelper.isAudioPlayerPlaying.listen((value) {
      if (mounted) {
        setState(() {
          isPlaying = value;
        });
        print("Status set to: $isPlaying");
      }
    });

    audioPlayerHelper.shuffleStatus.listen((value) {
      if (mounted) {
        setState(() {
          isShuffling = value;
        });
      }
    });
    audioPlayerHelper.currentStatus.listen((current) {
      if (mounted) {
        if (current == null) {
          return;
        } else {
          songTitle = current.audio.audio.metas.title ?? "UNKNOWN TITLE";
          songArtists = current.audio.audio.metas.artist ?? "UNKNOWN ARTISTS";
          songId = int.parse(current.audio.audio.metas.id!);
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: BackButton(
          color: Colors.black,
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
        title: const Text(
          "NOW PLAYING",
          style: TextStyle(
            fontSize: 14.0,
            fontWeight: FontWeight.bold,
            letterSpacing: 2.0,
            color: Colors.black,
          ),
        ),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: 16.0,
          vertical: 12.0,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            QueryArtworkWidget(
              id: songId,
              type: ArtworkType.AUDIO,
              artworkWidth: 300.0,
              artworkHeight: 300.0,
              nullArtworkWidget: Image.asset(
                "assets/images/no_album_art.png",
                width: 300.0,
                height: 300.0,
              ),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  songTitle.toUpperCase(),
                  overflow: TextOverflow.ellipsis,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    fontSize: 14.0,
                    letterSpacing: 2.0,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(
                    vertical: 8.0,
                  ),
                  child: Text(
                    songArtists.toUpperCase(),
                    overflow: TextOverflow.ellipsis,
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      fontSize: 12.0,
                      letterSpacing: 2.0,
                      color: Colors.black54,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
                audioPlayerHelper.seekBarWidget(context),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    audioPlayerHelper.previousButton(),
                    IconButton(
                      onPressed: () {
                        audioPlayerHelper.seekSongBackward();
                      },
                      icon: const Icon(
                        Icons.fast_rewind,
                      ),
                    ),
                    IconButton(
                      onPressed: () {
                        audioPlayerHelper.playPauseAudio();
                      },
                      icon: (!isPlaying)
                          ? const Icon(
                              Icons.play_arrow,
                            )
                          : const Icon(
                              Icons.pause,
                            ),
                    ),
                    IconButton(
                      onPressed: () {
                        audioPlayerHelper.seekSongForward();
                      },
                      icon: const Icon(
                        Icons.fast_forward,
                      ),
                    ),
                    audioPlayerHelper.nextButton(),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    // IconButton(
                    //   onPressed: () {
                    //     if (HiveHelper.getSongsBox().get(songId)!.isFavorite ==
                    //         true) {
                    //       HiveHelper.removeFromFavorites(songId, context);
                    //     } else {
                    //       HiveHelper.addToFavorites(songId, context);
                    //     }
                    //   },
                    //   icon: (HiveHelper.getSongsBox().get(songId)?.isFavorite ==
                    //           true)
                    //       ? const Icon(
                    //           Icons.favorite,
                    //         )
                    //       : const Icon(
                    //           Icons.favorite_border,
                    //         ),
                    // ),
                    // IconButton(
                    //   onPressed: () {},
                    //   icon: const Icon(
                    //     Icons.playlist_add,
                    //   ),
                    // ),
                    audioPlayerHelper.repeatIcon(),
                    IconButton(
                      onPressed: () async {
                        await audioPlayerHelper.shufflePlaylist();
                      },
                      icon: (isShuffling)
                          ? const Icon(
                              Icons.shuffle,
                            )
                          : const Icon(
                              Icons.shuffle,
                              color: Colors.grey,
                            ),
                    ),
                  ],
                )
              ],
            ),
          ],
        ),
      ),
    );
  }
}
