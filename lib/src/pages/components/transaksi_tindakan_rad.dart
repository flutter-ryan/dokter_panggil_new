import 'dart:async';

import 'package:admin_dokter_panggil/src/blocs/master_tindakan_rad_cari_bloc.dart';
import 'package:admin_dokter_panggil/src/blocs/tagihan_tindakan_rad_save_bloc.dart';
import 'package:admin_dokter_panggil/src/models/master_tindakan_rad_cari_modal.dart';
import 'package:admin_dokter_panggil/src/models/master_tindakan_rad_create_mode.dart';
import 'package:admin_dokter_panggil/src/models/pasien_kunjungan_detail_model.dart';
import 'package:admin_dokter_panggil/src/models/tagihan_tindakan_rad_save_model.dart';
import 'package:admin_dokter_panggil/src/pages/components/button_rounded_widget.dart';
import 'package:admin_dokter_panggil/src/pages/components/close_button_widget.dart';
import 'package:admin_dokter_panggil/src/pages/components/error_response.dart';
import 'package:admin_dokter_panggil/src/pages/components/error_dialog.dart';
import 'package:admin_dokter_panggil/src/pages/components/loading_kit.dart';
import 'package:admin_dokter_panggil/src/pages/components/search_input_form.dart';
import 'package:admin_dokter_panggil/src/pages/components/success_dialog.dart';
import 'package:admin_dokter_panggil/src/repositories/responseApi/api_response.dart';
import 'package:admin_dokter_panggil/src/source/color_style.dart';
import 'package:admin_dokter_panggil/src/source/size_config.dart';
import 'package:flutter/material.dart';
import 'package:admin_dokter_panggil/src/source/transition/animated_dialog.dart';
import 'package:intl/intl.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';

class TransaksiTindakanRad extends StatefulWidget {
  const TransaksiTindakanRad({
    super.key,
    required this.idKunjungan,
    this.idPengantar,
    required this.dataRad,
  });

  final int idKunjungan;
  final List<TindakanRad> dataRad;
  final int? idPengantar;

  @override
  State<TransaksiTindakanRad> createState() => _TransaksiTindakanRadState();
}

class _TransaksiTindakanRadState extends State<TransaksiTindakanRad> {
  final _filter = TextEditingController();
  final _tagihanTindakanRadSaveBloc = TagihanTindakanRadSaveBloc();
  final _masterTindakanRadBloc = MasterTindakanRadCariBloc();
  final _rupiah =
      NumberFormat.currency(locale: 'id', symbol: 'Rp. ', decimalDigits: 0);
  List<TindakanRad> _data = [];
  final List<MasterTindakanRad> _selectedData = [];
  List<MasterTindakanRad> _finalSelectedData = [];
  Timer? _timer;
  bool _isFilterempty = true;

  @override
  void initState() {
    super.initState();
    _data = widget.dataRad;
  }

  void _filterListen() {
    _timer?.cancel();
    if (_filter.text.isEmpty) {
      _filterTindakanRad();
    } else if (_filter.text.length > 2) {
      _timer = Timer.periodic(const Duration(milliseconds: 700), (timer) {
        _filterTindakanRad();
        timer.cancel();
      });
    }
  }

  void _filterTindakanRad() {
    _masterTindakanRadBloc.filterSink.add(_filter.text);
    _masterTindakanRadBloc.filterTindakanRadLayanan();
  }

  void _listTindakanRad() {
    _masterTindakanRadBloc.cariTindakanRad();
    _filter.addListener(_filterListen);
    showMaterialModalBottomSheet(
      context: context,
      isDismissible: false,
      backgroundColor: Colors.transparent,
      builder: (context) {
        return SafeArea(
          bottom: false,
          child: _streamListTindakanRad(context),
        );
      },
    ).then((value) {
      if (value != null) {
        setState(() {
          _finalSelectedData = _selectedData;
        });
      }
      _filter.removeListener(_filterListen);
      _filter.clear();
    });
  }

  void _detail() {
    showBarModalBottomSheet(
      context: context,
      builder: (context) {
        return _detailTindakanRad(context);
      },
      duration: const Duration(milliseconds: 500),
    );
  }

