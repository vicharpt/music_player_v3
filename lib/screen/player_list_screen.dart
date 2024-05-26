import 'package:flutter/material.dart';
import 'package:on_audio_query/on_audio_query.dart';
import 'package:vicharpt/constants/app_color.dart';
import 'package:vicharpt/model/music_service.dart';
import 'package:vicharpt/widgets/button_image_or_icon.dart';

class PlayerListScreen extends StatefulWidget {
  const PlayerListScreen({super.key, required this.selectedIndex});
  final int selectedIndex;

  @override
  State<PlayerListScreen> createState() => _PlayerListScreenState();
}

class _PlayerListScreenState extends State<PlayerListScreen> {
  late int selectedIndex;

  ScrollController scrollController = ScrollController();
  final MusicService _musicService = MusicService();
  List<SongModel> _songs = [];

  @override
  void initState() {
    super.initState();
    selectedIndex = widget.selectedIndex;

    WidgetsBinding.instance.addPostFrameCallback((_) {
      calculateScrollPosition(scrollController);
    });

    _loadSongs();
  }

  void _loadSongs() async {
    final songs = await _musicService.getSongs();
    setState(() {
      _songs = songs;
    });
  }

  void calculateScrollPosition(ScrollController scrollController) {
    int totalLength = _songs.length; // Use actual length
    if (totalLength > 0) {
      final maxScroll = scrollController.position.maxScrollExtent;
      final scrollToPosition = maxScroll / totalLength * selectedIndex;

      scrollController.animateTo(scrollToPosition,
          duration: Duration(milliseconds: 500), curve: Curves.easeIn);
    }
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: AppColor.bgColor,
      body: SafeArea(
        child: Column(
          children: [
            SizedBox(height: 20),
            Text(
              "VICHARPT",
              style: TextStyle(
                color: AppColor.secondaryTextColor,
                fontSize: 14,
                fontWeight: FontWeight.bold,
              ),
            ),
            Container(
              padding: EdgeInsets.symmetric(horizontal: 20),
              height: size.height * 0.3,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  ButtonImageOrIcon(
                    onPreseed: () {
                      Navigator.of(context).pop(selectedIndex);
                    },
                    size: 60,
                    child: Icon(
                      Icons.arrow_back_rounded,
                      color: AppColor.secondaryTextColor,
                    ),
                  ),
                  ButtonImageOrIcon(
                    size: size.width * 0.45,
                    distance: 20,
                    padding: 8,
                    child: Icon(
                      Icons.music_note,
                      color: AppColor.secondaryTextColor,
                      size: 85,
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: _songs.isEmpty
                  ? Center(child: CircularProgressIndicator())
                  : ListView.builder(
                      controller: scrollController,
                      itemCount: _songs.length,
                      itemBuilder: (context, index) {
                        final song = _songs[index];
                        return InkWell(
                          onTap: () {
                            setState(() {
                              selectedIndex = index;
                            });
                          },
                          child: Container(
                            margin: EdgeInsets.symmetric(
                                horizontal: 10, vertical: 5),
                            padding: EdgeInsets.symmetric(
                                horizontal: 20, vertical: 15),
                            decoration: selectedIndex == index
                                ? BoxDecoration(
                                    borderRadius: BorderRadius.circular(15),
                                    color: AppColor.secondaryTextColor
                                        .withOpacity(0.3),
                                  )
                                : null,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      song.title.length > 20? "${song.title.substring(0, 20)}...": song.title,
                                      style: TextStyle(
                                        color: AppColor.primaryTextColor,
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    Text(
                                      song.artist ?? 'Unknown Artist',
                                      style: TextStyle(
                                        color: AppColor.secondaryTextColor,
                                        fontSize: 12,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ],
                                ),
                                selectedIndex == index
                                    ? ButtonImageOrIcon(
                                        size: 50,
                                        colors: [
                                          AppColor.blueTopDark,
                                          AppColor.blue,
                                        ],
                                        child: Icon(
                                          Icons.pause_rounded,
                                          color: AppColor.white,
                                        ),
                                      )
                                    : ButtonImageOrIcon(
                                        size: 50,
                                        child: Icon(
                                          Icons.play_arrow_rounded,
                                          color: AppColor.secondaryTextColor,
                                        ),
                                      ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }
}
