import 'dart:io';

import 'package:dokter_panggil/src/blocs/laporan_harian_bloc.dart';
import 'package:dokter_panggil/src/models/laporan_harian_model.dart';
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
import 'package:flutter_svg/svg.dart';
import 'package:intl/intl.dart';
import 'package:url_launcher/url_launcher.dart';

class LaporanHarianPage extends StatefulWidget {
  const LaporanHarianPage({super.key});

  @override
  State<LaporanHarianPage> createState() => _LaporanHarianPageState();
}

class _LaporanHarianPageState extends State<LaporanHarianPage> {
  final _laporanHarianBloc = LaporanHarianBloc();
  final _tanggal = DateFormat('dd MMM yyyy', 'id');
  final _tanggalKirim = DateFormat('yyyy-MM-dd', 'id');
  List<DateTime?>? _selectedRange;

  @override
  void initState() {
    super.initState();
    _getLaporanHarian();
  }

  void _getLaporanHarian() {
    _laporanHarianBloc.getLaporanHarian();
  }

  void _tambahLaporan() {
    showAnimatedDialog(
      context: context,
      barrierDismissible: true,
      builder: (context) {
        return DialogRangeDate(
          selected: _selectedRange,
        );
      },
      duration: const Duration(milliseconds: 500),
      animationType: DialogTransitionType.slideFromBottomFade,
    ).then((value) {
      if (value != null) {
        var selected = value as SelectedDateLaporanHarian;
        _laporanHarianBloc.fromSink
            .add(_tanggalKirim.format(selected.tanggal!.first!));
        _laporanHarianBloc.toSink
            .add(_tanggalKirim.format(selected.tanggal!.last!));
        _laporanHarianBloc.convertSink.add(selected.convert!);
        _laporanHarianBloc.saveLaporanHarian();
        _showStreamSaveLaporanHarian();
      }
    });
  }

  void _showStreamSaveLaporanHarian() {
    showAnimatedDialog(
      context: context,
      builder: (context) {
        return _streamSaveLaporanHarian(context);
      },
      duration: const Duration(milliseconds: 500),
      animationType: DialogTransitionType.slideFromBottomFade,
    );
  }

  void _downloadPdf(LaporanHarian? data) async {
    final url = Uri.parse('${data!.url}');
    if (!await launchUrl(
      url,
      mode: Platform.isAndroid
          ? LaunchMode.externalNonBrowserApplication
          : LaunchMode.inAppBrowserView,
    )) {
      throw Exception('Could not launch');
    }
  }

  @override
  void dispose() {
    _laporanHarianBloc.dispose();
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
      body: _streamLaporanHarian(context),
      floatingActionButton: FloatingActionButton(
        onPressed: _tambahLaporan,
        tooltip: 'Tambah Laporan',
        backgroundColor: kPrimaryColor,
        child: const Icon(Icons.add),
      ),
    );
  }

  Widget _streamLaporanHarian(BuildContext context) {
    return StreamBuilder<ApiResponse<List<LaporanHarian>>>(
        stream: _laporanHarianBloc.laporanHarianStream,
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
                      _getLaporanHarian();
                      setState(() {});
                    },
                  ),
                );
              case Status.completed:
                return ListView.separated(
                  padding: const EdgeInsets.all(22.0),
                  itemBuilder: (context, i) {
                    var harian = snapshot.data!.data![i];
                    return CardLaporanJasa(
                      onTap: () => _downloadPdf(harian),
                      title: 'Laporan Harian',
                      icon: harian.convert == 'excel'
                          ? SvgPicture.asset(
                              'images/excel.svg',
                              height: 42,
                            )
                          : SvgPicture.asset(
                              'images/pdf.svg',
                              height: 42,
                            ),
                      periode:
                          '${_tanggal.format(harian.from!)} - ${_tanggal.format(harian.to!)}',
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
        });
  }

  Widget _streamSaveLaporanHarian(BuildContext context) {
    return StreamBuilder<ApiResponse<ResponseLaporanHarianRequestModel>>(
        stream: _laporanHarianBloc.laporanHarianRequestStream,
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
                  onTap: () => Navigator.pop(context, 'confirm'),
                );
            }
          }
          return const SizedBox();
        });
  }
}
