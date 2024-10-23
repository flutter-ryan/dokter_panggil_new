import 'package:dokter_panggil/src/models/master_jabatan_model.dart';
import 'package:dokter_panggil/src/models/master_role_model.dart';

MasterPegawaiFetchModel masterPegawaiFetchModelFromJson(dynamic str) =>
    MasterPegawaiFetchModel.fromJson(str);

class MasterPegawaiFetchModel {
  MasterPegawaiFetchModel({
    this.pegawai,
    this.message,
  });

  MasterPegawai? pegawai;
  String? message;

  factory MasterPegawaiFetchModel.fromJson(Map<String, dynamic> json) =>
      MasterPegawaiFetchModel(
        pegawai: MasterPegawai.fromJson(json["data"]),
        message: json["message"],
      );
}

class MasterPegawai {
  MasterPegawai({
    this.id,
    this.nama,
    this.profesi,
    this.user,
    this.sip,
  });

  int? id;
  String? nama;
  Jabatan? profesi;
  User? user;
  Sip? sip;

  factory MasterPegawai.fromJson(Map<String, dynamic> json) => MasterPegawai(
        id: json["id"],
        nama: json["nama"],
        profesi: Jabatan.fromJson(json["profesi"]),
        user: User.fromJson(json["user"]),
        sip: json["sip"] == null ? null : Sip.fromJson(json["sip"]),
      );
}

class Sip {
  Sip({
    this.id,
    this.idPegawai,
    this.nomor,
    this.tanggalBerlaku,
  });

  int? id;
  int? idPegawai;
  String? nomor;
  DateTime? tanggalBerlaku;

  factory Sip.fromJson(Map<String, dynamic> json) => Sip(
        id: json["id"],
        idPegawai: json["pegawai_id"],
        nomor: json["nomor"],
        tanggalBerlaku: DateTime.parse(json["tanggalBerlaku"]),
      );
}

class User {
  User({
    this.id,
    this.name,
    this.email,
    this.tokenFcm,
    this.idPegawai,
    this.role,
    this.masterRole,
  });

  int? id;
  String? name;
  String? email;
  String? tokenFcm;
  int? idPegawai;
  int? role;
  MasterRole? masterRole;

  factory User.fromJson(Map<String, dynamic> json) => User(
        id: json["id"],
        name: json["name"],
        email: json["email"],
        tokenFcm: json["token_fcm"],
        idPegawai: json["laravel_through_key"],
        role: json["role"],
        masterRole: MasterRole.fromJson(json["master_role"]),
      );
}
