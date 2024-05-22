class MusicModel {
  final String name;
  final String imageUrl;
  final String artist;
  final double length;
  late final bool isFav;

  MusicModel({
    required this.name,
    required this.imageUrl,
    required this.artist,
    required this.length,
    required this.isFav,
  });
}