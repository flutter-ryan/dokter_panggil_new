import 'dart:convert';

import 'package:admin_dokter_panggil/src/models/master_transportasi_tindakan_model.dart';

BiayaTransportasiTindakanModel biayaTransportasiTindakanModelFromJson(
        dynamic str) =>
    BiayaTransportasiTindakanModel.fromJson(str);

class BiayaTransportasiTindakanModel {
  BiayaTransportasiTindakanModel({
    this.data,
    this.message,
  });

  TransportasiTindakan? data;
  String? message;

  factory BiayaTransportasiTindakanModel.fromJson(Map<String, dynamic> json) =>
      BiayaTransportasiTindakanModel(
        data: TransportasiTindakan.fromJson(json["data"]),
        message: json["message"],
      );
}

String biayaTransportasiTindakanSaveModelToJson(
        BiayaTransportasiTindakanSaveModel data) =>
    json.encode(data.toJson());

class BiayaTransportasiTindakanSaveModel {
  BiayaTransportasiTindakanSaveModel({
    required this.jenis,
    required this.biaya,
  });

  int biaya;
  String jenis;

  Map<String, dynamic> toJson() => {
        "jenis": jenis,
        "biaya": biaya,
      };
}
