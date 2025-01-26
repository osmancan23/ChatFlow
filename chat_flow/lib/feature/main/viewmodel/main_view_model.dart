import 'package:chat_flow/core/base/view_model/base_view_model.dart';

/// Main ekranı için ViewModel sınıfı
class MainViewModel extends BaseViewModel {
  /// Seçili tab indeksi
  int _currentIndex = 0;
  int get currentIndex => _currentIndex;

  /// Tab'a tıklandığında
  void onTabTapped(int index) {
    if (_currentIndex == index) return;

    _currentIndex = index;
    notifyListeners();
  }
}
