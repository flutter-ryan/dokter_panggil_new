import 'dart:async';

import 'package:dokter_panggil/src/blocs/mr_pencarian_barang_farmasi_bloc.dart';
import 'package:dokter_panggil/src/models/mr_pencarian_barang_farmasi_model.dart';
import 'package:dokter_panggil/src/pages/components/error_response.dart';
import 'package:dokter_panggil/src/pages/components/loading_kit.dart';
import 'package:dokter_panggil/src/pages/components/search_input_form.dart';
import 'package:dokter_panggil/src/repositories/responseApi/api_response.dart';
import 'package:dokter_panggil/src/source/config.dart';
import 'package:dokter_panggil/src/source/size_config.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class MrPencarianBarangFarmasi extends StatefulWidget {
  const MrPencarianBarangFarmasi({
    super.key,
    this.selectedData,
  });

  final List<MrBarangFarmasi>? selectedData;

  @override
  State<MrPencarianBarangFarmasi> createState() =>
      _MrPencarianBarangFarmasiState();
}

class _MrPencarianBarangFarmasiState extends State<MrPencarianBarangFarmasi> {
  final _mrPencarianBarangFarmasiBloc = MrPencarianBarangFarmasiBloc();
  final _filter = TextEditingController();
  final _scrollController = ScrollController();
  final _numberFormat =
      NumberFormat.currency(locale: 'id', decimalDigits: 0, symbol: 'Rp. ');
  List<MrBarangFarmasi> _selectedBarang = [];
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _selectedBarang = [];
    _mrPencarianBarangFarmasiBloc.pencarianBarangFarmasi();
    _scrollController.addListener(_scrollListen);
    _filter.addListener(_filterListen);
  }

  void _scrollListen() {
    if (_scrollController.position.pixels ==
        _scrollController.position.maxScrollExtent) {
      _mrPencarianBarangFarmasiBloc.filterSink.add(_filter.text);
      _mrPencarianBarangFarmasiBloc.nextPage();
    }
  }

  void _filterListen() {
    _timer?.cancel();
    if (_filter.text.length > 2) {
      _timer = Timer.periodic(const Duration(milliseconds: 700), (timer) {
        _mrPencarianBarangFarmasiBloc.filterSink.add(_filter.text);
        _mrPencarianBarangFarmasiBloc.pencarianBarangFarmasi();
        timer.cancel();
        setState(() {});
      });
    } else if (_filter.text.isEmpty) {
      _mrPencarianBarangFarmasiBloc.filterSink.add('');
      _mrPencarianBarangFarmasiBloc.pencarianBarangFarmasi();
      _timer?.cancel();
      setState(() {});
    } else {
      _timer?.cancel();
    }
  }

  void _selectBarang(MrBarangFarmasi? barang) {
    if (_selectedBarang
        .where((selected) => selected.id == barang!.id)
        .isEmpty) {
      setState(() {
        _selectedBarang.add(barang!);
      });
    } else {
      setState(() {
        _selectedBarang.removeWhere((selected) => selected.id == barang!.id);
      });
    }
  }

  @override
  void dispose() {
    super.dispose();
    _mrPencarianBarangFarmasiBloc.dispose();
    _filter.removeListener(_filterListen);
    _scrollController.removeListener(_scrollListen);
    _scrollController.dispose();
    _filter.dispose();
  }

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return SizedBox(
      height: SizeConfig.blockSizeVertical * 90,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: EdgeInsets.all(18.0),
            child: Row(
              children: [
                Expanded(
                  child: Text(
                    'Daftar Obat/Barang Mitra',
                    style:
                        TextStyle(fontSize: 18.0, fontWeight: FontWeight.w600),
                  ),
                ),
                CloseButton(
                  onPressed: () => Navigator.pop(context),
                  color: Colors.grey[400],
                )
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 18.0, right: 18.0),
            child: SearchInputForm(
              controller: _filter,
              hint: "Pencarian nama barang/obat",
              suffixIcon: _filter.text.isNotEmpty
                  ? InkWell(
                      onTap: () {
                        _filter.clear();
                      },
                      child: const Icon(
                        Icons.close_rounded,
                        color: Colors.grey,
                      ),
                    )
                  : null,
            ),
          ),
          Expanded(
            child: _streamMitraApotek(context),
          ),
          Divider(
            color: Colors.grey[400],
            height: 0,
          ),
          Container(
            padding: EdgeInsets.all(18),
            child: ElevatedButton(
              onPressed: _selectedBarang.isEmpty
                  ? null
                  : () => Navigator.pop(context, _selectedBarang),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(32),
                ),
                minimumSize: Size(double.infinity, 42),
              ),
              child: _selectedBarang.isEmpty
                  ? Text('Pilih Barang Farmasi')
                  : Text('Pilih ${_selectedBarang.length} Barang Farmasi'),
            ),
          ),
          SizedBox(
            height: MediaQuery.of(context).padding.bottom,
          )
        ],
      ),
    );
  }

  Widget _streamMitraApotek(BuildContext context) {
    return StreamBuilder<ApiResponse<MrPencarianBarangFarmasiModel>>(
      stream: _mrPencarianBarangFarmasiBloc.pencarianBarangFarmasiStream,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          switch (snapshot.data!.status) {
            case Status.loading:
              return const SizedBox(
                height: 180,
                child: Center(
                  child: LoadingKit(
                    color: kPrimaryColor,
                  ),
                ),
              );
            case Status.error:
              return SizedBox(
                width: double.infinity,
                child: ErrorResponse(
                  message: snapshot.data!.message,
                  button: false,
                ),
              );
            case Status.completed:
              final pageBarang = snapshot.data!.data;
              return ListView.separated(
                keyboardDismissBehavior:
                    ScrollViewKeyboardDismissBehavior.onDrag,
                padding:
                    const EdgeInsets.symmetric(vertical: 22.0, horizontal: 8),
                controller: _scrollController,
                itemBuilder: (context, i) {
                  if (i == pageBarang.data!.length) {
                    return const SizedBox(
                      height: 50,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          CircleAvatar(
                            radius: 12,
                            backgroundColor: Colors.transparent,
                            child: CircularProgressIndicator(),
                          ),
                          SizedBox(
                            width: 12,
                          ),
                          Text('Memuat...'),
                        ],
                      ),
                    );
                  }
                  var data = pageBarang.data![i];
                  return ListTile(
                    onTap: () => _selectBarang(data),
                    title: Text('${data.namaBarang}'),
                    visualDensity: VisualDensity.compact,
                    dense: true,
                    subtitle: Text('${data.mitra!.namaMitra}'),
                    trailing: SizedBox(
                      width: 120,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          Text(_numberFormat.format(data.hargaJual)),
                          if (_selectedBarang
                              .where((e) => e.id == data.id)
                              .isNotEmpty)
                            Padding(
                              padding: const EdgeInsets.only(left: 8.0),
                              child: const Icon(
                                Icons.check_circle_outline_rounded,
                                color: Colors.green,
                                size: 22,
                              ),
                            ),
                        ],
                      ),
                    ),
                  );
                },
                separatorBuilder: (context, i) => const Divider(
                  height: 0,
                ),
                itemCount: pageBarang!.totalPage != pageBarang.currentPage
                    ? pageBarang.data!.length + 1
                    : pageBarang.data!.length,
              );
          }
        }
        return const SizedBox(
          height: 180,
        );
      },
    );
  }
}
