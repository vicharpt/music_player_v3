import 'package:on_audio_query/on_audio_query.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:just_audio/just_audio.dart';
import 'package:audio_service/audio_service.dart';
import 'dart:typed_data';

class MusicService {
  final OnAudioQuery _audioQuery = OnAudioQuery();
  final AudioPlayer _audioPlayer = AudioPlayer();

  Future<void> _requestPermission() async {
    var status = await Permission.storage.status;
    if (!status.isGranted) {
      status = await Permission.storage.request();
      if (!status.isGranted) {
        throw Exception("Storage permission not granted");
      }
    }

    status = await Permission.mediaLibrary.status;
    if (!status.isGranted) {
      status = await Permission.mediaLibrary.request();
      if (!status.isGranted) {
        throw Exception("Media library permission not granted");
      }
    }
  }

  Future<List<SongModel>> getSongs() async {
    await _requestPermission();
    return await _audioQuery.querySongs(
      orderType: OrderType.ASC_OR_SMALLER,
      uriType: UriType.EXTERNAL,
      sortType: null,
    );
  }

  Future<void> playSong(String uri) async {
    try {
      if (uri.startsWith('content://')) {
        await _audioPlayer.setUrl(uri);
      } else {
        await _audioPlayer.setFilePath(uri);
      }
      await _audioPlayer.play();
    } catch (e) {
      print("Error playing song: $e");
    }
  }

  Future<void> pauseSong() async {
    await _audioPlayer.pause();
  }

  Future<void> seek(Duration position) async {
    await _audioPlayer.seek(position);
  }

  Stream<Duration> get positionStream => _audioPlayer.positionStream;

  Future<void> seekPrev() async {
    await _audioPlayer.seekToPrevious();
  }

  Future<void> seekNext() async {
    await _audioPlayer.seekToNext();
  }
}
