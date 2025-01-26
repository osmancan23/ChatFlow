import 'dart:developer';

import 'package:chat_flow/core/models/notification_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

/// Bildirim servisi için abstract sınıf
/// Bu sınıf, bildirim işlemleri için gerekli olan metodları tanımlar
@immutable
abstract class INotificationService {
  /// Uygulama içi bildirimleri stream olarak döndürür
  Stream<List<NotificationModel>> getInAppNotifications();

  /// Bildirimi okundu olarak işaretler
  Future<void> markNotificationAsRead(String notificationId);

  /// Uygulama içi bildirim gösterir
  void showInAppNotification(BuildContext context, NotificationModel notification);
}

/// Bildirim servisi implementasyonu
/// Firebase Firestore kullanarak bildirim işlemlerini gerçekleştirir
class NotificationService implements INotificationService {
  NotificationService({FirebaseFirestore? firestore}) : _firestore = firestore ?? FirebaseFirestore.instance;
  final FirebaseFirestore _firestore;

  /// Kullanıcının okunmamış bildirimlerini stream olarak döndürür
  /// Bildirimler tarih sırasına göre sıralanır ve platform kontrolü yapılır
  @override
  Stream<List<NotificationModel>> getInAppNotifications() {
    try {
      final userId = FirebaseAuth.instance.currentUser!.uid;
      return _firestore
          .collection('in_app_notifications')
          .where('userId', isEqualTo: userId)
          .where('isRead', isEqualTo: false)
          .where('platform', isEqualTo: 'ios')
          .orderBy('timestamp', descending: true)
          .snapshots()
          .map((snapshot) => snapshot.docs.map(NotificationModel.fromFirestore).toList());
    } catch (e) {
      log('Bildirimler getirilirken hata: $e');
      return Stream.value([]);
    }
  }

  /// Bildirimi okundu olarak işaretler
  @override
  Future<void> markNotificationAsRead(String notificationId) async {
    try {
      await _firestore.collection('in_app_notifications').doc(notificationId).update({
        'isRead': true,
      });
      log('Bildirim okundu olarak işaretlendi');
    } catch (e) {
      log('Bildirim okundu işaretlenirken hata: $e');
      throw Exception('Bildirim okundu işaretlenemedi');
    }
  }

  /// Uygulama içi bildirim gösterir ve tıklanınca ilgili sohbete yönlendirir
  @override
  void showInAppNotification(BuildContext context, NotificationModel notification) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: _buildNotificationContent(notification),
        duration: const Duration(seconds: 3),
        behavior: SnackBarBehavior.floating,
        action: SnackBarAction(
          label: 'Görüntüle',
          onPressed: () => _handleNotificationTap(context, notification),
        ),
      ),
    );
  }

  /// Bildirim içeriğini oluşturur
  Widget _buildNotificationContent(NotificationModel notification) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          notification.title,
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        Text(notification.body),
      ],
    );
  }

  /// Bildirime tıklandığında çalışacak fonksiyon
  void _handleNotificationTap(BuildContext context, NotificationModel notification) {
    Navigator.of(context).pushNamed('/chat', arguments: notification.chatId);
    markNotificationAsRead(notification.id);
  }
} 