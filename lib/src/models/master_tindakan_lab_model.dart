import 'package:dokter_panggil/src/models/master_mitra_lab_model.dart';

MasterTindakanLabModel masterTindakanLabModelFromJson(dynamic str) =>
    MasterTindakanLabModel.fromJson(str);

class MasterTindakanLabModel {
  MasterTindakanLabModel({
    this.data,
    this.message,
  });

  List<MasterTindakanLab>? data;
  String? message;

  factory MasterTindakanLabModel.fromJson(Map<String, dynamic> json) =>
      MasterTindakanLabModel(
        data: List<MasterTindakanLab>.from(
            json["data"].map((x) => MasterTindakanLab.fromJson(x))),
        message: json["message"],
      );
}

class MasterTindakanLab {
  MasterTindakanLab({
    this.id,
    this.kodeLayanan,
    this.namaTindakanLab,
    this.hargaJual,
    this.hargaModal,
    this.tarifAplikasi,
    this.mitra,
    this.jenisKonsul,
  });

  int? id;
  String? kodeLayanan;
  String? namaTindakanLab;
  int? hargaJual;
  int? hargaModal;
  int? tarifAplikasi;
  int? jenisKonsul;
  MitraLab? mitra;

  factory MasterTindakanLab.fromJson(Map<String, dynamic> json) =>
      MasterTindakanLab(
        id: json["id"],
        kodeLayanan: json["kode_layanan"],
        namaTindakanLab: json["nama_tindakan_lab"],
        hargaJual: json["harga_jual"],
        hargaModal: json["harga_modal"],
        tarifAplikasi: json["tarif_aplikasi"],
        jenisKonsul: json["jenis"],
        mitra: json["mitra"] == null ? null : MitraLab.fromJson(json["mitra"]),
      );
}
