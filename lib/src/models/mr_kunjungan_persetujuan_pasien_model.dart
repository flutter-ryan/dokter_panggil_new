MrKunjunganPersetujuanPasienModel mrKunjunganPersetujuanPasienModelFromJson(
        dynamic str) =>
    MrKunjunganPersetujuanPasienModel.fromJson(str);

class MrKunjunganPersetujuanPasienModel {
  List<DataPersetujuanPasien>? data;
  String? message;

  MrKunjunganPersetujuanPasienModel({
    this.data,
    this.message,
  });

  factory MrKunjunganPersetujuanPasienModel.fromJson(
          Map<String, dynamic> json) =>
      MrKunjunganPersetujuanPasienModel(
        data: json["data"] == null
            ? []
            : List<DataPersetujuanPasien>.from(
                json["data"]!.map((x) => DataPersetujuanPasien.fromJson(x))),
        message: json["message"],
      );
}

class DataPersetujuanPasien {
  int? id;
  int? kunjugnanId;
  int? pegawaiId;
  String? namaPegawai;
  String? namaFile;
  String? sizeFile;
  String? url;
  String? createdAt;
  String? extension;
  String? jenis;

  DataPersetujuanPasien({
    this.id,
    this.kunjugnanId,
    this.pegawaiId,
    this.namaPegawai,
    this.namaFile,
    this.sizeFile,
    this.url,
    this.createdAt,
    this.extension,
    this.jenis,
  });

  factory DataPersetujuanPasien.fromJson(Map<String, dynamic> json) =>
      DataPersetujuanPasien(
        id: json["id"],
        kunjugnanId: json["kunjugnan_id"],
        pegawaiId: json["pegawai_id"],
        namaPegawai: json["nama_pegawai"],
        namaFile: json["nama_file"],
        sizeFile: json["size_file"],
        url: json["url"],
        createdAt: json["created_at"],
        extension: json["extension"],
        jenis: json["jenis"],
      );
}
