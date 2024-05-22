import 'package:on_audio_query/on_audio_query.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:vicharpt/model/music_model.dart';

class MusicService {
  final OnAudioQuery _audioQuery = OnAudioQuery();

  Future<void> _requestPermission() async {
    if (!await Permission.storage.request().isGranted) {
      await Permission.storage.request();
    }
    if (!await Permission.mediaLibrary.request().isGranted) {
      await Permission.mediaLibrary.request();
    }
  }

  Future<List<SongModel>> getSongs() async {
    await _requestPermission();
    return await _audioQuery.querySongs();
  }
}





// List<MusicModel> musicList = [
//   MusicModel(
//     name: "Lose it",
//     imageUrl: "assets/images/1.jpg",
//     artist: "Flume ft. Vic Mensa",
//     length: 345,
//     isFav: true,
//   ),
//   MusicModel(
//     name: "Helix",
//     imageUrl: "assets/images/2.jpg",
//     artist: "Flume",
//     length: 430,
//     isFav: false,
//   ),
//   MusicModel(
//     name: "Say It",
//     imageUrl: "assets/images/3.jpg",
//     artist: "Flume ft. Tove Lo",
//     length: 250,
//     isFav: false,
//   ),
//   MusicModel(
//     name: "Never Be Like You",
//     imageUrl: "assets/images/4.jpg",
//     artist: "Flume • Kai",
//     length: 500,
//     isFav: true,
//   ),
//   MusicModel(
//     name: "Numb & Getting Colder",
//     imageUrl: "assets/images/5.jpg",
//     artist: "Flume • KUCKA",
//     length: 330,
//     isFav: true,
//   ),
//   MusicModel(
//     name: "Wall Out",
//     imageUrl: "assets/images/6.jpg",
//     artist: "Flume",
//     length: 250,
//     isFav: false,
//   ),
//   MusicModel(
//     name: "Pika",
//     imageUrl: "assets/images/7.jpg",
//     artist: "Flume ft. Tove Lo",
//     length: 450,
//     isFav: true,
//   ),
//   MusicModel(
//     name: "Space Cadet",
//     imageUrl: "assets/images/8.jpg",
//     artist: "Flume ft. Tove",
//     length: 450,
//     isFav: true,
//   ),
//   MusicModel(
//     name: "Hyperreal",
//     imageUrl: "assets/images/9.jpg",
//     artist: "Tove Lo",
//     length: 450,
//     isFav: false,
//   ),
//   MusicModel(
//     name: "Smoke & Retribution",
//     imageUrl: "assets/images/10.jpg",
//     artist: "Flume • KUCKA",
//     length: 450,
//     isFav: false,
//   ),
// ];
