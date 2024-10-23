import 'dart:convert';

String notificationFmcModelToJson(NotificationFmcModel data) =>
    json.encode(data.toJson());

class NotificationFmcModel {
  NotificationFmcModel({
    this.notification,
    this.data,
    this.android,
    this.to,
  });

  Notification? notification;
  Data? data;
  Android? android;
  String? to;

  Map<String, dynamic> toJson() => {
        "notification": notification!.toJson(),
        "data": data!.toJson(),
        "android": android!.toJson(),
        "to": to,
      };
}

class Android {
  Android({
    this.priority,
  });

  String? priority;

  Map<String, dynamic> toJson() => {
        "priority": priority,
      };
}

class Data {
  Data({
    this.payload,
  });

  String? payload;

  Map<String, dynamic> toJson() => {
        "payload": payload,
      };
}

class Notification {
  Notification({
    this.body,
    this.title,
    this.sound,
  });

  String? body;
  String? title;
  String? sound;

  Map<String, dynamic> toJson() => {
        "body": body,
        "title": title,
        "sound": sound,
      };
}
