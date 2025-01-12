import 'package:dokter_panggil/src/models/master_bhp_model.dart';
import 'package:dokter_panggil/src/models/master_pegawai_fetch_model.dart';
import 'package:dokter_panggil/src/models/master_tindakan_lab_model.dart';
import 'package:dokter_panggil/src/models/master_tindakan_rad_create_mode.dart';

PasienKunjunganDetailModel pasienKunjunganDetailModelFromJson(dynamic str) =>
    PasienKunjunganDetailModel.fromJson(str);

class PasienKunjunganDetailModel {
  PasienKunjunganDetailModel({
    this.detail,
    this.message,
  });

  DetailKunjungan? detail;
  String? message;

  factory PasienKunjunganDetailModel.fromJson(Map<String, dynamic> json) =>
      PasienKunjunganDetailModel(
        detail: DetailKunjungan.fromJson(json["data"]),
        message: json["message"],
      );
}

class DetailKunjungan {
  DetailKunjungan({
    this.id,
    this.isEmr,
    this.nomorRegistrasi,
    this.tanggal,
    this.status,
    this.isTagihan,
    this.dokter,
    this.perawat,
    this.pegawai,
    this.pasien,
    this.tindakan,
    this.resep,
    this.resepMr,
    this.tagihanResep,
    this.resepRacikan,
    this.tagihanResepRacikan,
    this.tindakanLab,
    this.pengantarLabMr,
    this.tindakanRad,
    this.pengantarRadMr,
    this.tagihanTindakanLab,
    this.tagihanTindakanRad,
    this.bhp,
    this.bhpMr,
    this.obatInjeksi,
    this.obatInjeksiMr,
    this.tagihanBhp,
    this.totalTindakan,
    this.totalResep,
    this.totalResepRacikan,
    this.totalTindakanLab,
    this.totalTindakanRad,
    this.totalBhp,
    this.totalObatInjeksi,
    this.deposit,
    this.subTotal,
    this.total,
    this.linkNota,
    this.transportResep,
    this.transportResepRacikan,
    this.biayaLayanan,
    this.transportTindakan,
    this.transportOjolTindakan,
    this.transportLab,
    this.transportRad,
    this.dataBiayaAdmin,
    this.diskon,
    this.isPaket = false,
    this.isSuper = false,
    this.biayaLain,
    this.totalBiayaLain,
    this.urlDeposit,
    this.paket,
  });

  int? id;
  int? isEmr;
  String? nomorRegistrasi;
  String? tanggal;
  int? status;
  int? isTagihan;
  List<Dokter>? dokter;
  List<Perawat>? perawat;
  List<Pegawaikunjungan>? pegawai;
  Pasien? pasien;
  List<Tindakan>? tindakan;
  List<Resep>? resep;
  List<ResepMr>? resepMr;
  List<TagihanResep>? tagihanResep;
  List<ResepRacikan>? resepRacikan;
  List<TindakanLab>? tindakanLab;
  List<PengantarLabMr>? pengantarLabMr;
  List<TindakanRad>? tindakanRad;
  List<PengantarRadMr>? pengantarRadMr;
  List<TagihanTindakanLab>? tagihanTindakanLab;
  List<TagihanTindakanRad>? tagihanTindakanRad;
  List<TagihanResepRacikan>? tagihanResepRacikan;
  List<Bhp>? bhp;
  List<BhpMr>? bhpMr;
  List<KunjunganObatInjeksi>? obatInjeksi;
  List<ObatInjeksiMr>? obatInjeksiMr;
  List<TagihanBhp>? tagihanBhp;
  int? totalTindakan;
  int? totalResep;
  int? totalResepRacikan;
  int? totalTindakanLab;
  int? totalTindakanRad;
  int? totalBhp;
  int? totalObatInjeksi;
  int? deposit;
  int? subTotal;
  int? total;
  String? linkNota;
  int? transportResep;
  int? transportResepRacikan;
  int? biayaLayanan;
  int? transportTindakan;
  int? transportOjolTindakan;
  int? transportLab;
  int? transportRad;
  List<DataBiayaAdmin>? dataBiayaAdmin;
  Diskon? diskon;
  bool isPaket;
  bool isSuper;
  List<BiayaLain>? biayaLain;
  int? totalBiayaLain;
  String? urlDeposit;
  KunjunganPaket? paket;

