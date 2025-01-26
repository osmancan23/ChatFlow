import 'package:chat_flow/core/init/locator/locator_service.dart';
import 'package:chat_flow/core/init/navigation/navigation_service.dart';
import 'package:flutter/material.dart';

/// Tüm view model'lar için temel sınıf
/// Bu sınıf, ortak özellikleri ve metodları içerir
abstract class BaseViewModel extends ChangeNotifier {
  BaseViewModel() {
    _init();
  }

  /// Navigation servisi
  final navigationService = locator<NavigationService>();

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  set isLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }

  /// View model başlatıldığında çalışır
  void _init() {
    onInit();
  }

  /// View model başlatıldığında çalışacak metod
  /// Alt sınıflar bu metodu override edebilir
  void onInit() {}

  /// Hata mesajını gösterir
  void showError(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
    );
  }

  /// Başarı mesajını gösterir
  void showSuccess(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.green,
      ),
    );
  }

  /// Bilgi mesajını gösterir
  void showInfo(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.blue,
      ),
    );
  }

  /// Sayfa geçişi yapar
  void navigateToPage(BuildContext context, Widget page) {
    navigationService.navigateToPage(context: context, page: page);
  }

  /// Önceki sayfaları temizleyerek sayfa geçişi yapar
  void navigateToPageClear(BuildContext context, Widget page) {
    navigationService.navigateToPageClear(context: context, page: page);
  }

  /// Bir önceki sayfaya döner
  void navigateBack(BuildContext context) {
    navigationService.navigateToBack(context);
  }

  /// View model dispose edildiğinde çalışır
  @override
  void dispose() {
    onDispose();
    super.dispose();
  }

  /// View model dispose edildiğinde çalışacak metod
  /// Alt sınıflar bu metodu override edebilir
  void onDispose() {}
}
