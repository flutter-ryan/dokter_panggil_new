import 'dart:convert';

import 'package:dokter_panggil/src/models/pasien_kunjungan_detail_model.dart';

String transportasiKunjunganTindakanLabModelToJson(
        TransportasiKunjunganTindakanLabModel data) =>
    json.encode(data.toJson());

class TransportasiKunjunganTindakanLabModel {
  TransportasiKunjunganTindakanLabModel({
    required this.transportasi,
  });

  int transportasi;

  Map<String, dynamic> toJson() => {
        "transportasi": transportasi,
      };
}

ResponseTransportasiKunjunganTindakanLabModel
    responseTransportasiKunjunganTindakanLabModelFromJson(dynamic str) =>
        ResponseTransportasiKunjunganTindakanLabModel.fromJson(str);

class ResponseTransportasiKunjunganTindakanLabModel {
  ResponseTransportasiKunjunganTindakanLabModel({
    required this.data,
    required this.message,
  });

  DetailKunjungan data;
  String message;

  factory ResponseTransportasiKunjunganTindakanLabModel.fromJson(
          Map<String, dynamic> json) =>
      ResponseTransportasiKunjunganTindakanLabModel(
        data: DetailKunjungan.fromJson(json["data"]),
        message: json["message"],
      );
}
