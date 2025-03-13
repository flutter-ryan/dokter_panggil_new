import 'dart:convert';

import 'package:dokter_panggil/src/models/pasien_kunjungan_detail_model.dart';

MrPetugasKonsulSaveModel mrPetugasKonsulSaveModelFromJson(dynamic str) =>
    MrPetugasKonsulSaveModel.fromJson(str);

class MrPetugasKonsulSaveModel {
  Dokter? data;
  String? message;

  MrPetugasKonsulSaveModel({
    this.data,
    this.message,
  });

  factory MrPetugasKonsulSaveModel.fromJson(Map<String, dynamic> json) =>
      MrPetugasKonsulSaveModel(
        data: json["data"] == null ? null : Dokter.fromJson(json["data"]),
        message: json["message"],
      );
}

String mrPetugasKonsulRequestModelToJson(MrPetugasKonsulRequestModel data) =>
    json.encode(data.toJson());

class MrPetugasKonsulRequestModel {
  int idKunjungan;
  int idPetugas;
  int pilihanPetugas;

  MrPetugasKonsulRequestModel({
    required this.idKunjungan,
    required this.idPetugas,
    required this.pilihanPetugas,
  });

  Map<String, dynamic> toJson() => {
        "idKunjungan": idKunjungan,
        "idPetugas": idPetugas,
        "pilihanPetugas": pilihanPetugas,
      };
}
