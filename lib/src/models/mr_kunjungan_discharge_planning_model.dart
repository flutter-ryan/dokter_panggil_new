MrKunjunganDischargePlanningModel mrKunjunganDischargePlanningModelFromJson(
        dynamic str) =>
    MrKunjunganDischargePlanningModel.fromJson(str);

class MrKunjunganDischargePlanningModel {
  MrKunjunganDischargePlanning? data;
  String? message;

  MrKunjunganDischargePlanningModel({
    this.data,
    this.message,
  });

  factory MrKunjunganDischargePlanningModel.fromJson(
          Map<String, dynamic> json) =>
      MrKunjunganDischargePlanningModel(
        data: json["data"] == null
            ? null
            : MrKunjunganDischargePlanning.fromJson(json["data"]),
        message: json["message"],
      );
}

class MrKunjunganDischargePlanning {
  int? id;
  String? nomorRegistrasi;
  String? namaPetugas;
  DataDischargePlanning? dataDischargePlanning;

  MrKunjunganDischargePlanning({
    this.id,
    this.nomorRegistrasi,
    this.namaPetugas,
    this.dataDischargePlanning,
  });

  factory MrKunjunganDischargePlanning.fromJson(Map<String, dynamic> json) =>
      MrKunjunganDischargePlanning(
        id: json["id"],
        nomorRegistrasi: json["nomor_registrasi"],
        namaPetugas: json["nama_petugas"],
        dataDischargePlanning: json["data_discharge_planning"] == null
            ? null
            : DataDischargePlanning.fromJson(json["data_discharge_planning"]),
      );
}

class DataDischargePlanning {
  int? id;
  String? tanggal;
  String? createdAt;
  String? namaPegawai;
  bool? isUpdate;
  List<DischargeSkrining>? dischargeSkrining;
  List<DischargeRencana>? dischargeRencana;

  DataDischargePlanning({
    this.id,
    this.tanggal,
    this.createdAt,
    this.namaPegawai,
    this.isUpdate,
    this.dischargeSkrining,
    this.dischargeRencana,
  });

  factory DataDischargePlanning.fromJson(Map<String, dynamic> json) =>
      DataDischargePlanning(
        id: json["id"],
        tanggal: json["tanggal"],
        createdAt: json["created_at"],
        namaPegawai: json["nama_pegawai"],
        isUpdate: json["is_update"],
        dischargeSkrining: json["discharge_skrining"] == null
            ? []
            : List<DischargeSkrining>.from(json["discharge_skrining"]!
                .map((x) => DischargeSkrining.fromJson(x))),
        dischargeRencana: json["discharge_rencana"] == null
            ? []
            : List<DischargeRencana>.from(json["discharge_rencana"]!
                .map((x) => DischargeRencana.fromJson(x))),
      );
}

class DischargeRencana {
  int? id;
  int? dischargeId;
  String? rencana;

  DischargeRencana({
    this.id,
    this.dischargeId,
    this.rencana,
  });

  factory DischargeRencana.fromJson(Map<String, dynamic> json) =>
      DischargeRencana(
        id: json["id"],
        dischargeId: json["discharge_id"],
        rencana: json["rencana"],
      );
}

class DischargeSkrining {
  int? id;
  int? dischargeId;
  String? deskripsi;
  String? jawaban;

  DischargeSkrining({
    this.id,
    this.dischargeId,
    this.deskripsi,
    this.jawaban,
  });

  factory DischargeSkrining.fromJson(Map<String, dynamic> json) =>
      DischargeSkrining(
        id: json["id"],
        dischargeId: json["discharge_id"],
        deskripsi: json["deskripsi"],
        jawaban: json["jawaban"],
      );
}
