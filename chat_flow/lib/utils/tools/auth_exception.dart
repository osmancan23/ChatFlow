import 'package:flutter/cupertino.dart';

enum AuthResultStatus {
  successfull,
  sendEmail,
  emailAllredyExist,
  wrongPassword,
  invalidEmail,
  userNotFound,
  userDisabled,
  operationNotAllowed,
  toonManyRequests,
  signInFailed,
  undefined,
  cancelledByUserFromFacebook,
  networkError,
  signInCanceled,
  requiresRecentLogin,
  accountExist,
  mustRegister
}

class AuthExceptionHandler {
  static String findExceptionType(e) =>
      AuthExceptionHandler.generateExceptionMessage(AuthExceptionHandler.handleException(e));

  static AuthResultStatus handleException(e) {
    debugPrint('AuthExceptionHandleError: $e');
    AuthResultStatus status;

    switch (e.code) {
      case 'invalid-email':
        status = AuthResultStatus.invalidEmail;
      case 'wrong-password':
        status = AuthResultStatus.wrongPassword;
      case 'user-not-found':
        status = AuthResultStatus.userNotFound;
      case 'user-disabled':
        status = AuthResultStatus.userDisabled;
      case 'too-many-requests':
        status = AuthResultStatus.toonManyRequests;
      case 'must-register':
        status = AuthResultStatus.mustRegister;
      case 'operation-not-allowed':
        status = AuthResultStatus.operationNotAllowed;
      case 'email-already-in-use':
        status = AuthResultStatus.emailAllredyExist;
      case 'sign-in-failed':
        status = AuthResultStatus.signInFailed;
      case 'network-error':
        status = AuthResultStatus.networkError;
      case 'sign-in-cancelled':
        status = AuthResultStatus.signInCanceled;
      case 'requires-recent-login':
        status = AuthResultStatus.requiresRecentLogin;
      case 'account-exists-with-different-credential':
        status = AuthResultStatus.accountExist;
      default:
        status = AuthResultStatus.undefined;
    }
    return status;
  }

  static String generateExceptionMessage(exceptionCode) {
    String errorMessage;
    switch (exceptionCode) {
      case AuthResultStatus.invalidEmail:
        errorMessage = 'Geçersiz Email';
      case AuthResultStatus.mustRegister:
        errorMessage = 'Kayıt ol sayfasından hesap oluşturmalısınız';
      case AuthResultStatus.wrongPassword:
        errorMessage = 'Yanlış Parola';
      case AuthResultStatus.userNotFound:
        errorMessage = 'Kullanıcı Bulunamadı';
      case AuthResultStatus.userDisabled:
        errorMessage = 'Kullanıcı Devre Dışı';
      case AuthResultStatus.toonManyRequests:
        errorMessage = 'Çok Fazla İstek';
      case AuthResultStatus.operationNotAllowed:
        errorMessage = 'Operasyon İzin Verilmedi';
      case AuthResultStatus.emailAllredyExist:
        errorMessage = 'Email Zaten Kullanımda';
      case AuthResultStatus.signInFailed:
        errorMessage = 'Giriş Hata';
      case AuthResultStatus.cancelledByUserFromFacebook:
        errorMessage = "Facebook'tan Kullanıcı Tarafından iptal edildi";
      case AuthResultStatus.networkError:
        errorMessage = 'Ağ Hatası';
      case AuthResultStatus.signInCanceled:
        errorMessage = 'Giriş İptal Edildi';
      case AuthResultStatus.requiresRecentLogin:
        errorMessage = 'Son Giriş Gerekir';
      case AuthResultStatus.accountExist:
        errorMessage = 'Hesap Zaten Bulunmakta';
      default:
        errorMessage = 'Bir sorun oluştu';
    }
    return errorMessage;
  }
}
