import 'dart:convert';

MasterIdentitasModel masterIdentitasModelFromJson(dynamic str) =>
    MasterIdentitasModel.fromJson(str);

class MasterIdentitasModel {
  List<MasterIdentitas>? data;
  String? message;

  MasterIdentitasModel({
    this.data,
    this.message,
  });

  factory MasterIdentitasModel.fromJson(Map<String, dynamic> json) =>
      MasterIdentitasModel(
        data: json["data"] == null
            ? []
            : List<MasterIdentitas>.from(
                json["data"]!.map((x) => MasterIdentitas.fromJson(x))),
        message: json["message"],
      );
}

class MasterIdentitas {
  int? id;
  String? jenis;

  MasterIdentitas({
    this.id,
    this.jenis,
  });

  factory MasterIdentitas.fromJson(Map<String, dynamic> json) =>
      MasterIdentitas(
        id: json["id"],
        jenis: json["jenis"],
      );
}

String masterIdentitasRequestModelToJson(MasterIdentitasRequestModel data) =>
    json.encode(data.toJson());

class MasterIdentitasRequestModel {
  String jenis;

  MasterIdentitasRequestModel({
    required this.jenis,
  });
  Map<String, dynamic> toJson() => {
        "jenis": jenis,
      };
}

ResponseMasterIdentitasRequestModel responseMasterIdentitasRequestModelFromJson(
        dynamic str) =>
    ResponseMasterIdentitasRequestModel.fromJson(str);

class ResponseMasterIdentitasRequestModel {
  MasterIdentitas? data;
  String? message;

  ResponseMasterIdentitasRequestModel({
    this.data,
    this.message,
  });

  factory ResponseMasterIdentitasRequestModel.fromJson(
          Map<String, dynamic> json) =>
      ResponseMasterIdentitasRequestModel(
        data: json["data"] == null
            ? null
            : MasterIdentitas.fromJson(json["data"]),
        message: json["message"],
      );
}

String masterIdentitasFilterModelToJson(MasterIdentitasFilterModel data) =>
    json.encode(data.toJson());

class MasterIdentitasFilterModel {
  String filter;

  MasterIdentitasFilterModel({
    required this.filter,
  });

  Map<String, dynamic> toJson() => {
        "filter": filter,
      };
}
