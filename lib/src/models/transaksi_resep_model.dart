import 'dart:convert';

import 'package:admin_dokter_panggil/src/models/pasien_kunjungan_detail_model.dart';

String transaksiResepModelToJson(TransaksiResepModel data) =>
    json.encode(data.toJson());

class TransaksiResepModel {
  TransaksiResepModel({
    required this.barangMitra,
    required this.barangMentari,
    required this.jumlahMitra,
    required this.jumlahMentari,
  });

  List<int> barangMitra;
  List<int> barangMentari;
  List<int> jumlahMitra;
  List<int> jumlahMentari;

  Map<String, dynamic> toJson() => {
        "barangMitra": List<dynamic>.from(barangMitra.map((x) => x)),
        "barangMentari": List<dynamic>.from(barangMentari.map((x) => x)),
        "jumlahMitra": List<dynamic>.from(jumlahMitra.map((x) => x)),
        "jumlahMentari": List<dynamic>.from(jumlahMentari.map((x) => x)),
      };
}

ResponseTransaksiResepModel responseTransaksiResepModelFromJson(dynamic str) =>
    ResponseTransaksiResepModel.fromJson(str);

class ResponseTransaksiResepModel {
  ResponseTransaksiResepModel({
    this.data,
    this.message,
  });

  DetailKunjungan? data;
  String? message;

  factory ResponseTransaksiResepModel.fromJson(Map<String, dynamic> json) =>
      ResponseTransaksiResepModel(
        data: DetailKunjungan.fromJson(json["data"]),
        message: json["message"],
      );
}
