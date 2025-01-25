import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

@immutable
final class NotificationConstants {
  const NotificationConstants._();

  // Firebase Cloud Messaging
  static const String baseUrl = 'https://fcm.googleapis.com/v1/projects';
  static const String projectId = 'chatflow-f9c70';
  static const String clientEmail = 'fcm-service-account@chatflow-f9c70.iam.gserviceaccount.com';

  // Android Channel
  static const androidChannel = AndroidNotificationChannel(
    'high_importance_channel',
    'High Importance Notifications',
    description: 'This channel is used for important notifications.',
    importance: Importance.high,
  );

  // Android Notification Settings
  static const androidNotificationSettings = AndroidInitializationSettings('@drawable/ic_launcher');
  static const darwinNotificationSettings = DarwinInitializationSettings();

  // Service Account Private Key
  static const String privateKey = '''
-----BEGIN PRIVATE KEY-----
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
}
