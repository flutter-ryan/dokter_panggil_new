import 'package:admin_dokter_panggil/src/models/master_bhp_model.dart';
import 'package:admin_dokter_panggil/src/models/mr_pengkajian_dokter_model.dart';

MrKunjunganPengkajianPerawatModel mrKunjunganPengkajianPerawatModelFromJson(
        dynamic str) =>
    MrKunjunganPengkajianPerawatModel.fromJson(str);

class MrKunjunganPengkajianPerawatModel {
  MrKunjunganPengkajianPerawat? data;
  String? message;

  MrKunjunganPengkajianPerawatModel({
    this.data,
    this.message,
  });

  factory MrKunjunganPengkajianPerawatModel.fromJson(
          Map<String, dynamic> json) =>
      MrKunjunganPengkajianPerawatModel(
        data: json["data"] == null
            ? null
            : MrKunjunganPengkajianPerawat.fromJson(json["data"]),
        message: json["message"],
      );
}

class MrKunjunganPengkajianPerawat {
  int? id;
  String? nomorRegistrasi;
  bool? isDewasa;
  PengkajianPerawat? pengkajianPerawat;

  MrKunjunganPengkajianPerawat({
    this.id,
    this.nomorRegistrasi,
    this.pengkajianPerawat,
    this.isDewasa,
  });

  factory MrKunjunganPengkajianPerawat.fromJson(Map<String, dynamic> json) =>
      MrKunjunganPengkajianPerawat(
        id: json["id"],
        nomorRegistrasi: json["nomor_registrasi"],
        isDewasa: json["is_dewasa"],
        pengkajianPerawat: json["pengkajian_perawat"] == null
            ? null
            : PengkajianPerawat.fromJson(json["pengkajian_perawat"]),
      );
}

class PengkajianPerawat {
  int? id;
  String? namaPegawai;
  String? tanggalPengkajian;
  KeluhanUtama? keluhanUtama;
  TandaVital? tandaVital;
  Nutrisi? nutrisi;
  List<SkriningGizi>? skriningGizi;
  String? mst;
  int? mstSkor;
  SkriningPsikososial? skriningPsikososial;
  List<ResikoJatuh>? resikoJatuh;
  List<MrKunjunganTindakan>? tindakanPerawat;
  List<MrBhp>? bhp;
  List<DiagnosaPerawat>? diagnosaPerawat;
  List<DiagnosaTindakanPerawat>? diagnosaTindakanPerawat;
  SelesaiPengkajianPerawat? selesaiPengkajianPerawat;

  PengkajianPerawat({
    this.id,
    this.namaPegawai,
    this.tanggalPengkajian,
    this.keluhanUtama,
    this.tandaVital,
    this.nutrisi,
    this.skriningGizi,
    this.mst,
    this.mstSkor,
    this.skriningPsikososial,
    this.resikoJatuh,
    this.diagnosaPerawat,
    this.diagnosaTindakanPerawat,
    this.selesaiPengkajianPerawat,
    this.tindakanPerawat,
    this.bhp,
  });

