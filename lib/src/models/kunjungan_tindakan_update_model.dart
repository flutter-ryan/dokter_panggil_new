import 'dart:convert';

import 'package:dokter_panggil/src/models/pasien_kunjungan_detail_model.dart';

String kunjunganTindakanUpdateModelToJson(KunjunganTindakanUpdateModel data) =>
    json.encode(data.toJson());

class KunjunganTindakanUpdateModel {
  KunjunganTindakanUpdateModel({
    required this.quantity,
  });

  int quantity;

  Map<String, dynamic> toJson() => {
        "quantity": quantity,
      };
}

ResponseKunjunganTindakanUpdateModel
    responseKunjunganTindakanUpdateModelFromJson(dynamic str) =>
        ResponseKunjunganTindakanUpdateModel.fromJson(str);

class ResponseKunjunganTindakanUpdateModel {
  ResponseKunjunganTindakanUpdateModel({
    this.message,
    this.data,
  });

  String? message;
  DetailKunjungan? data;

  factory ResponseKunjunganTindakanUpdateModel.fromJson(
          Map<String, dynamic> json) =>
      ResponseKunjunganTindakanUpdateModel(
        message: json["message"],
        data: DetailKunjungan.fromJson(json["data"]),
      );
}
