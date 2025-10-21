import 'package:admin_dokter_panggil/src/models/pasien_kunjungan_detail_model.dart';
import 'package:admin_dokter_panggil/src/models/resume_pemeriksaan_pasien_model.dart';

ResumeMedisPasienModel resumeMedisPasienModelFromJson(dynamic str) =>
    ResumeMedisPasienModel.fromJson(str);

class ResumeMedisPasienModel {
  ResumeMedis? data;
  String? message;

  ResumeMedisPasienModel({
    this.data,
    this.message,
  });

  factory ResumeMedisPasienModel.fromJson(Map<String, dynamic> json) =>
      ResumeMedisPasienModel(
        data: ResumeMedis.fromJson(json["data"]),
        message: json["message"],
      );
}

class ResumeMedis {
  int? id;
  String? nomorRegistrasi;
  String? tanggal;
  String? keluhan;
  List<KunjunganTindakan>? kunjunganTindakan;
  List<KunjunganDokter>? kunjunganDokter;
  List<KunjunganPerawat>? kunjunganPerawat;
  List<KunjunganAnamnesaDokter>? kunjunganAnamnesaDokter;
  List<KunjunganAnamnesaPerawat>? kunjunganAnamnesaPerawat;
  List<KunjunganPemeriksaanFisikDokter>? kunjunganPemeriksaanFisikDokter;
  List<KunjunganPemeriksaanFisikPerawat>? kunjunganPemeriksaanFisikPerawat;
  List<Resep>? resep;
  List<ResepRacikan>? resepRacikan;
  List<DiagnosaDokter>? diagnosaDokter;
  List<ObatInjeksi>? obatInjeksi;
  List<Bhp>? bhp;
  List<TindakanLab>? tindakanLab;
  List<TindakanRad>? tindakanRad;

  ResumeMedis({
    this.id,
    this.nomorRegistrasi,
    this.tanggal,
    this.keluhan,
    this.kunjunganTindakan,
    this.kunjunganDokter,
    this.kunjunganPerawat,
    this.kunjunganAnamnesaDokter,
    this.kunjunganAnamnesaPerawat,
    this.kunjunganPemeriksaanFisikDokter,
    this.kunjunganPemeriksaanFisikPerawat,
    this.resep,
    this.resepRacikan,
    this.diagnosaDokter,
    this.obatInjeksi,
    this.bhp,
    this.tindakanLab,
    this.tindakanRad,
  });

  factory ResumeMedis.fromJson(Map<String, dynamic> json) => ResumeMedis(
        id: json["id"],
        nomorRegistrasi: json["nomor_registrasi"],
        tanggal: json["tanggal"],
        keluhan: json["keluhan"],
        kunjunganTindakan: List<KunjunganTindakan>.from(
            json["kunjungan_tindakan"]
                .map((x) => KunjunganTindakan.fromJson(x))),
        kunjunganDokter: List<KunjunganDokter>.from(
            json["kunjungan_dokter"].map((x) => KunjunganDokter.fromJson(x))),
        kunjunganPerawat: List<KunjunganPerawat>.from(
            json["kunjungan_perawat"].map((x) => KunjunganPerawat.fromJson(x))),
        kunjunganAnamnesaDokter: List<KunjunganAnamnesaDokter>.from(
            json["kunjungan_anamnesa_dokter"]
                .map((x) => KunjunganAnamnesaDokter.fromJson(x))),
        kunjunganAnamnesaPerawat: List<KunjunganAnamnesaPerawat>.from(
            json["kunjungan_anamnesa_perawat"]
                .map((x) => KunjunganAnamnesaPerawat.fromJson(x))),
        kunjunganPemeriksaanFisikDokter:
            List<KunjunganPemeriksaanFisikDokter>.from(
                json["kunjungan_pemeriksaan_fisik_dokter"]
                    .map((x) => KunjunganPemeriksaanFisikDokter.fromJson(x))),
        kunjunganPemeriksaanFisikPerawat:
            List<KunjunganPemeriksaanFisikPerawat>.from(
                json["kunjungan_pemeriksaan_fisik_perawat"]
                    .map((x) => KunjunganPemeriksaanFisikPerawat.fromJson(x))),
        resep: List<Resep>.from(json["resep"].map((x) => Resep.fromJson(x))),
        resepRacikan: List<ResepRacikan>.from(
            json["resep_racikan"].map((x) => ResepRacikan.fromJson(x))),
        diagnosaDokter: List<DiagnosaDokter>.from(
            json["diagnosa_dokter"].map((x) => DiagnosaDokter.fromJson(x))),
        obatInjeksi: List<ObatInjeksi>.from(
            json["obat_injeksi"].map((x) => ObatInjeksi.fromJson(x))),
        bhp: List<Bhp>.from(json["bhp"].map((x) => Bhp.fromJson(x))),
        tindakanLab: List<TindakanLab>.from(
            json["tindakan_lab"].map((x) => TindakanLab.fromJson(x))),
        tindakanRad: List<TindakanRad>.from(
            json["tindakan_rad"].map((x) => TindakanRad.fromJson(x))),
      );
}

