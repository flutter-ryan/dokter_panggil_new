import 'package:dokter_panggil/src/blocs/kunjungan_pasien_all_bloc.dart';
import 'package:dokter_panggil/src/models/kunjunga_pasien_all_model.dart';
import 'package:dokter_panggil/src/models/pendaftaran_kunjungan_save_model.dart';
import 'package:dokter_panggil/src/pages/components/card_kunjungan_pasien.dart';
import 'package:dokter_panggil/src/pages/components/close_button.dart';
import 'package:dokter_panggil/src/pages/components/error_response.dart';
import 'package:dokter_panggil/src/pages/components/header.dart';
import 'package:dokter_panggil/src/pages/components/loading_kit.dart';
import 'package:dokter_panggil/src/pages/components/search_input_form.dart';
import 'package:dokter_panggil/src/pages/master/pegawai_page.dart';
import 'package:dokter_panggil/src/repositories/responseApi/api_response.dart';
import 'package:dokter_panggil/src/source/config.dart';
import 'package:dokter_panggil/src/source/transition/slide_bottom_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class KunjunganPage extends StatefulWidget {
  const KunjunganPage({Key? key}) : super(key: key);

  @override
  State<KunjunganPage> createState() => _KunjunganPageState();
}

class _KunjunganPageState extends State<KunjunganPage> {
  final _controller = ScrollController();
  final KunjunganPasienAllBloc _kunjunganPasienAllBloc =
      KunjunganPasienAllBloc();
  KunjunganPasienAllModel? _kunjungan;

  @override
  void initState() {
    super.initState();
    _kunjunganPasienAllBloc.getPageKunjungan();
    _controller.addListener(_scrollListen);
  }

  void _scrollListen() {
    if (_controller.position.pixels == _controller.position.maxScrollExtent) {
      _kunjunganPasienAllBloc.getNextKunjungan();
    }
  }

  @override
  void dispose() {
    _controller.removeListener(_scrollListen);
    _kunjunganPasienAllBloc.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: const SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarBrightness: Brightness.dark,
        statusBarIconBrightness: Brightness.light,
      ),
      child: Scaffold(
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Header(
              title: 'Kunjungan Pasien',
              subtitle: SearchInputForm(
                isReadOnly: true,
                hint: 'Pencarian pegawai',
                onTap: () => Navigator.push(
                  context,
                  SlideBottomRoute(
                    page: const PencarianPegawai(),
                  ),
                ),
              ),
              closeButton: const ClosedButton(),
            ),
            Expanded(
              child: _streamKunjunganPasien(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _streamKunjunganPasien() {
    return StreamBuilder<ApiResponse<KunjunganPasienAllModel>>(
      stream: _kunjunganPasienAllBloc.kunjunganPasienAllStream,
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
                  setState(() {});
                },
              );
            case Status.completed:
              _kunjungan = snapshot.data!.data;
              return ListKunjunganAll(
                controller: _controller,
                data: _kunjungan!,
              );
          }
        }
        return const SizedBox();
      },
    );
  }
}

class ListKunjunganAll extends StatefulWidget {
  const ListKunjunganAll({
    Key? key,
    required this.controller,
    required this.data,
  }) : super(key: key);

  final ScrollController controller;
  final KunjunganPasienAllModel data;

  @override
  State<ListKunjunganAll> createState() => _ListKunjunganAllState();
}

class _ListKunjunganAllState extends State<ListKunjunganAll>
    with AutomaticKeepAliveClientMixin {
  final _filter = TextEditingController();
  List<Kunjungan> _data = [];
  @override
  void initState() {
    super.initState();
    _data = widget.data.data!;
  }

  @override
  void dispose() {
    _filter.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return _listKunjungan();
  }

  Widget _listKunjungan() {
    return ListView.separated(
      controller: widget.controller,
      padding: const EdgeInsets.symmetric(horizontal: 18.0, vertical: 22.0),
      itemBuilder: (context, i) {
        if (i == _data.length) {
          return const SizedBox(
            height: 40,
            child: Center(
              child: CircularProgressIndicator(),
            ),
          );
        }
        var kunjungan = _data[i];
        return CardKunjunganPasien(
          kunjungan: kunjungan,
          reload: (Kunjungan data) {
            setState(() {
              _data.removeWhere((e) => e.id == data.id);
            });
          },
        );
      },
      separatorBuilder: (context, i) => const SizedBox(height: 15.0),
      itemCount: widget.data.currentPage != widget.data.totalPage
          ? _data.length + 1
          : _data.length,
    );
  }

  @override
  bool get wantKeepAlive => true;
}
