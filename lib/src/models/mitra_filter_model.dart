import 'dart:convert';

String mitraFilterModelToJson(MitraFilterModel data) =>
    json.encode(data.toJson());

class MitraFilterModel {
  MitraFilterModel({
    required this.filter,
    required this.jenis,
  });

  String filter;
  String jenis;

  Map<String, dynamic> toJson() => {
        "filter": filter,
        "jenis": jenis,
      };
}

ResponseMitraFilterModel responseMitraFilterModelFromJson(dynamic str) =>
    ResponseMitraFilterModel.fromJson(str);

class ResponseMitraFilterModel {
  ResponseMitraFilterModel({
    this.mitra,
    this.message,
  });

  List<MitraFilter>? mitra;
  String? message;

  factory ResponseMitraFilterModel.fromJson(Map<String, dynamic> json) =>
      ResponseMitraFilterModel(
        mitra: List<MitraFilter>.from(
            json["data"].map((x) => MitraFilter.fromJson(x))),
        message: json["message"],
      );
}

class MitraFilter {
  MitraFilter({
    this.id,
    this.namaMitra,
    this.kode,
    this.jenis,
    this.persentase,
  });

  int? id;
  String? namaMitra;
  String? kode;
  String? jenis;
  String? persentase;

  factory MitraFilter.fromJson(Map<String, dynamic> json) => MitraFilter(
        id: json["id"],
        namaMitra: json["nama_mitra"],
        kode: json["kode"],
        jenis: json["jenis"],
        persentase: json["persentase"],
      );
}
