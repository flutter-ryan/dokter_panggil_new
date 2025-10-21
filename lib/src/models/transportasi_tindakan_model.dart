import 'dart:convert';

import 'package:admin_dokter_panggil/src/models/pasien_kunjungan_detail_model.dart';

String transportasiTindakanModelToJson(TransportasiTindakanModel data) =>
    json.encode(data.toJson());

class TransportasiTindakanModel {
  TransportasiTindakanModel({
    required this.tindakanKunjungan,
    required this.nilai,
    required this.jarak,
  });

  int tindakanKunjungan;
  int nilai;
  int jarak;

  Map<String, dynamic> toJson() => {
        "tindakanKunjungan": tindakanKunjungan,
        "nilai": nilai,
        "jarak": jarak,
      };
}

ResponseTransportasiTindakanModel responseTransportasiTindakanModelFromJson(
        dynamic str) =>
    ResponseTransportasiTindakanModel.fromJson(str);

class ResponseTransportasiTindakanModel {
  ResponseTransportasiTindakanModel({
    this.data,
    this.message,
  });

  DetailKunjungan? data;
  String? message;

  factory ResponseTransportasiTindakanModel.fromJson(
          Map<String, dynamic> json) =>
      ResponseTransportasiTindakanModel(
        data: DetailKunjungan.fromJson(json["data"]),
        message: json["message"],
      );
}