  factory PengkajianPerawat.fromJson(Map<String, dynamic> json) =>
      PengkajianPerawat(
        id: json["id"],
        namaPegawai: json["nama_pegawai"],
        tanggalPengkajian: json["tanggal_pengkajian"],
        keluhanUtama: json["keluhan_utama"] == null
            ? null
            : KeluhanUtama.fromJson(json["keluhan_utama"]),
        tandaVital: json["tanda_vital"] == null
            ? null
            : TandaVital.fromJson(json["tanda_vital"]),
        nutrisi:
            json["nutrisi"] == null ? null : Nutrisi.fromJson(json["nutrisi"]),
        skriningGizi: json["skrining_gizi"] == null
            ? []
            : List<SkriningGizi>.from(
                json["skrining_gizi"].map((x) => SkriningGizi.fromJson(x))),
        mst: json["mst"],
        mstSkor: json["skor_mst"],
        skriningPsikososial: json["skrining_psikososial"] == null
            ? null
            : SkriningPsikososial.fromJson(json["skrining_psikososial"]),
        resikoJatuh: json["resiko_jatuh"] == null
            ? []
            : List<ResikoJatuh>.from(
                json["resiko_jatuh"].map((x) => ResikoJatuh.fromJson(x))),
        tindakanPerawat: json["tindakan_perawat"] == null
            ? []
            : List<MrKunjunganTindakan>.from(json["tindakan_perawat"]
                .map((x) => MrKunjunganTindakan.fromJson(x))),
        bhp: json["barang_habis_pakai"] == null
            ? []
            : List<MrBhp>.from(
                json["barang_habis_pakai"].map((x) => MrBhp.fromJson(x))),
        diagnosaPerawat: json["diagnosa_perawat"] == null
            ? []
            : List<DiagnosaPerawat>.from(json["diagnosa_perawat"]
                .map((x) => DiagnosaPerawat.fromJson(x))),
        diagnosaTindakanPerawat: json["diagnosa_tindakan_perawat"] == null
            ? []
            : List<DiagnosaTindakanPerawat>.from(
                json["diagnosa_tindakan_perawat"]
                    .map((x) => DiagnosaTindakanPerawat.fromJson(x)),
              ),
        selesaiPengkajianPerawat: json["selesai_pengkajian"] == null
            ? null
            : SelesaiPengkajianPerawat.fromJson(json["selesai_pengkajian"]),
      );
}

class KeluhanUtama {
  int? id;
  String? keluhanUtama;

  KeluhanUtama({
    this.id,
    this.keluhanUtama,
  });

  factory KeluhanUtama.fromJson(Map<String, dynamic> json) => KeluhanUtama(
        id: json["id"],
        keluhanUtama: json["keluhan_utama"],
      );
}

class TandaVital {
  int? id;
  int? tdSistolik;
  ColorSelected? colorSistolik;
  int? tdDiastolik;
  int? nadi;
  ColorSelected? colorNadi;
  int? pernapasan;
  ColorSelected? colorPernapasan;
  String? suhu;
  ColorSelected? colorSuhu;
  int? saturasiOksigen;
  ColorSelected? colorOksigen;
  String? nyeri;
  int? skalaNyeri;
  String? bak;
  String? bab;
  String? cairanInputOral;
  String? cairanInputParenteral;
  double? totalInput;
  String? cairanOutputMuntah;
  String? cairanOutputKemih;
  double? totalOutput;
  List<Gcs>? gcs;
  int? score;
  String? textScore;
  PenilaianMews? penilaian;
  String? scoreGcs;
  ColorSelected? colorGcs;
  ColorSelected? colorSkor;
  String? kesadaran;
  ColorSelected? colorKesadaran;
  String? pencetusNyeri;
  String? gambaranNyeri;
  String? lokasiNyeri;
  String? durasiNyeri;

  TandaVital({
    this.id,
    this.tdSistolik,
    this.colorSistolik,
    this.tdDiastolik,
    this.nadi,
    this.colorNadi,
    this.pernapasan,
    this.colorPernapasan,
    this.suhu,
    this.colorSuhu,
    this.saturasiOksigen,
    this.colorOksigen,
    this.nyeri,
    this.skalaNyeri,
    this.bak,
    this.bab,
    this.cairanInputOral,
    this.cairanInputParenteral,
    this.totalInput,
    this.cairanOutputMuntah,
    this.cairanOutputKemih,
    this.totalOutput,
    this.gcs,
    this.colorGcs,
    this.score,
    this.textScore,
    this.penilaian,
    this.scoreGcs,
    this.colorSkor,
    this.kesadaran,
    this.colorKesadaran,
    this.pencetusNyeri,
    this.gambaranNyeri,
    this.lokasiNyeri,
    this.durasiNyeri,
  });

