import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import '../Const/app_colors.dart';

class CustomSvgIcon extends StatelessWidget {
  final String path;
  final double height;
  final double width;
  final Color? color;

  const CustomSvgIcon({
    super.key,
    required this.path,
    this.height = 24.0,
    this.width = 24.0,
    this.color,
  });

  @override
  Widget build(BuildContext context) {
    return SvgPicture.asset(
      path,
      height: height,
      width: width,
      placeholderBuilder: (context) => SizedBox(
        height: width,
        width: width,
        child: CircularProgressIndicator(color: AppColors.primary),
      ),
      colorFilter: color != null
          ? ColorFilter.mode(color!, BlendMode.srcIn)
          : null,
      fit: BoxFit.contain,
    );
  }
}