  factory DetailKunjungan.fromJson(Map<String, dynamic> json) =>
      DetailKunjungan(
        id: json["id"],
        isEmr: json["is_emr"],
        nomorRegistrasi: json["nomor_registrasi"],
        tanggal: json["tanggal"],
        status: json["status"],
        isTagihan: json["is_tagihan"],
        dokter:
            List<Dokter>.from(json["dokter"].map((x) => Dokter.fromJson(x))),
        perawat:
            List<Perawat>.from(json["perawat"].map((x) => Perawat.fromJson(x))),
        pegawai: List<Pegawaikunjungan>.from(
            json["pegawai"].map((x) => Pegawaikunjungan.fromJson(x))),
        pasien: Pasien.fromJson(json["pasien"]),
        tindakan: List<Tindakan>.from(
            json["tindakan"].map((x) => Tindakan.fromJson(x))),
        resep: List<Resep>.from(json["resep"].map((x) => Resep.fromJson(x))),
        resepMr: List<ResepMr>.from(
            json["resep_mr"].map((x) => ResepMr.fromJson(x))),
        tagihanResep: List<TagihanResep>.from(
            json["tagihan_resep"].map((x) => TagihanResep.fromJson(x))),
        resepRacikan: List<ResepRacikan>.from(
            json["resep_racikan"].map((x) => ResepRacikan.fromJson(x))),
        tagihanResepRacikan: List<TagihanResepRacikan>.from(
            json["tagihan_resep_racikan"]
                .map((x) => TagihanResepRacikan.fromJson(x))),
        tindakanLab: List<TindakanLab>.from(
            json["tindakan_lab"].map((x) => TindakanLab.fromJson(x))),
        pengantarLabMr: List<PengantarLabMr>.from(
            json["pengantar_lab_mr"].map((x) => PengantarLabMr.fromJson(x))),
        tindakanRad: List<TindakanRad>.from(
            json["tindakan_rad"].map((x) => TindakanRad.fromJson(x))),
        pengantarRadMr: List<PengantarRadMr>.from(
            json["pengantar_rad_mr"].map((x) => PengantarRadMr.fromJson(x))),
        tagihanTindakanLab: List<TagihanTindakanLab>.from(
            json["tagihan_tindakan_lab"]
                .map((x) => TagihanTindakanLab.fromJson(x))),
        tagihanTindakanRad: List<TagihanTindakanRad>.from(
            json["tagihan_tindakan_rad"]
                .map((x) => TagihanTindakanRad.fromJson(x))),
        obatInjeksi: List<KunjunganObatInjeksi>.from(
            json["obat_injeksi"].map((x) => KunjunganObatInjeksi.fromJson(x))),
        obatInjeksiMr: List<ObatInjeksiMr>.from(
            json["obat_injeksi_mr"].map((x) => ObatInjeksiMr.fromJson(x))),
        bhp: List<Bhp>.from(json["bhp"].map((x) => Bhp.fromJson(x))),
        bhpMr: List<BhpMr>.from(json["bhp_mr"]!.map((x) => BhpMr.fromJson(x))),
        tagihanBhp: List<TagihanBhp>.from(
            json["tagihan_bhp"].map((x) => TagihanBhp.fromJson(x))),
        totalTindakan: json["total_tindakan"],
        totalResep: json["total_resep"],
        totalResepRacikan: json["total_resep_racikan"],
        totalTindakanLab: json["total_tindakan_lab"],
        totalTindakanRad: json["total_tindakan_rad"],
        totalBhp: json["total_bhp"],
        totalObatInjeksi: json["total_obat_injeksi"],
        deposit: json["deposit"],
        subTotal: json["subTotal"],
        total: json["total"],
        linkNota: json["link_nota"],
        transportResep: json["transport_resep"],
        transportResepRacikan: json["transport_resep_racikan"],
        biayaLayanan: json["biaya_layanan"],
        transportTindakan: json["transport_tindakan"],
        transportLab: json["transport_lab"],
        transportRad: json["transport_rad"],
        transportOjolTindakan: json["ojol_tindakan"],
        dataBiayaAdmin: List<DataBiayaAdmin>.from(
          json["data_biaya"].map((x) => DataBiayaAdmin.fromJson(x)),
        ),
        diskon: json["diskon"] == null ? null : Diskon.fromJson(json["diskon"]),
        isPaket: json["is_paket"],
        isSuper: json["is_super"],
        totalBiayaLain: json["total_biaya_lain"],
        biayaLain: List<BiayaLain>.from(
          json["biaya_lain"].map((x) => BiayaLain.fromJson(x)),
        ),
        urlDeposit: json["url_deposit"],
        paket: json["paket"] != null
            ? KunjunganPaket.fromJson(json["paket"])
            : null,
      );
}

