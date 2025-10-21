import 'package:admin_dokter_panggil/src/models/pasien_kunjungan_detail_model.dart';

DeleteTagihanResepModel deleteTagihanResepModelFromJson(dynamic str) =>
    DeleteTagihanResepModel.fromJson(str);

class DeleteTagihanResepModel {
  DeleteTagihanResepModel({
    this.data,
    this.message,
  });

  DetailKunjungan? data;
  String? message;

  factory DeleteTagihanResepModel.fromJson(Map<String, dynamic> json) =>
      DeleteTagihanResepModel(
        data: DetailKunjungan.fromJson(json["data"]),
        message: json["message"],
      );
}
