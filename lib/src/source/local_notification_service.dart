import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
    FlutterLocalNotificationsPlugin();

@pragma('vm:entry-point')
void notificationTapBackground(NotificationResponse notificationResponse) {
  // ignore: avoid_print
  print('notification(${notificationResponse.id}) action tapped: '
      '${notificationResponse.actionId} with'
      ' payload: ${notificationResponse.payload}');
  if (notificationResponse.input?.isNotEmpty ?? false) {
    // ignore: avoid_print
    print(
        'notification action tapped with input: ${notificationResponse.input}');
  }
}

class LocalNotificationService {
  static Future<void> notificationHandler(BuildContext context) async {
    const AndroidInitializationSettings initializationSettingsAndroid =
        AndroidInitializationSettings('icon_app');
    const DarwinInitializationSettings initializationSettingsIOS =
        DarwinInitializationSettings(
      requestAlertPermission: false,
      requestBadgePermission: false,
      requestSoundPermission: false,
    );
    const InitializationSettings initializationSettings =
        InitializationSettings(
            android: initializationSettingsAndroid,
            iOS: initializationSettingsIOS);

    // Handling notifikasi yang di tap oleh pengguna
    flutterLocalNotificationsPlugin.initialize(initializationSettings,
        onDidReceiveNotificationResponse:
            (NotificationResponse? payload) async {
      if (payload != null) {
        //
      }
    }, onDidReceiveBackgroundNotificationResponse: notificationTapBackground);
  }

  static Future<void> showNotification(RemoteMessage payload) async {
    // Parsing data notifikasi
    final RemoteNotification notification = payload.notification!;

    // Parsing ID Notifikasi
    final int idNotification = notification.hashCode;

    // Daftar jenis notifikasi dari aplikasi.
    const DarwinNotificationDetails iosNotificationDetails =
        DarwinNotificationDetails();
    const AndroidNotificationDetails androidPlatformChannelSpecifics =
        AndroidNotificationDetails(
      'Registrasi_3',
      'Notification',
      channelDescription: 'All Notification is Here',
      importance: Importance.max,
      priority: Priority.high,
      icon: "mipmap/ic_launcher",
      ticker: 'ticker',
      playSound: true,
      sound: RawResourceAndroidNotificationSound('pop'),
    );
    const NotificationDetails platformChannelSpecifics = NotificationDetails(
        android: androidPlatformChannelSpecifics, iOS: iosNotificationDetails);
    // Menampilkan Notifikasi
    await flutterLocalNotificationsPlugin.show(
      idNotification,
      notification.title,
      notification.body,
      platformChannelSpecifics,
      payload: '',
    );
  }
}
