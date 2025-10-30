import 'package:admin_dokter_panggil/src/models/mr_pengkajian_telemedicine_model.dart';

MrPengkajianDokterModel mrPengkajianDokterModelFromJson(dynamic str) =>
    MrPengkajianDokterModel.fromJson(str);

class MrPengkajianDokterModel {
  DataMrPengkajianDokter? data;
  String? message;

  MrPengkajianDokterModel({
    this.data,
    this.message,
  });

  factory MrPengkajianDokterModel.fromJson(Map<String, dynamic> json) =>
      MrPengkajianDokterModel(
        data: json["data"] == null
            ? null
            : DataMrPengkajianDokter.fromJson(json["data"]),
        message: json["message"],
      );
}

class DataMrPengkajianDokter {
  int? id;
  String? nomorRegistrasi;
  MrKunjunganAnamnesa? anamnesa;
  MrKunjunganPemeriksaanFisis? pemeriksaanFisis;
  MrDiagnosaDokter? mrDiagnosaDokter;
  MrDiagnosaIcdDokter? mrDiagnosaIcdDokter;
  MrProsedur? mrProsedur;
  List<MrKunjunganTindakan>? kunjunganTindakan;
  List<MrKunjunganResepObatInjeksi>? kunjunganObatInjeksi;
  List<MrKunjunganResepOral>? kunjunganResep;
  List<MrKunjunganResepRacikan>? kunjunganResepRacikan;
  List<MrPengantarLab>? kunjunganTindakanLab;
  List<RiwayatDokumenLab>? dokumenLab;
  List<MrPengantarRad>? kunjunganTindakanRad;
  List<RiwayatDokumenRad>? dokumenRad;
  List<String>? layananLanjutan;
  SelesaiPengkajian? selesaiPengkajian;
  RencanaTerapi? rencanaTerapi;

  DataMrPengkajianDokter({
    this.id,
    this.nomorRegistrasi,
    this.anamnesa,
    this.pemeriksaanFisis,
    this.mrDiagnosaDokter,
    this.mrDiagnosaIcdDokter,
    this.mrProsedur,
    this.kunjunganTindakan,
    this.kunjunganObatInjeksi,
    this.kunjunganResep,
    this.kunjunganResepRacikan,
    this.kunjunganTindakanLab,
    this.dokumenLab,
    this.kunjunganTindakanRad,
    this.dokumenRad,
    this.layananLanjutan,
    this.selesaiPengkajian,
    this.rencanaTerapi,
  });

