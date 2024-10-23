import 'dart:convert';

String mitraModelToJson(MitraModel data) => json.encode(data.toJson());

class MitraModel {
  MitraModel({
    required this.mitra,
    required this.kode,
    required this.jenis,
    required this.persentase,
  });

  String mitra;
  String kode;
  String jenis;
  int persentase;

  Map<String, dynamic> toJson() => {
        "mitra": mitra,
        "kode": kode,
        "jenis": jenis,
        "persentase": persentase,
      };
}

ResponseMitraModel responseMitraModelFromJson(dynamic str) =>
    ResponseMitraModel.fromJson(str);

class ResponseMitraModel {
  ResponseMitraModel({
    this.message,
  });

  String? message;

  factory ResponseMitraModel.fromJson(Map<String, dynamic> json) =>
      ResponseMitraModel(
        message: json["message"],
      );
}
