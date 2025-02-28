FileEresepRacikanModel fileEresepRacikanModelFromJson(dynamic str) =>
    FileEresepRacikanModel.fromJson(str);

class FileEresepRacikanModel {
  FileEresepRacikan? data;
  String? message;

  FileEresepRacikanModel({
    this.data,
    this.message,
  });

  factory FileEresepRacikanModel.fromJson(Map<String, dynamic> json) =>
      FileEresepRacikanModel(
        data: json["data"] == null
            ? null
            : FileEresepRacikan.fromJson(json["data"]),
        message: json["message"],
      );
}

class FileEresepRacikan {
  int? id;
  int? resepId;
  String? pasien;
  String? url;
  String? nomorTelpon;

  FileEresepRacikan({
    this.id,
    this.resepId,
    this.pasien,
    this.url,
    this.nomorTelpon,
  });

  factory FileEresepRacikan.fromJson(Map<String, dynamic> json) =>
      FileEresepRacikan(
        id: json["id"],
        resepId: json["resep_id"],
        pasien: json["pasien"],
        url: json["url"],
        nomorTelpon: json["nomor_telpon"],
      );
}
