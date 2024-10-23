import 'dart:convert';

LaporanHarianModel laporanHarianModelFromJson(dynamic str) =>
    LaporanHarianModel.fromJson(str);

class LaporanHarianModel {
  List<LaporanHarian>? data;
  String? message;

  LaporanHarianModel({
    this.data,
    this.message,
  });

  factory LaporanHarianModel.fromJson(Map<String, dynamic> json) =>
      LaporanHarianModel(
        data: List<LaporanHarian>.from(
            json["data"]!.map((x) => LaporanHarian.fromJson(x))),
        message: json["message"],
      );
}

class LaporanHarian {
  int? id;
  DateTime? from;
  DateTime? to;
  String? url;
  String? convert;

  LaporanHarian({
    this.id,
    this.from,
    this.to,
    this.url,
    this.convert,
  });

  factory LaporanHarian.fromJson(Map<String, dynamic> json) => LaporanHarian(
        id: json["id"],
        from: json["from"] == null ? null : DateTime.parse(json["from"]),
        to: json["to"] == null ? null : DateTime.parse(json["to"]),
        url: json["url"],
        convert: json["convert"],
      );
}

String laporanHarianRequestModelToJson(LaporanHarianRequestModel data) =>
    json.encode(data.toJson());

class LaporanHarianRequestModel {
  String from;
  String to;
  String convert;

  LaporanHarianRequestModel({
    required this.from,
    required this.to,
    required this.convert,
  });

  Map<String, dynamic> toJson() => {
        "from": from,
        "to": to,
        "convert": convert,
      };
}

ResponseLaporanHarianRequestModel responseLaporanHarianRequestModelFromJson(
        dynamic str) =>
    ResponseLaporanHarianRequestModel.fromJson(str);

class ResponseLaporanHarianRequestModel {
  LaporanHarian? data;
  String? message;

  ResponseLaporanHarianRequestModel({
    this.data,
    this.message,
  });

  factory ResponseLaporanHarianRequestModel.fromJson(
          Map<String, dynamic> json) =>
      ResponseLaporanHarianRequestModel(
        data:
            json["data"] == null ? null : LaporanHarian.fromJson(json["data"]),
        message: json["message"],
      );
}
