import 'package:admin_dokter_panggil/src/models/mr_kunjungan_pengkajian_perawat_model.dart';
import 'package:admin_dokter_panggil/src/models/mr_pengkajian_dokter_model.dart';

MrPengkajianPerawatAnakModel mrPengkajianPerawatAnakModelFromJson(
        dynamic str) =>
    MrPengkajianPerawatAnakModel.fromJson(str);

class MrPengkajianPerawatAnakModel {
  MrPengkajianPerawatAnak? data;
  String? message;

  MrPengkajianPerawatAnakModel({
    this.data,
    this.message,
  });

  factory MrPengkajianPerawatAnakModel.fromJson(Map<String, dynamic> json) =>
      MrPengkajianPerawatAnakModel(
        data: json["data"] == null
            ? null
            : MrPengkajianPerawatAnak.fromJson(json["data"]),
        message: json["message"],
      );
}

class MrPengkajianPerawatAnak {
  int? id;
  String? nomorRegistrasi;
  bool? isDewasa;
  String? tanggalPengkajian;
  PengkajianPerawatAnak? pengkajianPerawatAnak;

  MrPengkajianPerawatAnak({
    this.id,
    this.nomorRegistrasi,
    this.isDewasa,
    this.tanggalPengkajian,
    this.pengkajianPerawatAnak,
  });

  factory MrPengkajianPerawatAnak.fromJson(Map<String, dynamic> json) =>
      MrPengkajianPerawatAnak(
        id: json["id"],
        nomorRegistrasi: json["nomor_registrasi"],
        isDewasa: json["is_dewasa"],
        tanggalPengkajian: json["tanggal_pengkajian"],
        pengkajianPerawatAnak: json["pengkajian_perawat_anak"] == null
            ? null
            : PengkajianPerawatAnak.fromJson(json["pengkajian_perawat_anak"]),
      );
}

class PengkajianPerawatAnak {
  int? id;
  String? namaPegawai;
  String? tanggalPengkajian;
  KeluhanUtama? keluhanUtama;
  TandaVitalAnak? tandaVital;
  List<SkriningGiziAnak>? skriningGizi;
  String? mst;
  int? mstSkor;
  ColorSelected? colorGizi;
  SkriningPsikososialAnak? skriningPsikososial;
  List<ResikoJatuh>? resikoJatuh;
  List<MrKunjunganTindakan>? tindakanPerawat;
  List<MrBhp>? bhp;
  List<DiagnosaPerawat>? diagnosaPerawat;
  List<DiagnosaTindakanPerawat>? diagnosaTindakanPerawat;
  SelesaiPengkajianPerawat? selesaiPengkajian;
  bool? isRemaja;

  PengkajianPerawatAnak({
    this.id,
    this.tanggalPengkajian,
    this.namaPegawai,
    this.keluhanUtama,
    this.tandaVital,
    this.skriningGizi,
    this.mst,
    this.mstSkor,
    this.colorGizi,
    this.skriningPsikososial,
    this.resikoJatuh,
    this.tindakanPerawat,
    this.bhp,
    this.diagnosaPerawat,
    this.diagnosaTindakanPerawat,
    this.selesaiPengkajian,
    this.isRemaja,
  });