  void _simpan() {
    if (_selectedData.isNotEmpty) {
      List<TindakanRadRequest> tindakanRads = [];
      for (final tindakanRad in _finalSelectedData) {
        tindakanRads.add(
          TindakanRadRequest(
              id: tindakanRad.id!,
              hargaModal: tindakanRad.hargaModal!,
              tarifAplikasi: tindakanRad.tarifAplikasi!),
        );
      }
      _tagihanTindakanRadSaveBloc.idPengantarSink.add(widget.idPengantar!);
      _tagihanTindakanRadSaveBloc.tindakanRadSink.add(tindakanRads);
      _tagihanTindakanRadSaveBloc.saveTagihanTindakanRad();
      _showStreamSimpanTransaksi();
    }
  }

  void _showStreamSimpanTransaksi() {
    showAnimatedDialog(
      context: context,
      builder: (context) {
        return _streamSimpanTransaksi(context);
      },
      animationType: DialogTransitionType.slideFromBottomFade,
    ).then((value) {
      if (value != null) {
        var data = value as DetailKunjungan;
        Future.delayed(const Duration(milliseconds: 500), () {
          if (!mounted) return;
          Navigator.pop(context, data);
        });
      }
    });
  }

  void _selectTindakanRad(MasterTindakanRad tindakan, StateSetter setState) {
    if (_selectedData.where((selected) => selected.id == tindakan.id).isEmpty) {
      setState(() {
        _selectedData.add(tindakan);
      });
    } else {
      setState(() {
        _selectedData.removeWhere((selected) => selected.id == tindakan.id);
      });
    }
  }

