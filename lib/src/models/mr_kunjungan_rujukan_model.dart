MrKunjunganRujukanModel mrKunjunganRujukanModelFromJson(dynamic str) =>
    MrKunjunganRujukanModel.fromJson(str);

class MrKunjunganRujukanModel {
  List<DataKunjunganRujukan>? data;
  String? message;

  MrKunjunganRujukanModel({
    this.data,
    this.message,
  });

  factory MrKunjunganRujukanModel.fromJson(Map<String, dynamic> json) =>
      MrKunjunganRujukanModel(
        data: List<DataKunjunganRujukan>.from(
            json["data"].map((x) => DataKunjunganRujukan.fromJson(x))),
        message: json["message"],
      );
}

class DataKunjunganRujukan {
  int? id;
  int? kunjunganId;
  int? pegawaiId;
  String? namaPegawai;
  String? namaFile;
  String? sizeFile;
  String? url;
  String? createdAt;
  String? extension;

  DataKunjunganRujukan({
    this.id,
    this.kunjunganId,
    this.pegawaiId,
    this.namaFile,
    this.sizeFile,
    this.namaPegawai,
    this.url,
    this.createdAt,
    this.extension,
  });

  factory DataKunjunganRujukan.fromJson(Map<String, dynamic> json) =>
      DataKunjunganRujukan(
        id: json["id"],
        kunjunganId: json["kunjungan_id"],
        pegawaiId: json["pegawai_id"],
        namaPegawai: json["nama_pegawai"],
        namaFile: json["nama_file"],
        sizeFile: json["size_file"],
        url: json["url"],
        createdAt: json["created_at"],
        extension: json["extension"],
      );
}
