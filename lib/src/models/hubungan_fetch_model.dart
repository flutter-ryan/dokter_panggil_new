HubunganFetchModel hubunganFetchModelFromJson(dynamic str) =>
    HubunganFetchModel.fromJson(str);

class HubunganFetchModel {
  HubunganFetchModel({
    this.hubungan,
    this.message,
  });

  List<Hubungan>? hubungan;
  String? message;

  factory HubunganFetchModel.fromJson(Map<String, dynamic> json) =>
      HubunganFetchModel(
        hubungan:
            List<Hubungan>.from(json["data"].map((x) => Hubungan.fromJson(x))),
        message: json["message"],
      );
}

class Hubungan {
  Hubungan({
    this.id,
    this.hubungan,
  });

  int? id;
  String? hubungan;

  factory Hubungan.fromJson(Map<String, dynamic> json) => Hubungan(
        id: json["id"],
        hubungan: json["hubungan"],
      );
}