  factory DataMrPengkajianDokter.fromJson(Map<String, dynamic> json) =>
      DataMrPengkajianDokter(
        id: json["id"],
        nomorRegistrasi: json["nomor_registrasi"],
        anamnesa: json["anamnesa"] == null
            ? null
            : MrKunjunganAnamnesa.fromJson(json["anamnesa"]),
        pemeriksaanFisis: json["pemeriksaan_fisis"] == null
            ? null
            : MrKunjunganPemeriksaanFisis.fromJson(json["pemeriksaan_fisis"]),
        mrDiagnosaDokter: json["diagnosa"] == null
            ? null
            : MrDiagnosaDokter.fromJson(json["diagnosa"]),
        mrDiagnosaIcdDokter: json["diagnosa_icd"] == null
            ? null
            : MrDiagnosaIcdDokter.fromJson(json["diagnosa_icd"]),
        mrProsedur: json["prosedur"] == null
            ? null
            : MrProsedur.fromJson(json["prosedur"]),
        kunjunganTindakan: json["kunjungan_tindakan"] == null
            ? []
            : List<MrKunjunganTindakan>.from(json["kunjungan_tindakan"]!
                .map((x) => MrKunjunganTindakan.fromJson(x))),
        kunjunganObatInjeksi: json["kunjungan_obat_injeksi"] == null
            ? []
            : List<MrKunjunganResepObatInjeksi>.from(
                json["kunjungan_obat_injeksi"]!
                    .map((x) => MrKunjunganResepObatInjeksi.fromJson(x))),
        kunjunganResep: json["kunjungan_resep"] == null
            ? []
            : List<MrKunjunganResepOral>.from(json["kunjungan_resep"]!
                .map((x) => MrKunjunganResepOral.fromJson(x))),
        kunjunganResepRacikan: json["kunjungan_resep_racikan"] == null
            ? []
            : List<MrKunjunganResepRacikan>.from(
                json["kunjungan_resep_racikan"]!
                    .map((x) => MrKunjunganResepRacikan.fromJson(x))),
        kunjunganTindakanLab: json["kunjungan_tindakan_lab"] == null
            ? []
            : List<MrPengantarLab>.from(json["kunjungan_tindakan_lab"]!
                .map((x) => MrPengantarLab.fromJson(x))),
        dokumenLab: json["dokumen_hasil_lab"] == null
            ? []
            : List<RiwayatDokumenLab>.from(json["dokumen_hasil_lab"]!
                .map((x) => RiwayatDokumenLab.fromJson(x))),
        kunjunganTindakanRad: json["kunjungan_tindakan_rad"] == null
            ? []
            : List<MrPengantarRad>.from(json["kunjungan_tindakan_rad"]!
                .map((x) => MrPengantarRad.fromJson(x))),
        dokumenRad: json["dokumen_hasil_rad"] == null
            ? null
            : List<RiwayatDokumenRad>.from(json["dokumen_hasil_rad"]!
                .map((x) => RiwayatDokumenRad.fromJson(x))),
        layananLanjutan: json["layanan_lanjutan"] == null
            ? null
            : List<String>.from(json["layanan_lanjutan"]!.map((x) => x)),
        selesaiPengkajian: json["selesai_pengkajian"] == null
            ? null
            : SelesaiPengkajian.fromJson(json["selesai_pengkajian"]),
        rencanaTerapi: json["rencana_terapi"] == null
            ? null
            : RencanaTerapi.fromJson(json["rencana_terapi"]),
      );
}

class MrDiagnosaDokter {
  int? id;
  int? kunjunganId;
  String? namaPegawai;
  String? catatan;
  List<DiagnosaDokter>? diagnosas;

  MrDiagnosaDokter({
    this.id,
    this.kunjunganId,
    this.namaPegawai,
    this.catatan,
    this.diagnosas,
  });

  factory MrDiagnosaDokter.fromJson(Map<String, dynamic> json) =>
      MrDiagnosaDokter(
        id: json["id"],
        kunjunganId: json["kunjungan_id"],
        namaPegawai: json["nama_pegawai"],
        catatan: json["catatan"],
        diagnosas: json["diagnosas"] == null
            ? []
            : List<DiagnosaDokter>.from(
                json["diagnosas"]!.map((x) => DiagnosaDokter.fromJson(x))),
      );
}

class DiagnosaDokter {
  int? id;
  String? kodeIcd10;
  String? namaDiagnosa;
  String? type;
  int? idItemDiagnosa;

  DiagnosaDokter({
    this.id,
    this.kodeIcd10,
    this.namaDiagnosa,
    this.type,
    this.idItemDiagnosa,
  });

  factory DiagnosaDokter.fromJson(Map<String, dynamic> json) => DiagnosaDokter(
        id: json["id"],
        kodeIcd10: json["kode_icd_10"],
        namaDiagnosa: json["nama_diagnosa"],
        type: json["type"],
        idItemDiagnosa: json["id_item_diagnosa"],
      );
}

class MrProsedur {
  int? id;
  int? kunjunganId;
  int? pegawaiId;
  String? catatan;
  List<Prosedur>? prosedur;

  MrProsedur({
    this.id,
    this.kunjunganId,
    this.pegawaiId,
    this.catatan,
    this.prosedur,
  });

  factory MrProsedur.fromJson(Map<String, dynamic> json) => MrProsedur(
        id: json["id"],
        kunjunganId: json["kunjungan_id"],
        pegawaiId: json["pegawai_id"],
        catatan: json["catatan"],
        prosedur: json["prosedur"] == null
            ? []
            : List<Prosedur>.from(
                json["prosedur"]!.map((x) => Prosedur.fromJson(x))),
      );
}

class Prosedur {
  int? id;
  String? kodeIcd9;
  String? prosedur;
  String? type;

  Prosedur({
    this.id,
    this.kodeIcd9,
    this.prosedur,
    this.type,
  });

