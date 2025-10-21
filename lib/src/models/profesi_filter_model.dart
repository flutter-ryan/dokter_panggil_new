import 'dart:convert';

import 'package:admin_dokter_panggil/src/models/master_group_jabatan_model.dart';

String profesiFilterModelToJson(ProfesiFilterModel data) =>
    json.encode(data.toJson());

class ProfesiFilterModel {
  ProfesiFilterModel({
    required this.filter,
  });

  String filter;

  Map<String, dynamic> toJson() => {
        "filter": filter,
      };
}

ResponseProfesiFilterModel responseProfesiFilterModelFromJson(dynamic str) =>
    ResponseProfesiFilterModel.fromJson(str);

class ResponseProfesiFilterModel {
  ResponseProfesiFilterModel({
    this.profesi,
    this.message,
  });

  List<Profesi>? profesi;
  String? message;

  factory ResponseProfesiFilterModel.fromJson(Map<String, dynamic> json) =>
      ResponseProfesiFilterModel(
        profesi:
            List<Profesi>.from(json["data"].map((x) => Profesi.fromJson(x))),
        message: json["message"],
      );
}

class Profesi {
  Profesi({
    this.id,
    this.namaJabatan,
    this.group,
  });

  int? id;
  String? namaJabatan;
  MasterGroupJabatan? group;

  factory Profesi.fromJson(Map<String, dynamic> json) => Profesi(
        id: json["id"],
        namaJabatan: json["nama_jabatan"],
        group: MasterGroupJabatan.fromJson(json["group"]),
      );
}
