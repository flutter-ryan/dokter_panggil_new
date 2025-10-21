import 'dart:convert';

import 'package:admin_dokter_panggil/src/models/pasien_kunjungan_detail_model.dart';

String kunjunganBhpUpdateModelToJson(KunjunganBhpUpdateModel data) =>
    json.encode(data.toJson());

class KunjunganBhpUpdateModel {
  KunjunganBhpUpdateModel({
    required this.barang,
    required this.jumlah,
    required this.hargaModal,
    required this.tarifAplikasi,
    required this.alasan,
  });

  int barang;
  int jumlah;
  int hargaModal;
  int tarifAplikasi;
  String alasan;

  Map<String, dynamic> toJson() => {
        "barang": barang,
        "jumlah": jumlah,
        "hargaModal": hargaModal,
        "tarifAplikasi": tarifAplikasi,
        "alasan": alasan,
      };
}

ResponseKunjunganBhpUpdateModel responseKunjunganBhpUpdateModelFromJson(
        dynamic str) =>
    ResponseKunjunganBhpUpdateModel.fromJson(str);

class ResponseKunjunganBhpUpdateModel {
  ResponseKunjunganBhpUpdateModel({
    this.data,
    this.message,
  });

  DetailKunjungan? data;
  String? message;

  factory ResponseKunjunganBhpUpdateModel.fromJson(Map<String, dynamic> json) =>
      ResponseKunjunganBhpUpdateModel(
        data: DetailKunjungan.fromJson(json["data"]),
        message: json["message"],
      );
}
