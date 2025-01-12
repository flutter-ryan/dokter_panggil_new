import 'dart:convert';

import 'package:dokter_panggil/src/models/pasien_kunjungan_detail_model.dart';

TagihanResepOralUpdateModel tagihanResepOralUpdateModelFromJson(dynamic str) =>
    TagihanResepOralUpdateModel.fromJson(str);

class TagihanResepOralUpdateModel {
  DetailKunjungan? data;
  String? message;

  TagihanResepOralUpdateModel({
    this.data,
    this.message,
  });

  factory TagihanResepOralUpdateModel.fromJson(Map<String, dynamic> json) =>
      TagihanResepOralUpdateModel(
        data: json["data"] == null
            ? null
            : DetailKunjungan.fromJson(json["data"]),
        message: json["message"],
      );
}

String tagihanResepOralRequestUpdateModelToJson(
        TagihanResepOralRequestUpdateModel data) =>
    json.encode(data.toJson());

class TagihanResepOralRequestUpdateModel {
  int jumlah;

  TagihanResepOralRequestUpdateModel({
    required this.jumlah,
  });

  Map<String, dynamic> toJson() => {
        "jumlah": jumlah,
      };
}
