import 'package:admin_dokter_panggil/src/models/mr_kunjungan_observasi_anak_model.dart';
import 'package:admin_dokter_panggil/src/models/mr_kunjungan_observasi_model.dart';

MrKunjunganCpptModel mrKunjunganCpptModelFromJson(dynamic str) =>
    MrKunjunganCpptModel.fromJson(str);

class MrKunjunganCpptModel {
  List<DataCppt>? data;
  String? message;

  MrKunjunganCpptModel({
    this.data,
    this.message,
  });

  factory MrKunjunganCpptModel.fromJson(Map<String, dynamic> json) =>
      MrKunjunganCpptModel(
        data: json["data"] == null
            ? []
            : List<DataCppt>.from(
                json["data"]!.map((x) => DataCppt.fromJson(x))),
        message: json["message"],
      );
}

class DataCppt {
  int? id;
  bool? isSoap;
  bool? isSoapPerawat;
  String? tanggal;
  String? jam;
  int? pegawaiId;
  String? namaPegawai;
  bool isDokter;
  String? createdAt;
  String? verifiedAt;
  String? verifiedBy;
  List<Racikans>? racikans;
  dynamic cpptable;
  DateTime? rawTanggal;
  bool? isVerifier;
  String? profesi;

  DataCppt({
    this.id,
    this.isSoap,
    this.isSoapPerawat,
    this.tanggal,
    this.jam,
    this.pegawaiId,
    this.namaPegawai,
    this.cpptable,
    this.createdAt,
    this.verifiedAt,
    this.verifiedBy,
    this.racikans,
    this.isDokter = false,
    this.rawTanggal,
    this.isVerifier,
    this.profesi,
  });

  factory DataCppt.fromJson(Map<String, dynamic> json) => DataCppt(
        id: json["id"],
        isSoap: json["is_soap"],
        isSoapPerawat: json["is_soap_perawat"],
        tanggal: json["tanggal"],
        jam: json["jam"],
        pegawaiId: json["pegawai_id"],
        namaPegawai: json["nama_pegawai"],
        isDokter: json["is_dokter"],
        createdAt: json["created_at"],
        verifiedAt: json["verified_at"],
        verifiedBy: json["verified_by"],
        racikans: json["racikans"] == null
            ? []
            : List<Racikans>.from(
                json["racikans"]!.map((x) => Racikans.fromJson(x))),
        cpptable: json["cpptable"] == null
            ? null
            : json["is_soap"] == true
                ? CpptableSoap.fromJson(json["cpptable"])
                : json["is_soap_perawat"]
                    ? CpptableSoapPerawat.fromJson(json["cpptable"])
                    : CpptableSbar.fromJson(json["cpptable"]),
        rawTanggal: DateTime.parse(json["raw_tanggal"]),
        isVerifier: json["is_verifier"],
        profesi: json["profesi"],
      );
}

class CpptableSoap {
  int? id;
  String? subjektif;
  String? objektif;
  List<DiagnosaCppt>? assesment;
  List<DiagnosaIcd9>? diagnosaIcd9;
  String? planning;
  List<TindakanCppt>? tindakan;
  List<ObatInjeksiCppt>? obatInjeksi;
  List<BhpCppt>? bhp;
  List<ResepCppt>? resep;
  List<ResepRacikanCppt>? resepRacikan;
  List<LabCppt>? lab;
  List<RadCppt>? rad;
  String? unverified;
  String? verifiedAt;

  CpptableSoap({
    this.id,
    this.subjektif,
    this.objektif,
    this.assesment,
    this.diagnosaIcd9,
    this.planning,
    this.tindakan,
    this.obatInjeksi,
    this.bhp,
    this.resep,
    this.resepRacikan,
    this.lab,
    this.rad,
    this.unverified,
    this.verifiedAt,
  });

