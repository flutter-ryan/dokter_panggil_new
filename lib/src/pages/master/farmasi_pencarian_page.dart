import 'dart:io';

import 'package:admin_dokter_panggil/src/blocs/barang_farmasi_filter_bloc.dart';
import 'package:admin_dokter_panggil/src/blocs/master_farmasi_paginate_bloc.dart';
import 'package:admin_dokter_panggil/src/models/barang_farmasi_filter_model.dart';
import 'package:admin_dokter_panggil/src/models/master_farmasi_paginate_model.dart';
import 'package:admin_dokter_panggil/src/pages/components/error_response.dart';
import 'package:admin_dokter_panggil/src/pages/components/loading_kit.dart';
import 'package:admin_dokter_panggil/src/pages/components/search_input_form.dart';
import 'package:admin_dokter_panggil/src/pages/master/list_barang_farmasi.dart';
import 'package:admin_dokter_panggil/src/repositories/responseApi/api_response.dart';
import 'package:admin_dokter_panggil/src/source/config.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class FarmasiPencarianPage extends StatefulWidget {
  const FarmasiPencarianPage({super.key});

  @override
  State<FarmasiPencarianPage> createState() => _FarmasiPencarianPageState();
}

class _FarmasiPencarianPageState extends State<FarmasiPencarianPage> {
  final MasterFarmasiPaginateBloc _farmasiPaginateBloc =
      MasterFarmasiPaginateBloc();
  final BarangFarmasiFilterBloc _barangFarmasiFilterBloc =
      BarangFarmasiFilterBloc();
  final _filterCon = TextEditingController();
  final _filterFocus = FocusNode();
  bool _isStream = false;
  bool _isSearch = false;

  @override
  void initState() {
    super.initState();
    _getFarmasi();
    _filterCon.addListener(_inputListener);
  }

  void _getFarmasi() {
    _farmasiPaginateBloc.getMasterFarmasiPaginate();
  }

  void _inputListener() {
    if (_filterCon.text.isNotEmpty) {
      _barangFarmasiFilterBloc.filterSink.add(_filterCon.text);
      _barangFarmasiFilterBloc.filterBarangFarmasi();
      setState(() {
        _isStream = true;
        _isSearch = true;
      });
    } else {
      setState(() {
        _isStream = false;
        _isSearch = false;
      });
    }
  }

  @override
  void dispose() {
    _farmasiPaginateBloc.dispose();
    _filterCon.dispose();
    _filterFocus.dispose();
    _filterCon.removeListener(_inputListener);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: const SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarBrightness: Brightness.light,
        statusBarIconBrightness: Brightness.dark,
      ),
      child: Scaffold(
        body: _streamBarangFarmasi(context),
      ),
    );
  }

  Widget _streamSearchBarangFarmasi(BuildContext context) {
    return StreamBuilder<ApiResponse<ResponseBarangFarmasiFilterModel>>(
      stream: _barangFarmasiFilterBloc.barangFarmasiStream,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          switch (snapshot.data!.status) {
            case Status.loading:
              return const Center(
                child: LoadingKit(
                  color: kPrimaryColor,
                ),
              );
            case Status.error:
              return Center(
                child: ErrorResponse(
                  message: snapshot.data!.message,
                  onTap: () => setState(() {
                    _getFarmasi();
                    _filterCon.clear();
                    setState(() {});
                  }),
                ),
              );
            case Status.completed:
              return ListView.separated(
                itemBuilder: (context, i) {
                  var data = snapshot.data!.data!.barang![i];
                  return ListTile(
                    onTap: () => Navigator.pop(context, data),
                    contentPadding: const EdgeInsets.symmetric(
                        vertical: 8.0, horizontal: 22.0),
                    dense: true,
                    title: data.mitraFarmasi == null
                        ? Text('${data.namaBarang}')
                        : Text(
                            '${data.namaBarang} - ${data.mitraFarmasi!.namaMitra}',
                          ),
                  );
                },
                separatorBuilder: (context, i) => const Divider(
                  height: 0,
                ),
                itemCount: snapshot.data!.data!.barang!.length,
              );
          }
        }
        return const SizedBox();
      },
    );
  }

  Widget _streamBarangFarmasi(BuildContext context) {
    return StreamBuilder<ApiResponse<MasterFarmasiPaginateModel>>(
      stream: _farmasiPaginateBloc.masterFarmasiPaginateStream,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          switch (snapshot.data!.status) {
            case Status.loading:
              return const Center(
                child: LoadingKit(
                  color: kPrimaryColor,
                ),
              );
            case Status.error:
              return Center(
                child: ErrorResponse(
                  message: snapshot.data!.message,
                  onTap: () => setState(() {
                    _getFarmasi();
                    setState(() {});
                  }),
                ),
              );
            case Status.completed:
              return Column(
                children: [
                  Padding(
                    padding: EdgeInsets.only(
                      left: 2.0,
                      right: 32.0,
                      top: MediaQuery.of(context).padding.top + 18,
                    ),
                    child: Row(
                      children: [
                        if (Platform.isAndroid)
                          IconButton(
                            onPressed: () => Navigator.pop(context),
                            icon: Icon(
                              Icons.arrow_back,
                              color: Colors.grey[600],
                            ),
                          )
                        else
                          IconButton(
                            onPressed: () => Navigator.pop(context),
                            icon: Icon(
                              Icons.arrow_back_ios,
                              color: Colors.grey[600],
                            ),
                          ),
                        const SizedBox(
                          width: 4.0,
                        ),
                        Expanded(
                          child: SearchInputForm(
                            controller: _filterCon,
                            focusNode: _filterFocus,
                            hint: 'Pencarian obat/barang',
                            autofocus: true,
                            suffixIcon: _isStream
                                ? InkWell(
                                    onTap: () {
                                      _filterFocus.requestFocus(FocusNode());
                                      setState(() {
                                        _filterCon.clear();
                                        _isStream = false;
                                      });
                                    },
                                    child: FaIcon(
                                      FontAwesomeIcons.circleXmark,
                                      size: 20,
                                      color: Colors.grey[600],
                                    ),
                                  )
                                : null,
                          ),
                        ),
                      ],
                    ),
                  ),
                  if (_isSearch)
                    Expanded(
                      child: _streamSearchBarangFarmasi(context),
                    )
                  else
                    Expanded(
                      child: ListBarangFarmasi(
                        data: snapshot.data!.data,
                        bloc: _farmasiPaginateBloc,
                      ),
                    ),
                ],
              );
          }
        }
        return const SizedBox();
      },
    );
  }
}