class BhpBarang {
  int? id;
  String? namaBarang;
  int? tarifAplikasi;

  BhpBarang({
    required this.id,
    required this.namaBarang,
    required this.tarifAplikasi,
  });

  factory BhpBarang.fromJson(Map<String, dynamic> json) => BhpBarang(
        id: json["id"],
        namaBarang: json["nama_barang"],
        tarifAplikasi: json["tarif_aplikasi"],
      );
}

class KunjunganAnamnesaDokter {
  int? id;
  PegawaiResume? dokter;
  String? keluhanUtama;
  String? riwayatPenyakitSebelumnya;
  String? riwayatPenyakitSekarang;

  KunjunganAnamnesaDokter({
    this.id,
    this.dokter,
    this.keluhanUtama,
    this.riwayatPenyakitSebelumnya,
    this.riwayatPenyakitSekarang,
  });

  factory KunjunganAnamnesaDokter.fromJson(Map<String, dynamic> json) =>
      KunjunganAnamnesaDokter(
        id: json["id"],
        dokter: PegawaiResume.fromJson(json["dokter"]),
        keluhanUtama: json["keluhan_utama"],
        riwayatPenyakitSebelumnya: json["riwayat_penyakit_sebelumnya"],
        riwayatPenyakitSekarang: json["riwayat_penyakit_sekarang"],
      );
}

class KunjunganAnamnesaPerawat {
  int? id;
  PegawaiResume? perawat;
  String? keluhanUtama;
  String? riwayatPenyakitSebelumnya;
  String? riwayatPenyakitSekarang;

  KunjunganAnamnesaPerawat({
    this.id,
    this.perawat,
    this.keluhanUtama,
    this.riwayatPenyakitSebelumnya,
    this.riwayatPenyakitSekarang,
  });

  factory KunjunganAnamnesaPerawat.fromJson(Map<String, dynamic> json) =>
      KunjunganAnamnesaPerawat(
        id: json["id"],
        perawat: json["perawat"] == null
            ? null
            : PegawaiResume.fromJson(json["perawat"]),
        keluhanUtama: json["keluhan_utama"],
        riwayatPenyakitSebelumnya: json["riwayat_penyakit_sebelumnya"],
        riwayatPenyakitSekarang: json["riwayat_penyakit_sekarang"],
      );
}

class PegawaiResume {
  int? id;
  String? nama;
  String? profesi;

  PegawaiResume({
    this.id,
    this.nama,
    this.profesi,
  });

  factory PegawaiResume.fromJson(Map<String, dynamic> json) => PegawaiResume(
        id: json["id"],
        nama: json["nama"],
        profesi: json["profesi"],
      );
}

class KunjunganDokter {
  int? id;
  int? dokterId;
  String? nama;
  bool isKonsul;

  KunjunganDokter({
    this.id,
    this.dokterId,
    this.nama,
    this.isKonsul = false,
  });

  factory KunjunganDokter.fromJson(Map<String, dynamic> json) =>
      KunjunganDokter(
        id: json["id"],
        dokterId: json["dokter_id"],
        nama: json["nama"],
        isKonsul: json["is_konsul"],
      );
}

class KunjunganPemeriksaanFisikDokter {
  int? id;
  PegawaiResume? pegawai;
  String? tekananDarah;
  String? nadi;
  String? pernafasan;
  String? suhu;
  String? beratBadan;
  String? tinggiBadan;
  String? catatan;

  KunjunganPemeriksaanFisikDokter({
    this.id,
    this.pegawai,
    this.tekananDarah,
    this.nadi,
    this.pernafasan,
    this.suhu,
    this.beratBadan,
    this.tinggiBadan,
    this.catatan,
  });

  factory KunjunganPemeriksaanFisikDokter.fromJson(Map<String, dynamic> json) =>
      KunjunganPemeriksaanFisikDokter(
        id: json["id"],
        pegawai: PegawaiResume.fromJson(json["pegawai"]),
        tekananDarah: json["tekanan_darah"],
        nadi: json["nadi"],
        pernafasan: json["pernafasan"],
        suhu: json["suhu"],
        beratBadan: json["berat_badan"],
        tinggiBadan: json["tinggi_badan"],
        catatan: json["catatan"],
      );
}

