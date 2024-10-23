import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
    FlutterLocalNotificationsPlugin();

class LocalNotificationService {
  static Future<void> showNotification(RemoteMessage payload) async {
    // Parsing data notifikasi
    final Map<String, dynamic> data = payload.data;
    final RemoteNotification notification = payload.notification!;

    // Parsing ID Notifikasi
    final int idNotification = notification.hashCode;

    // Daftar jenis notifikasi dari aplikasi.
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
    const NotificationDetails platformChannelSpecifics =
        NotificationDetails(android: androidPlatformChannelSpecifics);

    // Menampilkan Notifikasi
    await flutterLocalNotificationsPlugin.show(
      idNotification,
      notification.title,
      notification.body,
      platformChannelSpecifics,
      payload: data['type'],
    );
  }

  Future<void> notificationHandler(BuildContext context) async {
    const AndroidInitializationSettings initializationSettingsAndroid =
        AndroidInitializationSettings('app_icon');
    const InitializationSettings initializationSettings =
        InitializationSettings(android: initializationSettingsAndroid);

    // Handling notifikasi yang di tap oleh pengguna
    flutterLocalNotificationsPlugin.initialize(initializationSettings,
        onDidReceiveNotificationResponse:
            (NotificationResponse? payload) async {
      if (payload != null) {
        //
      }
    });
  }

  Future<void> channelNotification() async {
    final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
        FlutterLocalNotificationsPlugin();

    const AndroidNotificationChannel channel = AndroidNotificationChannel(
      'Registrasi_2', // id
      'Registrasi kunjungan', // title
      description:
          'This channel is used for important notifications.', // description
      importance: Importance.max,
      playSound: true,
      sound: RawResourceAndroidNotificationSound('pop'),
    );

    await flutterLocalNotificationsPlugin
        .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>()
        ?.createNotificationChannel(channel);
  }
}
