import 'dart:convert';

String barangFarmasiModelToJson(BarangFarmasiModel data) =>
    json.encode(data.toJson());

class BarangFarmasiModel {
  BarangFarmasiModel({
    required this.barang,
    required this.harga,
    required this.persen,
    required this.mitra,
  });

  String barang;
  int harga;
  int persen;
  int mitra;

  Map<String, dynamic> toJson() => {
        "barang": barang,
        "harga": harga,
        "persen": persen,
        "mitra": mitra,
      };
}

ResponseBarangFarmasiModel responseBarangFarmasiModelFromJson(dynamic str) =>
    ResponseBarangFarmasiModel.fromJson(str);

class ResponseBarangFarmasiModel {
  ResponseBarangFarmasiModel({
    this.message,
  });

  String? message;

  factory ResponseBarangFarmasiModel.fromJson(Map<String, dynamic> json) =>
      ResponseBarangFarmasiModel(
        message: json["message"],
      );
}