  factory Prosedur.fromJson(Map<String, dynamic> json) => Prosedur(
        id: json["id"],
        kodeIcd9: json["kode_icd_9"],
        prosedur: json["prosedur"],
        type: json["type"],
      );
}

class MrKunjunganTindakan {
  int? id;
  int? kunjunganId;
  int? tindakanId;
  String? namaTindakan;
  int? jasaDokter;
  int? jasaDokterPanggil;
  int? quantity;
  int? total;
  int? foc;

  MrKunjunganTindakan({
    this.id,
    this.kunjunganId,
    this.tindakanId,
    this.namaTindakan,
    this.jasaDokter,
    this.jasaDokterPanggil,
    this.quantity,
    this.total,
    this.foc,
  });

  factory MrKunjunganTindakan.fromJson(Map<String, dynamic> json) =>
      MrKunjunganTindakan(
        id: json["id"],
        kunjunganId: json["kunjungan_id"],
        tindakanId: json["tindakan_id"],
        namaTindakan: json["nama_tindakan"],
        jasaDokter: json["jasa_dokter"],
        jasaDokterPanggil: json["jasa_dokter_panggil"],
        quantity: json["quantity"],
        total: json["total"],
        foc: json["foc"],
      );
}

class MrKunjunganResepObatInjeksi {
  int? id;
  String? tanggalResepInjeksi;
  int? status;
  List<MrKunjunganObatInjeksi>? obatInjeksi;

  MrKunjunganResepObatInjeksi({
    this.id,
    this.tanggalResepInjeksi,
    this.status,
    this.obatInjeksi,
  });

  factory MrKunjunganResepObatInjeksi.fromJson(Map<String, dynamic> json) =>
      MrKunjunganResepObatInjeksi(
        id: json["id"],
        tanggalResepInjeksi: json["tanggal_resep_injeksi"],
        status: json["status"],
        obatInjeksi: json["obatInjeksi"] == null
            ? []
            : List<MrKunjunganObatInjeksi>.from(json["obatInjeksi"]!
                .map((x) => MrKunjunganObatInjeksi.fromJson(x))),
      );
}

class MrKunjunganObatInjeksi {
  int? id;
  int? resepInjeksiId;
  int? pegawaiId;
  Barang? barang;
  int? jumlah;
  String? aturanPakai;
  String? catatan;
  int? hargaModal;
  int? tarifAplikasi;
  int? tarif;
  String? dokter;
  bool isPengobatan;

  MrKunjunganObatInjeksi({
    this.id,
    this.resepInjeksiId,
    this.pegawaiId,
    this.barang,
    this.jumlah,
    this.aturanPakai,
    this.catatan,
    this.hargaModal,
    this.tarifAplikasi,
    this.tarif,
    this.dokter,
    this.isPengobatan = false,
  });

  factory MrKunjunganObatInjeksi.fromJson(Map<String, dynamic> json) =>
      MrKunjunganObatInjeksi(
        id: json["id"],
        resepInjeksiId: json["resep_injeksi_id"],
        pegawaiId: json["pegawai_id"],
        barang: json["barang"] == null ? null : Barang.fromJson(json["barang"]),
        jumlah: json["jumlah"],
        aturanPakai: json["aturan_pakai"],
        catatan: json["catatan"],
        hargaModal: json["harga_modal"],
        tarifAplikasi: json["tarif_aplikasi"],
        tarif: json["tarif"],
        dokter: json["dokter"],
        isPengobatan: json["is_pengobatan"],
      );
}

class Barang {
  int? id;
  String? namaBarang;

  Barang({
    this.id,
    this.namaBarang,
  });

  factory Barang.fromJson(Map<String, dynamic> json) => Barang(
        id: json["id"],
        namaBarang: json["nama_barang"],
      );
}

class Kategori {
  int? id;
  String? kategori;

  Kategori({
    this.id,
    this.kategori,
  });

  factory Kategori.fromJson(Map<String, dynamic> json) => Kategori(
        id: json["id"],
        kategori: json["kategori"],
      );
}

class Stock {
  int? id;
  int? currentStock;

  Stock({
    this.id,
    this.currentStock,
  });