class Bhp {
  Bhp({
    this.id,
    this.barang,
    this.hargaModal,
    this.jumlah,
    this.tarifAplikasi,
    this.tarif,
  });

  int? id;
  MasterBhp? barang;
  int? hargaModal;
  int? jumlah;
  int? tarifAplikasi;
  int? tarif;

  factory Bhp.fromJson(Map<String, dynamic> json) => Bhp(
        id: json["id"],
        barang:
            json["barang"] == null ? null : MasterBhp.fromJson(json["barang"]),
        hargaModal: json["harga_modal"],
        jumlah: json["jumlah"],
        tarifAplikasi: json["tarif_aplikasi"],
        tarif: json["tarif"],
      );
}

class BhpMr {
  int? id;
  int? pengkajianPerawatId;
  int? pegawaiId;
  String? namaPegawai;
  String? tanggalBhp;
  String? tanggalShort;
  String? jamShort;
  List<Bhp>? kunjunganBhp;

  BhpMr({
    this.id,
    this.pengkajianPerawatId,
    this.pegawaiId,
    this.namaPegawai,
    this.tanggalBhp,
    this.tanggalShort,
    this.jamShort,
    this.kunjunganBhp,
  });

  factory BhpMr.fromJson(Map<String, dynamic> json) => BhpMr(
        id: json["id"],
        pengkajianPerawatId: json["pengkajian_perawat_id"],
        pegawaiId: json["pegawai_id"],
        namaPegawai: json["nama_pegawai"],
        tanggalBhp: json["tanggal_bhp"],
        tanggalShort: json["tanggal_short"],
        jamShort: json["jam_short"],
        kunjunganBhp: json["kunjungan_bhp"] == null
            ? []
            : List<Bhp>.from(
                json["kunjungan_bhp"]!.map((x) => Bhp.fromJson(x))),
      );
}

class Pasien {
  Pasien({
    this.id,
    this.nik,
    this.norm,
    this.normSprint,
    this.namaPasien,
    this.tempatLahir,
    this.tanggalLahir,
    this.umur,
    this.alamat,
    this.jenisKelamin,
    this.nomorTelepon,
  });

  int? id;
  String? nik;
  String? norm;
  String? normSprint;
  String? namaPasien;
  String? tempatLahir;
  String? tanggalLahir;
  String? umur;
  String? alamat;
  String? jenisKelamin;
  String? nomorTelepon;

  factory Pasien.fromJson(Map<String, dynamic> json) => Pasien(
        id: json["id"],
        nik: json["nik"],
        norm: json["norm"],
        normSprint: json["norm_sprint"],
        namaPasien: json["nama_pasien"],
        tempatLahir: json["tempat_lahir"],
        tanggalLahir: json["tanggal_lahir"],
        umur: json["umur"],
        alamat: json["alamat"],
        jenisKelamin: json["jenis_kelamin"],
        nomorTelepon: json["nomor_telepon"],
      );
}

class ResepMr {
  int? id;
  String? tanggalResepOral;
  String? tanggalShort;
  String? jamShort;
  String? dokter;
  int? status;
  int? isBersedia;
  List<Resep>? obatOral;

  ResepMr({
    this.id,
    this.tanggalResepOral,
    this.tanggalShort,
    this.jamShort,
    this.dokter,
    this.status,
    this.obatOral,
    this.isBersedia,
  });

  factory ResepMr.fromJson(Map<String, dynamic> json) => ResepMr(
        id: json["id"],
        tanggalResepOral: json["tanggal_resep_oral"],
        tanggalShort: json["tanggal_short"],
        jamShort: json["jam_short"],
        dokter: json["dokter"],
        status: json["status"],
        isBersedia: json["is_bersedia"],
        obatOral: json["obatOral"] == null
            ? []
            : List<Resep>.from(json["obatOral"]!.map((x) => Resep.fromJson(x))),
      );
}

class Resep {
  Resep({
    this.id,
    this.barang,
    this.jumlah,
    this.aturanPakai,
    this.catatanTambahan,
    this.hargaModal,
    this.tarifAplikasi,
    this.tarif,
  });

