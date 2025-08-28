MasterStatusNikahModel masterStatusNikahModelFromJson(dynamic str) =>
    MasterStatusNikahModel.fromJson(str);

class MasterStatusNikahModel {
  List<MasterStatusNikah>? data;
  String? message;

  MasterStatusNikahModel({
    this.data,
    this.message,
  });

  factory MasterStatusNikahModel.fromJson(Map<String, dynamic> json) =>
      MasterStatusNikahModel(
        data: json["data"] == null
            ? []
            : List<MasterStatusNikah>.from(
                json["data"]!.map((x) => MasterStatusNikah.fromJson(x))),
        message: json["message"],
      );
}

class MasterStatusNikah {
  int? id;
  String? code;
  String? deskripsi;
  String? display;

  MasterStatusNikah({
    this.id,
    this.code,
    this.deskripsi,
    this.display,
  });

  factory MasterStatusNikah.fromJson(Map<String, dynamic> json) =>
      MasterStatusNikah(
        id: json["id"],
        code: json["code"],
        deskripsi: json["deskripsi"],
        display: json["display"],
      );
}
