import 'dart:convert';

import 'package:dokter_panggil/src/models/master_pegawai_fetch_model.dart';

String updateInfoPegawaiModelToJson(UpdateInfoPegawaiModel data) =>
    json.encode(data.toJson());

class UpdateInfoPegawaiModel {
  UpdateInfoPegawaiModel({
    required this.nama,
    required this.profesi,
  });

  String nama;
  int profesi;

  Map<String, dynamic> toJson() => {
        "nama": nama,
        "profesi": profesi,
      };
}

ResponseUpdateInfoPegawaiModel responseUpdateInfoPegawaiModelFromJson(
        dynamic str) =>
    ResponseUpdateInfoPegawaiModel.fromJson(str);

class ResponseUpdateInfoPegawaiModel {
  ResponseUpdateInfoPegawaiModel({
    this.data,
    this.message,
  });

  MasterPegawai? data;
  String? message;

  factory ResponseUpdateInfoPegawaiModel.fromJson(Map<String, dynamic> json) =>
      ResponseUpdateInfoPegawaiModel(
        data: MasterPegawai.fromJson(json["data"]),
        message: json["message"],
      );
}
