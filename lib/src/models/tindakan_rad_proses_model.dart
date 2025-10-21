import 'dart:convert';

import 'package:admin_dokter_panggil/src/models/pasien_kunjungan_detail_model.dart';

TindakanRadProsesModel tindakanRadProsesModelFromJson(dynamic str) =>
    TindakanRadProsesModel.fromJson(str);

class TindakanRadProsesModel {
  PengantarRadMr? data;
  String? message;

  TindakanRadProsesModel({
    this.data,
    this.message,
  });

  factory TindakanRadProsesModel.fromJson(Map<String, dynamic> json) =>
      TindakanRadProsesModel(
        data:
            json["data"] == null ? null : PengantarRadMr.fromJson(json["data"]),
        message: json["message"],
      );
}

String tindakanRadProsesRequestModelToJson(
        TindakanRadProsesRequestModel data) =>
    json.encode(data.toJson());

class TindakanRadProsesRequestModel {
  int status;
  int isBersedia;

  TindakanRadProsesRequestModel({
    required this.status,
    required this.isBersedia,
  });

  Map<String, dynamic> toJson() => {
        "status": status,
        "isBersedia": isBersedia,
      };
}
