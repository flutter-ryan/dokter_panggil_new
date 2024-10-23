import 'dart:convert';

String kunjunganFinalModelToJson(KunjunganFinalModel data) =>
    json.encode(data.toJson());

class KunjunganFinalModel {
  KunjunganFinalModel({
    required this.idKunjungan,
    required this.biaya,
    required this.nilai,
    required this.diskon,
    required this.totalDiskon,
  });

  int idKunjungan;
  List<String?>? biaya;
  List<int?>? nilai;
  String diskon;
  String totalDiskon;

  Map<String, dynamic> toJson() => {
        "idKunjungan": idKunjungan,
        "biaya": List<String>.from(biaya!.map((x) => x)),
        "nilai": List<int>.from(nilai!.map((x) => x)),
        "diskon": diskon,
        "total": totalDiskon
      };
}

ResponseKunjunganFinalModel responseKunjunganFinalModelFromJson(dynamic str) =>
    ResponseKunjunganFinalModel.fromJson(str);

class ResponseKunjunganFinalModel {
  ResponseKunjunganFinalModel({
    this.message,
    this.data,
  });

  String? message;
  KwitansiSimpan? data;

  factory ResponseKunjunganFinalModel.fromJson(Map<String, dynamic> json) =>
      ResponseKunjunganFinalModel(
        message: json["message"],
        data: KwitansiSimpan.fromJson(json['data']),
      );
}

class KwitansiSimpan {
  KwitansiSimpan({
    this.id,
    this.url,
    this.pasien,
  });

  int? id;
  String? url;
  PasienKwitansi? pasien;

  factory KwitansiSimpan.fromJson(Map<String, dynamic> json) => KwitansiSimpan(
        id: json["id"],
        url: json["url"],
        pasien: PasienKwitansi.fromJson(json["pasien"]),
      );
}

class PasienKwitansi {
  PasienKwitansi({
    this.id,
    this.norm,
    this.namaPasien,
    this.nomorTelepon,
  });

  int? id;
  String? norm;
  String? namaPasien;
  String? nomorTelepon;

  factory PasienKwitansi.fromJson(Map<String, dynamic> json) => PasienKwitansi(
        id: json["id"],
        norm: json["norm"],
        namaPasien: json["nama_pasien"],
        nomorTelepon: json["nomor_telepon"],
      );
}
