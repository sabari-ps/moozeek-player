// ignore_for_file: avoid_print

import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:hive/hive.dart';
import 'package:moozeek_player/models/boxmodels.dart';
import 'package:on_audio_query/on_audio_query.dart';

class HiveBoxController extends GetxController {
  Box<SongsBoxModel> getSongsBox() => Hive.box<SongsBoxModel>('songs');
  Box<AlbumsBoxModel> getAlbums() => Hive.box<AlbumsBoxModel>('albums');
  Box<PlaylistBoxModel> getPlaylistsBox() =>
      Hive.box<PlaylistBoxModel>('playlists');

  Future<void> boxInitiliaser() async {
    await Hive.initFlutter();
    print("SUCCESS: Hive initialised successfully.");

    adapterRegistrar();
    print("SUCCESS: Hive Adapters registered successfully.");

    await boxesOpener();
    print("SUCCESS: All Hive Boxes opened succesfully.");
  }

  void adapterRegistrar() {
    Hive.registerAdapter(SongsBoxModelAdapter());
    Hive.registerAdapter(AlbumsBoxModelAdapter());
    Hive.registerAdapter(PlaylistBoxModelAdapter());
    print("Adapters registered.");
  }

  Future<void> boxesOpener() async {
    await Hive.openBox<SongsBoxModel>('songs');
    await Hive.openBox<PlaylistBoxModel>('playlists');
    await Hive.openBox<AlbumsBoxModel>('albums');
    print("All boxes are opened successfully.");
  }

  Future<void> fetchAllSongs() async {
    List<SongModel> fetchedSongs = await OnAudioQuery().querySongs(
      sortType: SongSortType.DISPLAY_NAME,
      orderType: OrderType.ASC_OR_SMALLER,
    );
    for (SongModel song in fetchedSongs) {
      if (song.fileExtension == 'mp3' ||
          song.fileExtension == 'opus' && await File(song.data).exists()) {
        if (!getSongsBox().containsKey(song.id)) {
          Uint8List? art = await OnAudioQuery().queryArtwork(
            song.id,
            ArtworkType.AUDIO,
          );

          getSongsBox().put(
            song.id,
            SongsBoxModel(
              songTitle: song.title,
              songAlbum: song.album,
              songAlbumId: song.albumId,
              songUrl: song.data,
              songArtists: song.artist,
              songId: song.id,
              isFavorite: false,
              albumArt: art,
            ),
          );
        }
      }
    }
  }

  Future<void> fetchAllAlbums() async {
    List<AlbumModel> albums = await OnAudioQuery().queryAlbums(
      sortType: AlbumSortType.ALBUM,
    );
    for (var i = 0; i < albums.length; i++) {
      getAlbums().put(
        i,
        AlbumsBoxModel(
          albumId: albums[i].id,
          albumName: albums[i].album,
          albumSongs: albums[i].numOfSongs,
        ),
      );
    }
  }

  Future<void> addToFavorites(int songId) async {
    SongsBoxModel? current = getSongsBox().get(songId);
    if (current != null) {
      await getSongsBox().put(
        songId,
        SongsBoxModel(
          songTitle: current.songTitle,
          songAlbum: current.songAlbum,
          songAlbumId: current.songAlbumId,
          songUrl: current.songUrl,
          songArtists: current.songArtists,
          songId: current.songId,
          isFavorite: true,
          albumArt: current.albumArt,
        ),
      );
      Get.snackbar(
        "ADDED!",
        "Song added to Favourites",
        backgroundColor: Colors.deepPurple,
        titleText: const Text(
          "ADDED!",
          style: TextStyle(
            color: Colors.white,
            fontSize: 14.0,
            fontWeight: FontWeight.bold,
            letterSpacing: 1.0,
          ),
        ),
        messageText: const Text(
          "Song added to Favourites",
          style: TextStyle(
            color: Colors.white,
            fontSize: 12.0,
            fontWeight: FontWeight.bold,
            letterSpacing: 1.0,
          ),
        ),
        snackPosition: SnackPosition.BOTTOM,
        snackStyle: SnackStyle.FLOATING,
      );
      Get.back();
    }
  }

  Future<void> removeFromFavorites(int songId) async {
    SongsBoxModel? current = getSongsBox().get(songId);
    if (current != null) {
      await getSongsBox().put(
        songId,
        SongsBoxModel(
          songTitle: current.songTitle,
          songAlbum: current.songAlbum,
          songAlbumId: current.songAlbumId,
          songUrl: current.songUrl,
          songArtists: current.songArtists,
          songId: current.songId,
          isFavorite: false,
          albumArt: current.albumArt,
        ),
      );
      Get.snackbar(
        "REMOVED!",
        "Song removed from Favourites",
        backgroundColor: Colors.deepPurple,
        titleText: const Text(
          "REMOVED!",
          style: TextStyle(
            color: Colors.white,
            fontSize: 14.0,
            fontWeight: FontWeight.bold,
            letterSpacing: 1.0,
          ),
        ),
        messageText: const Text(
          "Song removed from Favourites",
          style: TextStyle(
            color: Colors.white,
            fontSize: 12.0,
            fontWeight: FontWeight.bold,
            letterSpacing: 1.0,
          ),
        ),
        snackPosition: SnackPosition.BOTTOM,
      );
    }
    Get.back();
  }

  Future<void> deleteFromPlaylist(int id, String name) async {
    List<int?> currentOne = getPlaylistsBox().get(name)!.playlistSongsId;
    currentOne.remove(id);
    await getPlaylistsBox().put(
      name,
      PlaylistBoxModel(
        playlistName: name,
        playlistSongsId: currentOne,
      ),
    );
    Get.snackbar(
      "REMOVED!",
      "Song removed from playlist",
    );
  }

  Future addToPlaylist(String name, int id) async {
    List<int?> currentData = getPlaylistsBox().get(name)!.playlistSongsId;
    var data = getPlaylistsBox().get(name);
    if (!currentData.contains(id)) {
      currentData.add(id);
    } else {
      Get.snackbar(
        "ADDED!",
        "Song added to playlist",
      );
    }

    await getPlaylistsBox().put(
      name,
      PlaylistBoxModel(
        playlistName: data!.playlistName,
        playlistSongsId: currentData,
      ),
    );
  }
}
