import 'package:admin_dokter_panggil/src/models/mr_riwayat_detail_model.dart';
import 'package:admin_dokter_panggil/src/pages/pasien/mr_riwayat_detail_page.dart';
import 'package:admin_dokter_panggil/src/pages/pasien/mr_riwayat_pasien/mr_discharge_planning.dart';
import 'package:admin_dokter_panggil/src/pages/pasien/mr_riwayat_pasien/mr_pengkajian_dokter.dart';
import 'package:admin_dokter_panggil/src/pages/pasien/mr_riwayat_pasien/mr_pengkajian_perawat.dart';
import 'package:admin_dokter_panggil/src/pages/pasien/mr_riwayat_pasien/mr_pengkajian_telemedicine.dart';
import 'package:admin_dokter_panggil/src/pages/pasien/mr_riwayat_pasien/mr_persetujuan.dart';
import 'package:admin_dokter_panggil/src/pages/pasien/mr_riwayat_pasien/mr_resume_medis.dart';
import 'package:admin_dokter_panggil/src/pages/pasien/mr_riwayat_pasien/mr_screening.dart';
import 'package:flutter/material.dart';

class MrBodyRiwayatWidget extends StatefulWidget {
  const MrBodyRiwayatWidget({
    super.key,
    this.tileModel,
    this.data,
  });

  final TabTileModel? tileModel;
  final MrRiwayatDetail? data;

  @override
  State<MrBodyRiwayatWidget> createState() => _MrBodyRiwayatWidgetState();
}

class _MrBodyRiwayatWidgetState extends State<MrBodyRiwayatWidget> {
  @override
  Widget build(BuildContext context) {
    switch (widget.tileModel!.id) {
      case 0:
        return MrScreening(
          data: widget.data,
        );
      case 1:
        return MrPersetujuan(
          data: widget.data,
        );
      case 2:
        return MrPengkajianTelemedicine(
          data: widget.data,
        );
      case 3:
        return MrResumeMedis(
          data: widget.data,
        );
      case 4:
        return MrPengkajianDokter(
          data: widget.data,
        );
      case 5:
        return MrPengkajianPerawat(
          data: widget.data,
        );
      case 6:
        return MrDischargePlanning(
          data: widget.data,
        );
      case 7:
        return MrCppt(
          data: widget.data,
        );
      // case 8:
      //   return MrImplementasiPerawat(
      //     data: widget.data,
      //   );
      // case 9:
      //   return MrObservasiKomprehensif(
      //     data: widget.data,
      //   );
      // case 10:
      //   return MrDaftarPengobatan(
      //     data: widget.data,
      //   );
      // case 11:
      //   return MrHasilLab(
      //     data: widget.data,
      //   );
      // case 12:
      //   return MrEdukasi(
      //     data: widget.data,
      //   );
      // case 13:
      //   return MrPersetujuanTindakan(
      //     data: widget.data,
      //   );
      // case 14:
      //   return MrTindakanAnastesiBedah(
      //     data: widget.data,
      //   );
      // case 15:
      //   return MrRujukan(
      //     data: widget.data,
      //   );
      // case 16:
      //   return MrTimbangTerima(
      //     data: widget.data,
      //   );
      // case 17:
      //   return MrPenghentianLayanan(
      //     data: widget.data,
      //   );
      default:
        return Container();
    }
  }
}