  int? id;
  String? barang;
  int? jumlah;
  String? aturanPakai;
  String? catatanTambahan;
  int? hargaModal;
  int? tarifAplikasi;
  int? tarif;

  factory Resep.fromJson(Map<String, dynamic> json) => Resep(
        id: json["id"],
        barang: json["barang"],
        jumlah: json["jumlah"],
        aturanPakai: json["aturan_pakai"],
        catatanTambahan: json["catatan_tambahan"],
        hargaModal: json["harga_modal"],
        tarifAplikasi: json["tarif_aplikasi"],
        tarif: json["tarif"],
      );
}

class ResepRacikan {
  ResepRacikan({
    this.id,
    this.kunjunganId,
    this.namaRacikan,
    this.barang,
    this.aturanPakai,
    this.petunjuk,
    this.tanggalRacikan,
    this.tanggalShort,
    this.jamShort,
    this.dokter,
    this.status,
    this.isBersedia,
  });

  int? id;
  int? kunjunganId;
  String? namaRacikan;
  List<BarangRacikan>? barang;
  String? aturanPakai;
  String? petunjuk;
  String? tanggalRacikan;
  String? tanggalShort;
  String? jamShort;
  String? dokter;
  int? status;
  int? isBersedia;

  factory ResepRacikan.fromJson(Map<String, dynamic> json) => ResepRacikan(
        id: json["id"],
        kunjunganId: json["kunjungan_id"],
        namaRacikan: json["nama_racikan"],
        barang: List<BarangRacikan>.from(
            json["barang"].map((x) => BarangRacikan.fromJson(x))),
        aturanPakai: json["aturan_pakai"],
        petunjuk: json["petunjuk"],
        tanggalRacikan: json["tanggal_racikan"],
        tanggalShort: json["tanggal_short"],
        jamShort: json["jam_short"],
        dokter: json["dokter"],
        status: json["status"],
        isBersedia: json["is_bersedia"],
      );
}

class BarangRacikan {
  BarangRacikan({
    this.id,
    this.barang,
    this.jumlah,
    this.hargaModal,
    this.tarifAplikasi,
    this.tarif,
    this.dosis,
  });

  int? id;
  String? barang;
  Jumlah? jumlah;
  int? hargaModal;
  int? tarifAplikasi;
  int? tarif;
  String? dosis;

  factory BarangRacikan.fromJson(Map<String, dynamic> json) => BarangRacikan(
        id: json["id"],
        barang: json["barang"],
        jumlah: Jumlah.fromJson(json["jumlah"]),
        hargaModal: json["harga_modal"],
        tarifAplikasi: json["tarif_aplikasi"],
        tarif: json["tarif"],
        dosis: json["dosis"],
      );
}

class Jumlah {
  Jumlah({
    this.id,
    this.jumlah,
    this.total,
  });

  int? id;
  int? jumlah;
  int? total;

  factory Jumlah.fromJson(Map<String, dynamic> json) => Jumlah(
        id: json["id"],
        jumlah: json["jumlah"],
        total: json["total"],
      );
}

class Tindakan {
  Tindakan({
    this.id,
    this.kunjunganId,
    this.namaTindakan,
    this.petugas,
    this.quantity,
    this.tarif,
    this.jasaDokter,
    this.jasaDokterPanggil,
    this.bayarLangsung,
    this.transportasi,
    this.gojek,
    this.status,
    this.dataTransportasi,
    this.dataOjol,
    this.foc,
    this.createdAt,
  });

  int? id;
  int? kunjunganId;
  String? namaTindakan;
  String? petugas;
  int? quantity;
  int? tarif;
  int? jasaDokter;
  int? jasaDokterPanggil;
  int? bayarLangsung;
  int? transportasi;
  int? gojek;
  int? status;
  Transportasi? dataTransportasi;
  OjolTindakan? dataOjol;
  int? foc;
  String? createdAt;

  factory Tindakan.fromJson(Map<String, dynamic> json) => Tindakan(
        id: json["id"],
        kunjunganId: json["kunjungan_id"],
        namaTindakan: json["nama_tindakan"],
        petugas: json["petugas"],
        quantity: json["quantity"],
        tarif: json["tarif"],
        jasaDokter: json["jasa_dokter"],
        jasaDokterPanggil: json["jasa_dokter_panggil"],
        bayarLangsung: json["bayar_langsung"],
        transportasi: json["transportasi"],
        gojek: json["gojek"],
        status: json["status"],
        dataTransportasi: json["data_transportasi"] == null
            ? null
            : Transportasi.fromJson(json["data_transportasi"]),
        dataOjol: json["data_ojol"] == null
            ? null
            : OjolTindakan.fromJson(json["data_ojol"]),
        foc: json["foc"],
        createdAt: json["created_at"],
      );
}

