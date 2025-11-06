MrKunjunganEdukasiModel mrKunjunganEdukasiModelFromJson(dynamic str) =>
    MrKunjunganEdukasiModel.fromJson(str);

class MrKunjunganEdukasiModel {
  List<DataKunjunganEdukasi>? data;
  String? message;

  MrKunjunganEdukasiModel({
    this.data,
    this.message,
  });

  factory MrKunjunganEdukasiModel.fromJson(Map<String, dynamic> json) =>
      MrKunjunganEdukasiModel(
        data: json["data"] == null
            ? []
            : List<DataKunjunganEdukasi>.from(
                json["data"]!.map((x) => DataKunjunganEdukasi.fromJson(x))),
        message: json["message"],
      );
}

class DataKunjunganEdukasi {
  int? id;
  int? kunjunganId;
  int? pegawaiId;
  String? namaPegawai;
  String? fileName;
  String? sizeFile;
  String? url;
  String? createdAt;
  String? extension;

  DataKunjunganEdukasi({
    this.id,
    this.kunjunganId,
    this.pegawaiId,
    this.namaPegawai,
    this.fileName,
    this.sizeFile,
    this.url,
    this.createdAt,
    this.extension,
  });

  factory DataKunjunganEdukasi.fromJson(Map<String, dynamic> json) =>
      DataKunjunganEdukasi(
        id: json["id"],
        kunjunganId: json["kunjungan_id"],
        pegawaiId: json["pegawai_id"],
        namaPegawai: json["nama_pegawai"],
        fileName: json["file_name"],
        sizeFile: json["size_file"],
        url: json["url"],
        createdAt: json["created_at"],
        extension: json["extension"],
      );
}
