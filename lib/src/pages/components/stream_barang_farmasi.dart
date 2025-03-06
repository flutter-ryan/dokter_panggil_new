import 'dart:async';

import 'package:dokter_panggil/src/blocs/master_farmasi_paginate_bloc.dart';
import 'package:dokter_panggil/src/blocs/master_farmasi_pencarian_bloc.dart';
import 'package:dokter_panggil/src/blocs/master_mitra_apotek_bloc.dart';
import 'package:dokter_panggil/src/models/master_farmasi_paginate_model.dart';
import 'package:dokter_panggil/src/models/master_mitra_apotek_model.dart';
import 'package:dokter_panggil/src/pages/components/close_button_widget.dart';
import 'package:dokter_panggil/src/pages/components/error_response.dart';
import 'package:dokter_panggil/src/pages/components/loading_kit.dart';
import 'package:dokter_panggil/src/pages/components/search_input_form.dart';
import 'package:dokter_panggil/src/repositories/responseApi/api_response.dart';
import 'package:dokter_panggil/src/source/config.dart';
import 'package:dokter_panggil/src/source/size_config.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';

class StreamBarangFarmasi extends StatefulWidget {
  const StreamBarangFarmasi({
    super.key,
  });

  @override
  State<StreamBarangFarmasi> createState() => _StreamBarangFarmasiState();
}

class _StreamBarangFarmasiState extends State<StreamBarangFarmasi> {
  final _masterMitraApotekBLoc = MasterMitraApotekBloc();

  @override
  void initState() {
    super.initState();
    _masterMitraApotekBLoc.getMitraApotek();
  }

