import 'package:chat_flow/utils/extension/string_extension.dart';

enum LottieEnums {
  login('login');

  const LottieEnums(this.value);

  final String value;

  String get lottiePath => value.toLottieJson;
}
