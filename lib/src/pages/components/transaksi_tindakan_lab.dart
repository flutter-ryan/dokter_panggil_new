import 'package:dokter_panggil/src/blocs/master_mitra_lab_bloc.dart';
import 'package:dokter_panggil/src/blocs/master_tindakan_lab_bloc.dart';
import 'package:dokter_panggil/src/blocs/transaksi_tindakan_lab_bloc.dart';
import 'package:dokter_panggil/src/models/master_mitra_lab_model.dart';
import 'package:dokter_panggil/src/models/master_tindakan_lab_model.dart';
import 'package:dokter_panggil/src/models/pasien_kunjungan_detail_model.dart';
import 'package:dokter_panggil/src/models/transaksi_tindakan_lab_model.dart';
import 'package:dokter_panggil/src/pages/components/error_response.dart';
import 'package:dokter_panggil/src/pages/components/error_dialog.dart';
import 'package:dokter_panggil/src/pages/components/loading_kit.dart';
import 'package:dokter_panggil/src/pages/components/search_widget_page.dart';
import 'package:dokter_panggil/src/pages/components/success_dialog.dart';
import 'package:dokter_panggil/src/repositories/responseApi/api_response.dart';
import 'package:dokter_panggil/src/source/config.dart';
import 'package:dokter_panggil/src/source/size_config.dart';
import 'package:flutter/material.dart';
import 'package:dokter_panggil/src/source/transition/animated_dialog.dart';
import 'package:intl/intl.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';

class TransaksiTindakanLab extends StatefulWidget {
  const TransaksiTindakanLab({
    super.key,
    required this.idKunjungan,
    required this.dataLab,
  });

  final int idKunjungan;
  final List<TindakanLab> dataLab;

  @override
  State<TransaksiTindakanLab> createState() => _TransaksiTindakanLabState();
}

class _TransaksiTindakanLabState extends State<TransaksiTindakanLab> {
  final TransaksiTindakanLabBloc _transaksiTindakanLabBloc =
      TransaksiTindakanLabBloc();
  final MasterMitraLabBloc _masterMitraLabBloc = MasterMitraLabBloc();
  final _rupiah =
      NumberFormat.currency(locale: 'id', symbol: 'Rp. ', decimalDigits: 0);
  List<TindakanLab> _data = [];
  List<MasterTindakanLab> _finalSelectedData = [];

  @override
  void initState() {
    super.initState();
    _data = widget.dataLab;
  }

  void _listTindakanLab() {
    _masterMitraLabBloc.getMitraLab();
    showBarModalBottomSheet(
      context: context,
      isDismissible: false,
      enableDrag: false,
      builder: (context) {
        return _streamListMitraLab(context);
      },
      duration: const Duration(milliseconds: 500),
    ).then((value) {
      if (value != null) {
        var data = value as List<MasterTindakanLab>;
        _finalSelectedData = data;
      }
      setState(() {});
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
    if (_finalSelectedData.isNotEmpty) {
      List<int> idSelected = [];
      for (var dataSelected in _finalSelectedData) {
        idSelected.add(dataSelected.id!);
      }
      _transaksiTindakanLabBloc.idKunjunganSink.add(widget.idKunjungan);
      _transaksiTindakanLabBloc.idTindakanSink.add(idSelected);
      _transaksiTindakanLabBloc.saveTransaksiTindakanLab();
      _showStreamSimpanTransaksi();
    }
  }

  void _showStreamSimpanTransaksi() {
    showAnimatedDialog(
      context: context,
      builder: (context) {
        return _streamSimpanTransaksi(context);
      },
      duration: const Duration(milliseconds: 500),
      animationType: DialogTransitionType.slideFromBottomFade,
    ).then((value) {
      if (value != null) {
        var data = value as DetailKunjungan;
        Future.delayed(const Duration(milliseconds: 300), () {
          if (!mounted) return;
          Navigator.pop(context, data);
        });
      }
    });
  }

  @override
  void dispose() {
    _masterMitraLabBloc.dispose();
    _transaksiTindakanLabBloc.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text('Transaksi Laboratorium'),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
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
      body: _formTransaksiLab(context),
    );
  }

  Widget _formTransaksiLab(BuildContext context) {
    return Column(
      children: [
        if (_finalSelectedData.isEmpty)
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
                  'Data tindakan laboratorium tidak tersedia',
                  style: TextStyle(fontSize: 16.0, color: Colors.grey),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          )
        else
          _formTransaksiTindakanLab(context),
        Container(
          padding: const EdgeInsets.all(18.0),
          width: double.infinity,
          decoration: const BoxDecoration(color: Colors.white, boxShadow: [
            BoxShadow(
                color: Colors.black12, blurRadius: 6, offset: Offset(0.0, -2.0))
          ]),
          child: Row(
            children: [
              ElevatedButton(
                onPressed: _listTindakanLab,
                style: ElevatedButton.styleFrom(
                  minimumSize: const Size(0.0, 48.0),
                  backgroundColor: Colors.grey[200],
                  foregroundColor: Colors.black,
                ),
                child: const Icon(Icons.add_rounded),
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
                  ),
                  child: const Text('SIMPAN TRANSAKSI'),
                ),
              ),
            ],
          ),
        )
      ],
    );
  }

  Widget _streamListMitraLab(BuildContext context) {
    return SizedBox(
      height: SizeConfig.blockSizeVertical * 85,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Padding(
            padding: EdgeInsets.all(22.0),
            child: Text(
              'List Tindakan Lab',
              style: TextStyle(fontSize: 16.0, fontWeight: FontWeight.w600),
            ),
          ),
          const Divider(
            height: 0.0,
            color: Colors.grey,
          ),
          Expanded(
            child: _streamMitraLab(context),
          ),
        ],
      ),
    );
  }

  Widget _streamMitraLab(BuildContext context) {
    return StreamBuilder<ApiResponse<MasterMitraLabModel>>(
      stream: _masterMitraLabBloc.masterMitraLabStream,
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
              return TabMitraTindakanLab(
                dataMitra: snapshot.data!.data!.data,
                selectedData: _finalSelectedData,
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
              'List Tindakan Laboratorium',
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
                  title: Text('${data.tindakanLab}'),
                  subtitle: Text('${data.mitra!.namaMitra}'),
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

  Widget _formTransaksiTindakanLab(BuildContext context) {
    return Expanded(
      child: ListView.separated(
        padding: const EdgeInsets.symmetric(horizontal: 22.0, vertical: 18.0),
        itemBuilder: (context, i) {
          var data = _finalSelectedData[i];
          return ListTile(
            title: Text('${data.namaTindakanLab}'),
            subtitle: Text('${data.mitra!.namaMitra}'),
            trailing: Text(
              _rupiah.format(data.hargaJual),
              style: const TextStyle(fontWeight: FontWeight.w600),
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
    return StreamBuilder<ApiResponse<ResponseTransaksiTindakanLabModel>>(
        stream: _transaksiTindakanLabBloc.transaksiTindakanLabStream,
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
                    (e) => StreamListTindakanLab(
                      idMitra: e.id!,
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
            decoration: const BoxDecoration(color: Colors.white, boxShadow: [
              BoxShadow(
                color: Colors.black12,
                offset: Offset(0.0, -2.0),
                blurRadius: 4,
              ),
            ]),
            child: ElevatedButton(
              onPressed: () => Navigator.pop(context, _selectedData),
              style: ElevatedButton.styleFrom(
                minimumSize: const Size(double.infinity, 45.0),
                backgroundColor: kPrimaryColor,
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
