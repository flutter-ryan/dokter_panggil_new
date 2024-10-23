import 'dart:convert';

import 'package:dokter_panggil/src/models/pasien_kunjungan_detail_model.dart';

String transaksiBhpModelToJson(TransaksiBhpModel data) =>
    json.encode(data.toJson());

class TransaksiBhpModel {
  TransaksiBhpModel({
    required this.barang,
    required this.jumlah,
  });

  List<int> barang;
  List<int> jumlah;

  Map<String, dynamic> toJson() => {
        "barang": List<dynamic>.from(barang.map((x) => x)),
        "jumlah": List<dynamic>.from(jumlah.map((x) => x)),
      };
}

ResponseTransaksiBhpModel responseTransaksiBhpModelFromJson(dynamic str) =>
    ResponseTransaksiBhpModel.fromJson(str);

class ResponseTransaksiBhpModel {
  ResponseTransaksiBhpModel({
    this.data,
    this.message,
  });

  DetailKunjungan? data;
  String? message;

  factory ResponseTransaksiBhpModel.fromJson(Map<String, dynamic> json) =>
      ResponseTransaksiBhpModel(
        data: DetailKunjungan.fromJson(json["data"]),
        message: json["message"],
      );
}
