import 'package:flutter/material.dart';

extension ThemeExtension on BuildContext {
  ThemeData get theme => Theme.of(this);
}

extension SizeExtension on BuildContext {
  Size get size => MediaQuery.of(this).size;

  double get dynamicWidth => size.width;
}
