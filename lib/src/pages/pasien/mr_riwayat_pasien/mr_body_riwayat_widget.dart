import 'package:admin_dokter_panggil/src/models/mr_menu_model.dart';
import 'package:admin_dokter_panggil/src/models/mr_riwayat_kunjungan_model.dart';
import 'package:admin_dokter_panggil/src/pages/pasien/mr_riwayat_pasien/mr_cppt.dart';
import 'package:admin_dokter_panggil/src/pages/pasien/mr_riwayat_pasien/mr_daftar_pengobatan.dart';
import 'package:admin_dokter_panggil/src/pages/pasien/mr_riwayat_pasien/mr_discharge_planning.dart';
import 'package:admin_dokter_panggil/src/pages/pasien/mr_riwayat_pasien/mr_edukasi.dart';
import 'package:admin_dokter_panggil/src/pages/pasien/mr_riwayat_pasien/mr_hasil_lab.dart';
import 'package:admin_dokter_panggil/src/pages/pasien/mr_riwayat_pasien/mr_implementasi_perawat.dart';
import 'package:admin_dokter_panggil/src/pages/pasien/mr_riwayat_pasien/mr_observasi_komprehensif.dart';
import 'package:admin_dokter_panggil/src/pages/pasien/mr_riwayat_pasien/mr_penghentian_layanan.dart';
import 'package:admin_dokter_panggil/src/pages/pasien/mr_riwayat_pasien/mr_pengkajian_dokter.dart';
import 'package:admin_dokter_panggil/src/pages/pasien/mr_riwayat_pasien/mr_pengkajian_perawat.dart';
import 'package:admin_dokter_panggil/src/pages/pasien/mr_riwayat_pasien/mr_pengkajian_telemedicine.dart';
import 'package:admin_dokter_panggil/src/pages/pasien/mr_riwayat_pasien/mr_persetujuan.dart';
import 'package:admin_dokter_panggil/src/pages/pasien/mr_riwayat_pasien/mr_persetujuan_tindakan.dart';
import 'package:admin_dokter_panggil/src/pages/pasien/mr_riwayat_pasien/mr_resume_medis.dart';
import 'package:admin_dokter_panggil/src/pages/pasien/mr_riwayat_pasien/mr_rujukan.dart';
import 'package:admin_dokter_panggil/src/pages/pasien/mr_riwayat_pasien/mr_screening.dart';
import 'package:admin_dokter_panggil/src/pages/pasien/mr_riwayat_pasien/mr_timbang_terima.dart';
import 'package:admin_dokter_panggil/src/pages/pasien/mr_riwayat_pasien/mr_tindakan_anastesi_bedah.dart';
import 'package:flutter/material.dart';

class MrBodyRiwayatWidget extends StatefulWidget {
  const MrBodyRiwayatWidget({
    super.key,
    this.tileModel,
    this.riwayatKunjungan,
  });

  final MrMenu? tileModel;
  final MrRiwayatKunjungan? riwayatKunjungan;

  @override
  State<MrBodyRiwayatWidget> createState() => _MrBodyRiwayatWidgetState();
}

class _MrBodyRiwayatWidgetState extends State<MrBodyRiwayatWidget> {
  @override
  Widget build(BuildContext context) {
    switch (widget.tileModel!.id) {
      case 0:
        return MrScreening(
          idKunjungan: widget.riwayatKunjungan!.idKunjungan,
        );
      case 1:
        return MrPersetujuan(
          idKunjungan: widget.riwayatKunjungan!.idKunjungan,
        );
      case 2:
        return MrPengkajianTelemedicine(
          idKunjungan: widget.riwayatKunjungan!.idKunjungan,
        );
      case 3:
        return MrResumeMedis(
          idKunjungan: widget.riwayatKunjungan!.idKunjungan,
        );
      case 4:
        return MrPengkajianDokter(
          riwayatKunjungan: widget.riwayatKunjungan,
        );
      case 5:
        return MrPengkajianPerawat(
          riwayatKunjungan: widget.riwayatKunjungan,
        );
      case 6:
        return MrDischargePlanning(
          idKunjungan: widget.riwayatKunjungan!.idKunjungan,
        );
      case 7:
        return MrCppt(
          riwayatKunjungan: widget.riwayatKunjungan,
        );
      case 8:
        return MrImplementasiPerawat(
          riwayatKunjungan: widget.riwayatKunjungan,
        );
      case 9:
        return MrObservasiKomprehensif(
          riwayatKunjungan: widget.riwayatKunjungan,
        );
      case 10:
        return MrDaftarPengobatan(
          riwayatKunjungan: widget.riwayatKunjungan,
        );
      case 11:
        return MrHasilLab(
          riwayatKunjungan: widget.riwayatKunjungan,
        );
      case 12:
        return MrEdukasi(
          riwayatKunjungan: widget.riwayatKunjungan,
        );
      case 13:
        return MrPersetujuanTindakan(
          riwayatKunjungan: widget.riwayatKunjungan,
        );
      case 14:
        return MrTindakanAnastesiBedah(
          riwayatKunjungan: widget.riwayatKunjungan,
        );
      case 15:
        return MrRujukan(
          riwayatKunjungan: widget.riwayatKunjungan,
        );
      case 16:
        return MrTimbangTerima(
          riwayatKunjungan: widget.riwayatKunjungan,
        );
      case 17:
        return MrPenghentianLayanan(
          riwayatKunjungan: widget.riwayatKunjungan,
        );
      default:
        return Container();
    }
  }
}