  factory Stock.fromJson(Map<String, dynamic> json) => Stock(
        id: json["id"],
        currentStock: json["current_stock"],
      );
}

class SelesaiPengkajian {
  int? id;
  int? kunjunganId;
  String? namaPegawai;
  String? createdAt;
  bool? isUpdate;
  String? updatedAt;

  SelesaiPengkajian({
    this.id,
    this.kunjunganId,
    this.namaPegawai,
    this.isUpdate,
    this.createdAt,
    this.updatedAt,
  });

  factory SelesaiPengkajian.fromJson(Map<String, dynamic> json) =>
      SelesaiPengkajian(
        id: json["id"],
        kunjunganId: json["kunjungan_id"],
        namaPegawai: json["nama_pegawai"],
        isUpdate: json["is_update"],
        createdAt: json["created_at"],
        updatedAt: json["updated_at"],
      );
}

class RencanaTerapi {
  int? id;
  int? kunjunganId;
  String? rencanaTerapi;

  RencanaTerapi({
    this.id,
    this.kunjunganId,
    this.rencanaTerapi,
  });

  factory RencanaTerapi.fromJson(Map<String, dynamic> json) => RencanaTerapi(
        id: json["id"],
        kunjunganId: json["kunjungan_id"],
        rencanaTerapi: json["rencana_terapi"],
      );
}

class KonfirmasiHasilLab {
  int? id;
  int? kunjunganId;
  String? confirmedAt;
  String? namaPegawai;

  KonfirmasiHasilLab({
    this.id,
    this.kunjunganId,
    this.confirmedAt,
    this.namaPegawai,
  });

  factory KonfirmasiHasilLab.fromJson(Map<String, dynamic> json) =>
      KonfirmasiHasilLab(
        id: json["id"],
        kunjunganId: json["kunjungan_id"],
        confirmedAt: json["confirmed_at"],
        namaPegawai: json["nama_pegawai"],
      );
}

class DokumenRad {
  int? id;
  PasienDokumen? pasien;
  String? namaFile;
  String? url;
  String? ext;
  String? confirmedBy;
  String? confirmedAt;
  String? createdAt;

  DokumenRad({
    this.id,
    this.pasien,
    this.namaFile,
    this.url,
    this.ext,
    this.confirmedBy,
    this.confirmedAt,
    this.createdAt,
  });

  factory DokumenRad.fromJson(Map<String, dynamic> json) => DokumenRad(
        id: json["id"],
        pasien: json["pasien"] == null
            ? null
            : PasienDokumen.fromJson(json["pasien"]),
        namaFile: json["nama_file"],
        url: json["url"],
        ext: json["ext"],
        confirmedBy: json["confirmed_by"],
        confirmedAt: json["confirmed_at"],
        createdAt: json["created_at"],
      );
}

class MrDiagnosaIcdDokter {
  int? id;
  int? kunjunganId;
  String? namaPegawai;
  String? catatan;
  List<DiagnosaIcdDokter>? diagnosas;

  MrDiagnosaIcdDokter({
    this.id,
    this.kunjunganId,
    this.namaPegawai,
    this.catatan,
    this.diagnosas,
  });

  factory MrDiagnosaIcdDokter.fromJson(Map<String, dynamic> json) =>
      MrDiagnosaIcdDokter(
        id: json["id"],
        kunjunganId: json["kunjungan_id"],
        namaPegawai: json["nama_pegawai"],
        catatan: json["catatan"],
        diagnosas: json["diagnosa_icds"] == null
            ? []
            : List<DiagnosaIcdDokter>.from(json["diagnosa_icds"]!
                .map((x) => DiagnosaIcdDokter.fromJson(x))),
      );
}

class DiagnosaIcdDokter {
  int? id;
  int? diagnosaId;
  String? code;
  String? display;
  String? type;

  DiagnosaIcdDokter({
    this.id,
    this.diagnosaId,
    this.code,
    this.display,
    this.type,
  });

  factory DiagnosaIcdDokter.fromJson(Map<String, dynamic> json) =>
      DiagnosaIcdDokter(
        id: json["id"],
        diagnosaId: json["diagnosa_id"],
        code: json["code"],
        display: json["display"],
        type: json["type"],
      );
}

