import 'dart:convert';

import 'package:dokter_panggil/src/models/current_user_model.dart';

String currentUserUpdateModelToJson(CurrentUserUpdateModel data) =>
    json.encode(data.toJson());

class CurrentUserUpdateModel {
  String name;
  String email;
  String password;
  String confirmationPassword;

  CurrentUserUpdateModel({
    required this.name,
    required this.email,
    required this.password,
    required this.confirmationPassword,
  });

  Map<String, dynamic> toJson() => {
        "name": name,
        "email": email,
        "password": password,
        "password_confirmation": confirmationPassword,
      };
}

ResponseCurrentUserUpdateModel responseCurrentUserUpdateModelFromJson(
        dynamic str) =>
    ResponseCurrentUserUpdateModel.fromJson(str);

class ResponseCurrentUserUpdateModel {
  CurrentUser? data;
  String? message;

  ResponseCurrentUserUpdateModel({
    this.data,
    this.message,
  });

  factory ResponseCurrentUserUpdateModel.fromJson(Map<String, dynamic> json) =>
      ResponseCurrentUserUpdateModel(
        data: CurrentUser.fromJson(json["data"]),
        message: json["message"],
      );
}