  factory CpptableSoap.fromJson(Map<String, dynamic> json) => CpptableSoap(
        id: json["id"],
        subjektif: json["subjektif"],
        objektif: json["objektif"],
        assesment: json["assesment"] == null
            ? []
            : List<DiagnosaCppt>.from(
                json["assesment"]!.map((x) => DiagnosaCppt.fromJson(x))),
        diagnosaIcd9: json["icd_9"] == null
            ? []
            : List<DiagnosaIcd9>.from(
                json["icd_9"]!.map((x) => DiagnosaIcd9.fromJson(x))),
        planning: json["planning"],
        tindakan: json["tindakan"] == null
            ? []
            : List<TindakanCppt>.from(
                json["tindakan"]!.map((x) => TindakanCppt.fromJson(x))),
        obatInjeksi: json["obatInjeksi"] == null
            ? []
            : List<ObatInjeksiCppt>.from(
                json["obatInjeksi"]!.map((x) => ObatInjeksiCppt.fromJson(x))),
        bhp: json["bhp"] == null
            ? []
            : List<BhpCppt>.from(json["bhp"]!.map((x) => BhpCppt.fromJson(x))),
        resep: json["resep"] == null
            ? []
            : List<ResepCppt>.from(
                json["resep"]!.map((x) => ResepCppt.fromJson(x))),
        resepRacikan: json["resep_racikan"] == null
            ? []
            : List<ResepRacikanCppt>.from(json["resep_racikan"]!
                .map((x) => ResepRacikanCppt.fromJson(x))),
        lab: json["lab"] == null
            ? []
            : List<LabCppt>.from(json["lab"]!.map((x) => LabCppt.fromJson(x))),
        rad: json["rad"] == null
            ? []
            : List<RadCppt>.from(json["rad"]!.map((x) => RadCppt.fromJson(x))),
        verifiedAt: json["verified_at"],
        unverified: json["unverified"],
      );
}

class CpptableSbar {
  int? id;
  bool? isPemberiInstruksi;
  PemberiInstruksiSbar? pemberiInstruksi;
  String? situation;
  String? background;
  List<DiagnosaCppt>? assesment;
  List<DiagnosaIcd9>? diagnosaIcd9;
  String? recomendation;
  List<TindakanCppt>? tindakan;
  List<ObatInjeksiCppt>? obatInjeksi;
  List<BhpCppt>? bhp;
  List<ResepCppt>? resep;
  List<ResepRacikanCppt>? resepRacikan;
  List<LabCppt>? lab;
  List<RadCppt>? rad;
  String? unverified;
  String? confirmAt;
  String? jamConfirm;
  String? verifiedAt;
  String? tanggalPemberi;
  String? jamPemberi;

  CpptableSbar({
    this.id,
    this.isPemberiInstruksi,
    this.pemberiInstruksi,
    this.situation,
    this.background,
    this.assesment,
    this.diagnosaIcd9,
    this.recomendation,
    this.tindakan,
    this.obatInjeksi,
    this.bhp,
    this.resep,
    this.resepRacikan,
    this.lab,
    this.rad,
    this.unverified,
    this.confirmAt,
    this.jamConfirm,
    this.verifiedAt,
    this.tanggalPemberi,
    this.jamPemberi,
  });