  factory TandaVital.fromJson(Map<String, dynamic> json) => TandaVital(
        id: json["id"],
        tdSistolik: json["td_sistolik"],
        colorSistolik: json["color_sistolik"] == null
            ? null
            : ColorSelected.fromJson(json["color_sistolik"]),
        tdDiastolik: json["td_diastolik"],
        nadi: json["nadi"],
        colorNadi: json["color_nadi"] == null
            ? null
            : ColorSelected.fromJson(json["color_nadi"]),
        pernapasan: json["pernapasan"],
        colorPernapasan: json["color_pernapasan"] == null
            ? null
            : ColorSelected.fromJson(json["color_pernapasan"]),
        suhu: json["suhu"],
        colorSuhu: json["color_suhu"] == null
            ? null
            : ColorSelected.fromJson(json["color_suhu"]),
        saturasiOksigen: json["saturasi_oksigen"],
        colorOksigen: json["color_oksigen"] == null
            ? null
            : ColorSelected.fromJson(json["color_oksigen"]),
        nyeri: json["nyeri"],
        skalaNyeri: json["skala_nyeri"],
        bak: json["bak"],
        bab: json["bab"],
        cairanInputOral: json["cairan_input_oral"],
        cairanInputParenteral: json["cairan_input_parenteral"],
        totalInput: json["total_input"]?.toDouble(),
        cairanOutputMuntah: json["cairan_output_muntah"],
        cairanOutputKemih: json["cairan_output_kemih"],
        totalOutput: json["total_output"]?.toDouble(),
        gcs: json["gcs"] == null
            ? []
            : List<Gcs>.from(json["gcs"]!.map((x) => Gcs.fromJson(x))),
        score: json["score"],
        textScore: json["text_score"],
        penilaian: json["penilaian"] == null
            ? null
            : PenilaianMews.fromJson(json["penilaian"]),
        scoreGcs: json["score_gcs"],
        colorGcs: json["color_gcs"] == null
            ? null
            : ColorSelected.fromJson(json["color_gcs"]),
        colorSkor: json["color_skor"] == null
            ? null
            : ColorSelected.fromJson(json["color_skor"]),
        kesadaran: json["kesadaran"],
        colorKesadaran: json["color_kesadaran"] == null
            ? null
            : ColorSelected.fromJson(json["color_kesadaran"]),
        pencetusNyeri: json["pencetus_nyeri"],
        gambaranNyeri: json["gambaran_nyeri"],
        lokasiNyeri: json["lokasi_nyeri"],
        durasiNyeri: json["durasi_nyeri"],
      );
}

class Gcs {
  int? id;
  String? jenisGcs;
  String? gcs;
  int? nilaiGcs;

  Gcs({
    this.id,
    this.jenisGcs,
    this.gcs,
    this.nilaiGcs,
  });

  factory Gcs.fromJson(Map<String, dynamic> json) => Gcs(
        id: json["id"],
        jenisGcs: json["jenis_gcs"],
        gcs: json["gcs"],
        nilaiGcs: json["nilai_gcs"],
      );
}

class DataSkalaNyeri {
  int? id;
  String? pencetus;
  String? gambaranNyeri;
  String? lokasiNyeri;
  String? durasi;

  DataSkalaNyeri({
    this.id,
    this.pencetus,
    this.gambaranNyeri,
    this.lokasiNyeri,
    this.durasi,
  });

  factory DataSkalaNyeri.fromJson(Map<String, dynamic> json) => DataSkalaNyeri(
        id: json["id"],
        pencetus: json["pencetus"],
        gambaranNyeri: json["gambaran_nyeri"],
        lokasiNyeri: json["lokasi_nyeri"],
        durasi: json["durasi"],
      );
}

class Nutrisi {
  int? id;
  int? tinggiBadan;
  int? beratBadan;
  double? imt;
  String? statusGizi;
  String? colorStatus;

  Nutrisi({
    this.id,
    this.tinggiBadan,
    this.beratBadan,
    this.imt,
    this.statusGizi,
    this.colorStatus,
  });

