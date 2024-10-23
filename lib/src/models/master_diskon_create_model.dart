import 'dart:convert';

String masterDiskonCreateModelToJson(MasterDiskonCreateModel data) =>
    json.encode(data.toJson());

class MasterDiskonCreateModel {
  MasterDiskonCreateModel({
    required this.filter,
  });

  String filter;

  Map<String, dynamic> toJson() => {
        "filter": filter,
      };
}

ResponseMasterDiskonCreateModel responseMasterDiskonCreateModelFromJson(
        dynamic str) =>
    ResponseMasterDiskonCreateModel.fromJson(str);

class ResponseMasterDiskonCreateModel {
  ResponseMasterDiskonCreateModel({
    this.data,
    this.message,
  });

  List<MasterDiskon>? data;
  String? message;

  factory ResponseMasterDiskonCreateModel.fromJson(Map<String, dynamic> json) =>
      ResponseMasterDiskonCreateModel(
        data: List<MasterDiskon>.from(
            json["data"].map((x) => MasterDiskon.fromJson(x))),
        message: json["message"],
      );
}

class MasterDiskon {
  MasterDiskon({
    required this.id,
    required this.deskripsi,
    required this.nilai,
    required this.isPersen,
  });

  int id;
  String deskripsi;
  int nilai;
  int isPersen;

  factory MasterDiskon.fromJson(Map<String, dynamic> json) => MasterDiskon(
        id: json["id"],
        deskripsi: json["deskripsi"],
        nilai: json["nilai"],
        isPersen: json["isPersen"],
      );
}
