import 'package:admin_dokter_panggil/src/models/pasien_kunjungan_detail_model.dart';

ResponseBatalPaketModel responseBatalPaketModelFromJson(dynamic str) =>
    ResponseBatalPaketModel.fromJson(str);

class ResponseBatalPaketModel {
  DetailKunjungan? data;
  String? message;

  ResponseBatalPaketModel({
    this.data,
    this.message,
  });

  factory ResponseBatalPaketModel.fromJson(Map<String, dynamic> json) =>
      ResponseBatalPaketModel(
        data: DetailKunjungan.fromJson(json["data"]),
        message: json["message"],
      );
}
