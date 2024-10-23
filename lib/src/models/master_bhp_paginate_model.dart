MasterBhpPaginateModel masterBhpPaginateModelFromJson(dynamic str) =>
    MasterBhpPaginateModel.fromJson(str);

class MasterBhpPaginateModel {
  MasterBhpPaginateModel({
    this.bhp,
    this.currentPage,
    this.totalPage,
    this.message,
  });

  List<BarangHabisPakai>? bhp;
  int? currentPage;
  int? totalPage;
  String? message;

  factory MasterBhpPaginateModel.fromJson(Map<String, dynamic> json) =>
      MasterBhpPaginateModel(
        bhp: List<BarangHabisPakai>.from(
            json["data"].map((x) => BarangHabisPakai.fromJson(x))),
        currentPage: json["current_page"],
        totalPage: json["totalPage"],
        message: json["message"],
      );
}

class BarangHabisPakai {
  BarangHabisPakai({
    this.id,
    this.namaBarang,
    this.hargaJual,
    this.hargaModal,
    this.tarifAplikasi,
  });

  int? id;
  String? namaBarang;
  int? hargaJual;
  int? hargaModal;
  int? tarifAplikasi;

  factory BarangHabisPakai.fromJson(Map<String, dynamic> json) =>
      BarangHabisPakai(
        id: json["id"],
        namaBarang: json["nama_barang"],
        hargaJual: json["harga_jual"],
        hargaModal: json["harga_modal"],
        tarifAplikasi: json["tarif_aplikasi"],
      );
}
