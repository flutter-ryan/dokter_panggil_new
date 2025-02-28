import 'dart:convert';

MrEresepModel mrEresepModelFromJson(dynamic str) => MrEresepModel.fromJson(str);

class MrEresepModel {
  MrEresep? data;
  String? message;

  MrEresepModel({
    this.data,
    this.message,
  });

  factory MrEresepModel.fromJson(Map<String, dynamic> json) => MrEresepModel(
        data: json["data"] == null ? null : MrEresep.fromJson(json["data"]),
        message: json["message"],
      );
}

class MrEresep {
  int? id;
  String? namaPasien;
  String? nomor;
  String? url;

  MrEresep({
    this.id,
    this.namaPasien,
    this.url,
    this.nomor,
  });

  factory MrEresep.fromJson(Map<String, dynamic> json) => MrEresep(
        id: json["id"],
        namaPasien: json["nama_pasien"],
        nomor: json["nomor"],
        url: json["url"],
      );
}

String mrEresepRequestModelToJson(MrEresepRequestModel data) =>
    json.encode(data.toJson());

class MrEresepRequestModel {
  int idResep;

  MrEresepRequestModel({
    required this.idResep,
  });

  Map<String, dynamic> toJson() => {
        "idResep": idResep,
      };
}
