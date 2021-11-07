import 'package:assets_audio_player/assets_audio_player.dart';
import 'package:audio_video_progress_bar/audio_video_progress_bar.dart';
import 'package:flutter/material.dart';
import 'package:moozeek_player/helpers/hivebox.dart';
import 'package:moozeek_player/helpers/sharedpref.dart';
import 'package:moozeek_player/models/boxmodels.dart';

class AudioPlayerHelper {
  final _audioPlayer = AssetsAudioPlayer();
  late Stream<bool> isAudioPlayerPlaying;
  late Stream<Playing?> currentStatus;
  late Stream<Duration?> currentInfo;
  late Stream<bool> shuffleStatus;

  // === Creating a singleton for the class ===
  static final AudioPlayerHelper _singleton = AudioPlayerHelper._internal();
  factory AudioPlayerHelper() {
    return _singleton;
  }
  AudioPlayerHelper._internal();

  // === Initial playlist ===

  Future<void> initializeInitialPlaylist() async {
    List<SongsBoxModel> allSongs =
        HiveHelper.getSongsBox().values.toList().cast<SongsBoxModel>();
    allSongs.sort((a, b) => a.songTitle.compareTo(b.songTitle));
    List<Audio> songsToPlay = [];
    for (SongsBoxModel song in allSongs) {
      songsToPlay.add(
        Audio.file(
          song.songUrl,
          metas: Metas(
            album: song.songAlbum,
            title: song.songTitle,
            artist: song.songArtists,
            id: song.songId.toString(),
          ),
        ),
      );
    }
    await _audioPlayer.open(
      Playlist(audios: songsToPlay, startIndex: 0),
      autoStart: false,
      loopMode: LoopMode.none,
      showNotification: SharedPreferencesHelper.sharedPreferences
              .getBool('notificationStatus') ??
          true,
      notificationSettings: const NotificationSettings(
        stopEnabled: false,
        seekBarEnabled: true,
      ),
    );
    isAudioPlayerPlaying = _audioPlayer.isPlaying;
    currentStatus = _audioPlayer.current;
    shuffleStatus = _audioPlayer.isShuffling;
  }

  // === Initializing audios ===
  Future<void> initializeAudiosToPlay(int audioType, int index,
      [int? uniqueId, String? name]) async {
    if (audioType == 1) {
      List albumSongs = HiveHelper.getSongsBox()
          .values
          .where((song) => song.songAlbumId == uniqueId)
          .toList();
      List<Audio> songsToPlay = [];
      for (SongsBoxModel song in albumSongs) {
        songsToPlay.add(
          Audio.file(
            song.songUrl,
            metas: Metas(
              album: song.songAlbum,
              title: song.songTitle,
              artist: song.songArtists,
              id: song.songId.toString(),
            ),
          ),
        );
      }
      await _audioPlayer.open(
        Playlist(audios: songsToPlay, startIndex: index),
        autoStart: true,
        loopMode: LoopMode.none,
        showNotification: SharedPreferencesHelper.sharedPreferences
                .getBool('notificationStatus') ??
            true,
        notificationSettings: const NotificationSettings(
          stopEnabled: false,
          seekBarEnabled: true,
        ),
      );
      isAudioPlayerPlaying = _audioPlayer.isPlaying;
      currentStatus = _audioPlayer.current;

      shuffleStatus = _audioPlayer.isShuffling;
    } else if (audioType == 2) {
      List favSongs = HiveHelper.getSongsBox()
          .values
          .where((song) => song.isFavorite == true)
          .toList();
      List<Audio> songsToPlay = [];
      for (SongsBoxModel song in favSongs) {
        songsToPlay.add(
          Audio.file(
            song.songUrl,
            metas: Metas(
              album: song.songAlbum,
              title: song.songTitle,
              artist: song.songArtists,
              id: song.songId.toString(),
            ),
          ),
        );
      }
      await _audioPlayer.open(
        Playlist(audios: songsToPlay, startIndex: index),
        autoStart: false,
        loopMode: LoopMode.none,
        showNotification: SharedPreferencesHelper.sharedPreferences
                .getBool('notificationStatus') ??
            true,
        notificationSettings: const NotificationSettings(
          stopEnabled: false,
          seekBarEnabled: true,
        ),
      );
      isAudioPlayerPlaying = _audioPlayer.isPlaying;
      currentStatus = _audioPlayer.current;

      shuffleStatus = _audioPlayer.isShuffling;
    } else if (audioType == 4) {
      List filteredSongs = HiveHelper.getSongsBox()
          .values
          .where(
            (song) => song.songTitle.toLowerCase().startsWith(
                  name.toString().toLowerCase(),
                ),
          )
          .toList();
      List<Audio> songsToPlay = [];
      for (SongsBoxModel song in filteredSongs) {
        songsToPlay.add(
          Audio.file(
            song.songUrl,
            metas: Metas(
              album: song.songAlbum,
              title: song.songTitle,
              artist: song.songArtists,
              id: song.songId.toString(),
            ),
          ),
        );
      }

      await _audioPlayer.open(
        Playlist(audios: songsToPlay, startIndex: index),
        autoStart: false,
        loopMode: LoopMode.none,
        showNotification: SharedPreferencesHelper.sharedPreferences
                .getBool('notificationStatus') ??
            true,
        notificationSettings: const NotificationSettings(
          stopEnabled: false,
          seekBarEnabled: true,
        ),
      );
      isAudioPlayerPlaying = _audioPlayer.isPlaying;
      currentStatus = _audioPlayer.current;
      shuffleStatus = _audioPlayer.isShuffling;
    } else if (audioType == 3) {
      List<int?> filtered =
          HiveHelper.getPlaylistsBox().get(name)!.playlistSongsId;
      List<SongsBoxModel> dbSongs =
          HiveHelper.getSongsBox().values.toList().cast<SongsBoxModel>();
      List<Audio> playlistSongs = <Audio>[];
      for (var i = 0; i < filtered.length; i++) {
        for (var song in dbSongs) {
          if (filtered[i] == song.songId) {
            playlistSongs.add(
              Audio.file(
                song.songUrl,
                metas: Metas(
                  album: song.songAlbum,
                  artist: song.songArtists,
                  id: song.songId.toString(),
                  title: song.songTitle,
                ),
              ),
            );
          }
        }
        if (dbSongs[i].songId == filtered[i]) {
          print(dbSongs[i].songId);
        }
      }
      print("SONGS ADDED TO PLAYLIST: $playlistSongs");
      await _audioPlayer.open(
        Playlist(audios: playlistSongs, startIndex: index),
        loopMode: LoopMode.none,
        autoStart: false,
        showNotification: SharedPreferencesHelper.sharedPreferences
                .getBool('notificationStatus') ??
            true,
        notificationSettings: const NotificationSettings(
          stopEnabled: false,
          seekBarEnabled: true,
        ),
      );
      isAudioPlayerPlaying = _audioPlayer.isPlaying;
      currentStatus = _audioPlayer.current;
      shuffleStatus = _audioPlayer.isShuffling;
    }
  }

