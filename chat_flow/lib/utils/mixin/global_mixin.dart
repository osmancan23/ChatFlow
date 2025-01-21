import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

mixin GlobalMixin {
  void dismissKeyboard() => FocusManager.instance.primaryFocus?.unfocus();
}
