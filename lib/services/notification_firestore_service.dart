import 'dart:io' show Platform;
import 'package:flutter/foundation.dart' show kIsWeb;

import 'package:flutter_local_notifications/flutter_local_notifications.dart';

import 'dart:html' as html;

class NotificheService {
  final FlutterLocalNotificationsPlugin _plugin = FlutterLocalNotificationsPlugin();

  NotificheService() {
    if (!kIsWeb) {
      _initializeMobile();
    } else {
      _initializeWeb();
    }
  }

  // -------------------------
  //     ANDROID + IOS
  // -------------------------
  void _initializeMobile() {
    const android = AndroidInitializationSettings('@mipmap/ic_launcher');
    const ios = DarwinInitializationSettings(
      requestAlertPermission: true,
      requestBadgePermission: true,
      requestSoundPermission: true,
    );

    const settings = InitializationSettings(android: android, iOS: ios);

    _plugin.initialize(settings);
  }

  // -------------------------
  //           WEB
  // -------------------------
  void _initializeWeb() {
    // I permessi vanno richiesti solo una volta (browser)
    html.Notification.requestPermission();
  }

  // -------------------------
  //     NOTIFICA UNIFICATA
  // -------------------------
  Future<void> showNotification({
    required String title,
    required String body,
  }) async {
    if (kIsWeb) {
      _showWebNotification(title, body);
      return;
    }

    // iOS richiede i permessi
    if (Platform.isIOS) {
      await _plugin
          .resolvePlatformSpecificImplementation<IOSFlutterLocalNotificationsPlugin>()
          ?.requestPermissions(alert: true, badge: true, sound: true);
    }

    const androidDetails = AndroidNotificationDetails(
      'segnalazioni_channel',
      'Segnalazioni',
      channelDescription: 'Notifiche nuove segnalazioni',
      importance: Importance.max,
      priority: Priority.high,
    );

    const iosDetails = DarwinNotificationDetails();

    final details = NotificationDetails(android: androidDetails, iOS: iosDetails);

    await _plugin.show(
      0,
      title,
      body,
      details,
    );
  }

  // -------------------------
  //      WEB NOTIFICATION
  // -------------------------
  void _showWebNotification(String title, String body) {
    // Su web la notifica viene mostrata dal browser
    html.Notification(title, body: body);
  }
}
