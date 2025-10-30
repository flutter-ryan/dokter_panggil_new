import 'package:admin_dokter_panggil/src/models/master_tindakan_lab_model.dart';
import 'package:admin_dokter_panggil/src/models/master_tindakan_rad_create_mode.dart';
import 'package:admin_dokter_panggil/src/models/mr_pengkajian_dokter_model.dart';

MrKunjunganTelemedicineModel mrKunjunganTelemedicineModelFromJson(
        dynamic str) =>
    MrKunjunganTelemedicineModel.fromJson(str);

class MrKunjunganTelemedicineModel {
  DataMrKunjunganTemedicine? data;
  String? message;

  MrKunjunganTelemedicineModel({
    this.data,
    this.message,
  });

  factory MrKunjunganTelemedicineModel.fromJson(Map<String, dynamic> json) =>
      MrKunjunganTelemedicineModel(
        data: json["data"] == null
            ? null
            : DataMrKunjunganTemedicine.fromJson(json["data"]),
        message: json["message"],
      );
}

class DataMrKunjunganTemedicine {
  int? id;
  String? nomorRegistrasi;
  MrKunjunganAnamnesa? anamnesa;
  MrDiagnosaDokter? mrDiagnosaDokter;
  MrDiagnosaIcdDokter? mrDiagnosaIcdDokter;
  MrProsedur? mrProsedur;
  List<MrKunjunganTindakan>? kunjunganTindakan;
  List<MrKunjunganResepObatInjeksi>? kunjunganObatInjeksi;
  List<MrKunjunganResepOral>? kunjunganResep;
  List<MrKunjunganResepRacikan>? kunjunganResepRacikan;
  List<MrPengantarLab>? kunjunganTindakanLab;
  List<MrPengantarRad>? kunjunganTindakanRad;
  List<RiwayatDokumenLab>? dokumenLab;
  List<RiwayatDokumenRad>? dokumenRad;
  List<MrKunjunganDokumentasi>? dokumentasi;
  List<LayananLanjutan>? layananLanjutan;
  RencanaTerapi? rencanaTerapi;
  SelesaiTelemedicine? selesaiLayanan;

  DataMrKunjunganTemedicine({
    this.id,
    this.nomorRegistrasi,
    this.anamnesa,
    this.mrDiagnosaDokter,
    this.mrDiagnosaIcdDokter,
    this.mrProsedur,
    this.kunjunganTindakan,
    this.kunjunganObatInjeksi,
    this.kunjunganResep,
    this.kunjunganResepRacikan,
    this.kunjunganTindakanLab,
    this.kunjunganTindakanRad,
    this.dokumenLab,
    this.dokumenRad,
    this.dokumentasi,
    this.layananLanjutan,
    this.rencanaTerapi,
    this.selesaiLayanan,
  });

  factory DataMrKunjunganTemedicine.fromJson(Map<String, dynamic> json) =>
      DataMrKunjunganTemedicine(
        id: json["id"],
        nomorRegistrasi: json["nomor_registrasi"],
        anamnesa: json["anamnesa"] == null
            ? null
            : MrKunjunganAnamnesa.fromJson(json["anamnesa"]),
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
        dokumenRad: json["dokumen_hasil_rad"] == null
            ? []
            : List<RiwayatDokumenRad>.from(json["dokumen_hasil_rad"]!
                .map((x) => RiwayatDokumenLab.fromJson(x))),
        kunjunganTindakanRad: json["kunjungan_tindakan_rad"] == null
            ? []
            : List<MrPengantarRad>.from(json["kunjungan_tindakan_rad"]!
                .map((x) => MrPengantarRad.fromJson(x))),
        dokumentasi: json["dokumentasi"] == null
            ? []
            : List<MrKunjunganDokumentasi>.from(json["dokumentasi"]!
                .map((x) => MrKunjunganDokumentasi.fromJson(x))),
        layananLanjutan: json["layanan_lanjutan"] == null
            ? []
            : List<LayananLanjutan>.from(json["layanan_lanjutan"]!
                .map((x) => LayananLanjutan.fromJson(x))),
        rencanaTerapi: json["rencana_terapi"] == null
            ? null
            : RencanaTerapi.fromJson(json["rencana_terapi"]),
        selesaiLayanan: json["selesai_layanan"] == null
            ? null
            : SelesaiTelemedicine.fromJson(json["selesai_layanan"]),
      );
}

class LayananLanjutan {
  int? id;
  int? layananId;
  int? kunjunganId;
  int? isLanjutan;
  String? namaLayanan;