  factory Nutrisi.fromJson(Map<String, dynamic> json) => Nutrisi(
        id: json["id"],
        tinggiBadan: json["tinggi_badan"],
        beratBadan: json["berat_badan"],
        imt: json["imt"]?.toDouble(),
        statusGizi: json["status_gizi"],
        colorStatus: json["color_status"],
      );
}

class SkriningPsikososial {
  int? id;
  List<String>? kondisiPsikologis;
  String? sebutkanKondisiLain;
  String? statusMental;
  String? sebutkanMasalahperilaku;
  String? sebutkanPerilakuKekerasan;
  String? sosialHubunganPasien;
  String? sosialTempatTinggal;
  String? sebutkanTempatTinggalLain;
  String? kebiasaanBeribadahTeratur;
  String? pengambilKeputusanKeluarga;

  SkriningPsikososial({
    this.id,
    this.kondisiPsikologis,
    this.sebutkanKondisiLain,
    this.statusMental,
    this.sebutkanMasalahperilaku,
    this.sebutkanPerilakuKekerasan,
    this.sosialHubunganPasien,
    this.sosialTempatTinggal,
    this.sebutkanTempatTinggalLain,
    this.kebiasaanBeribadahTeratur,
    this.pengambilKeputusanKeluarga,
  });

  factory SkriningPsikososial.fromJson(Map<String, dynamic> json) =>
      SkriningPsikososial(
        id: json["id"],
        kondisiPsikologis: json["kondisi_psikologis"] == null
            ? []
            : List<String>.from(json["kondisi_psikologis"]!.map((x) => x)),
        sebutkanKondisiLain: json["sebutkan_kondisi_lain"],
        statusMental: json["status_mental"],
        sebutkanMasalahperilaku: json["sebutkan_masalah_perilaku"],
        sebutkanPerilakuKekerasan: json["sebutkan_perilaku_kekerasan"],
        sosialHubunganPasien: json["sosial_hubungan_pasien"],
        sosialTempatTinggal: json["sosial_tempat_tinggal"],
        sebutkanTempatTinggalLain: json["sebutkan_tempat_tinggal_lain"],
        kebiasaanBeribadahTeratur: json["kebiasaan_beribadah_teratur"],
        pengambilKeputusanKeluarga: json["pengambil_keputusan_keluarga"],
      );
}

class DiagnosaPerawat {
  int? id;
  int? diagnosaPerawatId;
  String? namaDiagnosa;

  DiagnosaPerawat({
    this.id,
    this.diagnosaPerawatId,
    this.namaDiagnosa,
  });

  factory DiagnosaPerawat.fromJson(Map<String, dynamic> json) =>
      DiagnosaPerawat(
        id: json["id"],
        diagnosaPerawatId: json["diagnosa_perawat_id"],
        namaDiagnosa: json["nama_diagnosa"],
      );
}

class ResikoJatuh {
  int? id;
  String? pertanyaan;
  String? jawaban;
  int? skala;

  ResikoJatuh({
    this.id,
    this.pertanyaan,
    this.jawaban,
    this.skala,
  });

  factory ResikoJatuh.fromJson(Map<String, dynamic> json) => ResikoJatuh(
        id: json["id"],
        pertanyaan: json["pertanyaan"],
        jawaban: json["jawaban"],
        skala: json["skala"],
      );
}

class SkriningGizi {
  int? id;
  String? pertanyaan;
  String? jawaban;
  int? skor;

  SkriningGizi({
    this.id,
    this.pertanyaan,
    this.jawaban,
    this.skor,
  });

  factory SkriningGizi.fromJson(Map<String, dynamic> json) => SkriningGizi(
        id: json["id"],
        pertanyaan: json["pertanyaan"],
        jawaban: json["jawaban"],
        skor: json["skor"],
      );
}

class DiagnosaTindakanPerawat {
  int? id;
  int? diagnosaId;
  int? diagnosaTindakanId;
  String? diagnosaTindakan;
  String? diagnosa;

  DiagnosaTindakanPerawat({
    this.id,
    this.diagnosaId,
    this.diagnosaTindakanId,
    this.diagnosaTindakan,
    this.diagnosa,
  });

