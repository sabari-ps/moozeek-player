import 'dart:typed_data';

import 'package:hive/hive.dart';
part 'boxmodels.g.dart';

@HiveType(typeId: 0)
class SongsBoxModel extends HiveObject {
  @HiveField(0)
  late String songTitle;

  @HiveField(1)
  late String? songAlbum;

  @HiveField(2)
  late int? songAlbumId;

  @HiveField(3)
  late String? songArtists;

  @HiveField(4)
  late String songUrl;

  @HiveField(5)
  late bool isFavorite;

  @HiveField(6)
  late int songId;

  @HiveField(7)
  late Uint8List? albumArt;

  SongsBoxModel({
    required this.songTitle,
    required this.songAlbum,
    required this.songAlbumId,
    required this.songUrl,
    required this.songArtists,
    required this.songId,
    required this.isFavorite,
    required this.albumArt,
  });
}

@HiveType(typeId: 1)
class PlaylistBoxModel extends HiveObject {
  @HiveField(0)
  late String playlistName;

  @HiveField(1)
  late List<int?> playlistSongsId;

  PlaylistBoxModel({
    required this.playlistName,
    required this.playlistSongsId,
  });
}

@HiveType(typeId: 2)
class AlbumsBoxModel extends HiveObject {
  @HiveField(0)
  late String albumName;

  @HiveField(1)
  late int albumId;

  @HiveField(2)
  late int albumSongs;

  AlbumsBoxModel({
    required this.albumId,
    required this.albumName,
    required this.albumSongs,
  });
}
