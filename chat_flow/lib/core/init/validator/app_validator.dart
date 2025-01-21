class AppValidator {
  const AppValidator._();

  static String? email(String? value) {
    if (value == null || value.isEmpty) {
      return 'Lütfen e-posta adresinizi girin';
    }

    final emailRegex = RegExp(
      r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$',
    );

    if (!emailRegex.hasMatch(value)) {
      return 'Geçerli bir e-posta adresi girin';
    }

    return null;
  }

  static String? password(String? value) {
    if (value == null || value.isEmpty) {
      return 'Lütfen şifrenizi girin';
    }

    if (value.length < 6) {
      return 'Şifre en az 6 karakter olmalıdır';
    }

    return null;
  }

  static String? name(String? value) {
    if (value == null || value.isEmpty) {
      return 'Lütfen adınızı girin';
    }

    if (value.length < 2) {
      return 'Ad en az 2 karakter olmalıdır';
    }

    return null;
  }

  static String? notEmpty(String? value, {String? message}) {
    if (value == null || value.isEmpty) {
      return message ?? 'Bu alan boş bırakılamaz';
    }
    return null;
  }

  static String? minLength(String? value, int minLength, {String? message}) {
    if (value == null || value.isEmpty) {
      return message ?? 'Bu alan boş bırakılamaz';
    }

    if (value.length < minLength) {
      return message ?? 'En az $minLength karakter olmalıdır';
    }

    return null;
  }

  static String? maxLength(String? value, int maxLength, {String? message}) {
    if (value == null || value.isEmpty) {
      return message ?? 'Bu alan boş bırakılamaz';
    }

    if (value.length > maxLength) {
      return message ?? 'En fazla $maxLength karakter olmalıdır';
    }

    return null;
  }

  static String? phone(String? value) {
    if (value == null || value.isEmpty) {
      return 'Lütfen telefon numaranızı girin';
    }

    final phoneRegex = RegExp(r'^\d{10}$');
    if (!phoneRegex.hasMatch(value)) {
      return 'Geçerli bir telefon numarası girin';
    }

    return null;
  }

  static String? numeric(String? value) {
    if (value == null || value.isEmpty) {
      return 'Bu alan boş bırakılamaz';
    }

    if (int.tryParse(value) == null) {
      return 'Sadece sayı girebilirsiniz';
    }

    return null;
  }
}
