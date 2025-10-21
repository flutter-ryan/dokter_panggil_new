import 'dart:convert';

import 'package:admin_dokter_panggil/src/models/pasien_kunjungan_detail_model.dart';

String konfirmasiDepositModelToJson(KonfirmasiDepositModel data) =>
    json.encode(data.toJson());

class KonfirmasiDepositModel {
  KonfirmasiDepositModel({
    required this.status,
    required this.nilaiPembayaran,
    required this.deskripsiBiayaAdmin,
    required this.nilaiBiayaAdmin,
  });

  int status;
  String nilaiPembayaran;
  List<String> deskripsiBiayaAdmin;
  List<int> nilaiBiayaAdmin;

  Map<String, dynamic> toJson() => {
        "status": status,
        "nilaiPembayaran": nilaiPembayaran,
        "deskripsiBiayaAdmin": deskripsiBiayaAdmin,
        "nilaiBiayaAdmin": nilaiBiayaAdmin,
      };
}

ResponseKonfirmasiDepositModel responseKonfirmasiDepositModelFromJson(
        dynamic str) =>
    ResponseKonfirmasiDepositModel.fromJson(str);

class ResponseKonfirmasiDepositModel {
  ResponseKonfirmasiDepositModel({
    this.message,
    this.data,
  });

  String? message;
  DetailKunjungan? data;

  factory ResponseKonfirmasiDepositModel.fromJson(Map<String, dynamic> json) =>
      ResponseKonfirmasiDepositModel(
        message: json["message"],
        data: DetailKunjungan.fromJson(json["data"]),
      );
}