  factory CpptableSbar.fromJson(Map<String, dynamic> json) => CpptableSbar(
        id: json["id"],
        isPemberiInstruksi: json["is_pemberi_instruksi"],
        pemberiInstruksi: json["pemberi_instruksi"] == null
            ? null
            : PemberiInstruksiSbar.fromJson(json["pemberi_instruksi"]),
        situation: json["situation"],
        background: json["background"],
        assesment: json["assesment"] == null
            ? []
            : List<DiagnosaCppt>.from(
                json["assesment"]!.map((x) => DiagnosaCppt.fromJson(x))),
        diagnosaIcd9: json["icd_9"] == null
            ? []
            : List<DiagnosaIcd9>.from(
                json["icd_9"]!.map((x) => DiagnosaIcd9.fromJson(x))),
        recomendation: json["recomendation"],
        tindakan: json["tindakan"] == null
            ? []
            : List<TindakanCppt>.from(
                json["tindakan"]!.map((x) => TindakanCppt.fromJson(x))),
        obatInjeksi: json["obatInjeksi"] == null
            ? []
            : List<ObatInjeksiCppt>.from(
                json["obatInjeksi"]!.map((x) => ObatInjeksiCppt.fromJson(x))),
        bhp: json["barangHabisPakai"] == null
            ? []
            : List<BhpCppt>.from(
                json["barangHabisPakai"]!.map((x) => BhpCppt.fromJson(x))),
        resep: json["resep"] == null
            ? []
            : List<ResepCppt>.from(
                json["resep"]!.map((x) => ResepCppt.fromJson(x))),
        resepRacikan: json["resep_racikan"] == null
            ? []
            : List<ResepRacikanCppt>.from(json["resep_racikan"]!
                .map((x) => ResepRacikanCppt.fromJson(x))),
        lab: json["lab"] == null
            ? []
            : List<LabCppt>.from(json["lab"]!.map((x) => LabCppt.fromJson(x))),
        rad: json["rad"] == null
            ? []
            : List<RadCppt>.from(json["rad"]!.map((x) => RadCppt.fromJson(x))),
        verifiedAt: json["verified_at"],
        unverified: json["unverified"],
        confirmAt: json["confirm_at"],
        jamConfirm: json["jam_confirm"],
        tanggalPemberi: json["tanggal_pemberi"],
        jamPemberi: json["jam_pemberi"],
      );
}

class Assesment {
  AssesmentDiagnosa? diagnosa;
  AssesmentProsedur? prosedur;

  Assesment({
    this.diagnosa,
    this.prosedur,
  });

  factory Assesment.fromJson(Map<String, dynamic> json) => Assesment(
        diagnosa: json["diagnosa"] == null
            ? null
            : AssesmentDiagnosa.fromJson(json["diagnosa"]),
        prosedur: json["prosedur"] == null
            ? null
            : AssesmentProsedur.fromJson(json["prosedur"]),
      );
}

class AssesmentDiagnosa {
  List<DiagnosaCppt>? diagnosas;
  String? catatan;

  AssesmentDiagnosa({
    this.diagnosas,
    this.catatan,
  });

  factory AssesmentDiagnosa.fromJson(Map<String, dynamic> json) =>
      AssesmentDiagnosa(
        diagnosas: json["diagnosas"] == null
            ? []
            : List<DiagnosaCppt>.from(
                json["diagnosas"]!.map((x) => DiagnosaCppt.fromJson(x))),
        catatan: json["catatan"],
      );
}

class DiagnosaCppt {
  int? idDiagnosa;
  String? namaDiagnosa;
  String? kodeIcd10;
  String? type;

  DiagnosaCppt({
    this.idDiagnosa,
    this.namaDiagnosa,
    this.kodeIcd10,
    this.type,
  });

  factory DiagnosaCppt.fromJson(Map<String, dynamic> json) => DiagnosaCppt(
        idDiagnosa: json["idDiagnosa"],
        namaDiagnosa: json["namaDiagnosa"],
        kodeIcd10: json["kodeIcd10"],
        type: json["type"],
      );
}

class AssesmentProsedur {
  List<ProsedurCppt>? prosedurs;
  dynamic catatan;

  AssesmentProsedur({
    this.prosedurs,
    this.catatan,
  });

  factory AssesmentProsedur.fromJson(Map<String, dynamic> json) =>
      AssesmentProsedur(
        prosedurs: json["prosedurs"] == null
            ? []
            : List<ProsedurCppt>.from(
                json["prosedurs"]!.map((x) => ProsedurCppt.fromJson(x))),
        catatan: json["catatan"],
      );
}

class ProsedurCppt {
  int? idProsedur;
  String? namaProsedur;
  String? type;

