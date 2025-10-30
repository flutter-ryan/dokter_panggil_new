import 'package:admin_dokter_panggil/src/models/mr_riwayat_kunjungan_model.dart';
import 'package:admin_dokter_panggil/src/models/pasien_show_model.dart';

MrRiwayatDetailModel mrRiwayatDetailModelFromJson(dynamic str) =>
    MrRiwayatDetailModel.fromJson(str);

class MrRiwayatDetailModel {
  MrRiwayatDetail? data;
  String? message;

  MrRiwayatDetailModel({
    this.data,
    this.message,
  });

  factory MrRiwayatDetailModel.fromJson(Map<String, dynamic> json) =>
      MrRiwayatDetailModel(
        data: json["data"] == null
            ? null
            : MrRiwayatDetail.fromJson(json["data"]),
        message: json["message"],
      );
}

class MrRiwayatDetail {
  int? id;
  RiwayatKunjungan? kunjungan;
  PasienRiwayatAdmin? pasien;
  bool? mr0;
  bool? mr1;
  bool? mr2;
  bool? mr3;
  bool? mr4;
  bool? mr5;
  bool? mr6;
  bool? mr7;
  bool? mr8;
  bool? mr9;
  bool? mr10;
  bool? mr11;
  bool? mr12;
  bool? mr13;
  bool? mr14;
  bool? mr15;

  MrRiwayatDetail({
    this.id,
    this.kunjungan,
    this.pasien,
    this.mr0,
    this.mr1,
    this.mr2,
    this.mr3,
    this.mr4,
    this.mr5,
    this.mr6,
    this.mr7,
    this.mr8,
    this.mr9,
    this.mr10,
    this.mr11,
    this.mr12,
    this.mr13,
    this.mr14,
    this.mr15,
  });

  factory MrRiwayatDetail.fromJson(Map<String, dynamic> json) =>
      MrRiwayatDetail(
        id: json["id"],
        kunjungan: json["kunjungan"] == null
            ? null
            : RiwayatKunjungan.fromJson(json["kunjungan"]),
        pasien: json["pasien"] == null
            ? null
            : PasienRiwayatAdmin.fromJson(json["pasien"]),
        mr0: json["mr_0"],
        mr1: json["mr_1"],
        mr2: json["mr_2"],
        mr3: json["mr_3"],
        mr4: json["mr_4"],
        mr5: json["mr_5"],
        mr6: json["mr_6"],
        mr7: json["mr_7"],
        mr8: json["mr_8"],
        mr9: json["mr_9"],
        mr10: json["mr_10"],
        mr11: json["mr_11"],
        mr12: json["mr_12"],
        mr13: json["mr_13"],
        mr14: json["mr_14"],
        mr15: json["mr_15"],
      );
}

class RiwayatKunjungan {
  int? id;
  String? keluhan;
  String? jenisKunjungan;
  List<RiwayatLayanan>? layanan;
  List<RiwayatDokter>? dokter;
  RiwayatPerawat? perawat;
  Pasien? pasien;
  Role? role;
  bool? hasilLab;
  bool? hasilRad;
  bool? isDokter;
  bool? isPerawat;
  bool? isDewasa;
  bool? isEmr;

  RiwayatKunjungan({
    this.id,
    this.keluhan,
    this.jenisKunjungan,
    this.layanan,
    this.dokter,
    this.perawat,
    this.pasien,
    this.role,
    this.hasilLab,
    this.hasilRad,
    this.isDokter,
    this.isPerawat,
    this.isDewasa,
    this.isEmr,
  });

  factory RiwayatKunjungan.fromJson(Map<String, dynamic> json) =>
      RiwayatKunjungan(
        id: json["id"],
        keluhan: json["keluhan"],
        jenisKunjungan: json["jenis_kunjungan"],
        layanan: json["layanan"] == null
            ? []
            : List<RiwayatLayanan>.from(
                json["layanan"]!.map((x) => RiwayatLayanan.fromJson(x))),
        dokter: json["dokter"] == null
            ? []
            : List<RiwayatDokter>.from(
                json["dokter"]!.map((x) => RiwayatDokter.fromJson(x))),
        perawat: json["perawat"] == null
            ? null
            : RiwayatPerawat.fromJson(json["perawat"]),
        pasien: json["pasien"] == null ? null : Pasien.fromJson(json["pasien"]),
        role: json["role"] == null ? null : Role.fromJson(json["role"]),
        hasilLab: json["hasil_lab"],
        hasilRad: json["hasil_rad"],
        isDokter: json["is_dokter"],
        isPerawat: json["is_perawat"],
        isDewasa: json["is_dewasa"],
        isEmr: json["is_emr"],
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
    this.konsulKerjaSama,
    this.konsulAlihRawat,
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

class RiwayatLayanan {
  int? id;
  int? kunjunganId;
  int? layananId;
  String? namaLayanan;

  RiwayatLayanan({
    this.id,
    this.kunjunganId,
    this.layananId,
    this.namaLayanan,
  });

  factory RiwayatLayanan.fromJson(Map<String, dynamic> json) => RiwayatLayanan(
        id: json["id"],
        kunjunganId: json["kunjungan_id"],
        layananId: json["layanan_id"],
        namaLayanan: json["nama_layanan"],
      );
}

class Role {
  int? id;
  int? kunjunganId;
  int? isTelemedicine;
  int? isHomevisit;
  int? isHomevisitPerawat;
  int? isObservasi;
  int? isRanap;
  DateTime? createdAt;
  DateTime? updatedAt;

  Role({
    this.id,
    this.kunjunganId,
    this.isTelemedicine,
    this.isHomevisit,
    this.isHomevisitPerawat,
    this.isObservasi,
    this.isRanap,
    this.createdAt,
    this.updatedAt,
  });

  factory Role.fromJson(Map<String, dynamic> json) => Role(
        id: json["id"],
        kunjunganId: json["kunjungan_id"],
        isTelemedicine: json["is_telemedicine"],
        isHomevisit: json["is_homevisit"],
        isHomevisitPerawat: json["is_homevisit_perawat"],
        isObservasi: json["is_observasi"],
        isRanap: json["is_ranap"],
        createdAt: json["created_at"] == null
            ? null
            : DateTime.parse(json["created_at"]),
        updatedAt: json["updated_at"] == null
            ? null
            : DateTime.parse(json["updated_at"]),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "kunjungan_id": kunjunganId,
        "is_telemedicine": isTelemedicine,
        "is_homevisit": isHomevisit,
        "is_homevisit_perawat": isHomevisitPerawat,
        "is_observasi": isObservasi,
        "is_ranap": isRanap,
        "created_at": createdAt?.toIso8601String(),
        "updated_at": updatedAt?.toIso8601String(),
      };
}

class PasienRiwayatAdmin {
  int? id;
  String? nama;
  String? norm;
  bool? isDewasa;

  PasienRiwayatAdmin({
    this.id,
    this.nama,
    this.norm,
    this.isDewasa,
  });

  factory PasienRiwayatAdmin.fromJson(Map<String, dynamic> json) =>
      PasienRiwayatAdmin(
        id: json["id"],
        nama: json["nama"],
        norm: json["norm"],
        isDewasa: json["is_dewasa"],
      );
}
