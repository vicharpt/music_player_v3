import 'dart:async';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:on_audio_query/on_audio_query.dart';
import 'package:vicharpt/constants/app_color.dart';
import 'package:vicharpt/model/music_service.dart';
import 'package:vicharpt/screen/player_list_screen.dart';
import 'package:vicharpt/widgets/button_image_or_icon.dart';

class PLayerScreen extends StatefulWidget {
  const PLayerScreen({super.key});

  @override
  State<PLayerScreen> createState() => _PLayerScreenState();
}

class _PLayerScreenState extends State<PLayerScreen> {
  final MusicService _musicService = MusicService();
  late List<SongModel> _songs = [];
  Duration _currentPosition = Duration.zero;

  bool _isPlaying = false;
  int _currentItemPlaying = 0;
  double _currentPlayBack = 0;

  @override
  void initState() {
    super.initState();
    _loadSongs();
    _musicService.positionStream.listen((position) {
      
      setState(() {
        _currentPosition = position;
        _currentPlayBack = position.inMilliseconds.toDouble();
        if (_currentPlayBack >
            _songs[_currentItemPlaying].duration!.toDouble()) {
          _currentPlayBack = _songs[_currentItemPlaying].duration!.toDouble();
          _currentItemPlaying++;
        }
      });
    });
  }

  void _loadSongs() async {
    final songs = await _musicService.getSongs();
    setState(() {
      _songs = songs;
    });
  }

  Future<void> _togglePlayPause() async {
    setState(() {
      _isPlaying = !_isPlaying;
      if (_currentPlayBack > 0) {}
    });
    if (_isPlaying) {
      await _musicService.playSong(_songs[_currentItemPlaying].uri!);
    } else {
      await _musicService.pauseSong();
    }
  }

  String formatedPlayerTime(double milliseconds) {
    int seconds = milliseconds ~/ 1000;
    int minutes = seconds ~/ 60;
    seconds = seconds % 60;
    return "$minutes:${seconds.toString().padLeft(2, '0')}";
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: AppColor.bgColor,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  ButtonImageOrIcon(
                    size: 60,
                    child: Icon(
                      Icons.music_note_outlined,
                      color: AppColor.secondaryTextColor,
                    ),
                  ),
                  Text(
                    "P L A Y I N G - N O W",
                    style: TextStyle(
                      color: AppColor.secondaryTextColor,
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  ButtonImageOrIcon(
                    size: 60,
                    child: Icon(
                      Icons.menu,
                      color: AppColor.secondaryTextColor,
                    ),
                    onPreseed: () async {
                      int selectedIndex =
                          await Navigator.of(context).push(MaterialPageRoute(
                        builder: (context) => PlayerListScreen(
                          selectedIndex: _currentItemPlaying,
                        ),
                      ));
                      setState(() {
                        _currentItemPlaying = selectedIndex;
                      });
                    },
                  ),
                ],
              ),
              ButtonImageOrIcon(
                size: size.width * 0.65,
                distance: 20,
                padding: 8,
                child: Icon(
                  Icons.music_note,
                  color: AppColor.secondaryTextColor,
                  size: 110,
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Column(
                    children: [
                      Text(
                        _songs[_currentItemPlaying].title.length > 15
                            ? "${_songs[_currentItemPlaying].title.substring(0, 15)}..."
                            : _songs[_currentItemPlaying].title,
                        style: TextStyle(
                          color: AppColor.primaryTextColor,
                          fontSize: 25,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        _songs[_currentItemPlaying].artist.toString(),
                        style: TextStyle(
                          color: AppColor.secondaryTextColor,
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 22),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          formatedPlayerTime(
                              _currentPosition.inMilliseconds.toDouble()),
                          style: TextStyle(
                            color: AppColor.secondaryTextColor,
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          formatedPlayerTime(
                              _songs[_currentItemPlaying].duration!.toDouble()),
                          style: TextStyle(
                            color: AppColor.secondaryTextColor,
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Slider(
                    value: _currentPlayBack,
                    min: 0.0,
                    max: _songs[_currentItemPlaying].duration!.toDouble(),
                    thumbColor: AppColor.blue,
                    activeColor: AppColor.blue,
                    inactiveColor: AppColor.bgDark,
                    onChanged: (value) {
                      setState(() {
                        _currentPlayBack = value;
                      });
                      _musicService.seek(Duration(milliseconds: value.toInt()));
                    },
                  )
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  ButtonImageOrIcon(
                    onPreseed: () async {
                      if (_currentItemPlaying > 0) {
                        await _musicService.pauseSong();
                        setState(() {
                          _currentItemPlaying--;
                          if (_isPlaying) {
                            Timer(Duration(milliseconds: 1000), () {
                              _musicService
                                  .playSong(_songs[_currentItemPlaying].uri!);
                            });
                          } else {
                            _musicService.pauseSong();
                          }
                        });
                      }
                    },
                    size: 80,
                    child: Icon(
                      Icons.skip_previous_rounded,
                      color: AppColor.secondaryTextColor,
                      size: 35,
                    ),
                  ),
                  ButtonImageOrIcon(
                    onPreseed: () async {
                      _togglePlayPause();
                    },
                    size: 80,
                    colors: [AppColor.blueTopDark, AppColor.blue],
                    child: Icon(
                      _isPlaying
                          ? Icons.pause_rounded
                          : Icons.play_arrow_rounded,
                      color: AppColor.white,
                      size: 35,
                    ),
                  ),
                  ButtonImageOrIcon(
                    onPreseed: () async {
                      if (_currentItemPlaying < _songs.length - 1) {
                        await _musicService.pauseSong();
                        setState(() {
                          _currentItemPlaying++;
                          if (_isPlaying) {
                            Timer(Duration(milliseconds: 1000), () {
                              _musicService
                                  .playSong(_songs[_currentItemPlaying].uri!);
                            });
                          } else {
                            _musicService.pauseSong();
                          }
                        });
                      }
                    },
                    size: 80,
                    child: Icon(
                      Icons.skip_next_rounded,
                      color: AppColor.secondaryTextColor,
                      size: 35,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