class PengantarLabMr {
  int? id;
  int? kunjunganId;
  int? pegawaiId;
  String? tanggalPengantar;
  String? tanggalShort;
  String? jamShort;
  String? dokter;
  int? status;
  int? isBersedia;
  List<TindakanLab>? tindakanLab;

  PengantarLabMr({
    this.id,
    this.kunjunganId,
    this.pegawaiId,
    this.tanggalPengantar,
    this.tanggalShort,
    this.jamShort,
    this.dokter,
    this.status,
    this.isBersedia,
    this.tindakanLab,
  });

  factory PengantarLabMr.fromJson(Map<String, dynamic> json) => PengantarLabMr(
        id: json["id"],
        kunjunganId: json["kunjungan_id"],
        pegawaiId: json["pegawai_id"],
        tanggalPengantar: json["tanggal_pengantar"],
        tanggalShort: json["tanggal_short"],
        jamShort: json["jam_short"],
        dokter: json["dokter"],
        status: json["status"],
        isBersedia: json["is_bersedia"],
        tindakanLab: json["tindakan_lab"] == null
            ? []
            : List<TindakanLab>.from(
                json["tindakan_lab"]!.map((x) => TindakanLab.fromJson(x))),
      );
}

class TindakanLab {
  TindakanLab({
    this.id,
    this.tindakanLabId,
    this.tindakanLab,
    this.hargaModal,
    this.tarifAplikasi,
    this.tarif,
    this.mitra,
    this.nonKonsul,
    this.transportasi,
  });

  int? id;
  int? tindakanLabId;
  String? tindakanLab;
  int? hargaModal;
  int? tarifAplikasi;
  int? tarif;
  int? transportasi;
  int? nonKonsul;
  MitraTindakanLab? mitra;

  factory TindakanLab.fromJson(Map<String, dynamic> json) => TindakanLab(
        id: json["id"],
        tindakanLabId: json["tindakan_lab_id"],
        tindakanLab: json["tindakan_lab"],
        hargaModal: json["harga_modal"],
        tarifAplikasi: json["tarif_aplikasi"],
        tarif: json["tarif"],
        transportasi: json["transportasi"],
        nonKonsul: json["non_konsul"],
        mitra: json["mitra"] == null
            ? null
            : MitraTindakanLab.fromJson(json["mitra"]),
      );
}

class PengantarRadMr {
  int? id;
  int? kunjunganId;
  int? pegawaiId;
  String? dokter;
  String? tanggalPengantar;
  String? tanggalShort;
  String? jamShort;
  int? isBersedia;
  int? status;
  List<TindakanRad>? tindakanRad;

  PengantarRadMr({
    this.id,
    this.kunjunganId,
    this.pegawaiId,
    this.dokter,
    this.tanggalPengantar,
    this.tanggalShort,
    this.jamShort,
    this.status,
    this.isBersedia,
    this.tindakanRad,
  });

  factory PengantarRadMr.fromJson(Map<String, dynamic> json) => PengantarRadMr(
        id: json["id"],
        kunjunganId: json["kunjungan_id"],
        pegawaiId: json["pegawai_id"],
        dokter: json["dokter"],
        tanggalPengantar: json["tanggal_pengantar"],
        tanggalShort: json["tanggal_short"],
        jamShort: json["jam_short"],
        status: json["status"],
        isBersedia: json["is_bersedia"],
        tindakanRad: json["tindakan_rad"] == null
            ? []
            : List<TindakanRad>.from(
                json["tindakan_rad"]!.map((x) => TindakanRad.fromJson(x))),
      );
}

class TindakanRad {
  TindakanRad({
    this.id,
    this.tindakanRadId,
    this.tindakanRad,
    this.hargaModal,
    this.tarifAplikasi,
    this.tarif,
    this.transportasi,
  });

  int? id;
  int? tindakanRadId;
  String? tindakanRad;
  int? hargaModal;
  int? tarifAplikasi;
  int? tarif;
  int? transportasi;