class KunjunganPemeriksaanFisikPerawat {
  KunjunganPemeriksaanFisikPerawat({
    this.id,
    this.perawat,
    this.tekananDarah,
    this.nadi,
    this.pernafasan,
    this.suhu,
    this.beratBadan,
    this.tinggiBadan,
    this.catatan,
  });

  int? id;
  PegawaiResume? perawat;
  String? tekananDarah;
  String? nadi;
  String? pernafasan;
  String? suhu;
  String? beratBadan;
  String? tinggiBadan;
  String? catatan;

  factory KunjunganPemeriksaanFisikPerawat.fromJson(
          Map<String, dynamic> json) =>
      KunjunganPemeriksaanFisikPerawat(
        id: json["id"],
        perawat: json["pegawai"] == null
            ? null
            : PegawaiResume.fromJson(json["pegawai"]),
        tekananDarah: json["tekanan_darah"],
        nadi: json["nadi"],
        pernafasan: json["pernafasan"],
        suhu: json["suhu"],
        beratBadan: json["berat_badan"],
        tinggiBadan: json["tinggi_badan"],
        catatan: json["catatan"],
      );
}

class KunjunganPerawat {
  int? id;
  int? perawatId;
  String? nama;

  KunjunganPerawat({
    this.id,
    this.perawatId,
    this.nama,
  });

  factory KunjunganPerawat.fromJson(Map<String, dynamic> json) =>
      KunjunganPerawat(
        id: json["id"],
        perawatId: json["perawat_id"],
        nama: json["nama"],
      );
}

class KunjunganTindakan {
  int? id;
  KunjunganTindakanDokter? dokter;
  String? namaTindakan;

  KunjunganTindakan({
    this.id,
    this.dokter,
    this.namaTindakan,
  });

  factory KunjunganTindakan.fromJson(Map<String, dynamic> json) =>
      KunjunganTindakan(
        id: json["id"],
        dokter: KunjunganTindakanDokter.fromJson(json["dokter"]),
        namaTindakan: json["nama_tindakan"],
      );
}

class KunjunganTindakanDokter {
  int? id;
  String? nama;
  int? profesiId;

  KunjunganTindakanDokter({
    this.id,
    this.nama,
    this.profesiId,
  });

  factory KunjunganTindakanDokter.fromJson(Map<String, dynamic> json) =>
      KunjunganTindakanDokter(
        id: json["id"],
        nama: json["nama"],
        profesiId: json["profesi_id"],
      );
}

class ObatInjeksi {
  int? id;
  int? pegawaiId;
  BhpBarang? barang;
  int? jumlah;
  String? aturanPakai;
  String? catatan;
  int? hargaModal;
  int? tarifAplikasi;
  int? tarif;
  String? dokter;

  ObatInjeksi({
    this.id,
    this.pegawaiId,
    this.barang,
    this.jumlah,
    this.aturanPakai,
    this.catatan,
    this.hargaModal,
    this.tarifAplikasi,
    this.tarif,
    this.dokter,
  });

  factory ObatInjeksi.fromJson(Map<String, dynamic> json) => ObatInjeksi(
        id: json["id"],
        pegawaiId: json["pegawai_id"],
        barang: BhpBarang.fromJson(json["barang"]),
        jumlah: json["jumlah"],
        aturanPakai: json["aturan_pakai"],
        catatan: json["catatan"],
        hargaModal: json["harga_modal"],
        tarifAplikasi: json["tarif_aplikasi"],
        tarif: json["tarif"],
        dokter: json["dokter"],
      );
}

class BarangElement {
  int? id;
  String? barang;
  String? dosis;
  Jumlah? jumlah;
  int? hargaModal;
  int? tarifAplikasi;
  int? tarif;

  BarangElement({
    this.id,
    this.barang,
    this.dosis,
    this.jumlah,
    this.hargaModal,
    this.tarifAplikasi,
    this.tarif,
  });

  factory BarangElement.fromJson(Map<String, dynamic> json) => BarangElement(
        id: json["id"],
        barang: json["barang"],
        dosis: json["dosis"],
        jumlah: Jumlah.fromJson(json["jumlah"]),
        hargaModal: json["harga_modal"],
        tarifAplikasi: json["tarif_aplikasi"],
        tarif: json["tarif"],
      );
}

class Jumlah {
  int? id;
  int? jumlah;
  int? total;

  Jumlah({
    this.id,
    this.jumlah,
    this.total,
  });

  factory Jumlah.fromJson(Map<String, dynamic> json) => Jumlah(
        id: json["id"],
        jumlah: json["jumlah"],
        total: json["total"],
      );
}
