import 'package:admin_dokter_panggil/src/blocs/mr_kunjungan_observasi_bloc.dart';
import 'package:admin_dokter_panggil/src/models/mr_kunjungan_observasi_anak_model.dart';
import 'package:admin_dokter_panggil/src/models/mr_kunjungan_observasi_model.dart';
import 'package:admin_dokter_panggil/src/models/mr_riwayat_kunjungan_model.dart';
import 'package:admin_dokter_panggil/src/models/pasien_show_model.dart';
import 'package:admin_dokter_panggil/src/pages/components/error_response.dart';
import 'package:admin_dokter_panggil/src/pages/components/loading_kit.dart';
import 'package:admin_dokter_panggil/src/pages/pasien/mr_riwayat_pasien/observasi_anak.dart';
import 'package:admin_dokter_panggil/src/pages/pasien/mr_riwayat_pasien/observasi_dewasa.dart';
import 'package:admin_dokter_panggil/src/repositories/responseApi/api_response.dart';
import 'package:admin_dokter_panggil/src/source/color_style.dart';
import 'package:flutter/material.dart';

class MrObservasiKomprehensif extends StatefulWidget {
  const MrObservasiKomprehensif({
    super.key,
    this.riwayatKunjungan,
  });

  final MrRiwayatKunjungan? riwayatKunjungan;

  @override
  State<MrObservasiKomprehensif> createState() =>
      _MrObservasiKomprehensifState();
}

class _MrObservasiKomprehensifState extends State<MrObservasiKomprehensif> {
  final _mrKunjunganObservasiBloc = MrKunjunganObservasiBloc();

  @override
  void initState() {
    super.initState();
    _getObservasiKomprehensif();
  }

  void _getObservasiKomprehensif() {
    _mrKunjunganObservasiBloc.idKunjunganSink
        .add(widget.riwayatKunjungan!.idKunjungan!);
    if (widget.riwayatKunjungan!.pasien!.isDewasa) {
      _mrKunjunganObservasiBloc.getObservasi();
    } else {
      _mrKunjunganObservasiBloc.getObservasiAnak();
    }
  }

  @override
  void dispose() {
    super.dispose();
    _mrKunjunganObservasiBloc.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (!widget.riwayatKunjungan!.pasien!.isDewasa) {
      return _buildStreamObservasiAnak(context);
    }
    return StreamBuilder<ApiResponse<MrKunjunganObservasiModel>>(
      stream: _mrKunjunganObservasiBloc.observasiStream,
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
                  _getObservasiKomprehensif();
                  setState(() {});
                },
              );
            case Status.completed:
              return ObservasiKomprehensifWidget(
                pasien: widget.riwayatKunjungan!.pasien!,
                idKunjungan: widget.riwayatKunjungan!.idKunjungan,
                data: snapshot.data!.data!.data,
              );
          }
        }
        return const SizedBox();
      },
    );
  }

  Widget _buildStreamObservasiAnak(BuildContext context) {
    return StreamBuilder<ApiResponse<MrKunjunganObservasiAnakModel>>(
      stream: _mrKunjunganObservasiBloc.observasiAnakStream,
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
                  _getObservasiKomprehensif();
                  setState(() {});
                },
              );
            case Status.completed:
              return ObservasiKomprehensifAnakWidget(
                pasien: widget.riwayatKunjungan!.pasien!,
                idKunjungan: widget.riwayatKunjungan!.idKunjungan,
                data: snapshot.data!.data!.data,
              );
          }
        }
        return const SizedBox();
      },
    );
  }
}

class ObservasiKomprehensifWidget extends StatefulWidget {
  const ObservasiKomprehensifWidget({
    super.key,
    this.idKunjungan,
    this.data,
    required this.pasien,
  });

  final int? idKunjungan;
  final DataMrObservasi? data;
  final Pasien pasien;

  @override
  State<ObservasiKomprehensifWidget> createState() =>
      _ObservasiKomprehensifWidgetState();
}

class _ObservasiKomprehensifWidgetState
    extends State<ObservasiKomprehensifWidget> {
  DataMrObservasi? _data;

  @override
  void initState() {
    super.initState();
    _data = widget.data;
  }

  @override
  Widget build(BuildContext context) {
    return ObservasiDewasa(
      data: _data,
      pasien: widget.pasien,
      idKunjungan: widget.idKunjungan,
    );
  }
}

class ObservasiKomprehensifAnakWidget extends StatefulWidget {
  const ObservasiKomprehensifAnakWidget({
    super.key,
    this.idKunjungan,
    this.data,
    required this.pasien,
  });

  final int? idKunjungan;
  final DataMrObservasiAnak? data;
  final Pasien pasien;

  @override
  State<ObservasiKomprehensifAnakWidget> createState() =>
      _ObservasiKomprehensifAnakWidgetState();
}

class _ObservasiKomprehensifAnakWidgetState
    extends State<ObservasiKomprehensifAnakWidget> {
  DataMrObservasiAnak? _data;

  @override
  void initState() {
    super.initState();
    _data = widget.data;
  }

  @override
  Widget build(BuildContext context) {
    return ObservasiAnak(
      data: _data,
      pasien: widget.pasien,
      idKunjungan: widget.idKunjungan,
    );
  }
}

class ColumnWidget extends StatelessWidget {
  const ColumnWidget({
    super.key,
    this.label,
    this.border = true,
    this.color,
    this.height = 62,
  });

  final Widget? label;
  final bool border;
  final Color? color;
  final double height;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
      decoration: BoxDecoration(
        border: border
            ? const Border(bottom: BorderSide(width: 0.5, color: Colors.grey))
            : null,
        color: color ?? kBgRedLightColor,
      ),
      alignment: Alignment.center,
      width: 120.0,
      height: height,
      child: label,
    );
  }
}