  ProsedurCppt({
    this.idProsedur,
    this.namaProsedur,
    this.type,
  });

  factory ProsedurCppt.fromJson(Map<String, dynamic> json) => ProsedurCppt(
        idProsedur: json["idProsedur"],
        namaProsedur: json["namaProsedur"],
        type: json["type"],
      );
}

class LabCppt {
  int? tindakanLab;
  int? hargaModal;
  String? namaTindakanLab;
  int? tarifAplikasi;

  LabCppt({
    this.tindakanLab,
    this.hargaModal,
    this.namaTindakanLab,
    this.tarifAplikasi,
  });

  factory LabCppt.fromJson(Map<String, dynamic> json) => LabCppt(
        tindakanLab: json["tindakanLab"],
        hargaModal: json["hargaModal"],
        namaTindakanLab: json["namaTindakanLab"],
        tarifAplikasi: json["tarifAplikasi"],
      );
}

class ObatInjeksiCppt {
  int? id;
  int? kunjunganInjeksiId;
  String? namaBarang;
  int? jumlah;
  String? aturanPakai;
  int? hargaModal;
  int? tarifAplikasi;
  String? catatan;

  ObatInjeksiCppt({
    this.id,
    this.kunjunganInjeksiId,
    this.namaBarang,
    this.jumlah,
    this.aturanPakai,
    this.hargaModal,
    this.tarifAplikasi,
    this.catatan,
  });

  factory ObatInjeksiCppt.fromJson(Map<String, dynamic> json) =>
      ObatInjeksiCppt(
        id: json["id"],
        kunjunganInjeksiId: json["kunjunganInjeksiId"],
        namaBarang: json["namaBarang"],
        jumlah: json["jumlah"],
        aturanPakai: json["aturanPakai"],
        hargaModal: json["hargaModal"],
        tarifAplikasi: json["tarifAplikasi"],
        catatan: json["catatan"],
      );
}

class BhpCppt {
  int? id;
  String? namaBarang;
  int? jumlah;
  int? hargaModal;
  int? tarifAplikasi;

  BhpCppt({
    this.id,
    this.namaBarang,
    this.jumlah,
    this.hargaModal,
    this.tarifAplikasi,
  });

  factory BhpCppt.fromJson(Map<String, dynamic> json) => BhpCppt(
        id: json["id"],
        namaBarang: json["namaBarang"],
        jumlah: json["jumlah"],
        hargaModal: json["hargaModal"],
        tarifAplikasi: json["tarifAplikasi"],
      );
}

class RadCppt {
  int? tindakanRad;
  String? namaTindakanRad;
  int? hargaModal;
  int? tarifAplikasi;

  RadCppt({
    this.tindakanRad,
    this.namaTindakanRad,
    this.hargaModal,
    this.tarifAplikasi,
  });

  factory RadCppt.fromJson(Map<String, dynamic> json) => RadCppt(
        tindakanRad: json["tindakanRad"],
        hargaModal: json["hargaModal"],
        namaTindakanRad: json["namaTindakanRad"],
        tarifAplikasi: json["tarifAplikasi"],
      );
}

class ResepCppt {
  int? id;
  int? kunjunganResepBarangId;
  dynamic namaBarang;
  int? jumlah;
  String? aturanPakai;
  int? hargaModal;
  int? tarifAplikasi;
  String? catatan;

  ResepCppt({
    this.id,
    this.kunjunganResepBarangId,
    this.namaBarang,
    this.jumlah,
    this.aturanPakai,
    this.hargaModal,
    this.tarifAplikasi,
    this.catatan,
  });

  factory ResepCppt.fromJson(Map<String, dynamic> json) => ResepCppt(
        id: json["id"],
        kunjunganResepBarangId: json["kunjunganResepBarangId"],
        namaBarang: json["namaBarang"],
        jumlah: json["jumlah"],
        aturanPakai: json["aturanPakai"],
        hargaModal: json["hargaModal"],
        tarifAplikasi: json["tarifAplikasi"],
        catatan: json["catatan"],
      );
}

