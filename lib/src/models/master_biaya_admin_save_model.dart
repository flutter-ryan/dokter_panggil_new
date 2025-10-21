import 'dart:convert';

import 'package:admin_dokter_panggil/src/models/master_biaya_admin_model.dart';

String masterBiayaAdminSaveModelToJson(MasterBiayaAdminSaveModel data) =>
    json.encode(data.toJson());

class MasterBiayaAdminSaveModel {
  MasterBiayaAdminSaveModel({
    required this.deskripsi,
    required this.nilai,
    required this.jenis,
  });

  String deskripsi;
  int nilai;
  String jenis;

  Map<String, dynamic> toJson() => {
        "deskripsi": deskripsi,
        "nilai": nilai,
        "jenis": jenis,
      };
}

ResponseMasterBiayaAdminSaveModel responseMasterBiayaAdminSaveModelFromJson(
        dynamic str) =>
    ResponseMasterBiayaAdminSaveModel.fromJson(str);

class ResponseMasterBiayaAdminSaveModel {
  ResponseMasterBiayaAdminSaveModel({
    this.data,
    this.message,
  });

  MasterBiayaAdmin? data;
  String? message;

  factory ResponseMasterBiayaAdminSaveModel.fromJson(
          Map<String, dynamic> json) =>
      ResponseMasterBiayaAdminSaveModel(
        data: MasterBiayaAdmin.fromJson(json["data"]),
        message: json["message"],
      );
}
