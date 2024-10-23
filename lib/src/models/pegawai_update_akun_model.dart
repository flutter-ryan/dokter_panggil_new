import 'dart:convert';

String pegawaiUpdateAkunModelToJson(PegawaiUpdateAkunModel data) =>
    json.encode(data.toJson());

class PegawaiUpdateAkunModel {
  PegawaiUpdateAkunModel({
    required this.password,
    required this.name,
    required this.passwordConfirmation,
  });

  String password;
  String name;
  String passwordConfirmation;

  Map<String, dynamic> toJson() => {
        "name": name,
        "password": password,
        "password_confirmation": passwordConfirmation,
      };
}

ResponsePegawaiUpdateAkunModel responsePegawaiUpdateAkunModelFromJson(
        dynamic str) =>
    ResponsePegawaiUpdateAkunModel.fromJson(str);

class ResponsePegawaiUpdateAkunModel {
  ResponsePegawaiUpdateAkunModel({
    this.message,
  });

  String? message;

  factory ResponsePegawaiUpdateAkunModel.fromJson(Map<String, dynamic> json) =>
      ResponsePegawaiUpdateAkunModel(
        message: json["message"],
      );
}