class ResepRacikanCppt {
  int? id;
  String? namaRacikan;
  List<BarangRacikanCppt>? barangRacikan;
  String? aturanPakai;
  String? petunjuk;

  ResepRacikanCppt({
    this.id,
    this.namaRacikan,
    this.barangRacikan,
    this.aturanPakai,
    this.petunjuk,
  });

  factory ResepRacikanCppt.fromJson(Map<String, dynamic> json) =>
      ResepRacikanCppt(
        id: json["id"],
        namaRacikan: json["namaRacikan"],
        barangRacikan: json["barangRacikan"] == null
            ? []
            : List<BarangRacikanCppt>.from(json["barangRacikan"]!
                .map((x) => BarangRacikanCppt.fromJson(x))),
        aturanPakai: json["aturanPakai"],
        petunjuk: json["petunjuk"],
      );
}

class BarangRacikanCppt {
  int? id;
  String? namaBarang;
  String? dosis;
  int? hargaModal;
  int? tarifAplikasi;

  BarangRacikanCppt({
    this.id,
    this.namaBarang,
    this.dosis,
    this.hargaModal,
    this.tarifAplikasi,
  });

  factory BarangRacikanCppt.fromJson(Map<String, dynamic> json) =>
      BarangRacikanCppt(
        id: json["id"],
        namaBarang: json["namaBarang"],
        dosis: json["dosis"],
        hargaModal: json["hargaModal"],
        tarifAplikasi: json["tarifAplikasi"],
      );
}

class TindakanCppt {
  int? id;
  int? qty;
  String? namaTindakan;
  int? jasaDokter;
  int? jasaDokterPanggil;
  int? foc;

  TindakanCppt({
    this.id,
    this.qty,
    this.namaTindakan,
    this.jasaDokter,
    this.jasaDokterPanggil,
    this.foc,
  });

  factory TindakanCppt.fromJson(Map<String, dynamic> json) => TindakanCppt(
        id: json["id"],
        qty: json["qty"],
        namaTindakan: json["namaTindakan"],
        jasaDokter: json["jasaDokter"],
        jasaDokterPanggil: json["jasaDokterPanggil"],
        foc: json["foc"],
      );
}

class PegawaiPenerima {
  String? nama;
  int? id;
  String? profesi;

  PegawaiPenerima({
    this.id,
    this.nama,
    this.profesi,
  });
  factory PegawaiPenerima.fromJson(Map<String, dynamic> json) =>
      PegawaiPenerima(
        id: json["id"],
        nama: json["nama"],
        profesi: json["profesi"],
      );
}

class Racikans {
  int id;
  String namaRacikan;

  Racikans({
    required this.id,
    required this.namaRacikan,
  });

  factory Racikans.fromJson(Map<String, dynamic> json) => Racikans(
        id: json["id"],
        namaRacikan: json["nama_racikan"],
      );
}

class CpptableSoapPerawat {
  int? id;
  bool? isDewasa;
  String? subjektif;
  String? objektif;
  String? assesmentText;
  String? planningText;
  List<AssesmentPerawat>? assesment;
  List<PlanningPerawat>? planning;
  List<BhpCppt>? barangHabisPakai;
  List<TindakanPerawatCppt>? tindakanPerawat;
  dynamic ttv;
  String? verifiedAt;

  CpptableSoapPerawat({
    this.id,
    this.isDewasa,
    this.subjektif,
    this.objektif,
    this.assesmentText,
    this.planningText,
    this.assesment,
    this.planning,
    this.barangHabisPakai,
    this.tindakanPerawat,
    this.ttv,
    this.verifiedAt,
  });

