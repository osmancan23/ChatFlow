import 'package:chat_flow/utils/extension/string_extension.dart';

enum LottieEnums {
  login('assets/lottie/lottie_login.json');

  final String path;
  const LottieEnums(this.path);

  String get lottiePath => path.toLottieJson;
}
