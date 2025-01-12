import 'dart:convert';

import 'package:dokter_panggil/src/models/pasien_kunjungan_detail_model.dart';

ResepOralProsesModel resepOralProsesModelFromJson(dynamic str) =>
    ResepOralProsesModel.fromJson(str);

class ResepOralProsesModel {
  ResepMr? data;
  String? message;

  ResepOralProsesModel({
    this.data,
    this.message,
  });

  factory ResepOralProsesModel.fromJson(Map<String, dynamic> json) =>
      ResepOralProsesModel(
        data: json["data"] == null ? null : ResepMr.fromJson(json["data"]),
        message: json["message"],
      );
}

String resepOralProsesRequestModelToJson(ResepOralProsesRequestModel data) =>
    json.encode(data.toJson());

class ResepOralProsesRequestModel {
  int status;
  int isBersedia;

  ResepOralProsesRequestModel({
    required this.status,
    required this.isBersedia,
  });

  Map<String, dynamic> toJson() => {
        "status": status,
        "isBersedia": isBersedia,
      };
}
