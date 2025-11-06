MrKunjunganPenghentianLayananModel mrKunjunganPenghentianLayananModelFromJson(
        dynamic str) =>
    MrKunjunganPenghentianLayananModel.fromJson(str);

class MrKunjunganPenghentianLayananModel {
  List<DataKunjunganPenghentianLayanan>? data;
  String? message;

  MrKunjunganPenghentianLayananModel({
    this.data,
    this.message,
  });

  factory MrKunjunganPenghentianLayananModel.fromJson(
          Map<String, dynamic> json) =>
      MrKunjunganPenghentianLayananModel(
        data: json["data"] == null
            ? []
            : List<DataKunjunganPenghentianLayanan>.from(json["data"]!
                .map((x) => DataKunjunganPenghentianLayanan.fromJson(x))),
        message: json["message"],
      );
}

class DataKunjunganPenghentianLayanan {
  int? id;
  int? kunjunganId;
  int? pegawaiId;
  String? namaPegawai;
  String? fileName;
  String? sizeFile;
  String? url;
  String? createdAt;
  String? extension;

  DataKunjunganPenghentianLayanan({
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

  factory DataKunjunganPenghentianLayanan.fromJson(Map<String, dynamic> json) =>
      DataKunjunganPenghentianLayanan(
        id: json["id"],
        kunjunganId: json["kunjungan_id"],
        pegawaiId: json["pegawai_id"],
        namaPegawai: json["nama_pegawai"],
        fileName: json["nama_file"],
        sizeFile: json["size_file"],
        url: json["url"],
        createdAt: json["created_at"],
        extension: json["extension"],
      );
}
