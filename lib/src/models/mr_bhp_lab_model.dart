MrBhpLabModel mrBhpLabModelFromJson(dynamic str) => MrBhpLabModel.fromJson(str);

class MrBhpLabModel {
  List<BhpLab>? data;
  String? message;

  MrBhpLabModel({
    this.data,
    this.message,
  });

  factory MrBhpLabModel.fromJson(Map<String, dynamic> json) => MrBhpLabModel(
        data: json["data"] == null
            ? []
            : List<BhpLab>.from(json["data"]!.map((x) => BhpLab.fromJson(x))),
        message: json["message"],
      );
}

class BhpLab {
  int? id;
  int? jumlah;
  String? namaBarang;
  int? harga;

  BhpLab({
    this.id,
    this.jumlah,
    this.namaBarang,
    this.harga,
  });

  factory BhpLab.fromJson(Map<String, dynamic> json) => BhpLab(
        id: json["id"],
        jumlah: json["jumlah"],
        namaBarang: json["nama_barang"],
        harga: json["harga"],
      );
}
