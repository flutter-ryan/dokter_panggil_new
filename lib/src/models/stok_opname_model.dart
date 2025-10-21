import 'package:admin_dokter_panggil/src/models/cetak_stok_opname_model.dart';

StokOpnameModel stokOpnameModelFromJson(dynamic str) =>
    StokOpnameModel.fromJson(str);

class StokOpnameModel {
  List<StokOpname>? data;
  String? message;

  StokOpnameModel({
    this.data,
    this.message,
  });

  factory StokOpnameModel.fromJson(Map<String, dynamic> json) =>
      StokOpnameModel(
        data: List<StokOpname>.from(
            json["data"].map((x) => StokOpname.fromJson(x))),
        message: json["message"],
      );
}

class StokOpname {
  int? id;
  String? kodeStok;
  DateTime? fromDate;
  DateTime? toDate;
  int? isApproved;
  DateTime? finalAt;
  CetakStokOpname? file;

  StokOpname({
    this.id,
    this.kodeStok,
    this.fromDate,
    this.toDate,
    this.isApproved,
    this.finalAt,
    this.file,
  });

  factory StokOpname.fromJson(Map<String, dynamic> json) => StokOpname(
      id: json["id"],
      kodeStok: json["kode_stok"],
      fromDate: DateTime.parse(json["from_date"]),
      toDate: DateTime.parse(json["to_date"]),
      isApproved: json["is_approved"],
      finalAt:
          json["final_at"] == null ? null : DateTime.parse(json["final_at"]),
      file:
          json['file'] == null ? null : CetakStokOpname.fromJson(json['file']));
}

class BarangOpname {
  int? id;
  Barang? barang;
  int? currentStock;
  int? stokAwal;
  int? stokAkhir;
  int? stokKeluar;

  BarangOpname({
    this.id,
    this.barang,
    this.currentStock,
    this.stokAwal,
    this.stokAkhir,
    this.stokKeluar,
  });

  factory BarangOpname.fromJson(Map<String, dynamic> json) => BarangOpname(
        id: json["id"],
        barang: Barang.fromJson(json["barang"]),
        currentStock: json["current_stok"],
        stokAwal: json["stok_awal"],
        stokAkhir: json["stok_akhir"],
        stokKeluar: json["stok_keluar"],
      );
}

class Barang {
  int? id;
  String? namaBarang;

  Barang({
    this.id,
    this.namaBarang,
  });

  factory Barang.fromJson(Map<String, dynamic> json) => Barang(
        id: json["id"],
        namaBarang: json["nama_barang"],
      );
}
