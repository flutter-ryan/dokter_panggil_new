import 'dart:convert';

ResepInjeksiModel resepInjeksiModelFromJson(dynamic str) =>
    ResepInjeksiModel.fromJson(str);

class ResepInjeksiModel {
  List<ResepInjeksi>? data;
  String? message;

  ResepInjeksiModel({
    this.data,
    this.message,
  });

  factory ResepInjeksiModel.fromJson(Map<String, dynamic> json) =>
      ResepInjeksiModel(
        data: json["data"] == null
            ? []
            : List<ResepInjeksi>.from(
                json["data"]!.map((x) => ResepInjeksi.fromJson(x))),
        message: json["message"],
      );
}

class ResepInjeksi {
  int? id;
  String? tanggalResepInjeksi;
  int? isCppt;
  String? namaPegawai;
  int? pegawaiId;
  int? kunjunganId;
  List<ObatInjeksi>? obatInjeksis;

  ResepInjeksi({
    this.id,
    this.tanggalResepInjeksi,
    this.isCppt,
    this.namaPegawai,
    this.pegawaiId,
    this.kunjunganId,
    this.obatInjeksis,
  });

  factory ResepInjeksi.fromJson(Map<String, dynamic> json) => ResepInjeksi(
        id: json["id"],
        tanggalResepInjeksi: json["tanggal_resep_injeksi"],
        isCppt: json["is_cppt"],
        namaPegawai: json["nama_pegawai"],
        pegawaiId: json["pegawai_id"],
        kunjunganId: json["kunjungan_id"],
        obatInjeksis: json["obat_injeksis"] == null
            ? []
            : List<ObatInjeksi>.from(
                json["obat_injeksis"]!.map((x) => ObatInjeksi.fromJson(x))),
      );
}

class ObatInjeksi {
  int? id;
  int? resepInjeksiId;
  int? pegawaiId;
  Barang? barang;
  int? jumlah;
  String? aturanPakai;
  dynamic catatan;
  int? hargaModal;
  int? tarifAplikasi;
  int? tarif;
  String? dokter;

  ObatInjeksi({
    this.id,
    this.resepInjeksiId,
    this.pegawaiId,
    this.barang,
    this.jumlah,
    this.aturanPakai,
    this.catatan,
    this.hargaModal,
    this.tarifAplikasi,
    this.tarif,
    this.dokter,
  });

  factory ObatInjeksi.fromJson(Map<String, dynamic> json) => ObatInjeksi(
        id: json["id"],
        resepInjeksiId: json["resep_injeksi_id"],
        pegawaiId: json["pegawai_id"],
        barang: json["barang"] == null ? null : Barang.fromJson(json["barang"]),
        jumlah: json["jumlah"],
        aturanPakai: json["aturan_pakai"],
        catatan: json["catatan"],
        hargaModal: json["harga_modal"],
        tarifAplikasi: json["tarif_aplikasi"],
        tarif: json["tarif"],
        dokter: json["dokter"],
      );
}

class Barang {
  int? id;
  String? namaBarang;
  int? hargaJual;
  int? hargaModal;
  int? tarifAplikasi;

  Barang({
    this.id,
    this.namaBarang,
    this.hargaJual,
    this.hargaModal,
    this.tarifAplikasi,
  });

  factory Barang.fromJson(Map<String, dynamic> json) => Barang(
        id: json["id"],
        namaBarang: json["nama_barang"],
        hargaJual: json["harga_jual"],
        hargaModal: json["harga_modal"],
        tarifAplikasi: json["tarif_aplikasi"],
      );
}

String resepInjeksiRequestModelToJson(ResepInjeksiRequestModel data) =>
    json.encode(data.toJson());

class ResepInjeksiRequestModel {
  int idKunjungan;
  int idDokter;

  ResepInjeksiRequestModel({
    required this.idKunjungan,
    required this.idDokter,
  });

  Map<String, dynamic> toJson() => {
        "idKunjungan": idKunjungan,
        "idDokter": idDokter,
      };
}
