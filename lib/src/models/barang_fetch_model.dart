import 'dart:convert';

import 'package:admin_dokter_panggil/src/models/bhp_kategori_model.dart';

BarangFetchModel barangFetchModelFromJson(dynamic str) =>
    BarangFetchModel.fromJson(str);

class BarangFetchModel {
  BarangFetchModel({
    this.barang,
    this.message,
    this.currentPage,
    this.totalPage,
    this.total,
  });

  List<Barang>? barang;
  String? message;
  int? currentPage;
  int? totalPage;
  int? total;

  factory BarangFetchModel.fromJson(Map<String, dynamic> json) =>
      BarangFetchModel(
        barang: List<Barang>.from(json["data"].map((x) => Barang.fromJson(x))),
        message: json["message"],
        currentPage: json["current_page"],
        totalPage: json["totalPage"],
        total: json["total"],
      );
}

class Barang {
  Barang({
    this.id,
    this.namaBarang,
    this.kategori,
    this.hargaJual,
    this.hargaModal,
    this.tarifAplikasi,
    this.minStok,
    this.stock,
    this.stockMasuk,
    this.stockKeluar,
    this.isSuper = false,
  });

  int? id;
  String? namaBarang;
  BhpKategori? kategori;
  int? hargaJual;
  int? hargaModal;
  int? tarifAplikasi;
  int? minStok;
  Stock? stock;
  int? stockMasuk;
  int? stockKeluar;
  bool isSuper;

  factory Barang.fromJson(Map<String, dynamic> json) => Barang(
        id: json["id"],
        namaBarang: json["nama_barang"],
        kategori: BhpKategori.fromJson(json["kategori"]),
        hargaJual: json["harga_jual"],
        hargaModal: json["harga_modal"],
        tarifAplikasi: json["tarif_aplikasi"],
        minStok: json["min_stok"],
        stock: json["stock"] == null ? null : Stock.fromJson(json["stock"]),
        stockMasuk: json["stock_masuk"],
        stockKeluar: json["stock_keluar"],
        isSuper: json["is_super"],
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

String filterBarangfetchModelToJson(FilterBarangFetchModel data) =>
    json.encode(data.toJson());

class FilterBarangFetchModel {
  FilterBarangFetchModel({
    required this.filter,
  });

  String filter;

  Map<String, dynamic> toJson() => {
        "filter": filter,
      };
}