  @override
  void dispose() {
    _masterTindakanRadBloc.dispose();
    _tagihanTindakanRadSaveBloc.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text('Transaksi Radiologi'),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 0,
        actions: [
          IconButton(
            onPressed: _detail,
            icon: const Icon(
              Icons.info_outline_rounded,
              color: kPrimaryColor,
            ),
          ),
        ],
      ),
      body: _formTransaksiRad(context),
    );
  }

  Widget _formTransaksiRad(BuildContext context) {
    return Column(
      children: [
        if (_selectedData.isEmpty)
          const Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.warning_amber_rounded,
                  color: Colors.red,
                  size: 52.0,
                ),
                SizedBox(
                  height: 12.0,
                ),
                Text(
                  'Data tindakan radiologi tidak tersedia',
                  style: TextStyle(fontSize: 16.0, color: Colors.grey),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          )
        else
          _formTransaksiTindakanRad(context),
        Divider(
          color: Colors.grey[400],
          height: 0,
        ),
        Padding(
          padding: const EdgeInsets.all(18.0),
          child: Row(
            children: [
              CircleAvatar(
                radius: 26,
                backgroundColor: Colors.grey[200],
                child: IconButton(
                  onPressed: _listTindakanRad,
                  iconSize: 28,
                  color: Colors.blueAccent,
                  icon: Icon(Icons.add_rounded),
                ),
              ),
              const SizedBox(
                width: 15.0,
              ),
              Expanded(
                child: ElevatedButton(
                  onPressed: _finalSelectedData.isEmpty ? null : _simpan,
                  style: ElevatedButton.styleFrom(
                      minimumSize: const Size(0.0, 48.0),
                      backgroundColor: kPrimaryColor,
                      disabledForegroundColor: Colors.grey[400],
                      disabledBackgroundColor: Colors.grey[200],
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(32),
                      )),
                  child: const Text('SIMPAN TRANSAKSI'),
                ),
              ),
            ],
          ),
        ),
        SizedBox(
          height: MediaQuery.of(context).padding.bottom,
        )
      ],
    );
  }

  Widget _streamListTindakanRad(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(22),
          topRight: Radius.circular(22),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: EdgeInsets.fromLTRB(18, 28, 18, 8),
            child: Row(
              children: [
                Expanded(
                  child: Text(
                    'List Tindakan Radiologi',
                    style:
                        TextStyle(fontSize: 16.0, fontWeight: FontWeight.w600),
                  ),
                ),
                CloseButtonWidget(),
              ],
            ),
          ),
          Expanded(
            child: StatefulBuilder(
              builder: (context, state) {
                return Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.fromLTRB(18.0, 18.0, 18.0, 0),
                      child: SearchInputForm(
                        controller: _filter,
                        hint: 'Ketikkan nama tindakan',
                        autocorrect: false,
                        clearButton: !_isFilterempty ? true : false,
                        onClear: () {
                          state(() {
                            _filter.clear();
                            _isFilterempty = true;
                          });
                        },
                        onChanged: (val) {
                          if (val.isNotEmpty) {
                            state(() {
                              _isFilterempty = false;
                            });
                          }
                        },
                      ),
                    ),
                    Expanded(child: _streamTindakanRad(context, state)),
                  ],
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _streamTindakanRad(BuildContext context, StateSetter setState) {
    return StreamBuilder<ApiResponse<ResponseMasterTindakanRadCariModel>>(
      stream: _masterTindakanRadBloc.masterTindakanRadCariStream,
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
              return ErrorResponse(
                message: snapshot.data!.message,
                button: true,
                onTap: () => Navigator.pop(context),
              );
            case Status.completed:
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: ListView.separated(
                      keyboardDismissBehavior:
                          ScrollViewKeyboardDismissBehavior.onDrag,
                      padding: EdgeInsets.fromLTRB(
                          18, 22, 18, MediaQuery.of(context).viewInsets.bottom),
                      itemBuilder: (context, i) {
                        final tindakan = snapshot.data!.data!.data![i];
                        return ListTile(
                          onTap: () => _selectTindakanRad(tindakan, setState),
                          title: Text('${tindakan.namaTindakan}'),
                          contentPadding: EdgeInsets.zero,
                          subtitle: Text(_rupiah.format(tindakan.hargaJual)),
                          trailing: _selectedData
                                  .where(
                                      (selected) => selected.id == tindakan.id)
                                  .isEmpty
                              ? null
                              : Icon(
                                  Icons.check_circle_outline_rounded,
                                  color: Colors.green,
                                ),
                        );
                      },
                      separatorBuilder: (context, i) => Divider(
                        height: 8,
                        color: Colors.grey[400],
                      ),
                      itemCount: snapshot.data!.data!.data!.length,
                    ),
                  ),
                  Divider(
                    color: Colors.grey[400],
                  ),
                  Container(
                    padding: EdgeInsets.all(18),
                    child: ButtonRoundedWidget(
                      onPressed: _selectedData.isEmpty
                          ? null
                          : () => Navigator.pop(context, 'confirm'),
                      label: 'Konfirmasi ${_selectedData.length} tindakan',
                      backgroundColor: kSecondaryColor,
                      foregroundColor: Colors.white,
                    ),
                  )
                ],
              );
          }
        }
        return const SizedBox();
      },
    );
  }

  Widget _detailTindakanRad(BuildContext context) {
    return Container(
      constraints: BoxConstraints(
        minHeight: SizeConfig.blockSizeVertical * 20,
        maxHeight: SizeConfig.blockSizeVertical * 70,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Padding(
            padding: EdgeInsets.all(22.0),
            child: Text(
              'List Tindakan Radiologi',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
            ),
          ),
          Flexible(
            child: ListView.separated(
              padding: const EdgeInsets.only(bottom: 22.0),
              shrinkWrap: true,
              itemBuilder: (context, i) {
                var data = _data[i];
                return ListTile(
                  contentPadding: const EdgeInsets.symmetric(horizontal: 22.0),
                  title: Text('${data.tindakanRad}'),
                );
              },
              itemCount: _data.length,
              separatorBuilder: (context, i) => const Divider(
                height: 0.0,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _formTransaksiTindakanRad(BuildContext context) {
    return Expanded(
      child: ListView.separated(
        padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 18.0),
        itemBuilder: (context, i) {
          var data = _finalSelectedData[i];
          return ListTile(
            title: Text('${data.namaTindakan}'),
            subtitle: Text(_rupiah.format(data.hargaJual)),
            trailing: IconButton(
              onPressed: () {
                setState(() {
                  _finalSelectedData
                      .removeWhere((selected) => selected.id == data.id);
                });
              },
              color: kPrimaryColor,
              icon: Icon(Icons.delete_outline_outlined),
            ),
          );
        },
        itemCount: _finalSelectedData.length,
        separatorBuilder: (context, i) => const Divider(
          height: 0.0,
        ),
      ),
    );
  }

  Widget _streamSimpanTransaksi(BuildContext context) {
    return StreamBuilder<ApiResponse<TagihanTindakanRadSaveModel>>(
        stream: _tagihanTindakanRadSaveBloc.tagihanTindakanRadStream,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            switch (snapshot.data!.status) {
              case Status.loading:
                return const LoadingKit();
              case Status.error:
                return ErrorDialog(
                  message: snapshot.data!.message,
                );
              case Status.completed:
                return SuccessDialog(
                  message: snapshot.data!.data!.message,
                  onTap: () =>
                      Navigator.pop(context, snapshot.data!.data!.data),
                );
            }
          }
          return const SizedBox();
        });
  }
}
