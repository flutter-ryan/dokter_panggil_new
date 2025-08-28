import 'dart:convert';

import 'package:dokter_panggil/src/models/master_village_model.dart';

MrPasienSaveModel mrPasienSaveModelFromJson(dynamic str) =>
    MrPasienSaveModel.fromJson(str);

class MrPasienSaveModel {
  MrPasienSave? data;
  String? message;

  MrPasienSaveModel({
    this.data,
    this.message,
  });

  factory MrPasienSaveModel.fromJson(Map<String, dynamic> json) =>
      MrPasienSaveModel(
        data: json["data"] == null ? null : MrPasienSave.fromJson(json["data"]),
        message: json["message"],
      );
}

class MrPasienSave {
  int? id;
  String? norm;
  String? namaPasien;

  MrPasienSave({
    this.id,
    this.norm,
    this.namaPasien,
  });

  factory MrPasienSave.fromJson(Map<String, dynamic> json) => MrPasienSave(
        id: json["id"],
        norm: json["norm"],
        namaPasien: json["nama_pasien"],
      );
}

String mrPasienSaveRequestModelToJson(MrPasienSaveRequestModel data) =>
    json.encode(data.toJson());

class MrPasienSaveRequestModel {
  String nik;
  int jenis;
  String namaPasien;
  String tempatLahir;
  String tanggalLahir;
  String jenisKelamin;
  String alamat;
  Village village;
  String kodePos;
  String rt;
  String rw;
  String nomorHp;
  String namaDarurat;
  String nomorHpDarurat;
  int statusNikah;

  MrPasienSaveRequestModel({
    required this.nik,
    required this.jenis,
    required this.namaPasien,
    required this.tempatLahir,
    required this.tanggalLahir,
    required this.jenisKelamin,
    required this.alamat,
    required this.village,
    required this.kodePos,
    required this.rt,
    required this.rw,
    required this.nomorHp,
    required this.namaDarurat,
    required this.nomorHpDarurat,
    required this.statusNikah,
  });

  Map<String, dynamic> toJson() => {
        "nik": nik,
        "jenis": jenis,
        "namaPasien": namaPasien,
        "tempatLahir": tempatLahir,
        "tanggalLahir": tanggalLahir,
        "jenisKelamin": jenisKelamin,
        "alamat": alamat,
        "village": village.toJson(),
        "kodePos": kodePos,
        "rt": rt,
        "rw": rw,
        "nomorHp": nomorHp,
        "namaDarurat": namaDarurat,
        "nomorHpDarurat": nomorHpDarurat,
        "statusNikah": statusNikah,
      };
}
