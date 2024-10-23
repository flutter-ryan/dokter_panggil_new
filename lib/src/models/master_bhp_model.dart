import 'dart:convert';

String masterBhpModelToJson(MasterBhpModel data) => json.encode(data.toJson());

class MasterBhpModel {
  MasterBhpModel({
    required this.namaBarang,
    required this.minStock,
    required this.hargaModal,
    required this.jasa,
    required this.kategori,
  });

  String namaBarang;
  int minStock;
  int hargaModal;
  int jasa;
  int kategori;

  Map<String, dynamic> toJson() => {
        "namaBarang": namaBarang,
        "minStock": minStock,
        "hargaModal": hargaModal,
        "jasa": jasa,
        "kategori": kategori,
      };
}

ResponseMasterBhpModel responseMasterBhpModelFromJson(dynamic str) =>
    ResponseMasterBhpModel.fromJson(str);

class ResponseMasterBhpModel {
  ResponseMasterBhpModel({
    this.message,
    this.masterBhp,
  });

  MasterBhp? masterBhp;
  String? message;

  factory ResponseMasterBhpModel.fromJson(Map<String, dynamic> json) =>
      ResponseMasterBhpModel(
        masterBhp: MasterBhp.fromJson(json["data"]),
        message: json["message"],
      );
}

class MasterBhp {
  MasterBhp({
    this.id,
    this.namaBarang,
    this.hargaJual,
    this.hargaModal,
    this.tarifAplikasi,
    this.stock,
    this.stockMasuk,
    this.stockKeluar,
  });

  int? id;
  String? namaBarang;
  int? hargaJual;
  int? hargaModal;
  int? tarifAplikasi;
  Stock? stock;
  int? stockMasuk;
  int? stockKeluar;

  factory MasterBhp.fromJson(Map<String, dynamic> json) => MasterBhp(
        id: json["id"],
        namaBarang: json["nama_barang"],
        hargaJual: json["harga_jual"],
        hargaModal: json["harga_modal"],
        tarifAplikasi: json["tarif_aplikasi"],
        stock: json["stock"] == null ? null : Stock.fromJson(json["stock"]),
        stockMasuk: json["stock_masuk"],
        stockKeluar: json["stock_keluar"],
      );
}

class Stock {
  Stock({
    this.id,
    this.currentStock,
  });

  int? id;
  int? currentStock;

  factory Stock.fromJson(Map<String, dynamic> json) => Stock(
        id: json["id"],
        currentStock: json["current_stock"],
      );
}
