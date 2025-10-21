import 'dart:convert';

import 'package:admin_dokter_panggil/src/models/pasien_kunjungan_detail_model.dart';

String transportasiResepModelToJson(TransportasiResepModel data) =>
    json.encode(data.toJson());

class TransportasiResepModel {
  TransportasiResepModel({
    required this.idKunjungan,
    required this.biaya,
    required this.idResep,
  });

  int idKunjungan;
  int biaya;
  String idResep;

  Map<String, dynamic> toJson() => {
        "idKunjungan": idKunjungan,
        "biaya": biaya,
        "idResep": idResep,
      };
}

ResponseTransportasiResepModel responseTransportasiResepModelFromJson(
        dynamic str) =>
    ResponseTransportasiResepModel.fromJson(str);

class ResponseTransportasiResepModel {
  ResponseTransportasiResepModel({
    this.data,
    this.message,
  });

  DetailKunjungan? data;
  String? message;

  factory ResponseTransportasiResepModel.fromJson(Map<String, dynamic> json) =>
      ResponseTransportasiResepModel(
        data: DetailKunjungan.fromJson(json["data"]),
        message: json["message"],
      );
}