  Widget repeatIcon() {
    return _audioPlayer.builderLoopMode(
      builder: (context, loopMode) {
        return IconButton(
          onPressed: () {
            _audioPlayer.toggleLoop();
          },
          icon: (loopMode == LoopMode.none)
              ? const Icon(
                  Icons.repeat,
                  color: Colors.grey,
                )
              : (loopMode == LoopMode.single)
                  ? const Icon(
                      Icons.repeat_one,
                    )
                  : const Icon(
                      Icons.repeat,
                    ),
        );
      },
    );
  }

  Widget previousButton() {
    return _audioPlayer.builderCurrent(
      builder: (context, audio) {
        if (audio.index == 0) {
          return IconButton(
            onPressed: () {},
            icon: const Icon(
              Icons.skip_previous,
              color: Colors.grey,
              size: 24.0,
            ),
          );
        } else {
          return IconButton(
            onPressed: () {
              _audioPlayer.previous();
            },
            icon: const Icon(
              Icons.skip_previous,
            ),
          );
        }
      },
    );
  }

  Widget nextButton() {
    return _audioPlayer.builderCurrent(
      builder: (context, audioPlaying) {
        if (audioPlaying.hasNext) {
          return IconButton(
            onPressed: () {
              _audioPlayer.next();
            },
            icon: const Icon(
              Icons.skip_next,
            ),
          );
        } else {
          return IconButton(
            onPressed: () {},
            icon: const Icon(
              Icons.skip_next,
              color: Colors.grey,
              size: 24.0,
            ),
          );
        }
      },
    );
  }

  Future<void> playPauseAudio() async {
    await _audioPlayer.playOrPause();
  }

  Future<void> playPrevious() async {
    await _audioPlayer.previous();
  }

  Future<void> playNext() async {
    await _audioPlayer.next();
  }

  Future<void> seekSongForward() async {
    await _audioPlayer.seekBy(
      const Duration(
        seconds: 10,
      ),
    );
  }

  Future<void> seekSongBackward() async {
    await _audioPlayer.seekBy(
      const Duration(
        seconds: -10,
      ),
    );
  }

  Future<void> playSongAtIndex(int index) async {
    await _audioPlayer.playlistPlayAtIndex(index);
  }

  Future<void> switchRepeat() async {
    await _audioPlayer.toggleLoop();
  }

  Future<void> shufflePlaylist() async {
    _audioPlayer.toggleShuffle();
  }

  Widget seekBarWidget(BuildContext ctx) {
    return _audioPlayer.builderRealtimePlayingInfos(
      builder: (ctx, infos) {
        Duration cPos = infos.currentPosition;
        Duration total = infos.duration;
        return ProgressBar(
          progress: cPos,
          total: total,
          progressBarColor: Colors.deepPurple,
          onSeek: (to) {
            _audioPlayer.seek(to);
          },
        );
      },
    );
  }
}
