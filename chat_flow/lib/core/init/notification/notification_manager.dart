import 'dart:convert';
import 'dart:developer';
import 'dart:io';
import 'package:chat_flow/core/init/locator/locator_service.dart';
import 'package:chat_flow/core/init/notification/notification_constants.dart';
import 'package:chat_flow/core/service/auth/auth_service.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:http/http.dart' as http;

import 'package:jose/jose.dart';

@immutable
final class NotificationManager {
  // Firebase instances
  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();

  // Initialize FCM and request permissions
  Future<void> initFCM() async {
    log('FCM başlatılıyor...');
    await _registerFCMToken();
    await _requestNotificationPermissions();
    await _initPushNotifications();
    await _initLocalNotifications();
    log('FCM başlatma tamamlandı');
  }

  // Register FCM token for the current user
  Future<void> _registerFCMToken() async {
    log('FCM token kaydediliyor...');
    final token = await _firebaseMessaging.getToken();
    log('FCM Token alındı: $token');
    final userId = FirebaseAuth.instance.currentUser?.uid;

    if (token != null && userId != null) {
      final platform = Platform.isIOS ? 'ios' : 'android';
      log('Platform: $platform');
      await _firestore.collection('users').doc(userId).update({
        'fcmToken': token,
        'platform': platform,
      });
      log('FCM token Firestore\'a kaydedildi');
    }
  }

  // Request notification permissions
  Future<void> _requestNotificationPermissions() async {
    log('Bildirim izinleri isteniyor...');
    final settings = await _firebaseMessaging.requestPermission();
    log('Bildirim izin durumu: ${settings.authorizationStatus}');
    log('Uyarı izni: ${settings.alert}');
    log('Rozet izni: ${settings.badge}');
    log('Ses izni: ${settings.sound}');

    await _firebaseMessaging.setForegroundNotificationPresentationOptions(
      alert: true,
      badge: true,
      sound: true,
    );
    log('Ön plan bildirim seçenekleri ayarlandı');
  }

  // Initialize push notifications
  Future<void> _initPushNotifications() async {
    log('Push bildirimleri başlatılıyor...');
    await _firebaseMessaging.getInitialMessage().then(_handleMessage);
    FirebaseMessaging.onMessageOpenedApp.listen(_handleMessage);
    FirebaseMessaging.onMessage.listen(_handleForegroundMessage);
    log('Push bildirim dinleyicileri ayarlandı');
  }

  // Initialize local notifications
  Future<void> _initLocalNotifications() async {
    log('Yerel bildirimler başlatılıyor...');
    const initializationSettings = InitializationSettings(
      android: NotificationConstants.androidNotificationSettings,
      iOS: NotificationConstants.darwinNotificationSettings,
    );

    await flutterLocalNotificationsPlugin.initialize(
      initializationSettings,
      onDidReceiveNotificationResponse: _handleLocalNotificationResponse,
    );

    if (Platform.isAndroid) {
      log('Android bildirim kanalı oluşturuluyor...');
      final androidImplementation = flutterLocalNotificationsPlugin
          .resolvePlatformSpecificImplementation<AndroidFlutterLocalNotificationsPlugin>();
          
      if (androidImplementation != null) {
        await androidImplementation.createNotificationChannel(NotificationConstants.androidChannel);
        log('Android bildirim kanalı oluşturuldu: ${NotificationConstants.androidChannel.id}');
      } else {
        log('Android implementasyonu bulunamadı');
      }
    }
    log('Yerel bildirimler başlatıldı');
  }

  // Handle notification response
  void _handleLocalNotificationResponse(NotificationResponse response) {
    log('Yerel bildirime tıklandı: ${response.payload}');
    final payload = response.payload;
    if (payload != null) {
      final message = RemoteMessage.fromMap(jsonDecode(payload) as Map<String, dynamic>);
      _handleMessage(message);
    }
  }

  // Handle incoming messages
  void _handleMessage(RemoteMessage? message) {
    log('Bildirim mesajı alındı: ${message?.data}');
    if (message?.data['type'] == 'message') {
      final chatId = message?.data['chatId'];
      if (chatId != null) {
        log('Sohbet ID: $chatId ile sohbet açılacak');
        // Navigate to chat screen
      }
    }
  }

  // Handle foreground messages
  void _handleForegroundMessage(RemoteMessage message) {
    log('Ön planda bildirim alındı: ${message.data}');
    if (Platform.isIOS) {
      _showIOSNotification(message);
    } else if (Platform.isAndroid) {
      _showAndroidNotification(message);
    }
  }

  // Show iOS notification
  void _showIOSNotification(RemoteMessage message) {
    log('iOS bildirimi gösteriliyor...');
    final data = message.data;
    if (data.isNotEmpty && data['title'] != null && data['body'] != null) {
      flutterLocalNotificationsPlugin.show(
        DateTime.now().millisecondsSinceEpoch.hashCode,
        data['title'] as String,
        data['body'] as String,
        const NotificationDetails(
          iOS: DarwinNotificationDetails(
            presentAlert: true,
            presentBadge: true,
            presentSound: true,
          ),
        ),
        payload: jsonEncode(message.toMap()),
      );
      log('iOS bildirimi gösterildi');
    }
  }

