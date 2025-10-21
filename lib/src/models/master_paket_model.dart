import 'dart:convert';

import 'package:admin_dokter_panggil/src/models/master_paket_create_model.dart';

String masterPaketModelToJson(MasterPaketModel data) =>
    json.encode(data.toJson());

class MasterPaketModel {
  MasterPaketModel({
    required this.jenisHarga,
    required this.namaPaket,
    required this.diskon,
    required this.harga,
    required this.total,
    required this.tindakans,
    required this.jumlahTindakan,
    required this.drugs,
    required this.jumlahDrugs,
    required this.aturanDrugs,
    required this.catatanDrugs,
    required this.consumes,
    required this.jumlahConsumes,
    required this.farmasis,
    required this.jumlahFarmasi,
    required this.aturanFarmasi,
    required this.catatanFarmasi,
    required this.labs,
    required this.rads,
    required this.isDokter,
  });

  String jenisHarga;
  String namaPaket;
  int diskon;
  int harga;
  int total;
  List<int> tindakans;
  List<int> jumlahTindakan;
  List<int> drugs;
  List<int> jumlahDrugs;
  List<String> aturanDrugs;
  List<String> catatanDrugs;
  List<int> consumes;
  List<int> jumlahConsumes;
  List<int> farmasis;
  List<int> jumlahFarmasi;
  List<String> aturanFarmasi;
  List<String> catatanFarmasi;
  List<int> labs;
  List<int> rads;
  List<bool> isDokter;

  Map<String, dynamic> toJson() => {
        "jenisHarga": jenisHarga,
        "namaPaket": namaPaket,
        "diskon": diskon,
        "harga": harga,
        "total": total,
        "tindakans": List<dynamic>.from(tindakans.map((x) => x)),
        "jumlahTindakan": List<dynamic>.from(jumlahTindakan.map((x) => x)),
        "drugs": List<dynamic>.from(drugs.map((x) => x)),
        "jumlahDrugs": List<dynamic>.from(jumlahDrugs.map((x) => x)),
        "aturanDrugs": List<dynamic>.from(aturanDrugs.map((x) => x)),
        "catatanDrugs": List<dynamic>.from(catatanDrugs.map((x) => x)),
        "consumes": List<dynamic>.from(consumes.map((x) => x)),
        "jumlahConsumes": List<dynamic>.from(jumlahConsumes.map((x) => x)),
        "farmasis": List<dynamic>.from(farmasis.map((x) => x)),
        "jumlahFarmasi": List<dynamic>.from(jumlahFarmasi.map((x) => x)),
        "aturanFarmasi": List<dynamic>.from(aturanFarmasi.map((x) => x)),
        "catatanFarmasi": List<dynamic>.from(catatanFarmasi.map((x) => x)),
        "labs": List<dynamic>.from(labs.map((x) => x)),
        "rads": List<dynamic>.from(rads.map((x) => x)),
        "isDokter": List<dynamic>.from(isDokter.map((x) => x)),
      };
}

ResponseMasterPaketModel responseMasterPaketModelFromJson(dynamic str) =>
    ResponseMasterPaketModel.fromJson(str);

class ResponseMasterPaketModel {
  ResponseMasterPaketModel({
    this.data,
    this.message,
  });

  MasterPaket? data;
  String? message;

  factory ResponseMasterPaketModel.fromJson(Map<String, dynamic> json) =>
      ResponseMasterPaketModel(
        data: MasterPaket.fromJson(json["data"]),
        message: json["message"],
      );
}
