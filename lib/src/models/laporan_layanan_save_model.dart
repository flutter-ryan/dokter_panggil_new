import 'dart:convert';

import 'package:dokter_panggil/src/models/laporan_layanan_model.dart';

String laporanLayananSaveModelToJson(LaporanLayananSaveModel data) =>
    json.encode(data.toJson());

class LaporanLayananSaveModel {
  String from;
  String to;

  LaporanLayananSaveModel({
    required this.from,
    required this.to,
  });

  Map<String, dynamic> toJson() => {
        "from": from,
        "to": to,
      };
}

ResponseLaporanLayananSaveModel responseLaporanLayananSaveModelFromJson(
        dynamic str) =>
    ResponseLaporanLayananSaveModel.fromJson(str);

class ResponseLaporanLayananSaveModel {
  LaporanLayanan? data;
  String? message;

  ResponseLaporanLayananSaveModel({
    this.data,
    this.message,
  });

  factory ResponseLaporanLayananSaveModel.fromJson(Map<String, dynamic> json) =>
      ResponseLaporanLayananSaveModel(
        data: LaporanLayanan.fromJson(json["data"]),
        message: json["message"],
      );
}