  factory PengkajianPerawatAnak.fromJson(Map<String, dynamic> json) =>
      PengkajianPerawatAnak(
        id: json["id"],
        tanggalPengkajian: json["tanggal_pengkajian"],
        namaPegawai: json["nama_pegawai"],
        keluhanUtama: json["keluhan_utama"] == null
            ? null
            : KeluhanUtama.fromJson(json["keluhan_utama"]),
        tandaVital: json["tanda_vital"] == null
            ? null
            : TandaVitalAnak.fromJson(json["tanda_vital"]),
        mst: json["mst"],
        mstSkor: json["skor_mst"],
        colorGizi: json["color_gizi"] == null
            ? null
            : ColorSelected.fromJson(json["color_gizi"]),
        skriningGizi: json["skrining_gizi"] == null
            ? []
            : List<SkriningGiziAnak>.from(json["skrining_gizi"]!
                .map((x) => SkriningGiziAnak.fromJson(x))),
        skriningPsikososial: json["skrining_psikososial"] == null
            ? null
            : SkriningPsikososialAnak.fromJson(json["skrining_psikososial"]),
        resikoJatuh: json["resiko_jatuh"] == null
            ? []
            : List<ResikoJatuh>.from(
                json["resiko_jatuh"]!.map((x) => ResikoJatuh.fromJson(x))),
        tindakanPerawat: json["tindakan_perawat"] == null
            ? []
            : List<MrKunjunganTindakan>.from(
                json["tindakan_perawat"]
                    .map((x) => MrKunjunganTindakan.fromJson(x)),
              ),
        bhp: json["barang_habis_pakai"] == null
            ? []
            : List<MrBhp>.from(
                json["barang_habis_pakai"]!.map((x) => MrBhp.fromJson(x))),
        diagnosaPerawat: json["diagnosa_perawat"] == null
            ? []
            : List<DiagnosaPerawat>.from(json["diagnosa_perawat"]!
                .map((x) => DiagnosaPerawat.fromJson(x))),
        diagnosaTindakanPerawat: json["diagnosa_tindakan_perawat"] == null
            ? []
            : List<DiagnosaTindakanPerawat>.from(
                json["diagnosa_tindakan_perawat"]!
                    .map((x) => DiagnosaTindakanPerawat.fromJson(x))),
        selesaiPengkajian: json["selesai_pengkajian"] == null
            ? null
            : SelesaiPengkajianPerawat.fromJson(json["selesai_pengkajian"]),
        isRemaja: json["is_remaja"],
      );
}

class TandaVitalAnak {
  int? id;
  String? kesadaran;
  ColorSelected? colorKesadaran;
  int? tdSistolik;
  ColorSelected? colorSistolik;
  int? tdDiastolik;
  int? nadi;
  ColorSelected? colorNadi;
  int? pernapasan;
  ColorSelected? colorPernapasan;
  String? suhu;
  int? saturasiOksigen;
  ColorSelected? colorOksigen;
  String? alatBantuOksigen;
  ColorSelected? colorAlatBantu;
  String? nilaiAlatBantu;
  String? nyeri;
  int? skalaNyeri;
  String? bak;
  String? bab;
  String? cairanInputOral;
  String? cairanInputParenteral;
  int? totalInput;
  String? cairanOutputMuntah;
  String? cairanOutputKemih;
  int? totalOutput;
  int? score;
  String? textScore;
  String? penilaian;
  ColorSelected? colorSkor;
  int? waktuIsiKapiler;
  ColorSelected? colorWaktuIsiKapiler;
  DataSkalaNyeri? dataSkalaNyeri;
  String? pencetusNyeri;
  String? gambaranNyeri;
  String? lokasiNyeri;
  String? durasiNyeri;

  TandaVitalAnak({
    this.id,
    this.kesadaran,
    this.colorKesadaran,
    this.tdSistolik,
    this.colorSistolik,
    this.tdDiastolik,
    this.nadi,
    this.colorNadi,
    this.pernapasan,
    this.colorPernapasan,
    this.suhu,
    this.saturasiOksigen,
    this.colorOksigen,
    this.alatBantuOksigen,
    this.colorAlatBantu,
    this.nilaiAlatBantu,
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
    this.score,
    this.textScore,
    this.penilaian,
    this.colorSkor,
    this.waktuIsiKapiler,
    this.colorWaktuIsiKapiler,
    this.pencetusNyeri,
    this.gambaranNyeri,
    this.lokasiNyeri,
    this.durasiNyeri,
  });

  factory TandaVitalAnak.fromJson(Map<String, dynamic> json) => TandaVitalAnak(
        id: json["id"],
        kesadaran: json["kesadaran"],
        colorKesadaran: json["color_kesadaran"] == null
            ? null
            : ColorSelected.fromJson(json["color_kesadaran"]),
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
        saturasiOksigen: json["saturasi_oksigen"],
        colorOksigen: json["color_oksigen"] == null
            ? null
            : ColorSelected.fromJson(json["color_oksigen"]),
        alatBantuOksigen: json["alat_bantu_oksigen"],
        colorAlatBantu: json["color_alat_bantu"] == null
            ? null
            : ColorSelected.fromJson(json["color_alat_bantu"]),
        nilaiAlatBantu: json["nilai_alat_bantu"],
        nyeri: json["nyeri"],
        skalaNyeri: json["skala_nyeri"],
        bak: json["bak"],
        bab: json["bab"],
        cairanInputOral: json["cairan_input_oral"],
        cairanInputParenteral: json["cairan_input_parenteral"],
        totalInput: json["total_input"],
        cairanOutputMuntah: json["cairan_output_muntah"],
        cairanOutputKemih: json["cairan_output_kemih"],
        totalOutput: json["total_output"],
        score: json["score"],
        textScore: json["text_score"],
        penilaian: json["penilaian"],
        colorSkor: json["color_skor"] == null
            ? null
            : ColorSelected.fromJson(json["color_skor"]),
        waktuIsiKapiler: json["waktu_isi_kapiler"],
        colorWaktuIsiKapiler: json["color_isi_kapiler"] == null
            ? null
            : ColorSelected.fromJson(json["color_isi_kapiler"]),
        lokasiNyeri: json["lokasi_nyeri"],
        gambaranNyeri: json["gambaran_nyeri"],
        pencetusNyeri: json["pencetus_nyeri"],
        durasiNyeri: json["durasi_nyeri"],
      );
}

