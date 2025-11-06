import 'package:admin_dokter_panggil/src/blocs/mr_pengkajian_perawat_bloc.dart';
import 'package:admin_dokter_panggil/src/models/mr_kunjungan_pengkajian_perawat_model.dart';
import 'package:admin_dokter_panggil/src/models/mr_pengkajian_perawat_anak_model.dart';
import 'package:admin_dokter_panggil/src/models/mr_riwayat_kunjungan_model.dart';
import 'package:admin_dokter_panggil/src/pages/components/error_response.dart';
import 'package:admin_dokter_panggil/src/pages/components/loading_kit.dart';
import 'package:admin_dokter_panggil/src/pages/pasien/mr_riwayat_pasien/pengkajian_perawat_anak_form.dart';
import 'package:admin_dokter_panggil/src/pages/pasien/mr_riwayat_pasien/pengkajian_perawat_form.dart';
import 'package:admin_dokter_panggil/src/repositories/responseApi/api_response.dart';
import 'package:admin_dokter_panggil/src/source/color_style.dart';
import 'package:flutter/material.dart';

class MrPengkajianPerawat extends StatefulWidget {
  const MrPengkajianPerawat({
    super.key,
    this.riwayatKunjungan,
  });

  final MrRiwayatKunjungan? riwayatKunjungan;

  @override
  State<MrPengkajianPerawat> createState() => _MrPengkajianPerawatState();
}

class _MrPengkajianPerawatState extends State<MrPengkajianPerawat> {
  final _mrPengkajianPerawatBloc = MrPengkajianPerawatBloc();

  @override
  void initState() {
    super.initState();
    _getPengkajianPerawat();
  }

  void _getPengkajianPerawat() {
    _mrPengkajianPerawatBloc.idKunjunganSink
        .add(widget.riwayatKunjungan!.idKunjungan!);
    if (widget.riwayatKunjungan!.pasien!.isDewasa) {
      _mrPengkajianPerawatBloc.getPengkajianPerawat();
    } else {
      _mrPengkajianPerawatBloc.getPengkajianPerawatAnak();
    }
  }

  @override
  void dispose() {
    super.dispose();
    _mrPengkajianPerawatBloc.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (!widget.riwayatKunjungan!.pasien!.isDewasa) {
      return _streamPengkajianPerawatAnak(context);
    }
    return StreamBuilder<ApiResponse<MrKunjunganPengkajianPerawatModel>>(
      stream: _mrPengkajianPerawatBloc.pengkajianPerawatStream,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          switch (snapshot.data!.status) {
            case Status.loading:
              return const LoadingKit(
                color: kPrimaryColor,
              );
            case Status.error:
              return ErrorResponse(
                message: snapshot.data!.message,
                onTap: () {
                  _getPengkajianPerawat();
                  setState(() {});
                },
              );
            case Status.completed:
              return PengkajianPerawatForm(
                pasien: widget.riwayatKunjungan!.pasien!,
                data: snapshot.data!.data!.data,
                idKunjungan: widget.riwayatKunjungan!.idKunjungan,
              );
          }
        }
        return const SizedBox();
      },
    );
  }

  Widget _streamPengkajianPerawatAnak(BuildContext context) {
    return StreamBuilder<ApiResponse<MrPengkajianPerawatAnakModel>>(
      stream: _mrPengkajianPerawatBloc.pengkajianPerawatAnakStream,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          switch (snapshot.data!.status) {
            case Status.loading:
              return const LoadingKit(
                color: kPrimaryColor,
              );
            case Status.error:
              return ErrorResponse(
                message: snapshot.data!.message,
                onTap: () {
                  _getPengkajianPerawat();
                  setState(() {});
                },
              );
            case Status.completed:
              return PengkajianPerawatAnakForm(
                pasien: widget.riwayatKunjungan!.pasien!,
                data: snapshot.data!.data!.data,
                idKunjungan: widget.riwayatKunjungan!.idKunjungan,
              );
          }
        }
        return const SizedBox();
      },
    );
  }
}
