import 'dart:convert';

import 'package:dokter_panggil/src/models/pasien_kunjungan_detail_model.dart';

KunjunganPasienResumeModel kunjunganPasienResumeModelFromJson(dynamic str) =>
    KunjunganPasienResumeModel.fromJson(str);

class KunjunganPasienResumeModel {
  List<KunjunganPasienResume>? data;
  int? currentPage;
  int? totalPage;
  String? message;
  int? total;

  KunjunganPasienResumeModel({
    this.data,
    this.currentPage,
    this.totalPage,
    this.message,
    this.total,
  });

  factory KunjunganPasienResumeModel.fromJson(Map<String, dynamic> json) =>
      KunjunganPasienResumeModel(
        data: List<KunjunganPasienResume>.from(
            json["data"].map((x) => KunjunganPasienResume.fromJson(x))),
        currentPage: json["current_page"],
        totalPage: json["totalPage"],
        message: json["message"],
        total: json["total"],
      );
}

class KunjunganPasienResume {
  int? id;
  String? nomorRegistrasi;
  String? tanggalKunjungan;
  String? keluhan;
  List<DiagnosaResume>? diagnosa;
  List<PetugasResume>? petugas;
  Pasien? pasien;

  KunjunganPasienResume({
    this.id,
    this.nomorRegistrasi,
    this.tanggalKunjungan,
    this.keluhan,
    this.diagnosa,
    this.petugas,
    this.pasien,
  });

  factory KunjunganPasienResume.fromJson(Map<String, dynamic> json) =>
      KunjunganPasienResume(
          id: json["id"],
          nomorRegistrasi: json["nomor_registrasi"],
          tanggalKunjungan: json["tanggal_kunjungan"],
          keluhan: json["keluhan"],
          diagnosa: List<DiagnosaResume>.from(
              json["diagnosa"].map((x) => DiagnosaResume.fromJson(x))),
          petugas: List<PetugasResume>.from(
              json["petugas"].map((x) => PetugasResume.fromJson(x))),
          pasien: Pasien.fromJson(
            json["pasien"],
          ));
}

class PetugasResume {
  int? id;
  String? nama;
  String? profesi;

  PetugasResume({
    this.id,
    this.nama,
    this.profesi,
  });

  factory PetugasResume.fromJson(Map<String, dynamic> json) => PetugasResume(
        id: json["id"],
        nama: json["nama"],
        profesi: json["profesi"],
      );
}

class DiagnosaResume {
  int id;
  String namaDiagnosa;
  String kodeIcd10;

  DiagnosaResume({
    required this.id,
    required this.namaDiagnosa,
    required this.kodeIcd10,
  });

  factory DiagnosaResume.fromJson(Map<String, dynamic> json) => DiagnosaResume(
        id: json["id"],
        namaDiagnosa: json["nama_diagnosa"],
        kodeIcd10: json["kode_icd_10"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "nama_diagnosa": namaDiagnosa,
        "kode_icd_10": kodeIcd10,
      };
}

String pencarianRiwayatResumeModelToJson(PencarianRiwayatResumeModel data) =>
    json.encode(data.toJson());

class PencarianRiwayatResumeModel {
  String tanggal;

  PencarianRiwayatResumeModel({
    required this.tanggal,
  });

  Map<String, dynamic> toJson() => {
        "tanggal": tanggal,
      };
}
