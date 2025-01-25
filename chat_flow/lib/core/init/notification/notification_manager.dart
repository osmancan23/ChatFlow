import 'dart:convert';
import 'dart:developer';
import 'dart:io';
import 'package:chat_flow/core/init/locator/locator_service.dart';
import 'package:chat_flow/core/service/auth/auth_service.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:http/http.dart' as http;
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:jose/jose.dart';

@immutable
final class NotificationManager {
  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  final _androidChannel = const AndroidNotificationChannel(
    'high_importance_channel',
    'High Importance Notifications',
    description: 'This channel is used for important notifications.',
    importance: Importance.high,
  );

  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();

  // Service Account bilgileri
  static const String _projectId = 'chatflow-f9c70';
  static const String _clientEmail = 'fcm-service-account@chatflow-f9c70.iam.gserviceaccount.com';
  static const String _privateKey = '''-----BEGIN PRIVATE KEY-----
MIIEvgIBADANBgkqhkiG9w0BAQEFAASCBKgwggSkAgEAAoIBAQC24SKE1GLcIzfc
YeYosgWuc0DusPXjq5sywhBkfYF7OasFTTap/Jc4aUBIP9kIVGyiM2zzpWE5XTpa
axQiSK+ouVHNAfOazFzdFbzONZs38WVzveqrDH8fcF9KK5Fsdrs/VHV58CmZS149
uuXVV0QfzUSpFHRftrGPdsCsOdC8e2qKAlcLi3nu308dMT1Mr9eI04vEHjBzSNmc
MRf8vxC2m1KfiSJPavs7tB6xrXMAGcM8LGwUYLgAg0BstifRS+YRPoKoIwlCCFkM
3mgTJiIHolN0cwwJZwNS/bNoP5yt6pDjhRBK45wB2xEq/DnqdhrfSYUll3YzQpZb
n4ulXTjlAgMBAAECggEAIYh8nOCY1Aa9KnLlEhc6hXdqs5nNLJb92TvOZ66/vEmh
u1IiMN85F0XtXJIgiK96T++gDbkIb81RctzpjzPGyehZQH8YHQ1WBdADk8gukv53
fNaZHg4njSs8vcvpWXsX8I/bDqXj6tDwEd+gXxMmUbKA4YP3pslIG6dJwwrC5Jxo
ocE+i1RkBJ4io060bk71WYMudcCZRQt2s59kUpSXH/lVEbSdu5pGbsD8eYqwRKna
WlnVWjqTMql5qp72dFAXZYZ+tdgk7PFFfNQYlTbKVsnPLLu0I8WdTZBKaqy74pqa
AW4IkK7I8f3B0ehnJOKGnt1xy7wmoMEldBG07TIsQQKBgQD351jAs0gXYbstKV38
yD1H++N8eWYLXErnmgxbzfgYS1koi4AzF43y7HPFmkcXcV3C5/t7E799J+Nz9kz9
+BL/jYPBx2qy4aAW9xXt9pa+GSfukvtFGJa+MBQX5DARuR7vetLm7DJlLkZFi3sB
vacSHfycbW1HtNAwkxKs9EJC1QKBgQC82iN0zSeu9y9anAGc/nwnidvX+A/UBIGr
C7TlCvJ6StNH0RCCT9RMI2EWCgSZ/VZ4WLQXBvrM8CvRO36B89bu9XKzfgEdJ4uB
dbhXfMHYgupSVd7zdEJeP76N4fDE5MPc+M+aSFvsnG8HaCeINHE5w+tZDA7HLPeU
mmd7olyF0QKBgQCUEHpjBfGN/ZJVI/r96v8nClxR0RRQvrwCXnD5OCjxIbfLzp4w
ZeYjbHStVjsV1mEg83uxhBcAAp4Iedh8a/m05uoGCDxDQR1j+goACiL4wX+nL+Sh
3VDToVWu+1x2iXHfqSVkRTjIU/4mtWsvm/24hW6GY5k8ldMu3/jskistTQKBgQCW
5UGBWU9E+RLoNlD/rUNsoDV9+iJDiRpGnkL64+VdG553+q9TQA/kijxPzM9ib08B
N/clkxkgWSLZuszZbwkkxA/TJXIkZm2MkpApr3B/3BL4mM5c/l7tScerPIYR/KwX
SuMuZnS0uUXpyCoWJbj2q/nHm9/O+7oTDdBztAZzkQKBgF4VPzpMuOsB8etofUik
EzFqx5Pqb5LE3+/t/Gy2L4j0+lhD/5HiW29VJq1tRB4LgL9+U3YSVnJATdYAWZ14
GHwEeUSujFT5704g+EaYzOTFf5aeUWWKusMO2LTcGqNypxvokP+qOqZ7JJXz6Kfl
xnhSkDAq3ExGhvVfLpgY93rf
-----END PRIVATE KEY-----''';

