import 'dart:convert';

import 'package:dokter_panggil/src/models/master_bhp_model.dart';
import 'package:dokter_panggil/src/models/master_tindakan_lab_model.dart';

MasterBarangLabModel masterBarangLabModelFromJson(dynamic str) =>
    MasterBarangLabModel.fromJson(str);

class MasterBarangLabModel {
  List<MasterBarangLab>? data;
  String? message;

  MasterBarangLabModel({
    this.data,
    this.message,
  });

  factory MasterBarangLabModel.fromJson(Map<String, dynamic> json) =>
      MasterBarangLabModel(
        data: json["data"] == null
            ? []
            : List<MasterBarangLab>.from(
                json["data"]!.map((x) => MasterBarangLab.fromJson(x))),
        message: json["message"],
      );
}

class MasterBarangLab {
  int? id;
  MasterTindakanLab? tindakanLab;
  MasterBhp? barang;

  MasterBarangLab({
    this.id,
    this.tindakanLab,
    this.barang,
  });

  factory MasterBarangLab.fromJson(Map<String, dynamic> json) =>
      MasterBarangLab(
        id: json["id"],
        tindakanLab: json["tindakan_lab"] == null
            ? null
            : MasterTindakanLab.fromJson(json["tindakan_lab"]),
        barang:
            json["barang"] == null ? null : MasterBhp.fromJson(json["barang"]),
      );
}

String masterBarangLabRequestModelToJson(MasterBarangLabRequestModel data) =>
    json.encode(data.toJson());

class MasterBarangLabRequestModel {
  int barang;
  int tindakanLab;

  MasterBarangLabRequestModel({
    required this.barang,
    required this.tindakanLab,
  });

  Map<String, dynamic> toJson() => {
        "barang": barang,
        "tindakanLab": tindakanLab,
      };
}

ResponseMasterBarangLabModel responseMasterBarangLabModelFromJson(
        dynamic str) =>
    ResponseMasterBarangLabModel.fromJson(str);

class ResponseMasterBarangLabModel {
  MasterBarangLab? data;
  String? message;

  ResponseMasterBarangLabModel({
    this.data,
    this.message,
  });

  factory ResponseMasterBarangLabModel.fromJson(Map<String, dynamic> json) =>
      ResponseMasterBarangLabModel(
        data: MasterBarangLab.fromJson(json["data"]),
        message: json["message"],
      );
}

String masterBarangLabSaveModelToJson(MasterBarangLabSaveModel data) =>
    json.encode(data.toJson());

class MasterBarangLabSaveModel {
  int barang;
  List<int> tindakanLab;

  MasterBarangLabSaveModel({
    required this.barang,
    required this.tindakanLab,
  });

  Map<String, dynamic> toJson() => {
        "barang": barang,
        "tindakanLab": List<dynamic>.from(tindakanLab.map((x) => x)),
      };
}
