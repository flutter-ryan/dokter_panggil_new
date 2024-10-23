DownloadKwitansiModel downloadKwitansiModelFromJson(dynamic str) =>
    DownloadKwitansiModel.fromJson(str);

class DownloadKwitansiModel {
  DownloadKwitansiModel({
    this.data,
    this.message,
  });

  Data? data;
  String? message;

  factory DownloadKwitansiModel.fromJson(Map<String, dynamic> json) =>
      DownloadKwitansiModel(
        data: Data.fromJson(json["data"]),
        message: json["message"],
      );
}

class Data {
  Data({
    this.nama,
    this.nomor,
    this.url,
  });

  String? nama;
  String? nomor;
  String? url;

  factory Data.fromJson(Map<String, dynamic> json) => Data(
        nama: json["nama"],
        nomor: json["nomor"],
        url: json["url"],
      );
}
