import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:permission_handler/permission_handler.dart';

class NotificationService {

  static final FlutterLocalNotificationsPlugin _plugin =
      FlutterLocalNotificationsPlugin();

  static const _channelId = 'pomodoro_channel';
  static const _channelName = 'Pomodoro Alerts';

  static Future<void> init() async {

    final status = await Permission.notification.status;
    if (!status.isGranted) {
      await Permission.notification.request();
    }

    const androidSettings =
        AndroidInitializationSettings('@mipmap/ic_launcher');

    const iosSettings = DarwinInitializationSettings(
      requestAlertPermission: true,
      requestBadgePermission: true,
      requestSoundPermission: true,
    );

    const settings = InitializationSettings(
      android: androidSettings,
      iOS: iosSettings,
    );

    await _plugin.initialize(settings);

    const androidChannel = AndroidNotificationChannel(
      _channelId,
      _channelName,
      description: 'Notificaciones del temporizador Pomodoro',
      importance: Importance.high,
      playSound: true,
      enableVibration: true,
    );

    
    await _plugin
        .resolvePlatformSpecificImplementation<AndroidFlutterLocalNotificationsPlugin>()
        ?.createNotificationChannel(androidChannel);
  }

  static Future<void> showNotification({
    required bool isBreak,
    required int cycle,
    required int totalCycles,
  }) async {

    final granted = await Permission.notification.isGranted;
    if (!granted) {
      debugPrint('Sin permiso de notificaciones');
      return;
    }

    final String title = isBreak
        ? '🌿 ¡Tiempo de descansar!'
        : '🍅 ¡A trabajar!';

    final String body = isBreak
        ? 'Completaste el ciclo $cycle de $totalCycles. Tómate un respiro.'
        : 'El descanso terminó. Ciclo ${cycle + 1} de $totalCycles — ¡Enfócate!';

    final androidDetails = AndroidNotificationDetails(
      _channelId,
      _channelName,
      channelDescription: 'Notificaciones del temporizador Pomodoro',
      importance: Importance.max,
      priority: Priority.max,
      playSound: true,
      enableVibration: true,
      fullScreenIntent: true,
      visibility: NotificationVisibility.public,
      ticker: title,
    );

    const iosDetails = DarwinNotificationDetails(
      presentAlert: true,
      presentBadge: true,
      presentSound: true,
    );

    final details = NotificationDetails(
      android: androidDetails,
      iOS: iosDetails,
    );

    await _plugin.show(0, title, body, details);
  }
}