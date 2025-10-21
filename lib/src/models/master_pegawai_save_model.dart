import 'dart:convert';

import 'package:admin_dokter_panggil/src/models/master_pegawai_fetch_model.dart';

String masterPegawaiSaveModelToJson(MasterPegawaiSaveModel data) =>
    json.encode(data.toJson());

class MasterPegawaiSaveModel {
  MasterPegawaiSaveModel({
    required this.nama,
    required this.profesi,
    required this.email,
    required this.password,
    required this.passwordConfirmation,
    required this.nomorSip,
    required this.tanggalSip,
    required this.role,
  });

  String nama;
  int profesi;
  String email;
  String password;
  String passwordConfirmation;
  String nomorSip;
  String tanggalSip;
  int role;

  Map<String, dynamic> toJson() => {
        "nama": nama,
        "profesi": profesi,
        "email": email,
        "password": password,
        "password_confirmation": passwordConfirmation,
        "nomorSip": nomorSip,
        "tanggalSip": tanggalSip,
        "role": role,
      };
}

ResponseMasterPegawaiSaveModel responseMasterPegawaiSaveModelFromJson(
        dynamic str) =>
    ResponseMasterPegawaiSaveModel.fromJson(str);

class ResponseMasterPegawaiSaveModel {
  ResponseMasterPegawaiSaveModel({
    this.data,
    this.message,
  });

  MasterPegawai? data;
  String? message;

  factory ResponseMasterPegawaiSaveModel.fromJson(Map<String, dynamic> json) =>
      ResponseMasterPegawaiSaveModel(
        data: MasterPegawai.fromJson(json["data"]),
        message: json["message"],
      );
}
