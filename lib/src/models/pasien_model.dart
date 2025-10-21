import 'dart:convert';

import 'package:admin_dokter_panggil/src/models/pasien_show_model.dart';

String pasienModelToJson(PasienModel data) => json.encode(data.toJson());

class PasienModel {
  PasienModel({
    required this.nik,
    required this.jenis,
    required this.namaPasien,
    required this.tempatLahir,
    required this.tanggalLahir,
    required this.alamat,
    required this.jenisKelamin,
    required this.nomorHp,
  });

  String nik;
  String jenis;
  String namaPasien;
  String tempatLahir;
  String tanggalLahir;
  String alamat;
  String jenisKelamin;
  String nomorHp;

  Map<String, dynamic> toJson() => {
        "nik": nik,
        "jenis": jenis,
        "namaPasien": namaPasien,
        "tempatLahir": tempatLahir,
        "tanggalLahir": tanggalLahir,
        "alamat": alamat,
        "jenisKelamin": jenisKelamin,
        "nomorHp": nomorHp,
      };
}

ResponsePasienModel responsePasienModelFromJson(dynamic str) =>
    ResponsePasienModel.fromJson(str);

class ResponsePasienModel {
  ResponsePasienModel({
    this.message,
    this.data,
  });

  String? message;
  Pasien? data;

  factory ResponsePasienModel.fromJson(Map<String, dynamic> json) =>
      ResponsePasienModel(
        message: json["message"],
        data: Pasien.fromJson(json['data']),
      );
}
