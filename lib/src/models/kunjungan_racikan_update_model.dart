import 'dart:convert';

import 'package:dokter_panggil/src/models/pasien_kunjungan_detail_model.dart';

String kunjunganRacikanUpdateModelToJson(KunjunganRacikanUpdateModel data) =>
    json.encode(data.toJson());

class KunjunganRacikanUpdateModel {
  KunjunganRacikanUpdateModel({
    required this.jumlah,
  });

  int jumlah;

  Map<String, dynamic> toJson() => {
        "jumlah": jumlah,
      };
}

ResponseKunjunganRacikanUpdateModel responseKunjunganRacikanUpdateModelFromJson(
        dynamic str) =>
    ResponseKunjunganRacikanUpdateModel.fromJson(str);

class ResponseKunjunganRacikanUpdateModel {
  ResponseKunjunganRacikanUpdateModel({
    this.data,
    this.message,
  });

  DetailKunjungan? data;
  String? message;

  factory ResponseKunjunganRacikanUpdateModel.fromJson(
          Map<String, dynamic> json) =>
      ResponseKunjunganRacikanUpdateModel(
        data: DetailKunjungan.fromJson(json["data"]),
        message: json["message"],
      );
}
