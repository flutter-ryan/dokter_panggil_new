FileEresepOralModel fileEresepOralModelFromJson(dynamic str) =>
    FileEresepOralModel.fromJson(str);

class FileEresepOralModel {
  MrEresepOral? data;
  String? message;

  FileEresepOralModel({
    this.data,
    this.message,
  });

  factory FileEresepOralModel.fromJson(Map<String, dynamic> json) =>
      FileEresepOralModel(
        data: json["data"] == null ? null : MrEresepOral.fromJson(json["data"]),
        message: json["message"],
      );
}

class MrEresepOral {
  int? id;
  int? resepId;
  String? pasien;
  String? url;

  MrEresepOral({
    this.id,
    this.resepId,
    this.pasien,
    this.url,
  });

  factory MrEresepOral.fromJson(Map<String, dynamic> json) => MrEresepOral(
        id: json["id"],
        resepId: json["resep_id"],
        pasien: json["pasien"],
        url: json["url"],
      );
}
