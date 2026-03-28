import 'dart:async';

import 'package:admin_dokter_panggil/src/blocs/kunjungan_riwayat_all_bloc.dart';
import 'package:admin_dokter_panggil/src/blocs/new_riwayat_kunjungan_bloc.dart';
import 'package:admin_dokter_panggil/src/models/kunjunga_pasien_all_model.dart';
import 'package:admin_dokter_panggil/src/models/new_riwayat_kunjungan_model.dart';
import 'package:admin_dokter_panggil/src/models/pendaftaran_kunjungan_save_model.dart';
import 'package:admin_dokter_panggil/src/pages/components/card_kunjungan_pasien.dart';
import 'package:admin_dokter_panggil/src/pages/components/error_response.dart';
import 'package:admin_dokter_panggil/src/pages/components/loading_kit.dart';
import 'package:admin_dokter_panggil/src/pages/components/search_widget_page.dart';
import 'package:admin_dokter_panggil/src/pages/components/title_quick_act.dart';
import 'package:admin_dokter_panggil/src/repositories/responseApi/api_response.dart';
import 'package:admin_dokter_panggil/src/source/config.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class RiwayatKunjunganPage extends StatefulWidget {
  const RiwayatKunjunganPage({super.key});

  @override
  State<RiwayatKunjunganPage> createState() => _RiwayatKunjunganPageState();
}

class _RiwayatKunjunganPageState extends State<RiwayatKunjunganPage> {
  final _controller = ScrollController();
  final _filter = TextEditingController();
  final NewRiwayatKunjunganBloc _newRiwayatKunjunganBloc =
      NewRiwayatKunjunganBloc();

  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _newRiwayatKunjunganBloc.getRiwayatKunjungan();
    _controller.addListener(_scrollListen);
    _filter.addListener(_filterListen);
  }

  void _filterListen() {
    _timer?.cancel();
    _timer = Timer.periodic(const Duration(milliseconds: 700), (timer) {
      if (_filter.text.isEmpty) {
        _newRiwayatKunjunganBloc.filterSink.add('');
        _newRiwayatKunjunganBloc.getRiwayatKunjungan();
      } else if (_filter.text.length > 3) {
        _newRiwayatKunjunganBloc.filterSink.add(_filter.text);
        _newRiwayatKunjunganBloc.getRiwayatKunjungan();
      }
      timer.cancel();
      setState(() {});
    });
  }

  void _scrollListen() {
    if (_controller.position.pixels == _controller.position.maxScrollExtent) {
      _newRiwayatKunjunganBloc.nextPage();
    }
  }

  @override
  void dispose() {
    _newRiwayatKunjunganBloc.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 0.0,
        systemOverlayStyle: const SystemUiOverlayStyle(
          statusBarColor: Colors.transparent,
          statusBarBrightness: Brightness.light,
          statusBarIconBrightness: Brightness.dark,
        ),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const TitleQuickAct(
            title: 'Riwayat Kunjungan',
          ),
          SearchWidgetPage(
            filter: _filter,
            hint: 'Cari nama pasien',
            clearButton: _filter.text.isEmpty
                ? null
                : IconButton(
                    onPressed: () => _filter.clear(),
                    padding: EdgeInsets.zero,
                    icon: Icon(Icons.cancel_rounded),
                    color: Colors.grey,
                  ),
          ),
          Expanded(
            child: _buildStreamRiwayat(),
          )
        ],
      ),
    );
  }

  Widget _buildStreamRiwayat() {
    return StreamBuilder<ApiResponse<NewRiwayatKunjunganModel>>(
      stream: _newRiwayatKunjunganBloc.riwayatKunjunganStream,
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
                    _newRiwayatKunjunganBloc.getRiwayatKunjungan();
                    setState(() {});
                  },
                ),
              );
            case Status.completed:
              return ListView.separated(
                controller: _controller,
                padding: const EdgeInsets.symmetric(
                    vertical: 18.0, horizontal: 22.0),
                separatorBuilder: (context, i) => const SizedBox(
                  height: 15.0,
                ),
                itemBuilder: (context, i) {
                  if (i == snapshot.data!.data!.data!.length) {
                    return SizedBox(
                      height: 42,
                      child: Center(
                        child: SpinKitThreeBounce(
                          color: Colors.grey[400],
                          size: 20,
                        ),
                      ),
                    );
                  }
                  var riwayat = snapshot.data!.data!.data![i];
                  return Container(
                    padding: const EdgeInsets.symmetric(horizontal: 18.0),
                    decoration: BoxDecoration(
                      color: kPrimaryColor.withAlpha(8),
                      border: Border.all(width: 0.5, color: kPrimaryColor),
                      borderRadius: BorderRadius.circular(12.0),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        ListTile(
                          contentPadding: EdgeInsets.zero,
                          minVerticalPadding: 18,
                          dense: true,
                          title: Text(
                            '#${riwayat.nomorRegistrasi}',
                            style: const TextStyle(fontWeight: FontWeight.w600),
                          ),
                          subtitle:
                              Text('${riwayat.namaPasien} / ${riwayat.norm}'),
                          trailing: Container(
                            padding: const EdgeInsets.symmetric(
                                vertical: 4.0, horizontal: 8.0),
                            decoration: BoxDecoration(
                              color: riwayat.status == 5
                                  ? Colors.green
                                  : Colors.orange[200],
                              borderRadius: BorderRadius.circular(4.0),
                            ),
                            child: riwayat.status == 5
                                ? const Text(
                                    'Final',
                                    style: TextStyle(
                                        color: Colors.white, fontSize: 10),
                                  )
                                : const Text(
                                    'Sedang dilayani',
                                    style: TextStyle(fontSize: 10),
                                  ),
                          ),
                        ),
                        Divider(
                          height: 0.0,
                          color: Colors.grey[400],
                        ),
                        const SizedBox(
                          height: 12.0,
                        ),
                        const Text(
                          'Tanggal',
                          style: TextStyle(color: Colors.grey, fontSize: 11.0),
                        ),
                        const SizedBox(
                          height: 4.0,
                        ),
                        Text(
                          '${riwayat.tanggalKunjungan}',
                          style: const TextStyle(fontSize: 13.0),
                        ),
                        const SizedBox(
                          height: 12.0,
                        ),
                        const Text(
                          'Keluhan',
                          style: TextStyle(color: Colors.grey, fontSize: 11.0),
                        ),
                        const SizedBox(
                          height: 4.0,
                        ),
                        if (riwayat.keluhan != null)
                          Text(
                            '${riwayat.keluhan}',
                            style: const TextStyle(fontSize: 13.0),
                          )
                        else
                          const Text(
                            'Tidak ada',
                            style: TextStyle(fontSize: 13.0),
                          ),
                        const SizedBox(
                          height: 18.0,
                        )
                      ],
                    ),
                  );
                },
                itemCount: snapshot.data!.data!.nextPageUrl == null
                    ? snapshot.data!.data!.data!.length
                    : snapshot.data!.data!.data!.length + 1,
              );
          }
        }
        return const SizedBox();
      },
    );
  }
}
