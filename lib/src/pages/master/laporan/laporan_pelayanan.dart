import 'dart:io';

import 'package:admin_dokter_panggil/src/blocs/laporan_layanan_bloc.dart';
import 'package:admin_dokter_panggil/src/models/laporan_layanan_model.dart';
import 'package:admin_dokter_panggil/src/models/laporan_layanan_save_model.dart';
import 'package:admin_dokter_panggil/src/pages/components/error_dialog.dart';
import 'package:admin_dokter_panggil/src/pages/components/error_response.dart';
import 'package:admin_dokter_panggil/src/pages/components/loading_kit.dart';
import 'package:admin_dokter_panggil/src/pages/components/success_dialog.dart';
import 'package:admin_dokter_panggil/src/pages/master/laporan/card_laporan_jasa.dart';
import 'package:admin_dokter_panggil/src/pages/master/laporan/dialog_range_date.dart';
import 'package:admin_dokter_panggil/src/repositories/responseApi/api_response.dart';
import 'package:admin_dokter_panggil/src/source/config.dart';
import 'package:flutter/material.dart';
import 'package:admin_dokter_panggil/src/source/transition/animated_dialog.dart';
import 'package:intl/intl.dart';
import 'package:url_launcher/url_launcher.dart';

class LaporanPelayanan extends StatefulWidget {
  const LaporanPelayanan({super.key});

  @override
  State<LaporanPelayanan> createState() => _LaporanPelayananState();
}

class _LaporanPelayananState extends State<LaporanPelayanan> {
  final _laporanLayananBloc = LaporanLayananBloc();
  final _tanggal = DateFormat('dd MMM yyyy', 'id');

  @override
  void initState() {
    super.initState();
    _laporanLayananBloc.getLaporanLayanan();
  }

  void _tambahLaporan() {
    showAnimatedDialog(
      context: context,
      barrierDismissible: true,
      builder: (context) {
        return const DialogRangeDate();
      },
      duration: const Duration(milliseconds: 500),
      animationType: DialogTransitionType.slideFromBottomFade,
    ).then((value) {
      if (value != null) {
        var dates = value as List<DateTime?>;
        final from = dates.first;
        final to = dates.last;
        _laporanLayananBloc.fromSink.add('$from');
        _laporanLayananBloc.toSink.add('$to');
        _laporanLayananBloc.saveLaporanLayanan();
        _showStreamLaporanLayananSave();
      }
    });
  }

  void _showStreamLaporanLayananSave() {
    showAnimatedDialog(
      context: context,
      builder: (context) {
        return _streamLaporanLayananSave(context);
      },
      duration: const Duration(milliseconds: 500),
      animationType: DialogTransitionType.slideFromBottomFade,
    );
  }

  void _downloadPdf(LaporanLayanan? data) async {
    final Uri url = Uri.parse('${data!.url}');
    if (!await launchUrl(url,
        mode: Platform.isAndroid
            ? LaunchMode.externalNonBrowserApplication
            : LaunchMode.platformDefault)) {
      throw Exception('Could not launch');
    }
  }

  @override
  void dispose() {
    _laporanLayananBloc.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Laporan Harian'),
        backgroundColor: kPrimaryColor,
        elevation: 0,
      ),
      body: _streamLaporanLayanan(context),
      floatingActionButton: FloatingActionButton(
        onPressed: _tambahLaporan,
        tooltip: 'Tambah Laporan',
        backgroundColor: kPrimaryColor,
        child: const Icon(Icons.add),
      ),
    );
  }

  Widget _streamLaporanLayanan(BuildContext context) {
    return StreamBuilder<ApiResponse<List<LaporanLayanan>>>(
      stream: _laporanLayananBloc.laporanLayananStream,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          switch (snapshot.data!.status) {
            case Status.loading:
              return const LoadingKit(
                color: kPrimaryColor,
              );
            case Status.error:
              return Align(
                alignment: Alignment.center,
                child: ErrorResponse(
                  message: snapshot.data!.message,
                  onTap: () {
                    _laporanLayananBloc.getLaporanLayanan();
                    setState(() {});
                  },
                ),
              );
            case Status.completed:
              return ListView.separated(
                padding: const EdgeInsets.all(22.0),
                itemBuilder: (context, i) {
                  var data = snapshot.data!.data![i];
                  return CardLaporanJasa(
                    onTap: () => _downloadPdf(data),
                    title: 'Laporan Layanan',
                    periode:
                        '${_tanggal.format(data.from!)} - ${_tanggal.format(data.to!)}',
                  );
                },
                separatorBuilder: (context, i) => const SizedBox(
                  height: 18.0,
                ),
                itemCount: snapshot.data!.data!.length,
              );
          }
        }
        return const SizedBox();
      },
    );
  }

  Widget _streamLaporanLayananSave(BuildContext context) {
    return StreamBuilder<ApiResponse<ResponseLaporanLayananSaveModel>>(
      stream: _laporanLayananBloc.laporanLayananSaveStream,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          switch (snapshot.data!.status) {
            case Status.loading:
              return const LoadingKit();
            case Status.error:
              return ErrorDialog(
                message: snapshot.data!.message,
                onTap: () => Navigator.pop(context),
              );
            case Status.completed:
              return SuccessDialog(
                message: snapshot.data!.data!.message,
                onTap: () => Navigator.pop(context),
              );
          }
        }
        return const SizedBox();
      },
    );
  }
}
