import 'dart:convert';

import 'package:dokter_panggil/src/models/pasien_kunjungan_detail_model.dart';

String updateKunjunganResepTagihanModelToJson(
        UpdateKunjunganResepTagihanModel data) =>
    json.encode(data.toJson());

class UpdateKunjunganResepTagihanModel {
  UpdateKunjunganResepTagihanModel({
    required this.jumlah,
  });

  int jumlah;

  Map<String, dynamic> toJson() => {
        "jumlah": jumlah,
      };
}

ResponseUpdateKunjunganResepTagihanModel
    responseUpdateKunjunganResepTagihanModelFromJson(dynamic str) =>
        ResponseUpdateKunjunganResepTagihanModel.fromJson(str);

class ResponseUpdateKunjunganResepTagihanModel {
  ResponseUpdateKunjunganResepTagihanModel({
    this.data,
    this.message,
  });

  DetailKunjungan? data;
  String? message;

  factory ResponseUpdateKunjunganResepTagihanModel.fromJson(
          Map<String, dynamic> json) =>
      ResponseUpdateKunjunganResepTagihanModel(
        data: DetailKunjungan.fromJson(json["data"]),
        message: json["message"],
      );
}
