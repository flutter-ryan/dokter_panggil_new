import 'dart:convert';

import 'package:admin_dokter_panggil/src/models/notifikasi_admin_model.dart';

NotifikasiAdminSaveModel notifikasiAdminSaveModelFromJson(dynamic str) =>
    NotifikasiAdminSaveModel.fromJson(str);

class NotifikasiAdminSaveModel {
  NotifikasiAdmin? data;
  String? message;

  NotifikasiAdminSaveModel({
    this.data,
    this.message,
  });

  factory NotifikasiAdminSaveModel.fromJson(Map<String, dynamic> json) =>
      NotifikasiAdminSaveModel(
        data: json["data"] == null
            ? null
            : NotifikasiAdmin.fromJson(json["data"]),
        message: json["message"],
      );
}

String notifikasiAdminSaveRequestModelToJson(
        NotifikasiAdminSaveRequestModel data) =>
    json.encode(data.toJson());

class NotifikasiAdminSaveRequestModel {
  int isRead;

  NotifikasiAdminSaveRequestModel({
    required this.isRead,
  });

  Map<String, dynamic> toJson() => {
        "isRead": isRead,
      };
}
