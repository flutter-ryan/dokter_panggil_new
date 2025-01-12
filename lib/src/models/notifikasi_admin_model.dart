NotifikasiAdminModel notifikasiAdminModelFromJson(dynamic str) =>
    NotifikasiAdminModel.fromJson(str);

class NotifikasiAdminModel {
  List<NotifikasiAdmin>? data;
  int? currentPage;
  int? totalPage;
  String? message;
  int? total;

  NotifikasiAdminModel({
    this.data,
    this.currentPage,
    this.totalPage,
    this.message,
    this.total,
  });

  factory NotifikasiAdminModel.fromJson(Map<String, dynamic> json) =>
      NotifikasiAdminModel(
        data: json["data"] == null
            ? []
            : List<NotifikasiAdmin>.from(
                json["data"]!.map((x) => NotifikasiAdmin.fromJson(x))),
        currentPage: json["current_page"],
        totalPage: json["totalPage"],
        message: json["message"],
        total: json["total"],
      );
}

class NotifikasiAdmin {
  int? id;
  int? kunjunganId;
  String? judul;
  String? body;
  int? finaltagihan;
  String? jenis;
  String? createdAt;
  int? isRead;

  NotifikasiAdmin({
    this.id,
    this.kunjunganId,
    this.judul,
    this.body,
    this.finaltagihan,
    this.jenis,
    this.createdAt,
    this.isRead,
  });

  factory NotifikasiAdmin.fromJson(Map<String, dynamic> json) =>
      NotifikasiAdmin(
        id: json["id"],
        kunjunganId: json["kunjungan_id"],
        judul: json["judul"],
        body: json["body"],
        finaltagihan: json["final"],
        jenis: json["jenis"],
        createdAt: json["created_at"],
        isRead: json["is_read"],
      );
}
