import 'dart:convert';

String tindakanFilterModelToJson(TindakanFilterModel data) =>
    json.encode(data.toJson());

class TindakanFilterModel {
  TindakanFilterModel({
    required this.filter,
  });

  String filter;

  Map<String, dynamic> toJson() => {
        "filter": filter,
      };
}

ResponseTindakanFilterModel responseTindakanFilterModelFromJson(dynamic str) =>
    ResponseTindakanFilterModel.fromJson(str);

class ResponseTindakanFilterModel {
  ResponseTindakanFilterModel({
    this.tindakan,
    this.message,
  });

  List<TindakanFilter>? tindakan;
  String? message;

  factory ResponseTindakanFilterModel.fromJson(Map<String, dynamic> json) =>
      ResponseTindakanFilterModel(
        tindakan: List<TindakanFilter>.from(
            json["data"].map((x) => TindakanFilter.fromJson(x))),
        message: json["message"],
      );
}

class TindakanFilter {
  TindakanFilter({
    this.id,
    this.namaTindakan,
    this.jasaDokter,
    this.jasaDokterPanggil,
    this.tarif,
  });

  int? id;
  String? namaTindakan;
  int? jasaDokter;
  int? jasaDokterPanggil;
  int? tarif;

  factory TindakanFilter.fromJson(Map<String, dynamic> json) => TindakanFilter(
        id: json["id"],
        namaTindakan: json["nama_tindakan"],
        jasaDokter: json["jasa_dokter"],
        jasaDokterPanggil: json["jasa_admin_dokter_panggil"],
        tarif: json["tarif"],
      );
}
