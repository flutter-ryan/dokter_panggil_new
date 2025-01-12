import 'dart:convert';

import 'package:dokter_panggil/src/models/pasien_kunjungan_detail_model.dart';

ResepRacikanProsesModel resepRacikanProsesModelFromJson(dynamic str) =>
    ResepRacikanProsesModel.fromJson(str);

class ResepRacikanProsesModel {
  ResepRacikan? data;
  String? message;

  ResepRacikanProsesModel({
    this.data,
    this.message,
  });

  factory ResepRacikanProsesModel.fromJson(Map<String, dynamic> json) =>
      ResepRacikanProsesModel(
        data: json["data"] == null ? null : ResepRacikan.fromJson(json["data"]),
        message: json["message"],
      );
}

String resepRacikanProsesRequestModelToJson(
        ResepRacikanProsesRequestModel data) =>
    json.encode(data.toJson());

class ResepRacikanProsesRequestModel {
  int status;
  int isBersedia;

  ResepRacikanProsesRequestModel({
    required this.status,
    required this.isBersedia,
  });

  factory ResepRacikanProsesRequestModel.fromJson(Map<String, dynamic> json) =>
      ResepRacikanProsesRequestModel(
        status: json["status"],
        isBersedia: json["isBersedia"],
      );

  Map<String, dynamic> toJson() => {
        "status": status,
        "isBersedia": isBersedia,
      };
}
