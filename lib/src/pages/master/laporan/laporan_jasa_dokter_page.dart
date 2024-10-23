import 'dart:io';

import 'package:dokter_panggil/src/blocs/laporan_jasa_dokter_bloc.dart';
import 'package:dokter_panggil/src/models/laporan_jasa_dokter_model.dart';
import 'package:dokter_panggil/src/models/laporan_jasa_dokter_save_model.dart';
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

class LaporanJasaDokterPage extends StatefulWidget {
  const LaporanJasaDokterPage({super.key});

  @override
  State<LaporanJasaDokterPage> createState() => _LaporanJasaDokterPageState();
}

class _LaporanJasaDokterPageState extends State<LaporanJasaDokterPage> {
  final _laporanJasaDokterBloc = LaporanJasaDokterBloc();
  final _tanggal = DateFormat('dd MMM yyyy', 'id');

  @override
  void initState() {
    super.initState();
    _laporanJasaDokterBloc.getLaporanJasaDokter();
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
        _laporanJasaDokterBloc.fromSink.add('${dates.first}');
        _laporanJasaDokterBloc.toSink.add('${dates.last}');
        _laporanJasaDokterBloc.saveLaporanJasaDokter();
        _showStreamSaveLaporanJasaDokter();
      }
    });
  }

  void _showStreamSaveLaporanJasaDokter() {
    showAnimatedDialog(
      context: context,
      builder: (context) {
        return _streamLaporanJasaDokterSave(context);
      },
      duration: const Duration(milliseconds: 500),
      animationType: DialogTransitionType.slideFromBottomFade,
    );
  }

  void _downloadPdf(LaporanJasaDokter? data) async {
    final Uri url = Uri.parse('${data!.url}');
    if (!await launchUrl(url,
        mode: Platform.isAndroid
            ? LaunchMode.externalNonBrowserApplication
            : LaunchMode.platformDefault)) {
      throw Exception('Could not launch');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Laporan Jasa Dokter'),
        backgroundColor: kPrimaryColor,
        elevation: 0,
      ),
      body: _streamLaporanJasaDokter(context),
      floatingActionButton: FloatingActionButton(
        onPressed: _tambahLaporan,
        tooltip: 'Tambah Laporan',
        backgroundColor: kPrimaryColor,
        child: const Icon(Icons.add),
      ),
    );
  }

  Widget _streamLaporanJasaDokter(BuildContext context) {
    return StreamBuilder<ApiResponse<List<LaporanJasaDokter>>>(
      stream: _laporanJasaDokterBloc.laporanJasaDokterStream,
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
                    _laporanJasaDokterBloc.getLaporanJasaDokter();
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
                    title: 'Laporan Jasa Dokter',
                    periode:
                        '${_tanggal.format(data.from!)} - ${_tanggal.format(data.to!)}',
                  );
                },
                separatorBuilder: (context, i) => const SizedBox(
                  height: 18,
                ),
                itemCount: snapshot.data!.data!.length,
              );
          }
        }
        return const SizedBox();
      },
    );
  }

  Widget _streamLaporanJasaDokterSave(BuildContext context) {
    return StreamBuilder<ApiResponse<ResponseLaporanJasaDokterSaveModel>>(
      stream: _laporanJasaDokterBloc.laporanJasaDokterSaveStream,
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
                onTap: () => Navigator.pop(context, snapshot.data!.data!.data),
              );
          }
        }
        return const SizedBox();
      },
    );
  }
}
