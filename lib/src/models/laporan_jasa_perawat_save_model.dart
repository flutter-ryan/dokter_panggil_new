import 'dart:convert';

import 'package:admin_dokter_panggil/src/models/laporan_jasa_perawat_model.dart';

String laporanJasaPerawatSaveModelToJson(LaporanJasaPerawatSaveModel data) =>
    json.encode(data.toJson());

class LaporanJasaPerawatSaveModel {
  String from;
  String to;

  LaporanJasaPerawatSaveModel({
    required this.from,
    required this.to,
  });

  Map<String, dynamic> toJson() => {
        "from": from,
        "to": to,
      };
}

ResponseLaporanJasaPerawatSaveModel responseLaporanJasaPerawatSaveModelFromJson(
        dynamic str) =>
    ResponseLaporanJasaPerawatSaveModel.fromJson(str);

class ResponseLaporanJasaPerawatSaveModel {
  LaporanJasaPerawat? data;
  String? message;

  ResponseLaporanJasaPerawatSaveModel({
    this.data,
    this.message,
  });

  factory ResponseLaporanJasaPerawatSaveModel.fromJson(
          Map<String, dynamic> json) =>
      ResponseLaporanJasaPerawatSaveModel(
        data: LaporanJasaPerawat.fromJson(json["data"]),
        message: json["message"],
      );
}
