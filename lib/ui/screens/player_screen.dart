// ignore_for_file: avoid_print

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:moozeek_player/main.dart';
import 'package:on_audio_query/on_audio_query.dart';

class PlayerScreen extends StatefulWidget {
  const PlayerScreen({Key? key}) : super(key: key);

  @override
  _PlayerScreenState createState() => _PlayerScreenState();
}

class _PlayerScreenState extends State<PlayerScreen> {
  @override
  void initState() {
    super.initState();
    playerCtrl.isAudioPlayerPlaying.listen((value) {
      if (mounted) {
        setState(() {
          playerCtrl.isPlaying.value = value;
        });
        print("Status set to: ${playerCtrl.isPlaying.value}");
      }
    });

    playerCtrl.shuffleStatus.listen((value) {
      if (mounted) {
        setState(() {
          playerCtrl.isShuffling.value = value;
        });
      }
    });
    playerCtrl.currentStatus.listen((current) {
      if (mounted) {
        if (current == null) {
          return;
        } else {
          playerCtrl.songTitle.value =
              current.audio.audio.metas.title ?? "UNKNOWN TITLE";
          playerCtrl.songArtists.value =
              current.audio.audio.metas.artist ?? "UNKNOWN ARTISTS";
          playerCtrl.songId.value = int.parse(current.audio.audio.metas.id!);
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
            Get.back();
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
        child: Obx(
          () => Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              QueryArtworkWidget(
                id: playerCtrl.songId.value,
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
                    playerCtrl.songTitle.value.toUpperCase(),
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
                      playerCtrl.songArtists.value.toUpperCase(),
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
                  playerCtrl.seekBarWidget(context),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      playerCtrl.previousButton(),
                      IconButton(
                        onPressed: () {
                          playerCtrl.seekSongBackward();
                        },
                        icon: const Icon(
                          Icons.fast_rewind,
                        ),
                      ),
                      IconButton(
                        onPressed: () {
                          playerCtrl.playPauseAudio();
                        },
                        icon: (!playerCtrl.isPlaying.value)
                            ? const Icon(
                                Icons.play_arrow,
                              )
                            : const Icon(
                                Icons.pause,
                              ),
                      ),
                      IconButton(
                        onPressed: () {
                          playerCtrl.seekSongForward();
                        },
                        icon: const Icon(
                          Icons.fast_forward,
                        ),
                      ),
                      playerCtrl.nextButton(),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      playerCtrl.repeatIcon(),
                      IconButton(
                        onPressed: () async {
                          await playerCtrl.shufflePlaylist();
                        },
                        icon: (playerCtrl.isShuffling.isTrue)
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
      ),
    );
  }
}
