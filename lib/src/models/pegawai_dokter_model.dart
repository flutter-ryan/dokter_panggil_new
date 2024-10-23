PegawaiProfesiModel pegawaiProfesiModelFromJson(dynamic str) =>
    PegawaiProfesiModel.fromJson(str);

class PegawaiProfesiModel {
  PegawaiProfesiModel({
    this.profesi,
    this.message,
  });

  List<PegawaiProfesi>? profesi;
  String? message;

  factory PegawaiProfesiModel.fromJson(Map<String, dynamic> json) =>
      PegawaiProfesiModel(
        profesi: List<PegawaiProfesi>.from(
            json["data"].map((x) => PegawaiProfesi.fromJson(x))),
        message: json["message"],
      );
}

class PegawaiProfesi {
  PegawaiProfesi({
    this.id,
    this.nama,
    this.profesi,
    this.user,
  });

  int? id;
  String? nama;
  ProfesiPegawai? profesi;
  UserData? user;

  factory PegawaiProfesi.fromJson(Map<String, dynamic> json) => PegawaiProfesi(
        id: json["id"],
        nama: json["nama"],
        profesi: json["profesi"] == null
            ? null
            : ProfesiPegawai.fromJson(json["profesi"]),
        user: json["user"] == null ? null : UserData.fromJson(json["user"]),
      );
}

class UserData {
  UserData({
    this.id,
    this.name,
    this.email,
    this.tokenFcm,
  });

  int? id;
  String? name;
  String? email;
  String? tokenFcm;

  factory UserData.fromJson(Map<String, dynamic> json) => UserData(
        id: json["id"],
        name: json["name"],
        email: json["email"],
        tokenFcm: json["token_fcm"],
      );
}

class ProfesiPegawai {
  ProfesiPegawai({
    this.id,
    this.nama,
  });

  int? id;
  String? nama;

  factory ProfesiPegawai.fromJson(Map<String, dynamic> json) => ProfesiPegawai(
        id: json["id"],
        nama: json["nama_profesi"],
      );
}
