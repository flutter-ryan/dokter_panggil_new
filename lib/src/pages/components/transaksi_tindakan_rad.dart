import 'package:admin_dokter_panggil/src/blocs/master_tindakan_lab_bloc.dart';
import 'package:admin_dokter_panggil/src/blocs/master_tindakan_rad_cari_bloc.dart';
import 'package:admin_dokter_panggil/src/blocs/tagihan_tindakan_rad_save_bloc.dart';
import 'package:admin_dokter_panggil/src/models/master_mitra_lab_model.dart';
import 'package:admin_dokter_panggil/src/models/master_tindakan_lab_model.dart';
import 'package:admin_dokter_panggil/src/models/master_tindakan_rad_cari_modal.dart';
import 'package:admin_dokter_panggil/src/models/master_tindakan_rad_create_mode.dart';
import 'package:admin_dokter_panggil/src/models/pasien_kunjungan_detail_model.dart';
import 'package:admin_dokter_panggil/src/models/tagihan_tindakan_rad_save_model.dart';
import 'package:admin_dokter_panggil/src/pages/components/error_response.dart';
import 'package:admin_dokter_panggil/src/pages/components/error_dialog.dart';
import 'package:admin_dokter_panggil/src/pages/components/loading_kit.dart';
import 'package:admin_dokter_panggil/src/pages/components/search_widget_page.dart';
import 'package:admin_dokter_panggil/src/pages/components/success_dialog.dart';
import 'package:admin_dokter_panggil/src/repositories/responseApi/api_response.dart';
import 'package:admin_dokter_panggil/src/source/config.dart';
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
  final _tagihanTindakanRadSaveBloc = TagihanTindakanRadSaveBloc();
  final _masterTindakanRadBloc = MasterTindakanRadCariBloc();
  final _rupiah =
      NumberFormat.currency(locale: 'id', symbol: 'Rp. ', decimalDigits: 0);
  List<TindakanRad> _data = [];
  final List<MasterTindakanRad> _selectedData = [];
  List<MasterTindakanRad> _finalSelectedData = [];

  @override
  void initState() {
    super.initState();
    _data = widget.dataRad;
  }

  void _listTindakanRad() {
    _masterTindakanRadBloc.cariTindakanRad();
    showBarModalBottomSheet(
      context: context,
      isDismissible: false,
      builder: (context) {
        return _streamListTindakanRad(context);
      },
    ).then((value) {
      if (value != null) {
        setState(() {
          _finalSelectedData = _selectedData;
        });
      }
    });
  }

  void _detail() {
    showBarModalBottomSheet(
      context: context,
      builder: (context) {
        return _detailTindakanLab(context);
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
    return SizedBox(
      height: SizeConfig.blockSizeVertical * 95,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 22.0, vertical: 12),
            child: Row(
              children: [
                Expanded(
                  child: Text(
                    'List Tindakan Radiologi',
                    style:
                        TextStyle(fontSize: 16.0, fontWeight: FontWeight.w600),
                  ),
                ),
                CloseButton(
                  onPressed: () => Navigator.pop(context),
                  color: Colors.grey,
                ),
              ],
            ),
          ),
          const Divider(
            height: 0.0,
            color: Colors.grey,
          ),
          Expanded(
            child: StatefulBuilder(
              builder: (context, state) => _streamTindakanRad(context, state),
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
                  Flexible(
                    child: ListView.separated(
                      padding:
                          EdgeInsets.symmetric(vertical: 18, horizontal: 22),
                      shrinkWrap: true,
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
                    child: ElevatedButton(
                      onPressed: () => Navigator.pop(context, 'confirm'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.green,
                        minimumSize: Size(double.infinity, 42),
                      ),
                      child: Text('Pilih Tindakan Radiologi'),
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

  Widget _detailTindakanLab(BuildContext context) {
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

class TabMitraTindakanLab extends StatefulWidget {
  const TabMitraTindakanLab({
    super.key,
    this.dataMitra,
    this.selectedData,
  });

  final List<MitraLab>? dataMitra;
  final List<MasterTindakanLab>? selectedData;

  @override
  State<TabMitraTindakanLab> createState() => _TabMitraTindakanLabState();
}

class _TabMitraTindakanLabState extends State<TabMitraTindakanLab> {
  List<MasterTindakanLab> _selectedData = [];

  @override
  void initState() {
    super.initState();
    _selectedData = widget.selectedData!;
  }

  void _selectData(MasterTindakanLab data) {
    if (_selectedData
        .where((tindakanLab) => tindakanLab.id == data.id)
        .isEmpty) {
      setState(() {
        _selectedData.add(data);
      });
    } else {
      setState(() {
        _selectedData.removeWhere((e) => e.id == data.id);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: widget.dataMitra!.length,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          TabBar(
            labelColor: Colors.black,
            unselectedLabelColor: Colors.grey,
            indicatorColor: kPrimaryColor,
            isScrollable: true,
            tabs: widget.dataMitra!
                .map(
                  (e) => Tab(
                    text: e.namaMitra,
                  ),
                )
                .toList(),
          ),
          Expanded(
            child: TabBarView(
              children: widget.dataMitra!
                  .map(
                    (mitra) => StreamListTindakanLab(
                      idMitra: mitra.id!,
                      selectedData: _selectedData,
                      selectData: (MasterTindakanLab data) => _selectData(data),
                    ),
                  )
                  .toList(),
            ),
          ),
          Container(
            width: double.infinity,
            padding:
                const EdgeInsets.symmetric(horizontal: 22.0, vertical: 18.0),
            decoration: BoxDecoration(
              border:
                  Border(top: BorderSide(color: Colors.grey[400]!, width: 0.5)),
              color: Colors.white,
            ),
            child: ElevatedButton(
              onPressed: () => Navigator.pop(context, _selectedData),
              style: ElevatedButton.styleFrom(
                minimumSize: const Size(double.infinity, 45.0),
                backgroundColor: kPrimaryColor,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(32),
                ),
              ),
              child: Text('Pilih (${_selectedData.length}) tindakan'),
            ),
          ),
        ],
      ),
    );
  }
}

class StreamListTindakanLab extends StatefulWidget {
  const StreamListTindakanLab({
    super.key,
    required this.idMitra,
    this.selectData,
    this.selectedData,
  });

  final int idMitra;
  final List<MasterTindakanLab>? selectedData;
  final Function(MasterTindakanLab data)? selectData;

  @override
  State<StreamListTindakanLab> createState() => _StreamListTindakanLabState();
}

class _StreamListTindakanLabState extends State<StreamListTindakanLab> {
  final _masterTindakanLabBloc = MasterTindakanLabBloc();
  List<MasterTindakanLab> _selectedData = [];

  @override
  void initState() {
    super.initState();
    _selectedData = widget.selectedData!;
    _masterTindakanLabBloc.idMitraSink.add(widget.idMitra);
    _masterTindakanLabBloc.getTindakanLab();
  }

  @override
  void dispose() {
    _masterTindakanLabBloc.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<ApiResponse<MasterTindakanLabModel>>(
      stream: _masterTindakanLabBloc.tindakanLabStream,
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
                button: true,
                onTap: () => Navigator.pop(context),
              );
            case Status.completed:
              return ListTindakanLab(
                data: snapshot.data!.data!.data,
                selectedData: _selectedData,
                selectData: (MasterTindakanLab data) =>
                    widget.selectData!(data),
              );
          }
        }
        return const SizedBox();
      },
    );
  }
}

class ListTindakanLab extends StatefulWidget {
  const ListTindakanLab({
    super.key,
    this.data,
    this.selectedData,
    this.selectData,
  });

  final List<MasterTindakanLab>? data;
  final List<MasterTindakanLab>? selectedData;
  final Function(MasterTindakanLab data)? selectData;

  @override
  State<ListTindakanLab> createState() => _ListTindakanLabState();
}

class _ListTindakanLabState extends State<ListTindakanLab> {
  final _rupiah =
      NumberFormat.currency(locale: 'id', symbol: 'Rp. ', decimalDigits: 0);
  List<MasterTindakanLab> _data = [];
  final _filter = TextEditingController();
  List<MasterTindakanLab> _selectedData = [];

  @override
  void initState() {
    super.initState();
    _data = widget.data!;
    _selectedData = widget.selectedData!;
    _filter.addListener(_filterListen);
  }

  void _filterListen() {
    if (_filter.text.isEmpty) {
      setState(() {
        _data = widget.data!;
      });
    } else {
      setState(() {
        _data = widget.data!
            .where((e) => e.namaTindakanLab!
                .toLowerCase()
                .contains(_filter.text.toLowerCase()))
            .toList();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SearchWidgetPage(filter: _filter, hint: 'Pencarian Tindakan Lab'),
        Expanded(
          child: ListView.separated(
            padding: const EdgeInsets.symmetric(vertical: 18.0),
            itemBuilder: (context, i) {
              var data = _data[i];
              return ListTile(
                onTap: () => widget.selectData!(data),
                contentPadding: const EdgeInsets.symmetric(horizontal: 22.0),
                title: Text('${data.namaTindakanLab}'),
                subtitle: Text(_rupiah.format(data.hargaJual)),
                trailing: _selectedData.where((e) => e.id == data.id).isEmpty
                    ? null
                    : const Icon(
                        Icons.check_circle_outline_rounded,
                        color: Colors.green,
                      ),
              );
            },
            separatorBuilder: (context, i) => const Divider(
              height: 0.0,
            ),
            itemCount: _data.length,
          ),
        ),
      ],
    );
  }
}
