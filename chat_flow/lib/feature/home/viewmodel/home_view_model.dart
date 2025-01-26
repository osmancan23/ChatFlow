import 'package:chat_flow/core/base/view_model/base_view_model.dart';
import 'package:chat_flow/core/init/locator/locator_service.dart';
import 'package:chat_flow/core/init/navigation/navigation_service.dart';
import 'package:chat_flow/core/models/chat_model.dart';
import 'package:chat_flow/core/service/chat_service.dart';
import 'package:chat_flow/feature/chat/view/chat_view.dart';
import 'package:chat_flow/feature/profile/view/profile_view.dart';
import 'package:chat_flow/feature/users/view/users_view.dart';
import 'package:flutter/material.dart';

/// Home ekranı için ViewModel sınıfı
class HomeViewModel extends BaseViewModel {
  /// Constructor
  HomeViewModel() {
    _loadChats();
  }

  /// Chat servisi
  final _chatService = locator<ChatService>();

  /// Navigasyon servisi
  final _navigationService = locator<NavigationService>();

  /// Sohbetler listesi
  List<ChatModel> _chats = [];
  List<ChatModel> get chats => _chats;

  /// Yükleniyor durumu
  bool _isLoading = true;
  @override
  bool get isLoading => _isLoading;

  /// Sohbetleri yükle
  void _loadChats() {
    _isLoading = true;
    notifyListeners();

    _chatService.getUserChats().listen((chats) {
      _chats = chats;
      _isLoading = false;
      notifyListeners();
    });
  }

  /// Sohbete tıklandığında
  void onChatTap(BuildContext context, String chatId) {
    _navigationService.navigateToPage(
      context: context,
      page: ChatView(chatId: chatId),
    );
  }

  /// Kullanıcılar sayfasına git
  void navigateToUsers(BuildContext context) {
    _navigationService.navigateToPage(
      context: context,
      page: const UsersView(),
    );
  }

  /// Profil sayfasına git
  void navigateToProfile(BuildContext context) {
    _navigationService.navigateToPage(
      context: context,
      page: const ProfileView(),
    );
  }
}
