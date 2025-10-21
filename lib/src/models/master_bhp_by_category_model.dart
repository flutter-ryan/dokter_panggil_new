import 'package:admin_dokter_panggil/src/models/master_bhp_model.dart';

MasterBhpByCategoryModel masterBhpByCategoryModelFromJson(dynamic str) =>
    MasterBhpByCategoryModel.fromJson(str);

class MasterBhpByCategoryModel {
  MasterBhpByCategoryModel({
    this.data,
    this.message,
  });

  List<MasterBhp>? data;
  String? message;

  factory MasterBhpByCategoryModel.fromJson(Map<String, dynamic> json) =>
      MasterBhpByCategoryModel(
        data: List<MasterBhp>.from(
            json["data"].map((x) => MasterBhp.fromJson(x))),
        message: json["message"],
      );
}