  factory TindakanRad.fromJson(Map<String, dynamic> json) => TindakanRad(
        id: json["id"],
        tindakanRadId: json["tindakan_rad_id"],
        tindakanRad: json["tindakan_rad"],
        hargaModal: json["harga_modal"],
        tarifAplikasi: json["tarif_aplikasi"],
        tarif: json["tarif"],
        transportasi: json["transportasi"],
      );
}

class Dokter {
  Dokter({
    this.id,
    this.idDokter,
    this.idKunjungan,
    this.dokter,
    this.status,
    this.konsul = false,
    this.profesi,
  });

  int? id;
  int? idDokter;
  int? idKunjungan;
  String? dokter;
  int? status;
  bool konsul;
  String? profesi;

  factory Dokter.fromJson(Map<String, dynamic> json) => Dokter(
        id: json["id"],
        idDokter: json["pegawai_id"],
        idKunjungan: json["kunjungan_id"],
        dokter: json["dokter"],
        status: json["status"],
        konsul: json["konsul"],
        profesi: json["profesi"],
      );
}

class Perawat {
  Perawat({
    this.id,
    this.idPerawat,
    this.idKunjungan,
    this.perawat,
    this.status,
    this.profesi,
  });

  int? id;
  int? idPerawat;
  int? idKunjungan;
  String? perawat;
  int? status;
  String? profesi;

  factory Perawat.fromJson(Map<String, dynamic> json) => Perawat(
        id: json["id"],
        idPerawat: json["pegawai_id"],
        idKunjungan: json["kunjungan_id"],
        perawat: json["perawat"],
        status: json["status"],
        profesi: json["profesi"],
      );
}

class Transportasi {
  Transportasi({
    this.id,
    this.kunjunganTindakanId,
    this.jarak,
    this.biaya,
  });

  int? id;
  int? kunjunganTindakanId;
  int? jarak;
  int? biaya;

  factory Transportasi.fromJson(Map<String, dynamic> json) => Transportasi(
        id: json["id"],
        kunjunganTindakanId: json["kunjungan_tindakan_id"],
        jarak: json["jarak"],
        biaya: json["biaya"],
      );
}

class OjolTindakan {
  OjolTindakan({
    required this.id,
    required this.kunjunganTindakanId,
    required this.persen,
    required this.biaya,
    required this.total,
  });

  int id;
  int kunjunganTindakanId;
  int persen;
  int biaya;
  int total;

  factory OjolTindakan.fromJson(Map<String, dynamic> json) => OjolTindakan(
        id: json["id"],
        kunjunganTindakanId: json["kunjungan_tindakan_id"],
        persen: json["persen"],
        biaya: json["biaya"],
        total: json["total"],
      );
}

class TagihanResep {
  TagihanResep({
    this.id,
    this.resepOralId,
    this.idBarang,
    this.namaBarang,
    this.jumlah,
    this.hargaModal,
    this.tarifAplikasi,
    this.total,
    this.tagihanMitra,
  });

  int? id;
  int? resepOralId;
  int? idBarang;
  String? namaBarang;
  int? jumlah;
  int? hargaModal;
  int? tarifAplikasi;
  int? total;
  TagihanMitra? tagihanMitra;

  factory TagihanResep.fromJson(Map<String, dynamic> json) => TagihanResep(
        id: json["id"],
        resepOralId: json["resep_oral_id"],
        idBarang: json["id_barang"],
        namaBarang: json["namaBarang"],
        jumlah: json["jumlah"],
        hargaModal: json["harga_modal"],
        tarifAplikasi: json["tarif_aplikasi"],
        total: json["total"],
        tagihanMitra:
            json["mitra"] == null ? null : TagihanMitra.fromJson(json["mitra"]),
      );
}

class TagihanMitra {
  TagihanMitra({
    this.id,
    this.namaMitra,
    this.kode,
    this.jenis,
  });

  int? id;
  String? namaMitra;
  String? kode;
  String? jenis;

  factory TagihanMitra.fromJson(Map<String, dynamic> json) => TagihanMitra(
        id: json["id"],
        namaMitra: json["nama_mitra"],
        kode: json["kode"],
        jenis: json["jenis"],
      );
}

class TagihanBhp {
  TagihanBhp({
    this.id,
    this.idBarang,
    this.namaBarang,
    this.jumlah,
    this.hargaModal,
    this.tarifAplikasi,
    this.total,
  });

  int? id;
  int? idBarang;
  String? namaBarang;
  int? jumlah;
  int? hargaModal;
  int? tarifAplikasi;
  int? total;

