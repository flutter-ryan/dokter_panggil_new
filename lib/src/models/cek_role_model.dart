CekRoleModel cekRoleModelFromJson(dynamic str) => CekRoleModel.fromJson(str);

class CekRoleModel {
  RoleCek? data;
  String? message;

  CekRoleModel({
    this.data,
    this.message,
  });

  factory CekRoleModel.fromJson(Map<String, dynamic> json) => CekRoleModel(
        data: RoleCek.fromJson(json["data"]),
        message: json["message"],
      );
}

class RoleCek {
  bool isSuper;

  RoleCek({
    this.isSuper = false,
  });

  factory RoleCek.fromJson(Map<String, dynamic> json) => RoleCek(
        isSuper: json["is_super"],
      );
}
