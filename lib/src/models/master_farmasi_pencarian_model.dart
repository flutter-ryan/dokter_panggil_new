import 'dart:convert';

String masterFarmasiPencarianModelToJson(MasterFarmasiPencarianModel data) =>
    json.encode(data.toJson());

class MasterFarmasiPencarianModel {
  MasterFarmasiPencarianModel({
    required this.namaBarang,
  });

  String namaBarang;

  Map<String, dynamic> toJson() => {
        "namaBarang": namaBarang,
      };
}
