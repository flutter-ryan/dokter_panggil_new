import 'dart:convert';

String profesiSaveModelToJson(ProfesiSaveModel data) =>
    json.encode(data.toJson());

class ProfesiSaveModel {
  ProfesiSaveModel({
    required this.profesi,
    required this.group,
  });

  String profesi;
  int group;

  Map<String, dynamic> toJson() => {
        "jabatan": profesi,
        "group": group,
      };
}

ResponseProfesiSaveModel responseProfesiSaveModelFromJson(dynamic str) =>
    ResponseProfesiSaveModel.fromJson(str);

class ResponseProfesiSaveModel {
  ResponseProfesiSaveModel({
    this.message,
  });

  String? message;

  factory ResponseProfesiSaveModel.fromJson(Map<String, dynamic> json) =>
      ResponseProfesiSaveModel(
        message: json["message"],
      );
}
