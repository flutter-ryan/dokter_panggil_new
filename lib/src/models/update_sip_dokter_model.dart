import 'dart:convert';

import 'package:admin_dokter_panggil/src/models/master_pegawai_fetch_model.dart';

String updateSipDokterModelToJson(UpdateSipDokterModel data) =>
    json.encode(data.toJson());

class UpdateSipDokterModel {
  UpdateSipDokterModel({
    required this.nomor,
    required this.tanggal,
  });

  String nomor;
  String tanggal;

  Map<String, dynamic> toJson() => {
        "nomor": nomor,
        "tanggal": tanggal,
      };
}

ResponseUpdateSipDokterModel responseUpdateSipDokterModelFromJson(
        dynamic str) =>
    ResponseUpdateSipDokterModel.fromJson(str);

class ResponseUpdateSipDokterModel {
  ResponseUpdateSipDokterModel({
    this.data,
    this.message,
  });

  MasterPegawai? data;
  String? message;

  factory ResponseUpdateSipDokterModel.fromJson(Map<String, dynamic> json) =>
      ResponseUpdateSipDokterModel(
        data: MasterPegawai.fromJson(json["data"]),
        message: json["message"],
      );
}
