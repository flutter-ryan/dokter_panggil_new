import 'dart:convert';

import 'package:dokter_panggil/src/models/pasien_kunjungan_detail_model.dart';

String transportasiResepRacikanModelToJson(
        TransportasiResepRacikanModel data) =>
    json.encode(data.toJson());

class TransportasiResepRacikanModel {
  TransportasiResepRacikanModel({
    required this.idKunjungan,
    required this.biaya,
  });

  int idKunjungan;
  int biaya;

  Map<String, dynamic> toJson() => {
        "idKunjungan": idKunjungan,
        "biaya": biaya,
      };
}

ResponseTransportasiResepRacikanModel
    responseTransportasiResepRacikanModelFromJson(dynamic str) =>
        ResponseTransportasiResepRacikanModel.fromJson(str);

class ResponseTransportasiResepRacikanModel {
  ResponseTransportasiResepRacikanModel({
    this.data,
    this.message,
  });

  DetailKunjungan? data;
  String? message;

  factory ResponseTransportasiResepRacikanModel.fromJson(
          Map<String, dynamic> json) =>
      ResponseTransportasiResepRacikanModel(
        data: DetailKunjungan.fromJson(json["data"]),
        message: json["message"],
      );
}
