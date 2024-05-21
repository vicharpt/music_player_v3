import 'package:flutter/material.dart';
import 'package:vicharpt/constants/app_color.dart';
import 'package:vicharpt/model/music_model.dart';
import 'package:vicharpt/widgets/button_image_or_icon.dart';

class playerListScreen extends StatefulWidget {
  const playerListScreen({super.key, required this.selectedIndex});
  final int selectedIndex;

  @override
  State<playerListScreen> createState() => _playerListScreenState();
}

class _playerListScreenState extends State<playerListScreen> {
  late int selectedIndex;
  ScrollController scrollController = ScrollController();
  @override
  void initState() {
    selectedIndex = widget.selectedIndex;
    WidgetsBinding.instance.addPersistentFrameCallback((timeStamp) {
      calculateScrollPossition(scrollController);
    });
    super.initState();
  }

  calculateScrollPossition(ScrollController scrollController) {
    int totalLength = musicList.length;
    final macScrool = scrollController.position.maxScrollExtent;

    scrollController.animateTo(macScrool / totalLength * selectedIndex,
        duration: Duration(milliseconds: 10), curve: Curves.easeIn);
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
              "FLUME - KAI",
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
                    imageUrl: musicList[selectedIndex].imageUrl,
                  ),
                  ButtonImageOrIcon(
                    size: 60,
                    child: Icon(
                      musicList[selectedIndex].isFav
                          ? Icons.favorite
                          : Icons.favorite_border,
                      color: AppColor.secondaryTextColor,
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
                child: ListView.builder(
              controller: scrollController,
              itemCount: musicList.length,
              itemBuilder: (context, index) {
                return InkWell(
                  onTap: () {
                    setState(() {
                      selectedIndex = index;
                    });
                  },
                  child: Container(
                    margin: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                    padding: EdgeInsets.symmetric(horizontal: 20, vertical: 15),
                    decoration: selectedIndex == index
                        ? BoxDecoration(
                            borderRadius: BorderRadius.circular(15),
                            color: AppColor.secondaryTextColor.withOpacity(0.3))
                        : null,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              musicList[index].name,
                              style: TextStyle(
                                color: AppColor.primaryTextColor,
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Text(
                              musicList[index].artist,
                              style: TextStyle(
                                color: AppColor.secondaryTextColor,
                                fontSize: 12,
                                fontWeight: FontWeight.bold,
                              ),
                            )
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
                              )
                      ],
                    ),
                  ),
                );
              },
            ))
          ],
        ),
      ),
    );
  }
}
