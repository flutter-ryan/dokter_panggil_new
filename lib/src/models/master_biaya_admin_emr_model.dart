import 'dart:convert';

MasterBiayaAdminEmrModel masterBiayaAdminEmrModelFromJson(dynamic str) =>
    MasterBiayaAdminEmrModel.fromJson(str);

class MasterBiayaAdminEmrModel {
  List<MasterBiayaAdminEmr>? data;
  String? message;

  MasterBiayaAdminEmrModel({
    this.data,
    this.message,
  });

  factory MasterBiayaAdminEmrModel.fromJson(Map<String, dynamic> json) =>
      MasterBiayaAdminEmrModel(
        data: json["data"] == null
            ? []
            : List<MasterBiayaAdminEmr>.from(
                json["data"]!.map((x) => MasterBiayaAdminEmr.fromJson(x))),
        message: json["message"],
      );
}

class MasterBiayaAdminEmr {
  int? id;
  String? deskripsi;
  int? nilai;
  int? persen;
  String? layanan;

  MasterBiayaAdminEmr({
    this.id,
    this.deskripsi,
    this.nilai,
    this.persen,
    this.layanan,
  });

  factory MasterBiayaAdminEmr.fromJson(Map<String, dynamic> json) =>
      MasterBiayaAdminEmr(
        id: json["id"],
        deskripsi: json["deskripsi"],
        nilai: json["nilai"],
        persen: json["persen"],
        layanan: json["layanan"],
      );
}

String masterBiayaAdminEmrRequestModelToJson(
        MasterBiayaAdminEmrRequestModel data) =>
    json.encode(data.toJson());

class MasterBiayaAdminEmrRequestModel {
  String layanan;

  MasterBiayaAdminEmrRequestModel({
    required this.layanan,
  });

  Map<String, dynamic> toJson() => {
        "layanan": layanan,
      };
}
