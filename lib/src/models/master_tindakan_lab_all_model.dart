MasterTindakanLabAllModel masterTindakanLabAllModelFromJson(dynamic str) =>
    MasterTindakanLabAllModel.fromJson(str);

class MasterTindakanLabAllModel {
  MasterTindakanLabAllModel({
    this.data,
    this.message,
  });

  List<MasterTindakanLabAll>? data;
  String? message;

  factory MasterTindakanLabAllModel.fromJson(Map<String, dynamic> json) =>
      MasterTindakanLabAllModel(
        data: List<MasterTindakanLabAll>.from(
            json["data"]!.map((x) => MasterTindakanLabAll.fromJson(x))),
        message: json["message"],
      );
}

class MasterTindakanLabAll {
  MasterTindakanLabAll({
    this.id,
    this.kodeLayanan,
    this.namaTindakanLab,
    this.hargaJual,
    this.hargaModal,
    this.tarifAplikasi,
    this.jenis,
    this.mitra,
  });

  int? id;
  String? kodeLayanan;
  String? namaTindakanLab;
  int? hargaJual;
  int? hargaModal;
  int? tarifAplikasi;
  int? jenis;
  Mitra? mitra;

  factory MasterTindakanLabAll.fromJson(Map<String, dynamic> json) =>
      MasterTindakanLabAll(
        id: json["id"],
        kodeLayanan: json["kode_layanan"],
        namaTindakanLab: json["nama_tindakan_lab"],
        hargaJual: json["harga_jual"],
        hargaModal: json["harga_modal"],
        tarifAplikasi: json["tarif_aplikasi"],
        jenis: json["jenis"],
        mitra: json["mitra"] == null ? null : Mitra.fromJson(json["mitra"]),
      );
}

class Mitra {
  Mitra({
    this.id,
    this.namaMitra,
    this.kode,
    this.jenis,
    this.persentase,
    this.status,
  });

  int? id;
  String? namaMitra;
  String? kode;
  String? jenis;
  String? persentase;
  int? status;

  factory Mitra.fromJson(Map<String, dynamic> json) => Mitra(
        id: json["id"],
        namaMitra: json["nama_mitra"],
        kode: json["kode"],
        jenis: json["jenis"],
        persentase: json["persentase"],
        status: json["status"],
      );
}
