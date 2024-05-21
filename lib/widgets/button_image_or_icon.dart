import 'package:flutter/material.dart';
import 'package:vicharpt/constants/app_color.dart';

class ButtonImageOrIcon extends StatelessWidget {
  const ButtonImageOrIcon(
      {Key? key,
      required this.size,
      this.child,
      this.blur = 20,
      this.distance = 10,
      this.onPreseed,
      this.colors,
      this.imageUrl,
      this.padding})
      : super(key: key);
  final double size, blur, distance;
  final double? padding;
  final Widget? child;
  final VoidCallback? onPreseed;
  final List<Color>? colors;
  final String? imageUrl;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onPreseed,
      child: Container(
        width: size,
        height: size,
        padding: EdgeInsets.all(padding ?? 3),
        clipBehavior: Clip.antiAliasWithSaveLayer,
        decoration: BoxDecoration(
          color: colors == null ? AppColor.bgColor : colors![1],
          shape: BoxShape.circle,
          boxShadow: [
            BoxShadow(
              color: AppColor.white,
              blurRadius: blur,
              offset: Offset(-distance, -distance),
            ),
            BoxShadow(
              color: AppColor.bgDark,
              blurRadius: blur,
              offset: Offset(distance, distance),
            )
          ],
        ),
        child: imageUrl != null
            ? CircleAvatar(
                backgroundImage: AssetImage(imageUrl!),
              )
            : Container(
                decoration: BoxDecoration(
                  color: AppColor.bgColor,
                  shape: BoxShape.circle,
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: colors ??
                        [
                          AppColor.white,
                          AppColor.bgDark,
                        ],
                  ),
                ),
                child: child,
              ),
      ),
    );
  }
}