  LayananLanjutan({
    this.id,
    this.layananId,
    this.kunjunganId,
    this.isLanjutan,
    this.namaLayanan,
  });

  factory LayananLanjutan.fromJson(Map<String, dynamic> json) =>
      LayananLanjutan(
        id: json["id"],
        layananId: json["layanan_id"],
        kunjunganId: json["kunjungan_id"],
        isLanjutan: json["is_lanjutan"],
        namaLayanan: json["nama_layanan"],
      );
}

class SelesaiTelemedicine {
  int? id;
  int? pegawaiId;
  int? kunjunganId;
  String? namaPegawai;
  String? createdAt;
  String? updatedAt;
  String? editAt;
  int? isEdit;

  SelesaiTelemedicine({
    this.id,
    this.pegawaiId,
    this.kunjunganId,
    this.namaPegawai,
    this.createdAt,
    this.updatedAt,
    this.editAt,
    this.isEdit,
  });

  factory SelesaiTelemedicine.fromJson(Map<String, dynamic> json) =>
      SelesaiTelemedicine(
        id: json["id"],
        pegawaiId: json["pegawai_id"],
        kunjunganId: json["kunjungan_id"],
        namaPegawai: json["nama_pegawai"],
        createdAt: json["created_at"],
        updatedAt: json["updated_at"],
        editAt: json["edit_at"],
        isEdit: json["is_edit"],
      );
}

class RiwayatDokumenLab {
  int? id;
  int? pengantarId;
  String? namaFile;
  PasienDokumen? pasien;
  String? url;
  String? extension;
  String? createdAt;
  String? confirmedAt;
  String? confirmedBy;
  bool? verifikator;

  RiwayatDokumenLab({
    this.id,
    this.pengantarId,
    this.pasien,
    this.namaFile,
    this.url,
    this.extension,
    this.createdAt,
    this.confirmedAt,
    this.confirmedBy,
    this.verifikator,
  });

  factory RiwayatDokumenLab.fromJson(Map<String, dynamic> json) =>
      RiwayatDokumenLab(
        id: json["id"],
        pengantarId: json["pengantar_id"],
        pasien: PasienDokumen.fromJson(json["pasien"]),
        namaFile: json["nama_file"],
        url: json["url"],
        extension: json["extension"],
        createdAt: json["created_at"],
        confirmedAt: json["confirmed_at"],
        confirmedBy: json["confirmed_by"],
        verifikator: json["verifikator"],
      );
}

class RiwayatDokumenRad {
  int? id;
  int? pengantarId;
  String? namaFile;
  String? url;
  String? extension;
  String? confirmedBy;
  String? confirmedAt;

  RiwayatDokumenRad({
    this.id,
    this.pengantarId,
    this.namaFile,
    this.url,
    this.extension,
    this.confirmedBy,
    this.confirmedAt,
  });

  factory RiwayatDokumenRad.fromJson(Map<String, dynamic> json) =>
      RiwayatDokumenRad(
        id: json["id"],
        pengantarId: json["pengantar_id"],
        namaFile: json["nama_file"],
        url: json["url"],
        extension: json["extension"],
        confirmedAt: json["confirmed_at"],
        confirmedBy: json["confirmed_by"],
      );
}

class PasienDokumen {
  int? id;
  String? norm;
  String? namaPasien;

  PasienDokumen({
    this.id,
    this.norm,
    this.namaPasien,
  });

  factory PasienDokumen.fromJson(Map<String, dynamic> json) => PasienDokumen(
        id: json["id"],
        norm: json["norm"],
        namaPasien: json["nama_pasien"],
      );
}

class MrKunjunganAnamnesa {
  int? id;
  int? pegawaiId;
  int? kunjunganId;
  String? keluhanUtama;
  String? riwayatPenyakitSekarang;
  String? riwayatPenyakitDahulu;
  String? pernahDirawat;
  SebutkanPernahDirawat? sebutkanPernahDirawat;
  List<RiwayatPengobatan>? riwayatPengobatan;
  String? riwayatAlergi;
  SebutkanRiwayatAlergi? sebutkanRiwayatAlergi;
  String? riwayatMenyusui;
  String? riwayatHamil;

  MrKunjunganAnamnesa({
    this.id,
    this.pegawaiId,
    this.kunjunganId,
    this.keluhanUtama,
    this.riwayatPenyakitSekarang,
    this.riwayatPenyakitDahulu,
    this.pernahDirawat,
    this.sebutkanPernahDirawat,
    this.riwayatPengobatan,
    this.riwayatAlergi,
    this.sebutkanRiwayatAlergi,
    this.riwayatMenyusui,
    this.riwayatHamil,
  });

