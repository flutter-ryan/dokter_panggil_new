import 'dart:convert';

import 'package:dokter_panggil/src/models/pasien_kunjungan_detail_model.dart';

String kunjunganObatInkjeksiUpdateModelToJson(
        KunjunganObatInkjeksiUpdateModel data) =>
    json.encode(data.toJson());

class KunjunganObatInkjeksiUpdateModel {
  KunjunganObatInkjeksiUpdateModel({
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

ResponseKunjunganObatInkjeksiUpdateModel
    responseKunjunganObatInkjeksiUpdateModelFromJson(dynamic str) =>
        ResponseKunjunganObatInkjeksiUpdateModel.fromJson(str);

class ResponseKunjunganObatInkjeksiUpdateModel {
  ResponseKunjunganObatInkjeksiUpdateModel({
    this.data,
    this.message,
  });

  KunjunganObatInjeksi? data;
  String? message;

  factory ResponseKunjunganObatInkjeksiUpdateModel.fromJson(
          Map<String, dynamic> json) =>
      ResponseKunjunganObatInkjeksiUpdateModel(
        data: KunjunganObatInjeksi.fromJson(json["data"]),
        message: json["message"],
      );
}
