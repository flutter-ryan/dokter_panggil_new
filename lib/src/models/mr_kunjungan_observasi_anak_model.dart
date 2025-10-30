import 'package:admin_dokter_panggil/src/models/mr_kunjungan_pengkajian_perawat_model.dart';
import 'package:admin_dokter_panggil/src/models/mr_pengkajian_perawat_anak_model.dart';

MrKunjunganObservasiAnakModel mrKunjunganObservasiAnakModelFromJson(
        dynamic str) =>
    MrKunjunganObservasiAnakModel.fromJson(str);

class MrKunjunganObservasiAnakModel {
  DataMrObservasiAnak? data;
  String? message;

  MrKunjunganObservasiAnakModel({
    this.data,
    this.message,
  });

  factory MrKunjunganObservasiAnakModel.fromJson(Map<String, dynamic> json) =>
      MrKunjunganObservasiAnakModel(
        data: json["data"] == null
            ? null
            : DataMrObservasiAnak.fromJson(json["data"]),
        message: json["message"],
      );
}

class DataMrObservasiAnak {
  int? id;
  String? nomorRegistrasi;
  bool? isDewasa;
  String? tanggalPengkajian;
  String? namaPerawat;
  TandaVitalAnak? tandaVital;
  List<DataObservasiAnak>? observasi;

  DataMrObservasiAnak({
    this.id,
    this.nomorRegistrasi,
    this.isDewasa,
    this.tanggalPengkajian,
    this.namaPerawat,
    this.tandaVital,
    this.observasi,
  });

  factory DataMrObservasiAnak.fromJson(Map<String, dynamic> json) =>
      DataMrObservasiAnak(
        id: json["id"],
        nomorRegistrasi: json["nomor_registrasi"],
        isDewasa: json["is_dewasa"],
        tanggalPengkajian: json["tanggal_pengkajian"],
        namaPerawat: json["nama_perawat"],
        tandaVital: json["tanda_vital"] == null
            ? null
            : TandaVitalAnak.fromJson(json["tanda_vital"]),
        observasi: json["observasi"] == null
            ? []
            : List<DataObservasiAnak>.from(
                json["observasi"]!.map((x) => DataObservasiAnak.fromJson(x))),
      );
}

class DataObservasiAnak {
  int? id;
  int? pegawaiId;
  String? namaPegawai;
  String? tanggal;
  String? rawTanggal;
  int? tdSistolik;
  ColorSelected? colorSistolik;
  int? tdDiastolik;
  int? nadi;
  int? pernapasan;
  double? suhu;
  String? nyeri;
  int? skalaNyeri;
  int? saturasiOksigen;
  int? waktuIsiKapiler;
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
  int? score;
  String? textScore;
  String? penilaian;
  String? kesadaran;
  ColorSelected? color;
  String? alatBantuOksigen;
  String? nilaiAlatBantu;
  ColorSelected? colorAlatBantu;
  ColorSelected? colorKesadaran;
  ColorSelected? colorWarnaKulit;
  ColorSelected? colorSaturasi;
  ColorSelected? colorNadi;
  ColorSelected? colorPernapasan;
  ColorSelected? colorIsiKapiler;
  String? pencetusNyeri;
  String? gambaranNyeri;
  String? lokasiNyeri;
  String? durasiNyeri;

  DataObservasiAnak({
    this.id,
    this.pegawaiId,
    this.namaPegawai,
    this.tanggal,
    this.rawTanggal,
    this.tdSistolik,
    this.colorSistolik,
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
    this.score,
    this.color,
    this.textScore,
    this.penilaian,
    this.kesadaran,
    this.alatBantuOksigen,
    this.nilaiAlatBantu,
    this.colorAlatBantu,
    this.colorKesadaran,
    this.colorWarnaKulit,
    this.colorSaturasi,
    this.colorNadi,
    this.colorPernapasan,
    this.waktuIsiKapiler,
    this.colorIsiKapiler,
    this.pencetusNyeri,
    this.gambaranNyeri,
    this.lokasiNyeri,
    this.durasiNyeri,
  });

  factory DataObservasiAnak.fromJson(Map<String, dynamic> json) =>
      DataObservasiAnak(
        id: json["id"],
        pegawaiId: json["pegawai_id"],
        namaPegawai: json['nama_pegawai'],
        tanggal: json['tanggal'],
        rawTanggal: json['raw_tanggal'],
        tdSistolik: json["td_sistolik"],
        colorSistolik: json["color_sistolik"] == null
            ? null
            : ColorSelected.fromJson(json["color_sistolik"]),
        tdDiastolik: json["td_diastolik"],
        nadi: json["nadi"],
        pernapasan: json["pernapasan"],
        suhu: json["suhu"]?.toDouble(),
        nyeri: json['nyeri'],
        skalaNyeri: json["skala_nyeri"],
        saturasiOksigen: json["saturasi_oksigen"],
        bab: json["bab"],
        bak: json["bak"],
        bcInputOral: json["bc_input_oral"]?.toDouble(),
        bcInputParenteral: json["bc_input_parenteral"]?.toDouble(),
        totalBcInput: json["total_bc_input"]?.toDouble(),
        bcOutputMuntah: json["bc_output_muntah"]?.toDouble(),
        bcOutputKemih: json["bc_output_kemih"]?.toDouble(),
        totalBcOutput: json["total_bc_output"]?.toDouble(),
        score: json["score"],
        color: json["color_skor"] == null
            ? null
            : ColorSelected.fromJson(json["color_skor"]),
        textScore: json["text_score"],
        penilaian: json["penilaian"],
        kesadaran: json["kesadaran"],
        alatBantuOksigen: json["alat_bantu_oksigen"],
        nilaiAlatBantu: json["nilai_alat_bantu"],
        waktuIsiKapiler: json["waktu_isi_kapiler"],
        colorAlatBantu: json["color_alat_bantu"] == null
            ? null
            : ColorSelected.fromJson(json["color_alat_bantu"]),
        colorKesadaran: json["color_kesadaran"] == null
            ? null
            : ColorSelected.fromJson(json["color_kesadaran"]),
        colorSaturasi: json["color_oksigen"] == null
            ? null
            : ColorSelected.fromJson(json["color_oksigen"]),
        colorWarnaKulit: json["color_warna_kulit"] == null
            ? null
            : ColorSelected.fromJson(json["color_warna_kulit"]),
        colorNadi: json["color_nadi"] == null
            ? null
            : ColorSelected.fromJson(json["color_nadi"]),
        colorPernapasan: json["color_pernapasan"] == null
            ? null
            : ColorSelected.fromJson(json["color_pernapasan"]),
        colorIsiKapiler: json["color_isi_kapiler"] == null
            ? null
            : ColorSelected.fromJson(json["color_isi_kapiler"]),
        pencetusNyeri: json["pencetus_nyeri"],
        gambaranNyeri: json["gambaran_nyeri"],
        lokasiNyeri: json["lokasi_nyeri"],
        durasiNyeri: json["durasi_nyeri"],
      );
}
