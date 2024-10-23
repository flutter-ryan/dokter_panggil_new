import 'dart:convert';

String masterBhpPencarianModelToJson(MasterBhpPencarianModel data) =>
    json.encode(data.toJson());

class MasterBhpPencarianModel {
  MasterBhpPencarianModel({
    required this.namaBarang,
  });

  String namaBarang;

  Map<String, dynamic> toJson() => {
        "namaBarang": namaBarang,
      };
}
