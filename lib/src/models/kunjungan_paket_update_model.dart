import 'dart:convert';

import 'package:dokter_panggil/src/models/pasien_kunjungan_detail_model.dart';

String kunjunganPaketUpdateModelToJson(KunjunganPaketUpdateModel data) =>
    json.encode(data.toJson());

class KunjunganPaketUpdateModel {
  int idPaket;

  KunjunganPaketUpdateModel({
    required this.idPaket,
  });

  Map<String, dynamic> toJson() => {
        "idPaket": idPaket,
      };
}

ResponseKunjunganPaketUpdateModel responseKunjunganPaketUpdateModelFromJson(
        dynamic str) =>
    ResponseKunjunganPaketUpdateModel.fromJson(str);

class ResponseKunjunganPaketUpdateModel {
  DetailKunjungan? data;
  String? message;

  ResponseKunjunganPaketUpdateModel({
    this.data,
    this.message,
  });

  factory ResponseKunjunganPaketUpdateModel.fromJson(
          Map<String, dynamic> json) =>
      ResponseKunjunganPaketUpdateModel(
        data: DetailKunjungan.fromJson(json["data"]),
        message: json["message"],
      );
}