  factory MrKunjunganAnamnesa.fromJson(Map<String, dynamic> json) =>
      MrKunjunganAnamnesa(
        id: json["id"],
        pegawaiId: json["pegawai_id"],
        kunjunganId: json["kunjungan_id"],
        keluhanUtama: json["keluhan_utama"],
        riwayatPenyakitSekarang: json["riwayat_penyakit_sekarang"],
        riwayatPenyakitDahulu: json["riwayat_penyakit_dahulu"],
        pernahDirawat: json["pernah_dirawat"],
        sebutkanPernahDirawat: json["sebutkan_pernah_dirawat"] == null
            ? null
            : SebutkanPernahDirawat.fromJson(json["sebutkan_pernah_dirawat"]),
        riwayatPengobatan: json["riwayat_pengobatan"] == null
            ? []
            : List<RiwayatPengobatan>.from(json["riwayat_pengobatan"]!
                .map((x) => RiwayatPengobatan.fromJson(x))),
        riwayatAlergi: json["riwayat_alergi"],
        sebutkanRiwayatAlergi: json["sebutkan_riwayat_alergi"] == null
            ? null
            : SebutkanRiwayatAlergi.fromJson(json["sebutkan_riwayat_alergi"]),
        riwayatMenyusui: json["riwayat_menyusui"],
        riwayatHamil: json["riwayat_hamil"],
      );
}

class RiwayatPengobatan {
  int? id;
  int? anamnesaId;
  String? namaObat;
  String? dosis;
  String? waktuPenggunaan;
  String? createdAt;
  String? updatedAt;

  RiwayatPengobatan({
    this.id,
    this.anamnesaId,
    this.namaObat,
    this.dosis,
    this.waktuPenggunaan,
  });

  factory RiwayatPengobatan.fromJson(Map<String, dynamic> json) =>
      RiwayatPengobatan(
        id: json["id"],
        anamnesaId: json["anamnesa_id"],
        namaObat: json["nama_obat"],
        dosis: json["dosis"],
        waktuPenggunaan: json["waktu_penggunaan"],
      );
}

class SebutkanPernahDirawat {
  int? id;
  int? anamnesaId;
  String? tanggalDirawat;
  String? lokasiDirawat;
  String? diagnosa;
  String? createdAt;
  String? updatedAt;

  SebutkanPernahDirawat({
    this.id,
    this.anamnesaId,
    this.tanggalDirawat,
    this.lokasiDirawat,
    this.diagnosa,
  });

  factory SebutkanPernahDirawat.fromJson(Map<String, dynamic> json) =>
      SebutkanPernahDirawat(
        id: json["id"],
        anamnesaId: json["anamnesa_id"],
        tanggalDirawat: json["tanggal_dirawat"],
        lokasiDirawat: json["lokasi_dirawat"],
        diagnosa: json["diagnosa"],
      );
}

class SebutkanRiwayatAlergi {
  int? id;
  int? anamnesaId;
  String? riwayatAlergi;
  String? createdAt;
  String? updatedAt;

  SebutkanRiwayatAlergi({
    this.id,
    this.anamnesaId,
    this.riwayatAlergi,
  });

  factory SebutkanRiwayatAlergi.fromJson(Map<String, dynamic> json) =>
      SebutkanRiwayatAlergi(
        id: json["id"],
        anamnesaId: json["anamnesa_id"],
        riwayatAlergi: json["riwayat_alergi"],
      );
}

class MrKunjunganDokumentasi {
  int? id;
  int? pegawaiId;
  String? namaPegawai;
  String? url;

  MrKunjunganDokumentasi({
    this.id,
    this.pegawaiId,
    this.namaPegawai,
    this.url,
  });

  factory MrKunjunganDokumentasi.fromJson(Map<String, dynamic> json) =>
      MrKunjunganDokumentasi(
        id: json["id"],
        pegawaiId: json["pegawai_id"],
        namaPegawai: json["nama_pegawai"],
        url: json["url"],
      );
}

class MrKunjunganResepOral {
  int? id;
  String? tanggalResepOral;
  int? status;
  List<MrKunjunganResep>? obatOral;

  MrKunjunganResepOral({
    this.id,
    this.tanggalResepOral,
    this.status,
    this.obatOral,
  });

  factory MrKunjunganResepOral.fromJson(Map<String, dynamic> json) =>
      MrKunjunganResepOral(
        id: json["id"],
        tanggalResepOral: json["tanggal_resep_oral"],
        status: json["status"],
        obatOral: json["obatOral"] == null
            ? []
            : List<MrKunjunganResep>.from(
                json["obatOral"]!.map((x) => MrKunjunganResep.fromJson(x))),
      );
}