class SkriningGiziAnak {
  int? id;
  int? pertanyaanId;
  String? pertanyaan;
  String? jawaban;
  int? skor;

  SkriningGiziAnak({
    this.id,
    this.pertanyaanId,
    this.pertanyaan,
    this.jawaban,
    this.skor,
  });

  factory SkriningGiziAnak.fromJson(Map<String, dynamic> json) =>
      SkriningGiziAnak(
        id: json["id"],
        pertanyaanId: json["pertanyaan_id"],
        pertanyaan: json["pertanyaan"],
        jawaban: json["jawaban"],
        skor: json["skor"],
      );
}

class SkriningPsikososialAnak {
  int? id;
  List<String>? kondisiPsikologis;
  String? sebutkanKondisiLain;
  List<String>? napza;
  String? infeksiMenularSeksual;
  String? hivAids;
  String? prilakuSeksual;
  String? polaTidur;
  String? pendidikan;
  String? pubertas;
  String? statusPubertas;
  String? umur;
  String? statusMental;
  String? sebutkanMasalahPerilaku;
  String? sebutkanPerilakuKekerasan;
  String? sosialHubunganPasien;
  String? sosialTempatTinggal;
  String? sebutkanTempatTinggalLain;
  String? kebiasaanBeribadahTeratur;
  String? pengambilKeputusanKeluarga;

  SkriningPsikososialAnak({
    this.id,
    this.kondisiPsikologis,
    this.sebutkanKondisiLain,
    this.napza,
    this.infeksiMenularSeksual,
    this.hivAids,
    this.prilakuSeksual,
    this.polaTidur,
    this.pendidikan,
    this.pubertas,
    this.statusPubertas,
    this.umur,
    this.statusMental,
    this.sebutkanMasalahPerilaku,
    this.sebutkanPerilakuKekerasan,
    this.sosialHubunganPasien,
    this.sosialTempatTinggal,
    this.sebutkanTempatTinggalLain,
    this.kebiasaanBeribadahTeratur,
    this.pengambilKeputusanKeluarga,
  });

  factory SkriningPsikososialAnak.fromJson(Map<String, dynamic> json) =>
      SkriningPsikososialAnak(
        id: json["id"],
        kondisiPsikologis: json["kondisi_psikologis"] == null
            ? []
            : List<String>.from(json["kondisi_psikologis"]!.map((x) => x)),
        sebutkanKondisiLain: json["sebutkan_kondisi_lain"],
        napza: json["napza"] == null
            ? []
            : List<String>.from(json["napza"]!.map((x) => x)),
        infeksiMenularSeksual: json["infeksi_menular_seksual"],
        hivAids: json["hiv_aids"],
        prilakuSeksual: json["prilaku_seksual"],
        polaTidur: json["pola_tidur"],
        pendidikan: json["pendidikan"],
        pubertas: json["pubertas"],
        statusPubertas: json["status_pubertas"],
        umur: json["umur"],
        statusMental: json["status_mental"],
        sebutkanMasalahPerilaku: json["sebutkan_masalah_perilaku"],
        sebutkanPerilakuKekerasan: json["sebutkan_perilaku_kekerasan"],
        sosialHubunganPasien: json["sosial_hubungan_pasien"],
        sosialTempatTinggal: json["sosial_tempat_tinggal"],
        sebutkanTempatTinggalLain: json["sebutkan_tempat_tinggal_lain"],
        kebiasaanBeribadahTeratur: json["kebiasaan_beribadah_teratur"],
        pengambilKeputusanKeluarga: json["pengambil_keputusan_keluarga"],
      );
}
