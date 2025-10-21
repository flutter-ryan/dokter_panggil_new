import 'package:admin_dokter_panggil/src/models/master_bhp_model.dart';

MasterBhpKategoriModel masterBhpKategoriModelFromJson(dynamic str) =>
    MasterBhpKategoriModel.fromJson(str);

class MasterBhpKategoriModel {
  MasterBhpKategoriModel({
    this.message,
    this.data,
  });

  final String? message;
  final List<MasterBhp>? data;

  factory MasterBhpKategoriModel.fromJson(Map<String, dynamic> json) =>
      MasterBhpKategoriModel(
        data: List<MasterBhp>.from(json["data"].map(
          (x) => MasterBhp.fromJson(x),
        )),
        message: json["message"],
      );
}