  @override
  void dispose() {
    _masterMitraApotekBLoc.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return SizedBox(
      height: SizeConfig.blockSizeVertical * 90,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 18.0, vertical: 25.0),
            child: Row(
              children: [
                Expanded(
                  child: Text(
                    'Daftar Obat/Barang Mitra',
                    style:
                        TextStyle(fontSize: 18.0, fontWeight: FontWeight.w600),
                  ),
                ),
                CloseButtonWidget()
              ],
            ),
          ),
          Expanded(
            child: _streamMitraApotek(context),
          ),
        ],
      ),
    );
  }

  Widget _streamMitraApotek(BuildContext context) {
    return StreamBuilder<ApiResponse<MasterMitraApotekModel>>(
      stream: _masterMitraApotekBLoc.masterMitraApotekStream,
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
              var data = snapshot.data!.data!.mitraApotek;
              return DefaultTabController(
                length: data!.length,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    TabBar(
                      labelColor: Colors.black,
                      unselectedLabelColor: Colors.grey[400],
                      isScrollable: true,
                      indicatorColor: kPrimaryColor,
                      tabs: data
                          .map(
                            (mitra) => Tab(
                              text: '${mitra.namaMitra}',
                            ),
                          )
                          .toList(),
                    ),
                    const Divider(
                      height: 0,
                    ),
                    const SizedBox(
                      height: 22.0,
                    ),
                    Expanded(
                      child: TabBarView(
                        children: data
                            .map(
                              (mitra) => BarangFarmasiWidget(
                                idMitra: mitra.id,
                              ),
                            )
                            .toList(),
                      ),
                    ),
                  ],
                ),
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

class BarangFarmasiWidget extends StatefulWidget {
  const BarangFarmasiWidget({
    super.key,
    this.idMitra,
  });

  final int? idMitra;

  @override
  State<BarangFarmasiWidget> createState() => _BarangFarmasiWidgetState();
}

class _BarangFarmasiWidgetState extends State<BarangFarmasiWidget> {
  final _masterFarmasiPencarianBloc = MasterFarmasiPencarianBloc();
  final _masterFarmasiBloc = MasterFarmasiPaginateBloc();
  final _filter = TextEditingController();
  bool _isFilter = false;
  String? _prevFilter;
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _masterFarmasiBloc.idMitraSink.add(widget.idMitra!);
    _masterFarmasiBloc.getMasterFarmasiPaginate();
    _filter.addListener(_filterListener);
  }

  void _filterListener() {
    _timer?.cancel();
    if (_filter.text.isNotEmpty) {
      if (_prevFilter != _filter.text) {
        _timer = Timer.periodic(const Duration(milliseconds: 700), (timer) {
          _masterFarmasiPencarianBloc.namaBarangSink.add(_filter.text);
          _masterFarmasiPencarianBloc.getPencarianMasterFarmasi();
          setState(() {
            _isFilter = true;
            _prevFilter = _filter.text;
          });
          timer.cancel();
        });
      }
    } else {
      _timer = Timer.periodic(const Duration(milliseconds: 700), (timer) {
        _masterFarmasiBloc.getMasterFarmasiPaginate();
        setState(() {
          _isFilter = false;
          _prevFilter = null;
        });
        timer.cancel();
      });
    }
  }

  @override
  void dispose() {
    _masterFarmasiBloc.dispose();
    _masterFarmasiPencarianBloc.dispose();
    _filter.dispose();
    _filter.removeListener(_filterListener);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
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
        if (!_isFilter)
          Expanded(
            child: _streamBarangFarmasi(context),
          )
        else
          Expanded(
            child: _streamPencarianFarmasi(context),
          ),
      ],
    );
  }

  Widget _streamBarangFarmasi(BuildContext context) {
    return StreamBuilder<ApiResponse<MasterFarmasiPaginateModel>>(
      stream: _masterFarmasiBloc.masterFarmasiPaginateStream,
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
              return ListObat(
                data: snapshot.data!.data,
                bloc: _masterFarmasiBloc,
              );
          }
        }
        return const SizedBox(
          height: 180,
        );
      },
    );
  }

  Widget _streamPencarianFarmasi(BuildContext context) {
    return StreamBuilder<ApiResponse<MasterFarmasiPaginateModel>>(
      stream: _masterFarmasiPencarianBloc.pencarianMasterFarmasiStream,
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
              return ListObat(
                data: snapshot.data!.data,
                blocSearch: _masterFarmasiPencarianBloc,
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

class ListObat extends StatefulWidget {
  const ListObat({
    super.key,
    this.data,
    this.bloc,
    this.blocSearch,
  });

  final MasterFarmasiPaginateModel? data;
  final MasterFarmasiPaginateBloc? bloc;
  final MasterFarmasiPencarianBloc? blocSearch;

  @override
  State<ListObat> createState() => _ListObatState();
}

class _ListObatState extends State<ListObat> {
  final ScrollController _scrollController = ScrollController();
  List<BarangFarmasi>? _data;
  final List<BarangFarmasi> _selectedData = [];
  final _numberFormat =
      NumberFormat.currency(locale: 'id', symbol: 'Rp. ', decimalDigits: 0);

  @override
  void initState() {
    super.initState();
    _data = widget.data!.barangFarmasi!;
    _scrollController.addListener(_scrollListen);
  }

  void _scrollListen() {
    if (_scrollController.position.pixels ==
        _scrollController.position.maxScrollExtent) {
      if (widget.blocSearch != null) {
        widget.blocSearch!.getPencarianMasterFarmasiNextPage();
      } else {
        widget.bloc!.getMasterFarmasiNextPage();
      }
    }
  }

  void _selectData(BarangFarmasi data) {
    if (_selectedData.where((e) => e.id == data.id).isEmpty) {
      setState(() {
        _selectedData.add(data);
      });
    } else {
      setState(() {
        _selectedData.removeWhere((e) => e.id == data.id);
      });
    }
  }

  Future<void> _finalSelected() async {
    SystemChannels.textInput.invokeMethod('TextInput.hide');
    if (MediaQuery.of(context).viewInsets.bottom > 0.0) {
      await Future.delayed(
        const Duration(milliseconds: 700),
      );
    }
    if (!mounted) return;
    Navigator.pop(context, _selectedData);
  }

  @override
  void dispose() {
    _scrollController.removeListener(_scrollListen);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
          child: ListView.separated(
            keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
            padding: const EdgeInsets.symmetric(vertical: 22.0),
            controller: _scrollController,
            itemBuilder: (context, i) {
              if (i == _data!.length) {
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
              var data = _data![i];
              return ListTile(
                onTap: () => _selectData(data),
                contentPadding: const EdgeInsets.symmetric(horizontal: 25.0),
                title: Text('${data.namaBarang}'),
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(_numberFormat.format(data.hargaJual)),
                    SizedBox(
                      width: 8,
                    ),
                    SizedBox(
                      width: 22,
                      child:
                          _selectedData.where((e) => e.id == data.id).isNotEmpty
                              ? const Icon(
                                  Icons.check_circle_outline_rounded,
                                  color: Colors.green,
                                )
                              : null,
                    ),
                  ],
                ),
                subtitle: data.mitraFarmasi != null
                    ? Text('${data.mitraFarmasi?.namaMitra}')
                    : const Text('Unknown'),
              );
            },
            separatorBuilder: (context, i) => const Divider(
              height: 0,
            ),
            itemCount: widget.data!.totalPage != widget.data!.currentPage
                ? _data!.length + 1
                : _data!.length,
          ),
        ),
        Container(
          padding: const EdgeInsets.all(18.0),
          decoration: const BoxDecoration(
            color: Colors.white,
            boxShadow: [
              BoxShadow(
                  color: Colors.black12,
                  blurRadius: 6,
                  offset: Offset(0.0, -2.0))
            ],
          ),
          child: SafeArea(
            top: false,
            child: ElevatedButton(
              onPressed: _selectedData.isEmpty ? null : _finalSelected,
              style: ElevatedButton.styleFrom(
                  minimumSize: const Size(double.infinity, 42.0)),
              child: _selectedData.isEmpty
                  ? const Text('PILIH BARANG')
                  : Text('PILIH BARANG (${_selectedData.length} barang)'),
            ),
          ),
        ),
      ],
    );
  }
}
