import 'package:auto_size_text/auto_size_text.dart';
import 'package:chat_flow/utils/extension/string_extension.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

final class CustomText extends StatelessWidget {
  const CustomText(
    this.text, {
    super.key,
    this.textStyle,
    this.textAlign,
    this.maxLines,
    this.maxFontSize,
    this.minFontSize,
    this.maxCharacter,
  });
  final String? text;
  final TextStyle? textStyle;
  final TextAlign? textAlign;
  final int? maxLines;
  final double? maxFontSize;
  final double? minFontSize;
  final int? maxCharacter;

  @override
  Widget build(BuildContext context) {
    return AutoSizeText(
      text?.toShortString(countCharacter: maxCharacter) ?? '',
      style: GoogleFonts.urbanist(textStyle: textStyle),
      textAlign: textAlign,
      maxLines: maxLines,
      maxFontSize: maxFontSize ?? double.infinity,
      minFontSize: minFontSize ?? 11,
    );
  }
}
