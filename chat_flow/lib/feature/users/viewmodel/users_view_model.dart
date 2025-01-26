import 'package:chat_flow/core/base/viewModel/base_view_model.dart';
import 'package:chat_flow/core/init/locator/locator_service.dart';
import 'package:chat_flow/core/init/navigation/navigation_service.dart';
import 'package:chat_flow/core/models/user_model.dart';
import 'package:chat_flow/core/service/chat/chat_service.dart';
import 'package:chat_flow/feature/chat/view/chat_view.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

/// Users ekranı için ViewModel sınıfı
class UsersViewModel extends BaseViewModel {
  /// Constructor
  UsersViewModel() {
    _loadUsers();
  }

  /// Chat servisi
  final _chatService = locator<ChatService>();

  /// Navigasyon servisi
  final _navigationService = locator<NavigationService>();

  /// Arama controller'ı
  final searchController = TextEditingController();

  /// Kullanıcılar listesi
  List<UserModel> _users = [];
  List<UserModel> get users => _users;

  /// Yükleniyor durumu
  bool _isLoading = true;
  @override
  bool get isLoading => _isLoading;

  /// Kullanıcıları yükle
  Future<void> _loadUsers() async {
    _isLoading = true;
    notifyListeners();

    _chatService.getAvailableUsers().listen((users) {
      _users = users;
      _isLoading = false;
      notifyListeners();
    });
  }

  /// Kullanıcıya tıklandığında
  Future<void> onUserTap(BuildContext context, UserModel user) async {
    try {
      final chat = await _chatService.createChat([FirebaseAuth.instance.currentUser!.uid, user.id]);
      if (!context.mounted) return;

      await _navigationService.navigateToPage(
        context: context,
        page: ChatView(chatId: chat.id),
      );
    } catch (e) {
      showError(context, 'Sohbet oluşturulamadı');
    }
  }

  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
  }
}
