import 'dart:convert';

String pendaftaranKunjunganSaveModelToJson(
        PendaftaranKunjunganSaveModel data) =>
    json.encode(data.toJson());

class PendaftaranKunjunganSaveModel {
  PendaftaranKunjunganSaveModel({
    required this.norm,
    required this.tanggal,
    required this.jam,
    required this.dokter,
    required this.perawat,
    required this.tindakan,
    required this.jasaDokter,
    required this.jasaDrp,
    required this.total,
    required this.groupTindakan,
    required this.keluhan,
    required this.namaWali,
    required this.hubungan,
    required this.nomorWali,
    required this.tokens,
    required this.status,
  });

  String norm;
  String tanggal;
  String jam;
  String dokter;
  String perawat;
  String keluhan;
  List<int?> tindakan;
  List<int?> jasaDokter;
  List<int?> jasaDrp;
  List<int?> total;
  List<int?> groupTindakan;
  String namaWali;
  String hubungan;
  String nomorWali;
  List<String> tokens;
  int status;

  Map<String, dynamic> toJson() => {
        "norm": norm,
        "tanggal": tanggal,
        "jam": jam,
        "dokter": dokter,
        "perawat": perawat,
        "tindakan": tindakan,
        "jasaDokter": jasaDokter,
        "jasaDrp": jasaDrp,
        "total": total,
        "groupTindakan": groupTindakan,
        "keluhan": keluhan,
        "namaWali": namaWali,
        "hubungan": hubungan,
        "nomorWali": nomorWali,
        "tokens": tokens,
        "status": status,
      };
}

String pendaftaranKunjunganUpdateStatusModelToJson(
        PendaftaranKunjunganUpdateStatusModel data) =>
    json.encode(data.toJson());

class PendaftaranKunjunganUpdateStatusModel {
  PendaftaranKunjunganUpdateStatusModel({
    required this.status,
  });

  int status;

  Map<String, dynamic> toJson() => {
        "status": status,
      };
}

ResponsePendaftaranKunjunganSaveModel
    responsePendaftaranKunjunganSaveModelFromJson(dynamic str) =>
        ResponsePendaftaranKunjunganSaveModel.fromJson(str);

class ResponsePendaftaranKunjunganSaveModel {
  ResponsePendaftaranKunjunganSaveModel({
    this.kunjungan,
    this.message,
  });

  Kunjungan? kunjungan;
  String? message;

  factory ResponsePendaftaranKunjunganSaveModel.fromJson(
          Map<String, dynamic> json) =>
      ResponsePendaftaranKunjunganSaveModel(
        kunjungan: Kunjungan.fromJson(json["data"]),
        message: json["message"],
      );
}

class Kunjungan {
  Kunjungan({
    this.id,
    this.isEmr,
    this.namaPasien,
    this.norm,
    this.normSprint,
    this.nomorRegistrasi,
    this.tanggal,
    this.jam,
    this.fullTanggal,
    this.dokter,
    this.perawat,
    this.tindakan,
    this.keluhan,
    this.status,
    this.isTagihan,
  });

  int? id;
  int? isEmr;
  String? namaPasien;
  String? norm;
  String? normSprint;
  String? nomorRegistrasi;
  String? tanggal;
  String? jam;
  String? fullTanggal;
  String? dokter;
  String? perawat;
  String? keluhan;
  int? status;
  int? isTagihan;
  List<TindakanKunjungan>? tindakan;

  factory Kunjungan.fromJson(Map<String, dynamic> json) => Kunjungan(
        id: json["id"],
        isEmr: json["is_emr"],
        namaPasien: json["nama_pasien"],
        norm: json["norm"],
        normSprint: json["norm_sprint"],
        nomorRegistrasi: json["nomor_registrasi"],
        tanggal: json["tanggal"],
        jam: json["jam"],
        fullTanggal: json["full_tanggal"],
        dokter: json["dokter"],
        perawat: json["perawat"],
        keluhan: json["keluhan"],
        status: json["status"],
        isTagihan: json["is_tagihan"],
        tindakan: List<TindakanKunjungan>.from(
            json["tindakan"].map((x) => TindakanKunjungan.fromJson(x))),
      );
}

class TindakanKunjungan {
  TindakanKunjungan({
    this.id,
    this.namaTindakan,
  });

  int? id;
  String? namaTindakan;

  factory TindakanKunjungan.fromJson(Map<String, dynamic> json) =>
      TindakanKunjungan(
        id: json["id"],
        namaTindakan: json["nama_tindakan"],
      );
}

class WaliPasien {
  WaliPasien({
    this.id,
    this.namaWali,
    this.hubungan,
    this.nomorKontak,
  });

  int? id;
  String? namaWali;
  String? hubungan;
  String? nomorKontak;

  factory WaliPasien.fromJson(Map<String, dynamic> json) => WaliPasien(
        id: json["id"],
        namaWali: json["nama_wali"],
        hubungan: json["hubungan"],
        nomorKontak: json["nomor_kontak"],
      );
}
