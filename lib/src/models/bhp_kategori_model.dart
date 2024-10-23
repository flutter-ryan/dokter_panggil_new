BhpKategoriModel bhpKategoriModelFromJson(dynamic str) =>
    BhpKategoriModel.fromJson(str);

class BhpKategoriModel {
  BhpKategoriModel({
    this.data,
    this.message,
  });

  List<BhpKategori>? data;
  String? message;

  factory BhpKategoriModel.fromJson(Map<String, dynamic> json) =>
      BhpKategoriModel(
        data: List<BhpKategori>.from(
            json["data"].map((x) => BhpKategori.fromJson(x))),
        message: json["message"],
      );
}

class BhpKategori {
  BhpKategori({
    this.id,
    this.kategori,
  });

  int? id;
  String? kategori;

  factory BhpKategori.fromJson(Map<String, dynamic> json) => BhpKategori(
        id: json["id"],
        kategori: json["kategori"],
      );
}