  // Show Android notification
  void _showAndroidNotification(RemoteMessage message) {
    try {
      log('Android bildirimi gösteriliyor...');
      log('Bildirim içeriği: ${message.toMap()}');
      
      final notification = message.notification;
      final android = notification?.android;
      final data = message.data;

      // Bildirim içeriğini kontrol et
      if (data.containsKey('title') && data.containsKey('body')) {
        log('Data içinden bildirim gösteriliyor');
        flutterLocalNotificationsPlugin.show(
          DateTime.now().millisecondsSinceEpoch.hashCode,
          data['title'] as String,
          data['body'] as String,
          NotificationDetails(
            android: AndroidNotificationDetails(
              NotificationConstants.androidChannel.id,
              NotificationConstants.androidChannel.name,
              channelDescription: NotificationConstants.androidChannel.description,
              importance: Importance.max,
              priority: Priority.high,
              icon: '@drawable/ic_launcher',
              enableVibration: true,
              enableLights: true,
              playSound: true,
            ),
          ),
          payload: jsonEncode(message.toMap()),
        );
        log('Data içinden bildirim gösterildi');
      } 
      // RemoteNotification içeriğini kontrol et
      else if (notification != null) {
        log('RemoteNotification içinden bildirim gösteriliyor');
        flutterLocalNotificationsPlugin.show(
          notification.hashCode,
          notification.title,
          notification.body,
          NotificationDetails(
            android: AndroidNotificationDetails(
              NotificationConstants.androidChannel.id,
              NotificationConstants.androidChannel.name,
              channelDescription: NotificationConstants.androidChannel.description,
              importance: Importance.max,
              priority: Priority.high,
              icon: '@drawable/ic_launcher',
              enableVibration: true,
              enableLights: true,
              playSound: true,
            ),
          ),
          payload: jsonEncode(message.toMap()),
        );
        log('RemoteNotification içinden bildirim gösterildi');
      } else {
        log('Bildirim içeriği bulunamadı');
      }
    } catch (e) {
      log('Android bildirimi gösterme hatası: $e');
    }
  }

  // Get access token for FCM
  Future<String> _getAccessToken() async {
    final claims = JsonWebTokenClaims.fromJson({
      'iss': NotificationConstants.clientEmail,
      'scope': 'https://www.googleapis.com/auth/firebase.messaging',
      'aud': 'https://oauth2.googleapis.com/token',
      'exp': DateTime.now().add(const Duration(hours: 1)).millisecondsSinceEpoch ~/ 1000,
      'iat': DateTime.now().millisecondsSinceEpoch ~/ 1000,
    });

    final builder = JsonWebSignatureBuilder()
      ..jsonContent = claims.toJson()
      ..addRecipient(JsonWebKey.fromPem(NotificationConstants.privateKey));

    final jwt = builder.build();
    final signedJwt = jwt.toCompactSerialization();

    final response = await http.post(
      Uri.parse('https://oauth2.googleapis.com/token'),
      body: {
        'grant_type': 'urn:ietf:params:oauth:grant-type:jwt-bearer',
        'assertion': signedJwt,
      },
    );

    if (response.statusCode == 200) {
      return jsonDecode(response.body)['access_token'] as String;
    }
    throw Exception('Token alınamadı: ${response.statusCode}');
  }

  // Send notification to a specific user
  Future<void> _sendNotification(String targetToken, String senderName, String messageContent) async {
    try {
      log('Bildirim gönderiliyor...');
      log('Hedef token: $targetToken');
      log('Gönderen: $senderName');
      log('Mesaj: $messageContent');

      final receiverDoc = await _firestore.collection('users').where('fcmToken', isEqualTo: targetToken).get();
      if (receiverDoc.docs.isEmpty) {
        log('Alıcı bulunamadı');
        return;
      }

      final receiverData = receiverDoc.docs.first.data();
      final receiverPlatform = receiverData['platform'] as String?;
      log('Alıcı platformu: $receiverPlatform');

      const url = '${NotificationConstants.baseUrl}/${NotificationConstants.projectId}/messages:send';
      final accessToken = await _getAccessToken();
      log('Access token alındı');

      final notificationData = receiverPlatform == 'ios'
          ? _createIOSNotificationData(targetToken, senderName, messageContent)
          : _createAndroidNotificationData(targetToken, senderName, messageContent);

      log('Bildirim isteği gönderiliyor: ${jsonEncode(notificationData)}');
      final response = await http.post(
        Uri.parse(url),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $accessToken',
        },
        body: jsonEncode(notificationData),
      );

      log('Bildirim yanıtı: ${response.statusCode}');
      log('Yanıt body: ${response.body}');

      if (response.statusCode != 200) {
        throw Exception('Bildirim gönderilemedi: ${response.statusCode}');
      }
      log('Bildirim başarıyla gönderildi');
    } catch (e) {
      log('Bildirim gönderimi hatası: $e');
    }
  }

  // Create iOS notification data
  Map<String, dynamic> _createIOSNotificationData(String token, String senderName, String messageContent) {
    return {
      'message': {
        'token': token,
        'data': {
          'type': 'message',
          'title': '$senderName size bir mesaj gönderdi!',
          'body': messageContent,
          'click_action': 'FLUTTER_NOTIFICATION_CLICK',
        },
      },
    };
  }

  // Create Android notification data
  Map<String, dynamic> _createAndroidNotificationData(String token, String senderName, String messageContent) {
    return {
      'message': {
        'token': token,
        'data': {
          'type': 'message',
          'title': '$senderName size bir mesaj gönderdi!',
          'body': messageContent,
          'click_action': 'FLUTTER_NOTIFICATION_CLICK',
        },
        'android': {
          'priority': 'HIGH',
          'notification': {
            'channel_id': NotificationConstants.androidChannel.id,
            'notification_priority': 'PRIORITY_HIGH',
            'default_sound': true,
            'default_vibrate_timings': true,
            'icon': '@drawable/ic_launcher',
            'color': '#FF0000',
          },
        },
      },
    };
  }

  // Public method to send message
  Future<void> sendMessage(String receiverId, String message, String name) async {
    final token = await locator<AuthService>().getUserFcmToken(receiverId);
    if (token != null) {
      await _sendNotification(token, name, message);
    }
  }
}
