import 'dart:convert';

MasterRoleModel masterRoleModelFromJson(dynamic str) =>
    MasterRoleModel.fromJson(str);

class MasterRoleModel {
  List<MasterRole>? data;
  String? message;

  MasterRoleModel({
    this.data,
    this.message,
  });

  factory MasterRoleModel.fromJson(Map<String, dynamic> json) =>
      MasterRoleModel(
        data: List<MasterRole>.from(
            json["data"]!.map((x) => MasterRole.fromJson(x))),
        message: json["message"],
      );
}

class MasterRole {
  int? id;
  String? deskripsi;
  int? role;

  MasterRole({
    this.id,
    this.deskripsi,
    this.role,
  });

  factory MasterRole.fromJson(Map<String, dynamic> json) => MasterRole(
        id: json["id"],
        deskripsi: json["deskripsi"],
        role: json["role"],
      );
}

String masterRoleRequestModelToJson(MasterRoleRequestModel data) =>
    json.encode(data.toJson());

class MasterRoleRequestModel {
  String deskripsi;
  int role;

  MasterRoleRequestModel({
    required this.deskripsi,
    required this.role,
  });

  Map<String, dynamic> toJson() => {
        "deskripsi": deskripsi,
        "role": role,
      };
}

ResponseMasterRoleRequestModel responseMasterRoleRequestModelFromJson(
        dynamic str) =>
    ResponseMasterRoleRequestModel.fromJson(str);

class ResponseMasterRoleRequestModel {
  MasterRole? data;
  String? message;

  ResponseMasterRoleRequestModel({
    this.data,
    this.message,
  });

  factory ResponseMasterRoleRequestModel.fromJson(Map<String, dynamic> json) =>
      ResponseMasterRoleRequestModel(
        data: json["data"] == null ? null : MasterRole.fromJson(json["data"]),
        message: json["message"],
      );
}
