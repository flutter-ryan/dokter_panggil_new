import 'dart:convert';

import 'package:admin_dokter_panggil/src/models/pasien_kunjungan_detail_model.dart';
import 'package:admin_dokter_panggil/src/models/resume_medis_pasien_model.dart';

String resumePemeriksaanPasienModelToJson(ResumePemeriksaanPasienModel data) =>
    json.encode(data.toJson());

class ResumePemeriksaanPasienModel {
  int idKunjungan;
  int idPetugas;

  ResumePemeriksaanPasienModel({
    required this.idKunjungan,
    required this.idPetugas,
  });

  Map<String, dynamic> toJson() => {
        "idKunjungan": idKunjungan,
        "idPetugas": idPetugas,
      };
}

ResponseResumePemeriksaanPasienModel
    responseResumePemeriksaanPasienModelFromJson(dynamic str) =>
        ResponseResumePemeriksaanPasienModel.fromJson(str);

class ResponseResumePemeriksaanPasienModel {
  ResumePemeriksaanPasien? data;
  String? message;

  ResponseResumePemeriksaanPasienModel({
    this.data,
    this.message,
  });

  factory ResponseResumePemeriksaanPasienModel.fromJson(
          Map<String, dynamic> json) =>
      ResponseResumePemeriksaanPasienModel(
        data: ResumePemeriksaanPasien.fromJson(json["data"]),
        message: json["message"],
      );
}

class ResumePemeriksaanPasien {
  int? id;
  String? nomorRegistrasi;
  List<Tindakan>? kunjunganTindakan;
  List<KunjunganAnamnesaDokter>? anamnesaDokter;
  List<KunjunganAnamnesaPerawat>? anamnesaPerawat;
  List<KunjunganPemeriksaanFisikDokter>? fisikDokter;
  List<KunjunganPemeriksaanFisikPerawat>? fisikPerawat;
  List<Resep>? resep;
  List<ResepRacikan>? resepRacikan;
  List<DiagnosaDokter>? diagnosaDokter;
  List<DiagnosaPerawat>? diagnosaPerawat;
  List<Bhp>? bhp;
  List<KunjunganObatInjeksi>? obatInjeksi;
  List<TindakanLab>? tindakanLab;
  List<TindakanRad>? tindakanRad;
  List<ImplementasiPerawat>? implementasiPerawat;
  List<PlanningPerawat>? planningPerawat;

  ResumePemeriksaanPasien({
    this.id,
    this.nomorRegistrasi,
    this.kunjunganTindakan,
    this.anamnesaDokter,
    this.anamnesaPerawat,
    this.fisikDokter,
    this.fisikPerawat,
    this.resep,
    this.resepRacikan,
    this.diagnosaDokter,
    this.diagnosaPerawat,
    this.bhp,
    this.obatInjeksi,
    this.tindakanLab,
    this.tindakanRad,
    this.implementasiPerawat,
    this.planningPerawat,
  });

  factory ResumePemeriksaanPasien.fromJson(Map<String, dynamic> json) =>
      ResumePemeriksaanPasien(
        id: json["id"],
        nomorRegistrasi: json["nomor_registrasi"],
        kunjunganTindakan: List<Tindakan>.from(
            json["kunjungan_tindakan"].map((x) => Tindakan.fromJson(x))),
        anamnesaDokter: List<KunjunganAnamnesaDokter>.from(
            json["anamnesa_dokter"]
                .map((x) => KunjunganAnamnesaDokter.fromJson(x))),
        anamnesaPerawat: List<KunjunganAnamnesaPerawat>.from(
            json["anamnesa_perawat"]
                .map((x) => KunjunganAnamnesaPerawat.fromJson(x))),
        fisikDokter: List<KunjunganPemeriksaanFisikDokter>.from(
            json["fisik_dokter"]
                .map((x) => KunjunganPemeriksaanFisikDokter.fromJson(x))),
        fisikPerawat: List<KunjunganPemeriksaanFisikPerawat>.from(
            json["fisik_perawat"]
                .map((x) => KunjunganPemeriksaanFisikPerawat.fromJson(x))),
        resep: List<Resep>.from(json["resep"].map((x) => Resep.fromJson(x))),
        resepRacikan: List<ResepRacikan>.from(
            json["resep_racikan"].map((x) => ResepRacikan.fromJson(x))),
        diagnosaDokter: List<DiagnosaDokter>.from(
            json["diagnosa_dokter"].map((x) => DiagnosaDokter.fromJson(x))),
        diagnosaPerawat: List<DiagnosaPerawat>.from(
            json["diagnosa_perawat"].map((x) => DiagnosaPerawat.fromJson(x))),
        bhp: List<Bhp>.from(json["bhp"].map((x) => Bhp.fromJson(x))),
        obatInjeksi: List<KunjunganObatInjeksi>.from(
            json["obat_injeksi"].map((x) => KunjunganObatInjeksi.fromJson(x))),
        tindakanLab: List<TindakanLab>.from(
            json["tindakan_lab"].map((x) => TindakanLab.fromJson(x))),
        tindakanRad: List<TindakanRad>.from(
            json["tindakan_rad"].map((x) => TindakanRad.fromJson(x))),
        implementasiPerawat: List<ImplementasiPerawat>.from(
            json["implementasi_perawat"]
                .map((x) => ImplementasiPerawat.fromJson(x))),
        planningPerawat: List<PlanningPerawat>.from(
            json["planning_perawat"].map((x) => PlanningPerawat.fromJson(x))),
      );
}

class DiagnosaDokter {
  int? id;
  int? diagnosa;
  String? namaDiagnosa;
  String? catatanDiagnosa;

  DiagnosaDokter({
    this.id,
    this.diagnosa,
    this.namaDiagnosa,
    this.catatanDiagnosa,
  });

  factory DiagnosaDokter.fromJson(Map<String, dynamic> json) => DiagnosaDokter(
        id: json["id"],
        diagnosa: json["diagnosa"],
        namaDiagnosa: json["nama_diagnosa"],
        catatanDiagnosa: json["catatan_diagnosa"],
      );
}

class DiagnosaPerawat {
  int? id;
  String? catatanDiagnosa;

  DiagnosaPerawat({
    this.id,
    this.catatanDiagnosa,
  });

  factory DiagnosaPerawat.fromJson(Map<String, dynamic> json) =>
      DiagnosaPerawat(
        id: json["id"],
        catatanDiagnosa: json["catatan_diagnosa"],
      );
}

class ImplementasiPerawat {
  int? id;
  PegawaiResume? perawat;
  String? tindakan;
  String? jam;

  ImplementasiPerawat({
    this.id,
    this.perawat,
    this.tindakan,
    this.jam,
  });

  factory ImplementasiPerawat.fromJson(Map<String, dynamic> json) =>
      ImplementasiPerawat(
        id: json["id"],
        perawat: json["perawat"] == null
            ? null
            : PegawaiResume.fromJson(json["perawat"]),
        tindakan: json["tindakan"],
        jam: json["jam"],
      );
}

class PlanningPerawat {
  int? id;
  PegawaiResume? pegawai;
  String? catatan;

  PlanningPerawat({
    this.id,
    this.pegawai,
    this.catatan,
  });

  factory PlanningPerawat.fromJson(Map<String, dynamic> json) =>
      PlanningPerawat(
        id: json["id"],
        pegawai: json["pegawai"] == null
            ? null
            : PegawaiResume.fromJson(json["pegawai"]),
        catatan: json["catatan"],
      );
}