  factory CpptableSoapPerawat.fromJson(Map<String, dynamic> json) =>
      CpptableSoapPerawat(
        id: json["id"],
        isDewasa: json["is_dewasa"],
        subjektif: json["subjektif"],
        objektif: json["objektif"],
        assesmentText: json["assesment_text"],
        planningText: json["planning_text"],
        assesment: json["assesment"] == null
            ? []
            : List<AssesmentPerawat>.from(
                json["assesment"]!.map((x) => AssesmentPerawat.fromJson(x))),
        planning: json["planning"] == null
            ? []
            : List<PlanningPerawat>.from(
                json["planning"]!.map((x) => PlanningPerawat.fromJson(x))),
        tindakanPerawat: json["tindakan_perawat"] == null
            ? []
            : List<TindakanPerawatCppt>.from(json["tindakan_perawat"]
                .map((x) => TindakanPerawatCppt.fromJson(x))),
        barangHabisPakai: json["bhp"] == null
            ? []
            : List<BhpCppt>.from(
                json["bhp"].map((x) => BhpCppt.fromJson(x)),
              ),
        ttv: json["ttv"] == null
            ? null
            : json["is_dewasa"]
                ? DataObservasi.fromJson(json["ttv"])
                : DataObservasiAnak.fromJson(json["ttv"]),
        verifiedAt: json["verified_at"],
      );
}

class AssesmentPerawat {
  int? id;
  String? diagnosa;

  AssesmentPerawat({
    this.id,
    this.diagnosa,
  });

  factory AssesmentPerawat.fromJson(Map<String, dynamic> json) =>
      AssesmentPerawat(
        id: json["id"],
        diagnosa: json["diagnosa"],
      );
}

class PlanningPerawat {
  int? id;
  int? diagnosaId;
  String? namaDiagnosa;
  String? namaTindakan;

  PlanningPerawat({
    this.id,
    this.diagnosaId,
    this.namaDiagnosa,
    this.namaTindakan,
  });

  factory PlanningPerawat.fromJson(Map<String, dynamic> json) =>
      PlanningPerawat(
        id: json["id"],
        diagnosaId: json["diagnosaId"],
        namaDiagnosa: json["namaDiagnosa"],
        namaTindakan: json["namaTindakan"],
      );
}

class TindakanPerawatCppt {
  int? idTindakan;
  String? namaTindakan;
  int? quantity;
  int? jasaDokter;
  int? jasaDokterPanggil;
  int? tarif;

  TindakanPerawatCppt({
    this.idTindakan,
    this.namaTindakan,
    this.quantity,
    this.jasaDokter,
    this.jasaDokterPanggil,
    this.tarif,
  });

  factory TindakanPerawatCppt.fromJson(Map<String, dynamic> json) =>
      TindakanPerawatCppt(
        idTindakan: json["idTindakan"],
        namaTindakan: json["namaTindakan"],
        quantity: json["quantity"],
        jasaDokter: json["jasaDokter"],
        jasaDokterPanggil: json["jasaDokterPanggil"],
        tarif: json["tarif"],
      );
}

class DiagnosaIcd9 {
  int? idDiagnosa;
  String? namaDiagnosa;
  String? kodeIcd9;
  String? type;

  DiagnosaIcd9({
    this.idDiagnosa,
    this.namaDiagnosa,
    this.kodeIcd9,
    this.type,
  });

  factory DiagnosaIcd9.fromJson(Map<String, dynamic> json) => DiagnosaIcd9(
        idDiagnosa: json["idDiagnosa"],
        namaDiagnosa: json["namaDiagnosa"],
        kodeIcd9: json["kodeIcd9"],
        type: json["type"],
      );
}

class PemberiInstruksiSbar {
  int? id;
  String? namaPegawai;

  PemberiInstruksiSbar({
    this.id,
    this.namaPegawai,
  });

  factory PemberiInstruksiSbar.fromJson(Map<String, dynamic> json) =>
      PemberiInstruksiSbar(
        id: json["id"],
        namaPegawai: json["nama_pegawai"],
      );
}
