import 'dart:convert';

MasterVillageModel masterVillageModelFromJson(dynamic str) =>
    MasterVillageModel.fromJson(str);

class MasterVillageModel {
  List<Village>? data;
  String? message;

  MasterVillageModel({
    this.data,
    this.message,
  });

  factory MasterVillageModel.fromJson(Map<String, dynamic> json) =>
      MasterVillageModel(
        data: json["data"] == null
            ? []
            : List<Village>.from(json["data"]!.map((x) => Village.fromJson(x))),
        message: json["message"],
      );
}

class Village {
  int? id;
  String? name;
  Propinsi? propinsi;
  Kabupaten? kabupaten;
  Kabupaten? kecamatan;

  Village({
    this.id,
    this.name,
    this.propinsi,
    this.kabupaten,
    this.kecamatan,
  });

  factory Village.fromJson(Map<String, dynamic> json) => Village(
        id: json["id"],
        name: json["name"],
        propinsi: json["propinsi"] == null
            ? null
            : Propinsi.fromJson(json["propinsi"]),
        kabupaten: json["kabupaten"] == null
            ? null
            : Kabupaten.fromJson(json["kabupaten"]),
        kecamatan: json["kecamatan"] == null
            ? null
            : Kabupaten.fromJson(json["kecamatan"]),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "propinsi": propinsi?.toJson(),
        "kabupaten": kabupaten?.toJson(),
        "kecamatan": kecamatan?.toJson(),
      };
}

class Kabupaten {
  String? id;
  String? name;

  Kabupaten({
    this.id,
    this.name,
  });

  factory Kabupaten.fromJson(Map<String, dynamic> json) => Kabupaten(
        id: json["id"],
        name: json["name"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
      };
}

class Propinsi {
  String? id;
  String? nama;

  Propinsi({
    this.id,
    this.nama,
  });

  factory Propinsi.fromJson(Map<String, dynamic> json) => Propinsi(
        id: json["id"],
        nama: json["nama"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "nama": nama,
      };
}

String masterVillageRequestModelToJson(MasterVillageRequestModel data) =>
    json.encode(data.toJson());

class MasterVillageRequestModel {
  String filter;

  MasterVillageRequestModel({
    required this.filter,
  });

  Map<String, dynamic> toJson() => {
        "filter": filter,
      };
}
