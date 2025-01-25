import 'package:chat_flow/core/models/notification_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class NotificationService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // In-app bildirimleri dinle
  Stream<List<NotificationModel>> getInAppNotifications() {
    final userId = FirebaseAuth.instance.currentUser!.uid;
    return _firestore
        .collection('in_app_notifications')
        .where('userId', isEqualTo: userId)
        .where('isRead', isEqualTo: false)
        .where('platform', isEqualTo: 'ios')
        .orderBy('timestamp', descending: true)
        .snapshots()
        .map((snapshot) => snapshot.docs.map((doc) => NotificationModel.fromFirestore(doc)).toList());
  }

  // Bildirimi okundu olarak işaretle
  Future<void> markNotificationAsRead(String notificationId) async {
    await _firestore.collection('in_app_notifications').doc(notificationId).update({
      'isRead': true,
    });
  }

  // Uygulama içi bildirim göster
  void showInAppNotification(BuildContext context, NotificationModel notification) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              notification.title,
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
            Text(notification.body),
          ],
        ),
        duration: const Duration(seconds: 3),
        behavior: SnackBarBehavior.floating,
        action: SnackBarAction(
          label: 'Görüntüle',
          onPressed: () {
            // Bildirime tıklandığında sohbet ekranına yönlendir
            Navigator.of(context).pushNamed('/chat', arguments: notification.chatId);
            markNotificationAsRead(notification.id);
          },
        ),
      ),
    );
  }
} 