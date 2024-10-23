CurrentUserModel currentUserModelFromJson(dynamic str) =>
    CurrentUserModel.fromJson(str);

class CurrentUserModel {
  CurrentUser? data;
  String? message;

  CurrentUserModel({
    this.data,
    this.message,
  });

  factory CurrentUserModel.fromJson(Map<String, dynamic> json) =>
      CurrentUserModel(
        data: json["data"] == null ? null : CurrentUser.fromJson(json["data"]),
        message: json["message"],
      );
}

class CurrentUser {
  int? id;
  String? name;
  String? email;
  String? tokenFcm;
  int? role;

  CurrentUser({
    this.id,
    this.name,
    this.email,
    this.tokenFcm,
    this.role,
  });

  factory CurrentUser.fromJson(Map<String, dynamic> json) => CurrentUser(
        id: json["id"],
        name: json["name"],
        email: json["email"],
        tokenFcm: json["token_fcm"],
        role: json["role"],
      );
}
