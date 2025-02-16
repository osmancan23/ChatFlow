// ignore: must_be_immutable
import 'package:auto_size_text/auto_size_text.dart';
import 'package:chat_flow/utils/extension/context_extensions.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

@immutable
// ignore: must_be_immutable
final class ButtonWidget extends StatelessWidget {
  ButtonWidget({
    required this.onTap,
    super.key,
    this.text = '',
    this.width = 380,
    this.height = 58,
    this.buttonColor,
    this.radius = 30,
    this.fontSize = 16,
    this.textColor = Colors.white,
    this.isBold = true,
    this.fontWeight = FontWeight.bold,
  });
  late String? text;
  final double width;
  final double height;
  final double? radius;
  final VoidCallback onTap;
  final double? fontSize;
  final Color? textColor;
  final Color? buttonColor;
  final bool? isBold;
  late FontWeight? fontWeight;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: height.h,
      width: width.w,
      decoration: BoxDecoration(
        color: buttonColor ?? context.theme.colorScheme.onPrimary,
        borderRadius: BorderRadius.circular(36),
      ),
      child: ElevatedButton(
        style: ButtonStyle(
          backgroundColor: WidgetStateProperty.all<Color>(buttonColor ?? context.theme.colorScheme.primary),
          shape: WidgetStateProperty.all<RoundedRectangleBorder>(
            RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(radius!.r),
            ),
          ),
          overlayColor: WidgetStateProperty.all<Color>(context.theme.colorScheme.scrim.withOpacity(0.1)),
          elevation: WidgetStateProperty.all<double>(0.5),
        ),
        onPressed: onTap,
        child: Center(
          child: AutoSizeText(
            text!,
            style: context.theme.textTheme.bodyMedium
                ?.copyWith(color: textColor, fontSize: fontSize?.sp, fontWeight: fontWeight),
          ),
        ),
      ),
    );
  }
}