class MrKunjunganPemeriksaanFisis {
  int? id;
  int? kunjunganId;
  int? pegawaiId;
  Mata? mata;
  Tht? tht;
  Leher? leher;
  KakuDuduk? kakuDuduk;
  Thoraks? thoraks;
  Chor? chor;
  Pulmo? pulmo;
  Abdomen? abdomen;
  Peristaltik? peristaltik;
  Asites? asites;
  NyeriTekan? nyeriTekan;
  HeparLien? heparLien;
  Extremitas? extremitas;
  Udem? udem;
  FisikAnak? fisikAnak;

  MrKunjunganPemeriksaanFisis({
    this.id,
    this.kunjunganId,
    this.pegawaiId,
    this.mata,
    this.tht,
    this.leher,
    this.kakuDuduk,
    this.thoraks,
    this.chor,
    this.pulmo,
    this.abdomen,
    this.peristaltik,
    this.asites,
    this.nyeriTekan,
    this.heparLien,
    this.extremitas,
    this.udem,
    this.fisikAnak,
  });

  factory MrKunjunganPemeriksaanFisis.fromJson(Map<String, dynamic> json) =>
      MrKunjunganPemeriksaanFisis(
        id: json["id"],
        kunjunganId: json["kunjungan_id"],
        pegawaiId: json["pegawai_id"],
        mata: json["mata"] == null ? null : Mata.fromJson(json["mata"]),
        tht: json["tht"] == null ? null : Tht.fromJson(json["tht"]),
        leher: json["leher"] == null ? null : Leher.fromJson(json["leher"]),
        kakuDuduk: json["kaku_duduk"] == null
            ? null
            : KakuDuduk.fromJson(json["kaku_duduk"]),
        thoraks:
            json["thoraks"] == null ? null : Thoraks.fromJson(json["thoraks"]),
        chor: json["chor"] == null ? null : Chor.fromJson(json["chor"]),
        pulmo: json["pulmo"] == null ? null : Pulmo.fromJson(json["pulmo"]),
        abdomen:
            json["abdomen"] == null ? null : Abdomen.fromJson(json["abdomen"]),
        peristaltik: json["peristaltik"] == null
            ? null
            : Peristaltik.fromJson(json["peristaltik"]),
        asites: json["asites"] == null ? null : Asites.fromJson(json["asites"]),
        nyeriTekan: json["nyeri_tekan"] == null
            ? null
            : NyeriTekan.fromJson(json["nyeri_tekan"]),
        heparLien: json["hepar_lien"] == null
            ? null
            : HeparLien.fromJson(json["hepar_lien"]),
        extremitas: json["extremitas"] == null
            ? null
            : Extremitas.fromJson(json["extremitas"]),
        udem: json["udem"] == null ? null : Udem.fromJson(json["udem"]),
        fisikAnak: json["fisik_anak"] == null
            ? null
            : FisikAnak.fromJson(json["fisik_anak"]),
      );
}

class Abdomen {
  int? id;
  int? pemeriksaanFisikId;
  String? disintended;
  String? meteorismus;

  Abdomen({
    this.id,
    this.pemeriksaanFisikId,
    this.disintended,
    this.meteorismus,
  });

  factory Abdomen.fromJson(Map<String, dynamic> json) => Abdomen(
        id: json["id"],
        pemeriksaanFisikId: json["pemeriksaan_fisik_id"],
        disintended: json["disintended"],
        meteorismus: json["meteorismus"],
      );
}

class Asites {
  int? id;
  int? pemeriksaanFisikId;
  String? asites;

  Asites({
    this.id,
    this.pemeriksaanFisikId,
    this.asites,
  });

  factory Asites.fromJson(Map<String, dynamic> json) => Asites(
        id: json["id"],
        pemeriksaanFisikId: json["pemeriksaan_fisik_id"],
        asites: json["asites"],
      );
}

class Chor {
  int? id;
  int? pemeriksaanFisikId;
  String? chorPilihan;
  String? s1S2;
  String? murmur;
  String? lainlainMurmur;

  Chor({
    this.id,
    this.pemeriksaanFisikId,
    this.chorPilihan,
    this.s1S2,
    this.murmur,
    this.lainlainMurmur,
  });

