import 'package:admin_dokter_panggil/src/models/pasien_show_model.dart';

MrRiwayatKunjunganModel mrRiwayatKunjunganModelFromJson(dynamic str) =>
    MrRiwayatKunjunganModel.fromJson(str);

class MrRiwayatKunjunganModel {
  List<MrRiwayatKunjungan>? data;
  int? currentPage;
  int? totalPage;
  String? message;
  int? total;

  MrRiwayatKunjunganModel({
    this.data,
    this.currentPage,
    this.totalPage,
    this.message,
    this.total,
  });

  factory MrRiwayatKunjunganModel.fromJson(Map<String, dynamic> json) =>
      MrRiwayatKunjunganModel(
        data: json["data"] == null
            ? []
            : List<MrRiwayatKunjungan>.from(
                json["data"]!.map((x) => MrRiwayatKunjungan.fromJson(x))),
        currentPage: json["current_page"],
        totalPage: json["totalPage"],
        message: json["message"],
        total: json["total"],
      );
}

class MrRiwayatKunjungan {
  int? idKunjungan;
  String? noreg;
  bool? isEmr;
  String? tanggal;
  String? keluhan;
  int? statusKunjungan;
  bool? isKonsul;
  Skrining? skrining;
  int? isTelemedicine;
  int? isHomevisit;
  int? isObservasi;
  int? isRanap;
  List<RiwayatDokter>? dokter;
  List<RiwayatPerawat>? perawat;
  Pasien? pasien;

  MrRiwayatKunjungan({
    this.idKunjungan,
    this.noreg,
    this.isEmr,
    this.tanggal,
    this.keluhan,
    this.statusKunjungan,
    this.isKonsul,
    this.skrining,
    this.isTelemedicine,
    this.isHomevisit,
    this.isObservasi,
    this.isRanap,
    this.dokter,
    this.perawat,
    this.pasien,
  });

  factory MrRiwayatKunjungan.fromJson(Map<String, dynamic> json) =>
      MrRiwayatKunjungan(
        idKunjungan: json["id_kunjungan"],
        noreg: json["noreg"],
        isEmr: json["is_emr"],
        tanggal: json["tanggal"],
        keluhan: json["keluhan"],
        statusKunjungan: json["status_kunjungan"],
        isKonsul: json["is_konsul"],
        skrining: json["skrining"] == null
            ? null
            : Skrining.fromJson(json["skrining"]),
        isTelemedicine: json["is_telemedicine"],
        isHomevisit: json["is_homevisit"],
        isObservasi: json["is_observasi"],
        isRanap: json["is_ranap"],
        dokter: json["dokter"] == null
            ? []
            : List<RiwayatDokter>.from(
                json["dokter"]!.map((x) => RiwayatDokter.fromJson(x))),
        perawat: json["perawat"] == null
            ? []
            : List<RiwayatPerawat>.from(
                json["perawat"]!.map((x) => RiwayatPerawat.fromJson(x))),
        pasien: json["pasien"] == null ? null : Pasien.fromJson(json["pasien"]),
      );
}

class Skrining {
  int? id;
  String? skrining;
  String? warna;
  String? keputusan;

  Skrining({
    this.id,
    this.skrining,
    this.warna,
    this.keputusan,
  });

  factory Skrining.fromJson(Map<String, dynamic> json) => Skrining(
        id: json["id"],
        skrining: json["skrining"],
        warna: json["warna"],
        keputusan: json["keputusan"],
      );
}

class RiwayatDokter {
  int? id;
  int? dokterId;
  String? nama;
  bool? isKonsul;
  bool? konsulKerjaSama;
  bool? konsulAlihRawat;

  RiwayatDokter({
    this.id,
    this.dokterId,
    this.nama,
    this.isKonsul,
    this.konsulAlihRawat,
    this.konsulKerjaSama,
  });

  factory RiwayatDokter.fromJson(Map<String, dynamic> json) => RiwayatDokter(
        id: json["id"],
        dokterId: json["dokter_id"],
        nama: json["nama"],
        isKonsul: json["is_konsul"],
        konsulKerjaSama: json["konsul_kerja_sama"],
        konsulAlihRawat: json["konsul_alih_rawat"],
      );
}

class RiwayatPerawat {
  int? id;
  int? kunjunganId;
  int? perawatId;
  String? nama;

  RiwayatPerawat({
    this.id,
    this.kunjunganId,
    this.perawatId,
    this.nama,
  });

  factory RiwayatPerawat.fromJson(Map<String, dynamic> json) => RiwayatPerawat(
        id: json["id"],
        kunjunganId: json["kunjungan_id"],
        perawatId: json["perawat_id"],
        nama: json["nama"],
      );
}
