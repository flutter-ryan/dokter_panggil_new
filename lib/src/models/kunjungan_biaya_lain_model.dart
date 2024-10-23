import 'dart:convert';

String kunjunganBiayaLainModelToJson(KunjunganBiayaLainModel data) =>
    json.encode(data.toJson());

class KunjunganBiayaLainModel {
  int kunjungan;
  String deskripsi;
  int nilai;

  KunjunganBiayaLainModel({
    required this.kunjungan,
    required this.deskripsi,
    required this.nilai,
  });

  Map<String, dynamic> toJson() => {
        "kunjungan": kunjungan,
        "deskripsi": deskripsi,
        "nilai": nilai,
      };
}
