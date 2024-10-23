MasterFarmasiPaginateModel masterFarmasiPaginateModelFromJson(dynamic str) =>
    MasterFarmasiPaginateModel.fromJson(str);

class MasterFarmasiPaginateModel {
  MasterFarmasiPaginateModel({
    this.barangFarmasi,
    this.currentPage,
    this.totalPage,
    this.message,
  });

  List<BarangFarmasi>? barangFarmasi;
  int? currentPage;
  int? totalPage;
  String? message;

  factory MasterFarmasiPaginateModel.fromJson(Map<String, dynamic> json) =>
      MasterFarmasiPaginateModel(
        barangFarmasi: List<BarangFarmasi>.from(
            json["data"].map((x) => BarangFarmasi.fromJson(x))),
        currentPage: json["current_page"],
        totalPage: json["totalPage"],
        message: json["message"],
      );
}

class BarangFarmasi {
  BarangFarmasi({
    this.id,
    this.mitraFarmasi,
    this.namaBarang,
    this.persentase,
    this.hargaJual,
    this.hargaModal,
    this.tarifAplikasi,
  });

  int? id;
  MitraFarmasi? mitraFarmasi;
  String? namaBarang;
  dynamic persentase;
  int? hargaJual;
  int? hargaModal;
  int? tarifAplikasi;

  factory BarangFarmasi.fromJson(Map<String, dynamic> json) => BarangFarmasi(
        id: json["id"],
        mitraFarmasi:
            json["mitra"] == null ? null : MitraFarmasi.fromJson(json["mitra"]),
        namaBarang: json["nama_barang"],
        persentase: json["persentase"],
        hargaJual: json["harga_jual"],
        hargaModal: json["harga_modal"],
        tarifAplikasi: json["tarif_aplikasi"],
      );
}

class MitraFarmasi {
  MitraFarmasi({
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

  factory MitraFarmasi.fromJson(Map<String, dynamic> json) => MitraFarmasi(
        id: json["id"],
        namaMitra: json["nama_mitra"],
        kode: json["kode"],
        jenis: json["jenis"],
        persentase: json["persentase"],
        status: json["status"],
      );
}
