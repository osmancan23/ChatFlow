extension ImagePath on String {
  String get toSvgIc => 'assets/icons/svg_$this.svg';

  String get toSvg => 'assets/images/svg_$this.svg';

  String get toPng => 'assets/images/ig_$this.png';

  String get toJpeg => 'assets/images/ig_$this.jpg';

  String get toPngIc => 'assets/icons/ic_$this.png';

  String get toJpegIc => 'assets/icons/ic_$this.jpg';

  String get toLottieJson => 'assets/lottie/lottie_$this.json';
}

extension FormValidate on String {
  String? get emailValidate => contains('@') ? null : 'Uygun bir e-mail adresi giriniz !';
}

extension RichTranslation on String {
  String get removeRichMarking => replaceAll('*', '');
}

extension StringExtensions on String {
  String? get isValidDate =>
      contains(RegExp(r'^([0-2][0-9]|(3)[0-1])(\/)(((0)[0-9])|((1)[0-2]))(\/)\d{4}$')) ? null : 'Tarih formatı yanlış';
  bool get isValidDates => RegExp(r'^([0-2][0-9]|(3)[0-1])(\/)(((0)[0-9])|((1)[0-2]))(\/)\d{4}$').hasMatch(this);

  bool get isCheckNullable => this != 'null' && this != ' ';
}

extension StringShortener on String? {
  String? toShortString({int? countCharacter}) {
    return this != null
        ? this!.length > (countCharacter ?? 100)
            ? '${this!.substring(0, countCharacter)} ...'
            : this
        : null;
  }
}

extension StringToDateTime on String {
  ///MARK: 10.00.00 -> 10:00 Convert
  String get toHourMinute => replaceAll('.', ':').substring(0, 5);

  ///MARK: 2021-10-10T10:00:00.000Z -> 10.10.2021 Convert
  String get toDayMonthYear => split('T').first.split('-').reversed.join('.');
}

extension StringToDouble on String {
  double get toDouble => double.parse(this);
}
