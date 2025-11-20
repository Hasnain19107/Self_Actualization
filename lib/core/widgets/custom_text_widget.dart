import 'package:flutter/material.dart';

class CustomTextWidget extends StatelessWidget {
  const CustomTextWidget({
    super.key,
    this.fontWeight = FontWeight.w400,
    this.fontSize = 18,
    this.textColor = Colors.black,
    required this.text,
    this.textAlign = TextAlign.center,
    this.underlined = false,
    this.limitedCharacters = false,
    this.noOfCharacter = 20,
    this.textOverflow = TextOverflow.ellipsis,
    this.latterSpacing = 1,
    this.maxLines,
  });

  final FontWeight fontWeight;
  final double fontSize;
  final Color textColor;
  final String text;
  final TextAlign textAlign;
  final bool underlined;
  final bool limitedCharacters;
  final int noOfCharacter;
  final TextOverflow textOverflow;
  final double latterSpacing;
  final int? maxLines;

  @override
  Widget build(BuildContext context) {
    final displayText = limitedCharacters
        ? text.length > noOfCharacter
        ? "${text.substring(0, noOfCharacter)}..."
        : text
        : text;
    return Text(
      displayText,
      overflow: textOverflow,
      maxLines: maxLines,
      textAlign: textAlign,
      softWrap: true,
      style: TextStyle(
        fontFamily:'Poppins',
        height: 0,
        fontSize: fontSize,
        color: textColor,
        fontWeight: fontWeight,
        letterSpacing: latterSpacing,
        decoration: underlined ? TextDecoration.underline : null,
        decorationColor: textColor,
      ),
    );
  }
}
