import 'dart:io';

import 'package:dokter_panggil/src/blocs/laporan_jasa_perawat_bloc.dart';
import 'package:dokter_panggil/src/models/laporan_jasa_perawat_model.dart';
import 'package:dokter_panggil/src/models/laporan_jasa_perawat_save_model.dart';
import 'package:dokter_panggil/src/pages/components/error_dialog.dart';
import 'package:dokter_panggil/src/pages/components/error_response.dart';
import 'package:dokter_panggil/src/pages/components/loading_kit.dart';
import 'package:dokter_panggil/src/pages/components/success_dialog.dart';
import 'package:dokter_panggil/src/pages/master/laporan/card_laporan_jasa.dart';
import 'package:dokter_panggil/src/pages/master/laporan/dialog_range_date.dart';
import 'package:dokter_panggil/src/repositories/responseApi/api_response.dart';
import 'package:dokter_panggil/src/source/config.dart';
import 'package:flutter/material.dart';
import 'package:dokter_panggil/src/source/transition/animated_dialog.dart';
import 'package:intl/intl.dart';
import 'package:url_launcher/url_launcher.dart';

class LaporanJasaPerawatPage extends StatefulWidget {
  const LaporanJasaPerawatPage({super.key});

  @override
  State<LaporanJasaPerawatPage> createState() => _LaporanJasaPerawatPageState();
}

class _LaporanJasaPerawatPageState extends State<LaporanJasaPerawatPage> {
  final _laporanJasaPerawatBloc = LaporanJasaPerawatBloc();
  final _tanggal = DateFormat('dd MMM yyyy', 'id');

  @override
  void initState() {
    super.initState();
    _laporanJasaPerawatBloc.getLaporanJasa();
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
        var from = '${dates.first}';
        var to = '${dates.last}';
        _laporanJasaPerawatBloc.fromSink.add(from);
        _laporanJasaPerawatBloc.toSink.add(to);
        _laporanJasaPerawatBloc.saveLaporanJasa();
        _showStreamLaporanJasa();
      }
    });
  }

  void _showStreamLaporanJasa() {
    showAnimatedDialog(
        context: context,
        builder: (context) {
          return _streamLaporanJasaPerawatSave(context);
        },
        duration: const Duration(milliseconds: 500),
        animationType: DialogTransitionType.slideFromBottomFade);
  }

  void _downloadPdf(LaporanJasaPerawat? data) async {
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
    _laporanJasaPerawatBloc.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Laporan Jasa Perawat'),
        backgroundColor: kPrimaryColor,
        elevation: 0,
      ),
      body: _streamLaporanJasaPerawat(context),
      floatingActionButton: FloatingActionButton(
        onPressed: _tambahLaporan,
        tooltip: 'Tambah Laporan',
        backgroundColor: kPrimaryColor,
        child: const Icon(Icons.add),
      ),
    );
  }

  Widget _streamLaporanJasaPerawat(BuildContext context) {
    return StreamBuilder<ApiResponse<List<LaporanJasaPerawat>>>(
      stream: _laporanJasaPerawatBloc.laporanJasaPerawatStream,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          switch (snapshot.data!.status) {
            case Status.loading:
              return const LoadingKit(
                color: kPrimaryColor,
              );
            case Status.error:
              return Center(
                child: ErrorResponse(
                  message: snapshot.data!.message,
                  onTap: () {
                    _laporanJasaPerawatBloc.getLaporanJasa();
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
                    title: 'Laporan Jasa Perawat',
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

  Widget _streamLaporanJasaPerawatSave(BuildContext context) {
    return StreamBuilder<ApiResponse<ResponseLaporanJasaPerawatSaveModel>>(
      stream: _laporanJasaPerawatBloc.laporanJasaPerawatSaveStream,
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
