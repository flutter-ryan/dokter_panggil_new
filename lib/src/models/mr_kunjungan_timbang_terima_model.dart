MrKunjunganTimbangTerimaModel mrKunjunganTimbangTerimaModelFromJson(
        dynamic str) =>
    MrKunjunganTimbangTerimaModel.fromJson(str);

class MrKunjunganTimbangTerimaModel {
  MrKunjunganTimbangTerima? data;
  String? message;

  MrKunjunganTimbangTerimaModel({
    this.data,
    this.message,
  });

  factory MrKunjunganTimbangTerimaModel.fromJson(Map<String, dynamic> json) =>
      MrKunjunganTimbangTerimaModel(
        data: json["data"] == null
            ? null
            : MrKunjunganTimbangTerima.fromJson(json["data"]),
        message: json["message"],
      );
}

class MrKunjunganTimbangTerima {
  int? id;
  String? nomorRegistrasi;
  List<TimbangTerima>? timbangTerima;

  MrKunjunganTimbangTerima({
    this.id,
    this.nomorRegistrasi,
    this.timbangTerima,
  });

  factory MrKunjunganTimbangTerima.fromJson(Map<String, dynamic> json) =>
      MrKunjunganTimbangTerima(
        id: json["id"],
        nomorRegistrasi: json["nomor_registrasi"],
        timbangTerima: json["timbang_terima"] == null
            ? []
            : List<TimbangTerima>.from(
                json["timbang_terima"]!.map((x) => TimbangTerima.fromJson(x))),
      );
}

class TimbangTerima {
  int? id;
  int? kunjunganId;
  String? pegawai;
  String? shift;
  String? keadaanUmum;
  String? intervensiDilakukan;
  String? intervensiBelumDilakukan;
  String? catatanKhusus;
  String? tanggal;
  DateTime? rawTanggal;
  PenerimaTimbang? penerimaTimbang;
  PerawatPengganti? pengganti;

  TimbangTerima({
    this.id,
    this.kunjunganId,
    this.pegawai,
    this.shift,
    this.keadaanUmum,
    this.intervensiDilakukan,
    this.intervensiBelumDilakukan,
    this.catatanKhusus,
    this.tanggal,
    this.rawTanggal,
    this.penerimaTimbang,
    this.pengganti,
  });

  factory TimbangTerima.fromJson(Map<String, dynamic> json) => TimbangTerima(
        id: json["id"],
        kunjunganId: json["kunjungan_id"],
        pegawai: json["pegawai"],
        shift: json["shift"],
        keadaanUmum: json["keadaan_umum"],
        intervensiDilakukan: json["intervensi_dilakukan"],
        intervensiBelumDilakukan: json["intervensi_belum_dilakukan"],
        catatanKhusus: json["catatan_khusus"],
        tanggal: json["tanggal"],
        rawTanggal: DateTime.parse(json["raw_tanggal"]),
        penerimaTimbang: json["penerima"] == null
            ? null
            : PenerimaTimbang.fromJson(json["penerima"]),
        pengganti: json["pengganti"] == null
            ? null
            : PerawatPengganti.fromJson(json["pengganti"]),
      );
}

class PenerimaTimbang {
  int? id;
  String? nama;
  String? tanggal;

  PenerimaTimbang({
    this.id,
    this.nama,
    this.tanggal,
  });

  factory PenerimaTimbang.fromJson(Map<String, dynamic> json) =>
      PenerimaTimbang(
        id: json["id"],
        nama: json["nama"],
        tanggal: json["tanggal"],
      );
}

class PerawatPengganti {
  int id;
  String nama;

  PerawatPengganti({
    required this.id,
    required this.nama,
  });

  factory PerawatPengganti.fromJson(Map<String, dynamic> json) =>
      PerawatPengganti(
        id: json["id"],
        nama: json["nama"],
      );
}
