import 'package:admin_dokter_panggil/src/models/mr_kunjungan_pengkajian_perawat_model.dart';

MrKunjunganObservasiModel mrKunjunganObservasiModelFromJson(dynamic str) =>
    MrKunjunganObservasiModel.fromJson(str);

class MrKunjunganObservasiModel {
  DataMrObservasi? data;
  String? message;

  MrKunjunganObservasiModel({
    this.data,
    this.message,
  });

  factory MrKunjunganObservasiModel.fromJson(Map<String, dynamic> json) =>
      MrKunjunganObservasiModel(
        data: json["data"] == null
            ? null
            : DataMrObservasi.fromJson(json["data"]),
        message: json["message"],
      );
}

class DataMrObservasi {
  int? id;
  String? nomorRegistrasi;
  bool? isDewasa;
  String? tanggalPengkajian;
  String? namaPerawat;
  TandaVital? tandaVital;
  List<DataObservasi>? observasi;

  DataMrObservasi({
    this.id,
    this.nomorRegistrasi,
    this.isDewasa,
    this.tanggalPengkajian,
    this.namaPerawat,
    this.tandaVital,
    this.observasi,
  });

  factory DataMrObservasi.fromJson(Map<String, dynamic> json) =>
      DataMrObservasi(
        id: json["id"],
        nomorRegistrasi: json["nomor_registrasi"],
        isDewasa: json["is_dewasa"],
        tanggalPengkajian: json["tanggal_pengkajian"],
        namaPerawat: json["nama_perawat"],
        tandaVital: json["tanda_vital"] == null
            ? null
            : TandaVital.fromJson(json["tanda_vital"]),
        observasi: json["observasi"] == null
            ? []
            : List<DataObservasi>.from(
                json["observasi"]!.map((x) => DataObservasi.fromJson(x))),
      );
}

class DataObservasi {
  int? id;
  String? namaPegawai;
  String? tanggal;
  String? rawTanggal;
  int? tdSistolik;
  int? tdDiastolik;
  int? nadi;
  int? pernapasan;
  double? suhu;
  String? nyeri;
  int? skalaNyeri;
  int? saturasiOksigen;
  String? bab;
  String? bak;
  double? bcInputOral;
  double? bcInputParenteral;
  double? totalBcInput;
  double? bcOutputMuntah;
  double? bcOutputKemih;
  double? totalBcOutput;
  List<Gcs>? gcs;
  String? skorGcs;
  ColorSelected? colorGcs;
  int? score;
  String? textScore;
  PenilaianMews? penilaian;
  String? kesadaran;
  ColorSelected? color;
  ColorSelected? colorKesadaran;
  ColorSelected? colorSistolik;
  ColorSelected? colorNadi;
  ColorSelected? colorPernapasan;
  ColorSelected? colorSuhu;
  ColorSelected? colorOksigen;
  String? pencetusNyeri;
  String? gambaranNyeri;
  String? lokasiNyeri;
  String? durasiNyeri;

  DataObservasi({
    this.id,
    this.namaPegawai,
    this.tanggal,
    this.rawTanggal,
    this.tdSistolik,
    this.tdDiastolik,
    this.nadi,
    this.pernapasan,
    this.suhu,
    this.nyeri,
    this.skalaNyeri,
    this.saturasiOksigen,
    this.bab,
    this.bak,
    this.bcInputOral,
    this.bcInputParenteral,
    this.totalBcInput,
    this.bcOutputMuntah,
    this.bcOutputKemih,
    this.totalBcOutput,
    this.gcs,
    this.skorGcs,
    this.colorGcs,
    this.score,
    this.color,
    this.textScore,
    this.penilaian,
    this.kesadaran,
    this.colorKesadaran,
    this.colorSistolik,
    this.colorNadi,
    this.colorPernapasan,
    this.colorSuhu,
    this.colorOksigen,
    this.pencetusNyeri,
    this.gambaranNyeri,
    this.lokasiNyeri,
    this.durasiNyeri,
  });

  factory DataObservasi.fromJson(Map<String, dynamic> json) => DataObservasi(
        id: json["id"],
        namaPegawai: json['nama_pegawai'],
        tanggal: json['tanggal'],
        rawTanggal: json["raw_tanggal"],
        tdSistolik: json["td_sistolik"],
        tdDiastolik: json["td_diastolik"],
        nadi: json["nadi"],
        pernapasan: json["pernapasan"],
        suhu: json["suhu"]?.toDouble(),
        nyeri: json['nyeri'],
        skalaNyeri: json["skala_nyeri"],
        pencetusNyeri: json["pencetus_nyeri"],
        gambaranNyeri: json["gambaran_nyeri"],
        lokasiNyeri: json["lokasi_nyeri"],
        durasiNyeri: json["durasi_nyeri"],
        saturasiOksigen: json["saturasi_oksigen"],
        bab: json["bab"],
        bak: json["bak"],
        bcInputOral: json["bc_input_oral"]?.toDouble(),
        bcInputParenteral: json["bc_input_parenteral"]?.toDouble(),
        totalBcInput: json["total_bc_input"]?.toDouble(),
        bcOutputMuntah: json["bc_output_muntah"]?.toDouble(),
        bcOutputKemih: json["bc_output_kemih"]?.toDouble(),
        totalBcOutput: json["total_bc_output"]?.toDouble(),
        gcs: json["gcs"] == null
            ? []
            : List<Gcs>.from(json["gcs"]!.map((x) => Gcs.fromJson(x))),
        skorGcs: json["score_gcs"],
        colorGcs: json["color_gcs"] == null
            ? null
            : ColorSelected.fromJson(json["color_gcs"]),
        score: json["score"],
        color: json["color"] == null
            ? null
            : ColorSelected.fromJson(json["color"]),
        textScore: json["text_score"],
        penilaian: json["penilaian"] == null
            ? null
            : PenilaianMews.fromJson(json["penilaian"]),
        kesadaran: json["kesadaran"],
        colorKesadaran: json["color_kesadaran"] == null
            ? null
            : ColorSelected.fromJson(json["color_kesadaran"]),
        colorSistolik: json["color_sistolik"] == null
            ? null
            : ColorSelected.fromJson(json["color_sistolik"]),
        colorNadi: json["color_nadi"] == null
            ? null
            : ColorSelected.fromJson(json["color_nadi"]),
        colorPernapasan: json["color_pernapasan"] == null
            ? null
            : ColorSelected.fromJson(json["color_pernapasan"]),
        colorSuhu: json["color_suhu"] == null
            ? null
            : ColorSelected.fromJson(json["color_suhu"]),
        colorOksigen: json["color_saturasi"] == null
            ? null
            : ColorSelected.fromJson(json["color_saturasi"]),
      );
}
