import 'dart:convert';

import 'package:admin_dokter_panggil/src/models/pasien_kunjungan_detail_model.dart';

String batalFinalPetugasModelToJson(BatalFinalPetugasModel data) =>
    json.encode(data.toJson());

class BatalFinalPetugasModel {
  int idPetugas;
  bool isDokter;

  BatalFinalPetugasModel({
    required this.idPetugas,
    required this.isDokter,
  });

  Map<String, dynamic> toJson() => {
        "idPetugas": idPetugas,
        "isDokter": isDokter,
      };
}

ResponseBatalFinalPetugasModel responseBatalFinalPetugasModelFromJson(
        dynamic str) =>
    ResponseBatalFinalPetugasModel.fromJson(str);

class ResponseBatalFinalPetugasModel {
  ResponseBatalFinalPetugasModel({
    this.detail,
    this.message,
  });

  DetailKunjungan? detail;
  String? message;

  factory ResponseBatalFinalPetugasModel.fromJson(Map<String, dynamic> json) =>
      ResponseBatalFinalPetugasModel(
        detail: DetailKunjungan.fromJson(json["data"]),
        message: json["message"],
      );
}
