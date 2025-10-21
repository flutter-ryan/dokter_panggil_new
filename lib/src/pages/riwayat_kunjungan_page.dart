import 'package:admin_dokter_panggil/src/blocs/kunjungan_riwayat_all_bloc.dart';
import 'package:admin_dokter_panggil/src/models/kunjunga_pasien_all_model.dart';
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

class RiwayatKunjunganPage extends StatefulWidget {
  const RiwayatKunjunganPage({super.key});

  @override
  State<RiwayatKunjunganPage> createState() => _RiwayatKunjunganPageState();
}

class _RiwayatKunjunganPageState extends State<RiwayatKunjunganPage> {
  final _controller = ScrollController();
  final KunjunganRiwayatAllBloc _kunjunganRiwayatBloc =
      KunjunganRiwayatAllBloc();
  KunjunganPasienAllModel? _kunjungan;

  @override
  void initState() {
    super.initState();
    _kunjunganRiwayatBloc.getRiwayatKunjuganAll();
    _controller.addListener(_scrollListen);
  }

  void _scrollListen() {
    if (_controller.position.pixels == _controller.position.maxScrollExtent) {
      _kunjunganRiwayatBloc.getNextRiwayatAll();
    }
  }

  @override
  void dispose() {
    _kunjunganRiwayatBloc.dispose();
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
          Expanded(
            child: _buildStreamRiwayat(),
          )
        ],
      ),
    );
  }

  Widget _buildStreamRiwayat() {
    return StreamBuilder<ApiResponse<KunjunganPasienAllModel>>(
      stream: _kunjunganRiwayatBloc.riwayatKunjunganAllStream,
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
                    _kunjunganRiwayatBloc.getRiwayatKunjuganAll();
                    setState(() {});
                  },
                ),
              );
            case Status.completed:
              _kunjungan = snapshot.data!.data!;
              return ListRiwayatKunjungan(
                data: _kunjungan!,
                controller: _controller,
              );
          }
        }
        return const SizedBox();
      },
    );
  }
}

class ListRiwayatKunjungan extends StatefulWidget {
  const ListRiwayatKunjungan({
    super.key,
    required this.data,
    required this.controller,
  });

  final KunjunganPasienAllModel data;
  final ScrollController controller;

  @override
  State<ListRiwayatKunjungan> createState() => _ListRiwayatKunjunganState();
}

class _ListRiwayatKunjunganState extends State<ListRiwayatKunjungan>
    with AutomaticKeepAliveClientMixin {
  final _filter = TextEditingController();
  List<Kunjungan> _data = [];

  @override
  void initState() {
    super.initState();
    _data = widget.data.data!;
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Column(
      children: [
        SearchWidgetPage(
          filter: _filter,
          hint: 'Cari Nama/nomor registrasi',
        ),
        Expanded(
          child: ListView.separated(
            controller: widget.controller,
            padding:
                const EdgeInsets.symmetric(vertical: 18.0, horizontal: 22.0),
            separatorBuilder: (context, i) => const SizedBox(
              height: 15.0,
            ),
            itemBuilder: (context, i) {
              if (i == _data.length) {
                return const SizedBox(
                  height: 40,
                  child: Center(
                    child: CircularProgressIndicator(),
                  ),
                );
              }
              var riwayat = _data[i];
              return CardKunjunganPasien(
                kunjungan: riwayat,
                type: 'view',
              );
            },
            itemCount: widget.data.currentPage != widget.data.totalPage
                ? _data.length + 1
                : _data.length,
          ),
        ),
      ],
    );
  }

  @override
  bool get wantKeepAlive => true;
}