  factory Chor.fromJson(Map<String, dynamic> json) => Chor(
        id: json["id"],
        pemeriksaanFisikId: json["pemeriksaan_fisik_id"],
        chorPilihan: json["chor_pilihan"],
        s1S2: json["s1_s2"],
        murmur: json["murmur"],
        lainlainMurmur: json["lainlain_murmur"],
      );
}

class Extremitas {
  int? id;
  int? pemeriksaanFisikId;
  String? extremitas;

  Extremitas({
    this.id,
    this.pemeriksaanFisikId,
    this.extremitas,
  });

  factory Extremitas.fromJson(Map<String, dynamic> json) => Extremitas(
        id: json["id"],
        pemeriksaanFisikId: json["pemeriksaan_fisik_id"],
        extremitas: json["extremitas"],
      );
}

class HeparLien {
  int? id;
  int? pemeriksaanFisikId;
  String? hepar;
  String? lien;

  HeparLien({
    this.id,
    this.pemeriksaanFisikId,
    this.hepar,
    this.lien,
  });

  factory HeparLien.fromJson(Map<String, dynamic> json) => HeparLien(
        id: json["id"],
        pemeriksaanFisikId: json["pemeriksaan_fisik_id"],
        hepar: json["hepar"],
        lien: json["lien"],
      );
}

class KakuDuduk {
  int? id;
  int? pemeriksaanFisikId;
  String? kakuDuduk;

  KakuDuduk({
    this.id,
    this.pemeriksaanFisikId,
    this.kakuDuduk,
  });

  factory KakuDuduk.fromJson(Map<String, dynamic> json) => KakuDuduk(
        id: json["id"],
        pemeriksaanFisikId: json["pemeriksaan_fisik_id"],
        kakuDuduk: json["kaku_duduk"],
      );
}

class Leher {
  int? id;
  int? pemeriksaanFisikId;
  String? ivp;
  String? pembesaranKelenjarLimfe;
  String? sebutkanPembesaranKelenjarLimfe;

  Leher({
    this.id,
    this.pemeriksaanFisikId,
    this.ivp,
    this.pembesaranKelenjarLimfe,
    this.sebutkanPembesaranKelenjarLimfe,
  });

  factory Leher.fromJson(Map<String, dynamic> json) => Leher(
        id: json["id"],
        pemeriksaanFisikId: json["pemeriksaan_fisik_id"],
        ivp: json["ivp"],
        pembesaranKelenjarLimfe: json["pembesaran_kelenjar_limfe"],
        sebutkanPembesaranKelenjarLimfe:
            json["sebutkan_pembesaran_kelenjar_limfe"],
      );
}

class Mata {
  int? id;
  int? pemeriksaanFisikId;
  String? anemis;
  String? ikterus;
  String? pupil;
  String? diameterKanan;
  String? diameterKiri;
  String? udemPalpebrae;

  Mata({
    this.id,
    this.pemeriksaanFisikId,
    this.anemis,
    this.ikterus,
    this.pupil,
    this.diameterKanan,
    this.diameterKiri,
    this.udemPalpebrae,
  });

  factory Mata.fromJson(Map<String, dynamic> json) => Mata(
        id: json["id"],
        pemeriksaanFisikId: json["pemeriksaan_fisik_id"],
        anemis: json["anemis"],
        ikterus: json["ikterus"],
        pupil: json["pupil"],
        diameterKanan: json["diameter_pupil_kanan"],
        diameterKiri: json["diameter_pupil_kiri"],
        udemPalpebrae: json["udem_palpebrae"],
      );
}

class NyeriTekan {
  int? id;
  int? pemeriksaanFisikId;
  String? nyeriTekan;
  String? lokasiNyeriTekan;

  NyeriTekan({
    this.id,
    this.pemeriksaanFisikId,
    this.nyeriTekan,
    this.lokasiNyeriTekan,
  });

  factory NyeriTekan.fromJson(Map<String, dynamic> json) => NyeriTekan(
        id: json["id"],
        pemeriksaanFisikId: json["pemeriksaan_fisik_id"],
        nyeriTekan: json["nyeri_tekan"],
        lokasiNyeriTekan: json["lokasi_nyeri_tekan"],
      );
}

