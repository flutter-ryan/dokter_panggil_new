import 'dart:convert';

import 'package:admin_dokter_panggil/src/models/pasien_kunjungan_detail_model.dart';

String transaksiTindakanLabModelToJson(TransaksiTindakanLabModel data) =>
    json.encode(data.toJson());

class TransaksiTindakanLabModel {
  TransaksiTindakanLabModel({
    required this.tindakanLab,
  });

  List<int> tindakanLab;

  Map<String, dynamic> toJson() => {
        "tindakanLab": List<dynamic>.from(tindakanLab.map((x) => x)),
      };
}

ResponseTransaksiTindakanLabModel responseTransaksiTindakanLabModelFromJson(
        dynamic str) =>
    ResponseTransaksiTindakanLabModel.fromJson(str);

class ResponseTransaksiTindakanLabModel {
  ResponseTransaksiTindakanLabModel({
    this.data,
    this.message,
  });

  DetailKunjungan? data;
  String? message;

  factory ResponseTransaksiTindakanLabModel.fromJson(
          Map<String, dynamic> json) =>
      ResponseTransaksiTindakanLabModel(
        data: DetailKunjungan.fromJson(json["data"]),
        message: json["message"],
      );
}