  factory TagihanBhp.fromJson(Map<String, dynamic> json) => TagihanBhp(
        id: json["id"],
        idBarang: json["id_barang"],
        namaBarang: json["nama_barang"],
        jumlah: json["jumlah"],
        hargaModal: json["harga_modal"],
        tarifAplikasi: json["tarif_aplikasi"],
        total: json["total"],
      );
}

class MitraTindakanLab {
  MitraTindakanLab({
    this.id,
    this.namaMitra,
    this.kode,
    this.jenis,
    this.status,
  });

  int? id;
  String? namaMitra;
  String? kode;
  String? jenis;
  int? status;

  factory MitraTindakanLab.fromJson(Map<String, dynamic> json) =>
      MitraTindakanLab(
        id: json["id"],
        namaMitra: json["nama_mitra"],
        kode: json["kode"],
        jenis: json["jenis"],
        status: json["status"],
      );
}

class ObatInjeksiMr {
  int? id;
  String? tanggalResepInjeksi;
  String? tanggalShort;
  String? jamShort;
  int? dokterId;
  String? dokter;
  int? status;
  List<KunjunganObatInjeksi>? obatInjeksi;

  ObatInjeksiMr({
    this.id,
    this.tanggalResepInjeksi,
    this.tanggalShort,
    this.jamShort,
    this.dokter,
    this.dokterId,
    this.status,
    this.obatInjeksi,
  });

  factory ObatInjeksiMr.fromJson(Map<String, dynamic> json) => ObatInjeksiMr(
        id: json["id"],
        tanggalResepInjeksi: json["tanggal_resep_injeksi"],
        tanggalShort: json["tanggal_short"],
        jamShort: json["jam_short"],
        dokter: json["dokter"],
        dokterId: json["dokter_id"],
        status: json["status"],
        obatInjeksi: json["obatInjeksi"] == null
            ? []
            : List<KunjunganObatInjeksi>.from(json["obatInjeksi"]!
                .map((x) => KunjunganObatInjeksi.fromJson(x))),
      );
}

class KunjunganObatInjeksi {
  KunjunganObatInjeksi({
    this.id,
    this.pegawaiId,
    this.barang,
    this.jumlah,
    this.aturanPakai,
    this.catatan,
    this.hargaModal,
    this.tarifAplikasi,
    this.tarif,
  });

  int? id;
  int? pegawaiId;
  MasterBhp? barang;
  int? jumlah;
  String? aturanPakai;
  String? catatan;
  int? hargaModal;
  int? tarifAplikasi;
  int? tarif;

  factory KunjunganObatInjeksi.fromJson(Map<String, dynamic> json) =>
      KunjunganObatInjeksi(
        id: json["id"],
        pegawaiId: json["pegawai_id"],
        barang: MasterBhp.fromJson(json["barang"]),
        jumlah: json["jumlah"],
        aturanPakai: json["aturan_pakai"],
        catatan: json["catatan"],
        hargaModal: json["harga_modal"],
        tarifAplikasi: json["tarif_aplikasi"],
        tarif: json["tarif"],
      );
}

class DataBiayaAdmin {
  DataBiayaAdmin({
    this.id,
    this.kunjunganId,
    this.deskripsi,
    this.nilai,
  });

  int? id;
  int? kunjunganId;
  String? deskripsi;
  int? nilai;

  factory DataBiayaAdmin.fromJson(Map<String, dynamic> json) => DataBiayaAdmin(
        id: json["id"],
        kunjunganId: json["kunjungan_id"],
        deskripsi: json["deskripsi"],
        nilai: json["nilai"],
      );
}

class Diskon {
  Diskon({
    this.id,
    this.kunjunganId,
    this.diskonId,
    this.total,
  });

  int? id;
  int? kunjunganId;
  int? diskonId;
  int? total;

  factory Diskon.fromJson(Map<String, dynamic> json) => Diskon(
        id: json["id"],
        kunjunganId: json["kunjungan_id"],
        diskonId: json["diskon_id"],
        total: json["total"],
      );
}

class BiayaLain {
  int? id;
  MasterPegawai? pegawai;
  String? deskripsi;
  int? nilai;

  BiayaLain({
    this.id,
    this.pegawai,
    this.deskripsi,
    this.nilai,
  });

