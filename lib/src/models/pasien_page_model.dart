import 'package:dokter_panggil/src/models/pasien_filter_model.dart';

PasienPageModel pasienPageModelFromJson(dynamic str) =>
    PasienPageModel.fromJson(str);

class PasienPageModel {
  PasienPageModel({
    this.data,
    this.currentPage,
    this.totalPage,
    this.message,
  });

  List<PasienFilter>? data;
  int? currentPage;
  int? totalPage;
  String? message;

  factory PasienPageModel.fromJson(Map<String, dynamic> json) =>
      PasienPageModel(
        data: List<PasienFilter>.from(
            json["data"].map((x) => PasienFilter.fromJson(x))),
        currentPage: json["current_page"],
        totalPage: json["totalPage"],
        message: json["message"],
      );
}
