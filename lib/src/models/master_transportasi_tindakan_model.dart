MasterTransportasiTindakanModel masterTransportasiTindakanModelFromJson(
        dynamic str) =>
    MasterTransportasiTindakanModel.fromJson(str);

class MasterTransportasiTindakanModel {
  MasterTransportasiTindakanModel({
    this.data,
    this.message,
  });

  List<TransportasiTindakan>? data;
  String? message;

  factory MasterTransportasiTindakanModel.fromJson(Map<String, dynamic> json) =>
      MasterTransportasiTindakanModel(
        data: List<TransportasiTindakan>.from(
            json["data"].map((x) => TransportasiTindakan.fromJson(x))),
        message: json["message"],
      );
}

class TransportasiTindakan {
  TransportasiTindakan({
    this.id,
    this.deskripsi,
    this.nilai,
  });

  int? id;
  String? deskripsi;
  int? nilai;

  factory TransportasiTindakan.fromJson(Map<String, dynamic> json) =>
      TransportasiTindakan(
        id: json["id"],
        deskripsi: json["deskripsi"],
        nilai: json["nilai"],
      );
}