  factory DiagnosaTindakanPerawat.fromJson(Map<String, dynamic> json) =>
      DiagnosaTindakanPerawat(
        id: json["id"],
        diagnosaId: json["diagnosa_id"],
        diagnosaTindakanId: json["diagnosa_tindakan_id"],
        diagnosaTindakan: json["diagnosa_tindakan"],
        diagnosa: json["diagnosa"],
      );
}

class SelesaiPengkajianPerawat {
  int? id;
  int? pengkajianId;
  String? namaPegawai;
  int? updateCount;
  bool? isUpdate;
  String? createdAt;
  String? updatedAt;

  SelesaiPengkajianPerawat({
    this.id,
    this.pengkajianId,
    this.namaPegawai,
    this.updateCount,
    this.isUpdate,
    this.createdAt,
    this.updatedAt,
  });

  factory SelesaiPengkajianPerawat.fromJson(Map<String, dynamic> json) =>
      SelesaiPengkajianPerawat(
        id: json["id"],
        pengkajianId: json["pengkajian_id"],
        namaPegawai: json["nama_pegawai"],
        updateCount: json["update_count"],
        isUpdate: json["is_update"],
        createdAt: json["created_at"],
        updatedAt: json["updated_at"],
      );
}

class PenilaianMews {
  String? klasifikasi;
  String? responKlinis;
  String? tindakan;
  String? frekuensi;

  PenilaianMews({
    this.klasifikasi,
    this.responKlinis,
    this.tindakan,
    this.frekuensi,
  });

  factory PenilaianMews.fromJson(Map<String, dynamic> json) => PenilaianMews(
        klasifikasi: json["klasifikasi"],
        responKlinis: json["respon_klinis"],
        tindakan: json["tindakan"],
        frekuensi: json["frekuensi"],
      );
}

class MrBhp {
  int? id;
  int? pengkajianPerawatId;
  int? pegawaiId;
  String? namaPegawai;
  String? tanggalBhp;
  List<KunjunganBhp>? kunjunganBhp;

  MrBhp({
    this.id,
    this.pengkajianPerawatId,
    this.pegawaiId,
    this.namaPegawai,
    this.tanggalBhp,
    this.kunjunganBhp,
  });

  factory MrBhp.fromJson(Map<String, dynamic> json) => MrBhp(
        id: json["id"],
        pengkajianPerawatId: json["pengkajian_perawat_id"],
        pegawaiId: json["pegawai_id"],
        namaPegawai: json["nama_pegawai"],
        tanggalBhp: json["tanggal_bhp"],
        kunjunganBhp: json["kunjungan_bhp"] == null
            ? []
            : List<KunjunganBhp>.from(
                json["kunjungan_bhp"]!.map((x) => KunjunganBhp.fromJson(x))),
      );
}

class KunjunganBhp {
  int? id;
  int? pegawaiId;
  MasterBhp? barang;
  int? hargaModal;
  int? jumlah;
  int? tarifAplikasi;
  int? tarif;

  KunjunganBhp({
    this.id,
    this.pegawaiId,
    this.barang,
    this.hargaModal,
    this.jumlah,
    this.tarifAplikasi,
    this.tarif,
  });

  factory KunjunganBhp.fromJson(Map<String, dynamic> json) => KunjunganBhp(
        id: json["id"],
        pegawaiId: json["pegawai_id"],
        barang:
            json["barang"] == null ? null : MasterBhp.fromJson(json["barang"]),
        hargaModal: json["harga_modal"],
        jumlah: json["jumlah"],
        tarifAplikasi: json["tarif_aplikasi"],
        tarif: json["tarif"],
      );
}

class ColorSelected {
  String? body;
  String? text;

  ColorSelected({
    this.body,
    this.text,
  });

  factory ColorSelected.fromJson(Map<String, dynamic> json) => ColorSelected(
        body: json["body"],
        text: json["text"],
      );
}
