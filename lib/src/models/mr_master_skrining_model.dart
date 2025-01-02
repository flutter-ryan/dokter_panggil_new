import 'dart:convert';

MrMasterSkriningModel mrMasterSkriningModelFromJson(dynamic str) =>
    MrMasterSkriningModel.fromJson(str);

class MrMasterSkriningModel {
  List<MasterSkrining>? data;
  String? message;

  MrMasterSkriningModel({
    this.data,
    this.message,
  });

  factory MrMasterSkriningModel.fromJson(Map<String, dynamic> json) =>
      MrMasterSkriningModel(
        data: json["data"] == null
            ? []
            : List<MasterSkrining>.from(
                json["data"]!.map((x) => MasterSkrining.fromJson(x))),
        message: json["message"],
      );
}

class MasterSkrining {
  int? id;
  String? skrining;
  String? warna;
  String? keputusan;

  MasterSkrining({
    this.id,
    this.skrining,
    this.warna,
    this.keputusan,
  });

  factory MasterSkrining.fromJson(Map<String, dynamic> json) => MasterSkrining(
        id: json["id"],
        skrining: json["skrining"],
        warna: json["warna"],
        keputusan: json["keputusan"],
      );
}

String mrMasterSkriningRequestModelToJson(MrMasterSkriningRequestModel data) =>
    json.encode(data.toJson());

class MrMasterSkriningRequestModel {
  String filter;

  MrMasterSkriningRequestModel({
    required this.filter,
  });

  Map<String, dynamic> toJson() => {
        "filter": filter,
      };
}