class MrKunjunganResep {
  int? id;
  int? kunjunganId;
  int? pegawaiId;
  String? barang;
  int? barangId;
  int? jumlah;
  String? aturanPakai;
  String? catatanTambahan;
  int? hargaModal;
  int? tarifAplikasi;
  int? tarif;
  String? dokter;
  bool? isPengobatan;

  MrKunjunganResep({
    this.id,
    this.kunjunganId,
    this.pegawaiId,
    this.barangId,
    this.barang,
    this.jumlah,
    this.aturanPakai,
    this.catatanTambahan,
    this.hargaModal,
    this.tarifAplikasi,
    this.tarif,
    this.dokter,
    this.isPengobatan,
  });

  factory MrKunjunganResep.fromJson(Map<String, dynamic> json) =>
      MrKunjunganResep(
        id: json["id"],
        kunjunganId: json["kunjungan_id"],
        pegawaiId: json["pegawai_id"],
        barangId: json["barang_id"],
        barang: json["barang"],
        jumlah: json["jumlah"],
        aturanPakai: json["aturan_pakai"],
        catatanTambahan: json["catatan_tambahan"],
        hargaModal: json["harga_modal"],
        tarifAplikasi: json["tarif_aplikasi"],
        tarif: json["tarif"],
        dokter: json["dokter"],
        isPengobatan: json["is_pengobatan"],
      );
}

class MrKunjunganResepRacikan {
  int? id;
  int? kunjunganId;
  String? namaRacikan;
  List<BarangRacikan>? barang;
  String? aturanPakai;
  String? petunjuk;
  String? dokter;
  String? tanggalRacikan;

  MrKunjunganResepRacikan({
    this.id,
    this.kunjunganId,
    this.namaRacikan,
    this.barang,
    this.aturanPakai,
    this.petunjuk,
    this.dokter,
    this.tanggalRacikan,
  });

  factory MrKunjunganResepRacikan.fromJson(Map<String, dynamic> json) =>
      MrKunjunganResepRacikan(
        id: json["id"],
        kunjunganId: json["kunjungan_id"],
        namaRacikan: json["nama_racikan"],
        barang: json["barang"] == null
            ? []
            : List<BarangRacikan>.from(
                json["barang"]!.map((x) => BarangRacikan.fromJson(x))),
        aturanPakai: json["aturan_pakai"],
        petunjuk: json["petunjuk"],
        dokter: json["dokter"],
        tanggalRacikan: json["tanggal_racikan"],
      );
}

class BarangRacikan {
  int? id;
  String? barang;
  String? dosis;
  JumlahRacikan? jumlah;
  int? hargaModal;
  int? tarifAplikasi;
  int? tarif;

  BarangRacikan({
    this.id,
    this.barang,
    this.dosis,
    this.jumlah,
    this.hargaModal,
    this.tarifAplikasi,
    this.tarif,
  });

  factory BarangRacikan.fromJson(Map<String, dynamic> json) => BarangRacikan(
        id: json["id"],
        barang: json["barang"],
        dosis: json["dosis"],
        jumlah: json["jumlah"] == null
            ? null
            : JumlahRacikan.fromJson(json["jumlah"]),
        hargaModal: json["harga_modal"],
        tarifAplikasi: json["tarif_aplikasi"],
        tarif: json["tarif"],
      );
}

class JumlahRacikan {
  int? id;
  int? jumlah;
  int? total;

  JumlahRacikan({
    this.id,
    this.jumlah,
    this.total,
  });

  factory JumlahRacikan.fromJson(Map<String, dynamic> json) => JumlahRacikan(
        id: json["id"],
        jumlah: json["jumlah"],
        total: json["total"],
      );
}

class MrPengantarLab {
  int? id;
  int? kunjunganId;
  int? pegawaiId;
  String? tanggalPengantar;
  String? dokter;
  List<MrKunjunganTindakanLab>? tindakanLab;

  MrPengantarLab({
    this.id,
    this.kunjunganId,
    this.pegawaiId,
    this.tanggalPengantar,
    this.dokter,
    this.tindakanLab,
  });

  factory MrPengantarLab.fromJson(Map<String, dynamic> json) => MrPengantarLab(
        id: json["id"],
        kunjunganId: json["kunjungan_id"],
        pegawaiId: json["pegawai_id"],
        tanggalPengantar: json["tanggal_pengantar"],
        dokter: json["dokter"],
        tindakanLab: json["tindakan_lab"] == null
            ? []
            : List<MrKunjunganTindakanLab>.from(json["tindakan_lab"]!
                .map((x) => MrKunjunganTindakanLab.fromJson(x))),
      );
}

