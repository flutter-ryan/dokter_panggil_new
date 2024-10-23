import 'dart:convert';

import 'package:dokter_panggil/src/models/master_tindakan_rad_create_mode.dart';

String masterTindakanRadCariModelToJson(MasterTindakanRadCariModel data) =>
    json.encode(data.toJson());

class MasterTindakanRadCariModel {
  String filter;

  MasterTindakanRadCariModel({
    required this.filter,
  });

  Map<String, dynamic> toJson() => {
        "filter": filter,
      };
}

ResponseMasterTindakanRadCariModel responseMasterTindakanRadCariModelFromJson(
        dynamic str) =>
    ResponseMasterTindakanRadCariModel.fromJson(str);

class ResponseMasterTindakanRadCariModel {
  List<MasterTindakanRad>? data;
  String? message;

  ResponseMasterTindakanRadCariModel({
    this.data,
    this.message,
  });

  factory ResponseMasterTindakanRadCariModel.fromJson(
          Map<String, dynamic> json) =>
      ResponseMasterTindakanRadCariModel(
        data: List<MasterTindakanRad>.from(
            json["data"].map((x) => MasterTindakanRad.fromJson(x))),
        message: json["message"],
      );
}