class Peristaltik {
  int? id;
  int? pemeriksaanFisikId;
  String? peristaltik;

  Peristaltik({
    this.id,
    this.pemeriksaanFisikId,
    this.peristaltik,
  });

  factory Peristaltik.fromJson(Map<String, dynamic> json) => Peristaltik(
        id: json["id"],
        pemeriksaanFisikId: json["pemeriksaan_fisik_id"],
        peristaltik: json["peristaltik"],
      );
}

class Pulmo {
  int? id;
  int? pemeriksaanFisikId;
  String? suaraNafas;
  String? ronchi;
  String? sebutkanRonchi;
  String? wheezing;
  String? sebutkanWheezing;

  Pulmo({
    this.id,
    this.pemeriksaanFisikId,
    this.suaraNafas,
    this.ronchi,
    this.sebutkanRonchi,
    this.wheezing,
    this.sebutkanWheezing,
  });

  factory Pulmo.fromJson(Map<String, dynamic> json) => Pulmo(
        id: json["id"],
        pemeriksaanFisikId: json["pemeriksaan_fisik_id"],
        suaraNafas: json["suara_nafas"],
        ronchi: json["ronchi"],
        sebutkanRonchi: json["sebutkan_ronchi"],
        wheezing: json["wheezing"],
        sebutkanWheezing: json["sebutkan_wheezing"],
      );
}

class Thoraks {
  int? id;
  int? pemeriksaanFisikId;
  String? thoraks;
  String? sebutkanThoraksAsimetris;

  Thoraks({
    this.id,
    this.pemeriksaanFisikId,
    this.thoraks,
    this.sebutkanThoraksAsimetris,
  });

  factory Thoraks.fromJson(Map<String, dynamic> json) => Thoraks(
        id: json["id"],
        pemeriksaanFisikId: json["pemeriksaan_fisik_id"],
        thoraks: json["thoraks"],
        sebutkanThoraksAsimetris: json["sebutkan_thoraks_asimetris"],
      );
}

class Tht {
  int? id;
  int? pemeriksaanFisikId;
  String? tonsil;
  String? faring;
  String? lidah;
  String? bibir;

  Tht({
    this.id,
    this.pemeriksaanFisikId,
    this.tonsil,
    this.faring,
    this.lidah,
    this.bibir,
  });

  factory Tht.fromJson(Map<String, dynamic> json) => Tht(
        id: json["id"],
        pemeriksaanFisikId: json["pemeriksaan_fisik_id"],
        tonsil: json["tonsil"],
        faring: json["faring"],
        lidah: json["lidah"],
        bibir: json["bibir"],
      );
}

class Udem {
  int? id;
  int? pemeriksaanFisikId;
  String? udem;
  String? sebutkanUdem;
  String? lainLain;

  Udem({
    this.id,
    this.pemeriksaanFisikId,
    this.udem,
    this.sebutkanUdem,
    this.lainLain,
  });

  factory Udem.fromJson(Map<String, dynamic> json) => Udem(
        id: json["id"],
        pemeriksaanFisikId: json["pemeriksaan_fisik_id"],
        udem: json["udem"],
        sebutkanUdem: json["sebutkan_udem"],
        lainLain: json["lain_lain"],
      );
}

class FisikAnak {
  int? id;
  int? pemeriksaanFisikId;
  double? panjangBadan;
  double? beratBadan;
  double? lingkarKepala;
  String? statusGizi;
  String? keadaanUmum;

  FisikAnak({
    this.id,
    this.pemeriksaanFisikId,
    this.panjangBadan,
    this.beratBadan,
    this.lingkarKepala,
    this.statusGizi,
    this.keadaanUmum,
  });

  factory FisikAnak.fromJson(Map<String, dynamic> json) => FisikAnak(
        id: json["id"],
        pemeriksaanFisikId: json["pemeriksaan_fisik_id"],
        panjangBadan: json["panjang_badan"]?.toDouble(),
        beratBadan: json["berat_badan"]?.toDouble(),
        lingkarKepala: json["lingkar_kepala"]?.toDouble(),
        statusGizi: json["status_gizi"],
        keadaanUmum: json["keadaan_umum"],
      );
}