  factory BiayaLain.fromJson(Map<String, dynamic> json) => BiayaLain(
        id: json["id"],
        pegawai: MasterPegawai.fromJson(json["pegawai"]),
        deskripsi: json["deskripsi"],
        nilai: json["nilai"],
      );
}

class Pegawaikunjungan {
  int? id;
  String? nama;

  Pegawaikunjungan({
    this.id,
    this.nama,
  });

  factory Pegawaikunjungan.fromJson(Map<String, dynamic> json) =>
      Pegawaikunjungan(
        id: json["id"],
        nama: json["nama"],
      );
}

class TagihanTindakanLab {
  int? id;
  MasterTindakanLab? tindakanLab;
  int? hargaModal;
  int? tarifAplikasi;
  int? total;
  int? pengantarId;

  TagihanTindakanLab({
    this.id,
    this.tindakanLab,
    this.hargaModal,
    this.tarifAplikasi,
    this.total,
    this.pengantarId,
  });

  factory TagihanTindakanLab.fromJson(Map<String, dynamic> json) =>
      TagihanTindakanLab(
        id: json["id"],
        tindakanLab: MasterTindakanLab.fromJson(json["tindakan_lab"]),
        hargaModal: json["harga_modal"],
        tarifAplikasi: json["tarif_aplikasi"],
        total: json["total"],
        pengantarId: json["pengantar_id"],
      );
}

class TagihanTindakanRad {
  int? id;
  String? norm;
  int? kunjunganId;
  int? pegawaiId;
  MasterTindakanRad? tindakanRad;
  int? hargaModal;
  int? tarifAplikasi;
  int? total;
  int? pengantarId;

  TagihanTindakanRad({
    this.id,
    this.norm,
    this.kunjunganId,
    this.pegawaiId,
    this.tindakanRad,
    this.hargaModal,
    this.tarifAplikasi,
    this.total,
    this.pengantarId,
  });

  factory TagihanTindakanRad.fromJson(Map<String, dynamic> json) =>
      TagihanTindakanRad(
        id: json["id"],
        norm: json["norm"],
        kunjunganId: json["kunjungan_id"],
        pegawaiId: json["pegawai_id"],
        tindakanRad: MasterTindakanRad.fromJson(json["tindakan_rad"]),
        hargaModal: json["harga_modal"],
        tarifAplikasi: json["tarif_aplikasi"],
        total: json["total"],
        pengantarId: json["pengantar_id"],
      );
}

class KunjunganPaket {
  int? id;
  Paket? paket;
  int? harga;

  KunjunganPaket({
    this.id,
    this.paket,
    this.harga,
  });

  factory KunjunganPaket.fromJson(Map<String, dynamic> json) => KunjunganPaket(
        id: json["id"],
        paket: json["paket"] == null ? null : Paket.fromJson(json["paket"]),
        harga: json["harga"],
      );
}

class Paket {
  int? id;
  String? namaPaket;
  int? harga;
  int? totalHarga;
  int? persen;

  Paket({
    this.id,
    this.namaPaket,
    this.harga,
    this.totalHarga,
    this.persen,
  });

  factory Paket.fromJson(Map<String, dynamic> json) => Paket(
        id: json["id"],
        namaPaket: json["nama_paket"],
        harga: json["harga"],
        totalHarga: json["total_harga"],
        persen: json["persen"],
      );
}

class TagihanResepRacikan {
  TagihanResepRacikan({
    this.id,
    this.kunjunganRacikanId,
    this.idBarang,
    this.namaBarang,
    this.jumlah,
    this.hargaModal,
    this.tarifAplikasi,
    this.total,
    this.tagihanMitra,
  });

  int? id;
  int? kunjunganRacikanId;
  int? resepOralId;
  int? idBarang;
  String? namaBarang;
  int? jumlah;
  int? hargaModal;
  int? tarifAplikasi;
  int? total;
  TagihanMitra? tagihanMitra;

  factory TagihanResepRacikan.fromJson(Map<String, dynamic> json) =>
      TagihanResepRacikan(
        id: json["id"],
        kunjunganRacikanId: json["kunjungan_racikan_id"],
        idBarang: json["id_barang"],
        namaBarang: json["namaBarang"],
        jumlah: json["jumlah"],
        hargaModal: json["harga_modal"],
        tarifAplikasi: json["tarif_aplikasi"],
        total: json["total"],
        tagihanMitra:
            json["mitra"] == null ? null : TagihanMitra.fromJson(json["mitra"]),
      );
}
