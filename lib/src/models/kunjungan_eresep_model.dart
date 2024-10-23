KunjunganEresepModel kunjunganEresepModelFromJson(dynamic str) =>
    KunjunganEresepModel.fromJson(str);

class KunjunganEresepModel {
  KunjunganEresepModel({
    this.data,
    this.message,
  });

  Eresep? data;
  String? message;

  factory KunjunganEresepModel.fromJson(Map<String, dynamic> json) =>
      KunjunganEresepModel(
        data: Eresep.fromJson(json["data"]),
        message: json["message"],
      );
}

class Eresep {
  Eresep({
    this.id,
    this.idKunjungan,
    this.namaPasien,
    this.url,
  });

  int? id;
  int? idKunjungan;
  String? namaPasien;
  String? url;

  factory Eresep.fromJson(Map<String, dynamic> json) => Eresep(
        id: json["id"],
        idKunjungan: json["idKunjungan"],
        namaPasien: json["nama_pasien"],
        url: json["url"],
      );
}
