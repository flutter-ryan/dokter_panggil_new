import 'dart:convert';

import 'package:dokter_panggil/src/models/pasien_kunjungan_detail_model.dart';

TindakanLabProsesModel tindakanLabProsesModelFromJson(dynamic str) =>
    TindakanLabProsesModel.fromJson(str);

class TindakanLabProsesModel {
  PengantarLabMr? data;
  String? message;

  TindakanLabProsesModel({
    this.data,
    this.message,
  });

  factory TindakanLabProsesModel.fromJson(Map<String, dynamic> json) =>
      TindakanLabProsesModel(
        data:
            json["data"] == null ? null : PengantarLabMr.fromJson(json["data"]),
        message: json["message"],
      );
}

String tindakanLabProsesRequestModelToJson(
        TindakanLabProsesRequestModel data) =>
    json.encode(data.toJson());

class TindakanLabProsesRequestModel {
  int status;
  int isBersedia;

  TindakanLabProsesRequestModel({
    required this.status,
    required this.isBersedia,
  });

  Map<String, dynamic> toJson() => {
        "status": status,
        "isBersedia": isBersedia,
      };
}
