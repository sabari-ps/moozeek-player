// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'boxmodels.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class SongsBoxModelAdapter extends TypeAdapter<SongsBoxModel> {
  @override
  final int typeId = 0;

  @override
  SongsBoxModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return SongsBoxModel(
      songTitle: fields[0] as String,
      songAlbum: fields[1] as String?,
      songAlbumId: fields[2] as int?,
      songUrl: fields[4] as String,
      songArtists: fields[3] as String?,
      songId: fields[6] as int,
      isFavorite: fields[5] as bool,
      albumArt: fields[7] as Uint8List?,
    );
  }

  @override
  void write(BinaryWriter writer, SongsBoxModel obj) {
    writer
      ..writeByte(8)
      ..writeByte(0)
      ..write(obj.songTitle)
      ..writeByte(1)
      ..write(obj.songAlbum)
      ..writeByte(2)
      ..write(obj.songAlbumId)
      ..writeByte(3)
      ..write(obj.songArtists)
      ..writeByte(4)
      ..write(obj.songUrl)
      ..writeByte(5)
      ..write(obj.isFavorite)
      ..writeByte(6)
      ..write(obj.songId)
      ..writeByte(7)
      ..write(obj.albumArt);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is SongsBoxModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class PlaylistBoxModelAdapter extends TypeAdapter<PlaylistBoxModel> {
  @override
  final int typeId = 1;

  @override
  PlaylistBoxModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return PlaylistBoxModel(
      playlistName: fields[0] as String,
      playlistSongsId: (fields[1] as List).cast<int?>(),
    );
  }

  @override
  void write(BinaryWriter writer, PlaylistBoxModel obj) {
    writer
      ..writeByte(2)
      ..writeByte(0)
      ..write(obj.playlistName)
      ..writeByte(1)
      ..write(obj.playlistSongsId);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is PlaylistBoxModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class AlbumsBoxModelAdapter extends TypeAdapter<AlbumsBoxModel> {
  @override
  final int typeId = 2;

  @override
  AlbumsBoxModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return AlbumsBoxModel(
      albumId: fields[1] as int,
      albumName: fields[0] as String,
      albumSongs: fields[2] as int,
    );
  }

  @override
  void write(BinaryWriter writer, AlbumsBoxModel obj) {
    writer
      ..writeByte(3)
      ..writeByte(0)
      ..write(obj.albumName)
      ..writeByte(1)
      ..write(obj.albumId)
      ..writeByte(2)
      ..write(obj.albumSongs);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is AlbumsBoxModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
