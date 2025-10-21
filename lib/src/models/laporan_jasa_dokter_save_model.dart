import 'dart:convert';

import 'package:admin_dokter_panggil/src/models/laporan_jasa_dokter_model.dart';

String laporanJasaDokterSaveModelToJson(LaporanJasaDokterSaveModel data) =>
    json.encode(data.toJson());

class LaporanJasaDokterSaveModel {
  String from;
  String to;

  LaporanJasaDokterSaveModel({
    required this.from,
    required this.to,
  });

  Map<String, dynamic> toJson() => {
        "from": from,
        "to": to,
      };
}

ResponseLaporanJasaDokterSaveModel responseLaporanJasaDokterSaveModelFromJson(
        dynamic str) =>
    ResponseLaporanJasaDokterSaveModel.fromJson(str);

class ResponseLaporanJasaDokterSaveModel {
  LaporanJasaDokter? data;
  String? message;

  ResponseLaporanJasaDokterSaveModel({
    this.data,
    this.message,
  });

  factory ResponseLaporanJasaDokterSaveModel.fromJson(
          Map<String, dynamic> json) =>
      ResponseLaporanJasaDokterSaveModel(
        data: LaporanJasaDokter.fromJson(json["data"]),
        message: json["message"],
      );
}
