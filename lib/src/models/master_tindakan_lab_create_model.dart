import 'package:admin_dokter_panggil/src/models/master_tindakan_lab_model.dart';

MasterTindakanLabCreateModel masterTindakanLabCreateModelFromJson(
        dynamic str) =>
    MasterTindakanLabCreateModel.fromJson(str);

class MasterTindakanLabCreateModel {
  MasterTindakanLabCreateModel({
    this.data,
    this.message,
  });

  List<MasterTindakanLab>? data;
  String? message;

  factory MasterTindakanLabCreateModel.fromJson(Map<String, dynamic> json) =>
      MasterTindakanLabCreateModel(
        data: List<MasterTindakanLab>.from(
            json["data"].map((x) => MasterTindakanLab.fromJson(x))),
        message: json["message"],
      );
}
