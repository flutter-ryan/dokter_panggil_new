import 'dart:convert';

CetakStokOpnameModel cetakStokOpnameModelFromJson(dynamic str) =>
    CetakStokOpnameModel.fromJson(str);

class CetakStokOpnameModel {
  CetakStokOpname? data;
  String? message;

  CetakStokOpnameModel({
    this.data,
    this.message,
  });

  factory CetakStokOpnameModel.fromJson(Map<String, dynamic> json) =>
      CetakStokOpnameModel(
        data: json["data"] == null
            ? null
            : CetakStokOpname.fromJson(json["data"]),
        message: json["message"],
      );
}

class CetakStokOpname {
  int? id;
  String? link;
  String? size;
  String? periode;

  CetakStokOpname({
    this.id,
    this.link,
    this.size,
    this.periode,
  });

  factory CetakStokOpname.fromJson(Map<String, dynamic> json) =>
      CetakStokOpname(
        id: json["id"],
        link: json["link"],
        size: json["size"],
        periode: json["periode"],
      );
}

String cetakStokOpnameRequestModelToJson(CetakStokOpnameRequestModel data) =>
    json.encode(data.toJson());

class CetakStokOpnameRequestModel {
  String from;
  String to;

  CetakStokOpnameRequestModel({
    required this.from,
    required this.to,
  });

  Map<String, dynamic> toJson() => {
        "from": from,
        "to": to,
      };
}