  Future<String> _getAccessToken() async {
    final claims = JsonWebTokenClaims.fromJson({
      "iss": _clientEmail,
      "scope": "https://www.googleapis.com/auth/firebase.messaging",
      "aud": "https://oauth2.googleapis.com/token",
      "exp": DateTime.now().add(const Duration(hours: 1)).millisecondsSinceEpoch ~/ 1000,
      "iat": DateTime.now().millisecondsSinceEpoch ~/ 1000,
    });

    final builder = JsonWebSignatureBuilder()
      ..jsonContent = claims.toJson()
      ..addRecipient(JsonWebKey.fromPem(_privateKey));

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
      final token = jsonDecode(response.body)['access_token'] as String;
      return token;
    } else {
      throw Exception('Token alınamadı: ${response.statusCode} - ${response.body}');
    }
  }

  Future<void> _sendNotification(String targetToken, String senderName, String messageContent) async {
    try {
      log('Bildirim gönderiliyor...');
      log('Hedef Token: $targetToken');

      final receiverDoc = await _firestore.collection('users').where('fcmToken', isEqualTo: targetToken).get();

      if (receiverDoc.docs.isEmpty) {
        log('Alıcı kullanıcı bulunamadı');
        return;
      }

      final receiverData = receiverDoc.docs.first.data();
      final receiverPlatform = receiverData['platform'] as String?;
      log('Alıcı platform: $receiverPlatform');

      final url = 'https://fcm.googleapis.com/v1/projects/$_projectId/messages:send';
      final accessToken = await _getAccessToken();

      Map<String, dynamic> notificationData;

      if (receiverPlatform == 'ios') {
        log('iOS için data-only mesaj yapılandırılıyor...');
        notificationData = {
          'message': {
            'token': targetToken,
            'data': {
              'type': 'message',
              'title': '$senderName size bir mesaj gönderdi!',
              'body': messageContent,
              'click_action': 'FLUTTER_NOTIFICATION_CLICK',
            },
          },
        };
      } else {
        log('Android için bildirim ayarları yapılandırılıyor...');
        notificationData = {
          'message': {
            'token': targetToken,
            'notification': {
              'title': '$senderName size bir mesaj gönderdi!',
              'body': messageContent,
            },
            'data': {
              'type': 'message',
              'click_action': 'FLUTTER_NOTIFICATION_CLICK',
            },
            'android': {
              'priority': 'HIGH',
              'notification': {
                'channel_id': 'high_importance_channel',
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

      log('Gönderilecek bildirim verisi: ${jsonEncode(notificationData)}');

      final response = await http.post(
        Uri.parse(url),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $accessToken',
        },
        body: jsonEncode(notificationData),
      );

      log('Bildirim yanıtı - Status Code: ${response.statusCode}');
      log('Bildirim yanıtı - Body: ${response.body}');

      if (response.statusCode == 200) {
        log('Bildirim başarıyla gönderildi');
      } else {
        log('Bildirim gönderimi başarısız: ${response.statusCode} - ${response.body}');
      }
    } catch (e, stackTrace) {
      log('Bildirim gönderimi hatası: $e');
      log('Hata stack trace: $stackTrace');
    }
  }

  Future<void> initFCM() async {
    final token = await _firebaseMessaging.getToken();
    log('FCM Token alındı: $token');

    if (token != null) {
      final userId = FirebaseAuth.instance.currentUser?.uid;
      if (userId != null) {
        final platform = Platform.isIOS ? 'ios' : 'android';
        log('Platform: $platform için token kaydediliyor...');
        await _firestore.collection('users').doc(userId).update({
          'fcmToken': token,
          'platform': platform,
        });
        log('Token başarıyla kaydedildi');
      }
    }

    final settings = await _firebaseMessaging.requestPermission();
    log('Bildirim izinleri: ${settings.authorizationStatus}');

    await _initPushNotifications();
    await _initLocalNotifications();
  }

  Future<void> _initPushNotifications() async {
    await _firebaseMessaging.getInitialMessage().then((RemoteMessage? message) {
      if (message != null) {
        _handleMessage(message);
      }
    });

    // Click on notification
    FirebaseMessaging.onMessageOpenedApp.listen(_handleMessage);

    await _foregroundNotification();
  }

  void _handleMessage(RemoteMessage message) {
    if (message.data['type'] == 'message') {
      final chatId = message.data['chatId'];
      if (chatId != null) {
        // Navigate to chat screen
        print('clicked on notification');
      }
    }
  }

  Future<void> _foregroundNotification() async {
    FirebaseMessaging.onMessage.listen((message) {
      log('Foreground mesajı alındı: ${message.toMap()}');

      final notification = message.notification;
      final data = message.data;

      if (Platform.isIOS) {
        // iOS için data mesajlarını işle
        if (data.isNotEmpty && data['title'] != null && data['body'] != null) {
          log('iOS için bildirim gösteriliyor...');
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
        }
      } else if (Platform.isAndroid && notification != null) {
        // Android için normal notification göster
        final android = notification.android;
        if (android != null) {
          flutterLocalNotificationsPlugin.show(
            notification.hashCode,
            notification.title,
            notification.body,
            NotificationDetails(
              android: AndroidNotificationDetails(
                _androidChannel.id,
                _androidChannel.name,
                channelDescription: _androidChannel.description,
                importance: Importance.high,
                priority: Priority.high,
                icon: '@drawable/ic_launcher',
              ),
            ),
            payload: jsonEncode(message.toMap()),
          );
        }
      }
    });

    await _firebaseMessaging.setForegroundNotificationPresentationOptions(
      alert: true,
      badge: true,
      sound: true,
    );
  }

  Future<void> _initLocalNotifications() async {
    const initializationSettingsAndroid = AndroidInitializationSettings('@drawable/ic_launcher');
    const initializationSettingsIOS = DarwinInitializationSettings();
    const initializationSettings = InitializationSettings(
      android: initializationSettingsAndroid,
      iOS: initializationSettingsIOS,
    );

    await flutterLocalNotificationsPlugin.initialize(
      initializationSettings,
      onDidReceiveNotificationResponse: (NotificationResponse response) {
        final payload = response.payload;
        if (payload != null) {
          final message = RemoteMessage.fromMap(jsonDecode(payload) as Map<String, dynamic>);
          _handleMessage(message);
        }
      },
    );
  }

  Future<void> sendMessage(String receiverId, String message, String name) async {
    final token = await locator<AuthService>().getUserFcmToken(receiverId);

    if (token != null) {
      await _sendNotification(token, name, message);
    } else {
      print('Hedef kullanıcının FCM tokenı bulunamadı.');
    }
  }
}