class MrKunjunganTindakanLab {
  int? id;
  int? pegawaiId;
  int? kunjunganId;
  int? tindakanLabId;
  String? tindakanLab;
  int? hargaModal;
  int? tarifAplikasi;
  int? tarif;
  int? nonKonsul;
  int? transportasi;
  String? dokter;
  MasterTindakanLab? masterTindakanLab;
  List<BhpLab>? bhpLab;

  MrKunjunganTindakanLab({
    this.id,
    this.pegawaiId,
    this.kunjunganId,
    this.tindakanLabId,
    this.tindakanLab,
    this.hargaModal,
    this.tarifAplikasi,
    this.tarif,
    this.nonKonsul,
    this.transportasi,
    this.dokter,
    this.masterTindakanLab,
    this.bhpLab,
  });

  factory MrKunjunganTindakanLab.fromJson(Map<String, dynamic> json) =>
      MrKunjunganTindakanLab(
        id: json["id"],
        pegawaiId: json["pegawai_id"],
        kunjunganId: json["kunjungan_id"],
        tindakanLabId: json["tindakan_lab_id"],
        tindakanLab: json["tindakan_lab"],
        hargaModal: json["harga_modal"],
        tarifAplikasi: json["tarif_aplikasi"],
        tarif: json["tarif"],
        nonKonsul: json["non_konsul"],
        transportasi: json["transportasi"],
        dokter: json["dokter"],
        masterTindakanLab: json["master_tindakan_lab"] == null
            ? null
            : MasterTindakanLab.fromJson(json["master_tindakan_lab"]),
        bhpLab: json["bhp_lab"] == null
            ? []
            : List<BhpLab>.from(
                json["bhp_lab"].map((x) => BhpLab.fromJson(x)),
              ),
      );
}

class BhpLab {
  int? id;
  String? namaBarang;

  BhpLab({
    this.id,
    this.namaBarang,
  });

  factory BhpLab.fromJson(Map<String, dynamic> json) => BhpLab(
        id: json["id"],
        namaBarang: json["nama_barang"],
      );
}

class MrPengantarRad {
  int? id;
  int? kunjunganId;
  int? pegawaiId;
  String? tanggalPengantar;
  List<MrKunjunganTindakanRad>? tindakanRad;

  MrPengantarRad({
    this.id,
    this.kunjunganId,
    this.pegawaiId,
    this.tanggalPengantar,
    this.tindakanRad,
  });

  factory MrPengantarRad.fromJson(Map<String, dynamic> json) => MrPengantarRad(
        id: json["id"],
        kunjunganId: json["kunjungan_id"],
        pegawaiId: json["pegawai_id"],
        tanggalPengantar: json["tanggal_pengantar"],
        tindakanRad: json["tindakan_rad"] == null
            ? []
            : List<MrKunjunganTindakanRad>.from(json["tindakan_rad"]!
                .map((x) => MrKunjunganTindakanRad.fromJson(x))),
      );
}

class MrKunjunganTindakanRad {
  int? id;
  int? pegawaiId;
  int? kunjunganId;
  int? tindakanRadId;
  String? tindakanRad;
  int? hargaModal;
  int? tarifAplikasi;
  int? tarif;
  int? transportasi;
  String? dokter;
  MasterTindakanRad? masterTindakanRad;

  MrKunjunganTindakanRad({
    this.id,
    this.pegawaiId,
    this.kunjunganId,
    this.tindakanRadId,
    this.tindakanRad,
    this.hargaModal,
    this.tarifAplikasi,
    this.tarif,
    this.transportasi,
    this.dokter,
    this.masterTindakanRad,
  });

  factory MrKunjunganTindakanRad.fromJson(Map<String, dynamic> json) =>
      MrKunjunganTindakanRad(
        id: json["id"],
        pegawaiId: json["pegawai_id"],
        kunjunganId: json["kunjungan_id"],
        tindakanRadId: json["tindakan_rad_id"],
        tindakanRad: json["tindakan_rad"],
        hargaModal: json["harga_modal"],
        tarifAplikasi: json["tarif_aplikasi"],
        tarif: json["tarif"],
        transportasi: json["transportasi"],
        dokter: json["dokter"],
        masterTindakanRad: json["master_tindakan_rad"] == null
            ? null
            : MasterTindakanRad.fromJson(json["master_tindakan_rad"]),
      );
}
