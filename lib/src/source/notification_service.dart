import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class NotificationService {
  static final NotificationService _instance = NotificationService._internal();
  factory NotificationService() => _instance;
  NotificationService._internal();

  static final FlutterLocalNotificationsPlugin _plugin =
      FlutterLocalNotificationsPlugin();

  /// Android Channel
  static const AndroidNotificationChannel channel = AndroidNotificationChannel(
    'high_importance_channel_sound',
    'High Importance Notifications Sounds',
    description: 'Used for important notifications Sound Custom',
    importance: Importance.high,
    sound: RawResourceAndroidNotificationSound('pop'),
    playSound: true,
  );

  /// INIT SERVICE
  static Future<void> init() async {
    const AndroidInitializationSettings androidInit =
        AndroidInitializationSettings('@mipmap/ic_launcher');

    const DarwinInitializationSettings iosInit = DarwinInitializationSettings();

    const InitializationSettings initSettings = InitializationSettings(
      android: androidInit,
      iOS: iosInit,
    );

    await _plugin.initialize(
      settings: initSettings,
      onDidReceiveNotificationResponse: (response) {
        // Handle notification tap
      },
    );

    await FirebaseMessaging.instance
        .setForegroundNotificationPresentationOptions(
      alert: true,
      badge: true,
      sound: true,
    );

    final androidPlugin = _plugin.resolvePlatformSpecificImplementation<
        AndroidFlutterLocalNotificationsPlugin>();

    await androidPlugin?.createNotificationChannel(channel);
  }

  static Future<void> show(RemoteMessage message) async {
    AndroidNotificationDetails androidDetails = AndroidNotificationDetails(
      channel.id,
      channel.name,
      channelDescription: channel.description,
      importance: Importance.max,
      priority: Priority.high,
      icon: 'finger',
      largeIcon: DrawableResourceAndroidBitmap('ic_launcher'),
      sound: RawResourceAndroidNotificationSound('pop'),
      playSound: true,
      enableVibration: true,
    );

    DarwinNotificationDetails iosDetails = DarwinNotificationDetails(
      sound: 'pop.aiff',
    );

    await _plugin.show(
      id: DateTime.now().millisecondsSinceEpoch ~/ 1000,
      title: message.data["title"],
      body: message.data["body"],
      notificationDetails: NotificationDetails(
        android: androidDetails,
        iOS: iosDetails,
      ),
    );
  }

  /// SHOW FROM FCM MESSAGE
  static void showFromFCM(RemoteMessage message) {
    final notification = message.notification;
    if (notification == null) return;
    show(message);
  }
}
