// ignore_for_file: avoid_print

import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:moozeek_player/models/boxmodels.dart';
import 'package:on_audio_query/on_audio_query.dart';

class HiveHelper {
  // =======Hive Initiliazer =================
  static Future<void> boxInitiliaser() async {
    await Hive.initFlutter();
    print("SUCCESS: Hive initialised successfully.");

    adapterRegistrar();
    print("SUCCESS: Hive Adapters registered successfully.");

    await boxesOpener();
    print("SUCCESS: All Hive Boxes opened succesfully.");
  }

  // =======Hive adapters registration =================
  static void adapterRegistrar() {
    Hive.registerAdapter(SongsBoxModelAdapter());
    Hive.registerAdapter(AlbumsBoxModelAdapter());
    Hive.registerAdapter(PlaylistBoxModelAdapter());
    print("Adapters registered.");
  }

  // =======Hive boxes openers =================
  static Future<void> boxesOpener() async {
    await Hive.openBox<SongsBoxModel>('songs');
    await Hive.openBox<PlaylistBoxModel>('playlists');
    await Hive.openBox<AlbumsBoxModel>('albums');
    print("All boxes are opened successfully.");
  }

  // == Fetching songs from local storage ==

  static Future<void> fetchAllSongs() async {
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

  // === Fetching all albums from local storage ===

  static Future<void> fetchAllAlbums() async {
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

  // === Adding a song to favorites ===
  static Future<void> addToFavorites(int songId, BuildContext ctx) async {
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
      ScaffoldMessenger.of(ctx).showSnackBar(
        const SnackBar(
          content: Text(
            "ADDED TO FAVOURITES",
            style: TextStyle(
              fontSize: 12.0,
              color: Colors.white,
              letterSpacing: 2.0,
              fontWeight: FontWeight.bold,
            ),
          ),
          behavior: SnackBarBehavior.floating,
        ),
      );
      print("SUCCESS: Song added to favourites.");
    }
  }

  // === Removing a song from favorites ===
  static Future<void> removeFromFavorites(int songId, BuildContext ctx) async {
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
      ScaffoldMessenger.of(ctx).showSnackBar(
        const SnackBar(
          content: Text(
            "REMOVED FROM FAVOURITES",
            style: TextStyle(
              fontSize: 12.0,
              color: Colors.white,
              letterSpacing: 2.0,
              fontWeight: FontWeight.bold,
            ),
          ),
          behavior: SnackBarBehavior.floating,
        ),
      );
      print("SUCCESS: Song removed from favourites.");
    }
  }

  // === Deleting a playlist ===
  static Future<void> deleteFromPlaylist(
      int id, String name, BuildContext ctx) async {
    List<int?> currentOne = getPlaylistsBox().get(name)!.playlistSongsId;
    currentOne.remove(id);
    await getPlaylistsBox().put(
      name,
      PlaylistBoxModel(
        playlistName: name,
        playlistSongsId: currentOne,
      ),
    );
    ScaffoldMessenger.of(ctx).showSnackBar(
      const SnackBar(
        content: Text(
          "DELETED FROM PLAYLIST",
          style: TextStyle(
            fontSize: 12.0,
            color: Colors.white,
            letterSpacing: 2.0,
            fontWeight: FontWeight.bold,
          ),
        ),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  // === Adding song to playlist ===
  static Future addToPlaylist(String name, int id, BuildContext ct) async {
    List<int?> currentData = getPlaylistsBox().get(name)!.playlistSongsId;
    var data = getPlaylistsBox().get(name);
    if (!currentData.contains(id)) {
      currentData.add(id);
    } else {
      ScaffoldMessenger.of(ct).showSnackBar(
        const SnackBar(
          content: Text(
            "SONG ALREADY EXISTS IN THIS PLAYLIST",
            style: TextStyle(
              fontSize: 12.0,
              color: Colors.white,
              letterSpacing: 2.0,
              fontWeight: FontWeight.bold,
            ),
          ),
          behavior: SnackBarBehavior.floating,
        ),
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

  // ======= Getting boxes instances =================
  static Box<SongsBoxModel> getSongsBox() => Hive.box<SongsBoxModel>('songs');
  static Box<AlbumsBoxModel> getAlbums() => Hive.box<AlbumsBoxModel>('albums');
  static Box<PlaylistBoxModel> getPlaylistsBox() =>
      Hive.box<PlaylistBoxModel>('playlists');
}
