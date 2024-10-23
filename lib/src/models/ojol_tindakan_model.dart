import 'dart:convert';

import 'package:dokter_panggil/src/models/pasien_kunjungan_detail_model.dart';

String ojolTindakanModelToJson(OjolTindakanModel data) =>
    json.encode(data.toJson());

class OjolTindakanModel {
  OjolTindakanModel({
    required this.tindakanKunjungan,
    required this.biaya,
    required this.persen,
  });

  int tindakanKunjungan;
  int biaya;
  int persen;

  Map<String, dynamic> toJson() => {
        "tindakanKunjungan": tindakanKunjungan,
        "biaya": biaya,
        "persen": persen,
      };
}

ResponseOjolTindakanModel responseOjolTindakanModelFromJson(dynamic str) =>
    ResponseOjolTindakanModel.fromJson(str);

class ResponseOjolTindakanModel {
  ResponseOjolTindakanModel({
    this.data,
    this.message,
  });

  DetailKunjungan? data;
  String? message;

  factory ResponseOjolTindakanModel.fromJson(Map<String, dynamic> json) =>
      ResponseOjolTindakanModel(
        data: DetailKunjungan.fromJson(json["data"]),
        message: json["message"],
      );
}
