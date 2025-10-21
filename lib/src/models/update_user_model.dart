import 'dart:convert';

import 'package:admin_dokter_panggil/src/models/master_pegawai_fetch_model.dart';

String updateUserModelToJson(UpdateUserModel data) =>
    json.encode(data.toJson());

class UpdateUserModel {
  UpdateUserModel({
    required this.name,
    required this.email,
    required this.password,
    required this.passwordConfirmation,
    required this.role,
  });

  String name;
  String email;
  String password;
  String passwordConfirmation;
  int role;

  Map<String, dynamic> toJson() => {
        "name": name,
        "email": email,
        "password": password,
        "password_confirmation": passwordConfirmation,
        "role": role,
      };
}

ResponseUpdateUserModel responseUpdateUserModelFromJson(dynamic str) =>
    ResponseUpdateUserModel.fromJson(str);

class ResponseUpdateUserModel {
  ResponseUpdateUserModel({
    this.data,
    this.message,
  });

  MasterPegawai? data;
  String? message;

  factory ResponseUpdateUserModel.fromJson(Map<String, dynamic> json) =>
      ResponseUpdateUserModel(
        data: MasterPegawai.fromJson(json["data"]),
        message: json["message"],
      );
}
