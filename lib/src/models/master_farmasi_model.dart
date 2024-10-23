import 'dart:convert';

String masterFarmasiModelToJson(MasterFarmasiModel data) =>
    json.encode(data.toJson());

class MasterFarmasiModel {
  MasterFarmasiModel({
    required this.barang,
    required this.harga,
    required this.persen,
    required this.mitra,
  });

  String barang;
  int harga;
  String persen;
  int mitra;

  Map<String, dynamic> toJson() => {
        "barang": barang,
        "harga": harga,
        "persen": persen,
        "mitra": mitra,
      };
}

ResponseMasterFarmasiModel responseMasterFarmasiModelFromJson(dynamic str) =>
    ResponseMasterFarmasiModel.fromJson(str);

class ResponseMasterFarmasiModel {
  ResponseMasterFarmasiModel({
    this.message,
  });

  String? message;

  factory ResponseMasterFarmasiModel.fromJson(Map<String, dynamic> json) =>
      ResponseMasterFarmasiModel(
        message: json["message"],
      );
}
