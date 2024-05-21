import 'package:flutter/material.dart';
import 'package:vicharpt/constants/app_color.dart';
import 'package:vicharpt/model/music_model.dart';
import 'package:vicharpt/screen/player_list_screen.dart';
import 'package:vicharpt/widgets/button_image_or_icon.dart';

class PLayerScreen extends StatefulWidget {
  const PLayerScreen({super.key});

  @override
  State<PLayerScreen> createState() => _PLayerScreenState();
}

class _PLayerScreenState extends State<PLayerScreen> {
  int _currentItemPlaying = 0;
  double _currentPlayBack = 0;

  String formatedPlayerTime(double time) {
    final min = time ~/ 60;
    final sec = time % 60;
    return "$min:${sec.toStringAsFixed(0).padRight(2, "0")}";
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
                      musicList[_currentItemPlaying].isFav
                          ? Icons.favorite
                          : Icons.favorite_border,
                      color: AppColor.secondaryTextColor,
                    ),
                  ),
                  Text(
                    "PLAYING NOW",
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
                        builder: (context) => playerListScreen(
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
                size: size.width * 0.8,
                distance: 20,
                padding: 10,
                imageUrl: musicList[_currentItemPlaying].imageUrl,
              ),
              Column(
                children: [
                  Text(
                    musicList[_currentItemPlaying].name,
                    style: TextStyle(
                      color: AppColor.primaryTextColor,
                      fontSize: 25,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    musicList[_currentItemPlaying].artist,
                    style: TextStyle(
                      color: AppColor.secondaryTextColor,
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                    ),
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
                          formatedPlayerTime(_currentPlayBack),
                          style: TextStyle(
                            color: AppColor.secondaryTextColor,
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          formatedPlayerTime(
                              musicList[_currentItemPlaying].length),
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
                    max: musicList[_currentItemPlaying].length,
                    thumbColor: AppColor.blue,
                    activeColor: AppColor.blue,
                    inactiveColor: AppColor.bgDark,
                    onChanged: (value) {
                      setState(() {
                        _currentPlayBack = value;
                      });
                    },
                  )
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  ButtonImageOrIcon(
                    onPreseed: () {
                      if (_currentItemPlaying > 0)
                        setState(() {
                          _currentItemPlaying--;
                        });
                    },
                    size: 80,
                    child: Icon(
                      Icons.skip_previous_rounded,
                      color: AppColor.secondaryTextColor,
                      size: 35,
                    ),
                  ),
                  ButtonImageOrIcon(
                    size: 80,
                    colors: [AppColor.blueTopDark, AppColor.blue],
                    child: Icon(
                      Icons.pause_rounded,
                      color: AppColor.white,
                      size: 35,
                    ),
                  ),
                  ButtonImageOrIcon(
                    onPreseed: () {
                      if (_currentItemPlaying < musicList.length - 1)
                        setState(() {
                          _currentItemPlaying++;
                        });
                    },
                    size: 80,
                    child: Icon(
                      Icons.skip_next_rounded,
                      color: AppColor.secondaryTextColor,
                      size: 35,
                    ),
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
