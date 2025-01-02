import 'package:dokter_panggil/src/blocs/master_barang_lab_bloc.dart';
import 'package:dokter_panggil/src/blocs/master_tindakan_lab_all_bloc.dart';
import 'package:dokter_panggil/src/models/barang_fetch_model.dart';
import 'package:dokter_panggil/src/models/master_barang_lab_model.dart';
import 'package:dokter_panggil/src/models/master_tindakan_lab_all_model.dart';
import 'package:dokter_panggil/src/pages/components/confirm_dialog.dart';
import 'package:dokter_panggil/src/pages/components/error_dialog.dart';
import 'package:dokter_panggil/src/pages/components/error_response.dart';
import 'package:dokter_panggil/src/pages/components/loading_kit.dart';
import 'package:dokter_panggil/src/pages/components/marker_bottom_sheet.dart';
import 'package:dokter_panggil/src/pages/components/search_widget_page.dart';
import 'package:dokter_panggil/src/pages/components/success_dialog.dart';
import 'package:dokter_panggil/src/repositories/responseApi/api_response.dart';
import 'package:dokter_panggil/src/source/config.dart';
import 'package:dokter_panggil/src/source/size_config.dart';
import 'package:flutter/material.dart';
import 'package:dokter_panggil/src/source/transition/animated_dialog.dart';

class ListTindakanBarangLab extends StatefulWidget {
  const ListTindakanBarangLab({
    super.key,
    this.barang,
  });

  final Barang? barang;

  @override
  State<ListTindakanBarangLab> createState() => _ListTindakanBarangLabState();
}

class _ListTindakanBarangLabState extends State<ListTindakanBarangLab> {
  final _masterTindakanLabAllBloc = MasterTindakanLabAllBloc();

  @override
  void initState() {
    super.initState();
    _getTindakanLab();
  }

  void _getTindakanLab() {
    _masterTindakanLabAllBloc.getTindakanLabAll();
  }

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return Container(
      constraints: BoxConstraints(
        minHeight: SizeConfig.blockSizeVertical * 40,
        maxHeight: SizeConfig.blockSizeVertical * 92,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Center(child: MarkerBottomSheet()),
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 22.0, vertical: 12.0),
            child: Text(
              'Input Barang Laboratorium',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
          ),
          Container(
            margin: const EdgeInsets.all(22),
            decoration: BoxDecoration(
              color: kPrimaryColor.withOpacity(0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: ListTile(
              title: Text('${widget.barang!.namaBarang}'),
              contentPadding:
                  const EdgeInsets.symmetric(horizontal: 22.0, vertical: 8.0),
              subtitle: Text('Stok: ${widget.barang!.stock!.currentStock}'),
            ),
          ),
          const Divider(),
          Flexible(
            child: _buildStreamTindakanLab(context),
          ),
        ],
      ),
    );
  }

  Widget _buildStreamTindakanLab(BuildContext context) {
    return StreamBuilder<ApiResponse<MasterTindakanLabAllModel>>(
      stream: _masterTindakanLabAllBloc.tindakanLabAllStream,
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
                  onTap: () {
                    _getTindakanLab();
                    setState(() {});
                  },
                ),
              );
            case Status.completed:
              return ListTindakanLab(
                data: snapshot.data!.data!.data!,
                barang: widget.barang,
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
    this.barang,
  });

  final List<MasterTindakanLabAll>? data;
  final Barang? barang;

  @override
  State<ListTindakanLab> createState() => _ListTindakanLabState();
}

class _ListTindakanLabState extends State<ListTindakanLab> {
  final _masterBarangLabBloc = MasterBarangLabBloc();
  List<MasterTindakanLabAll> _data = [];
  final List<int> _idTindakan = [];
  final _filter = TextEditingController();

  @override
  void initState() {
    super.initState();
    _data = widget.data!;
    _filter.addListener(_filterListen);
  }

  void _filterListen() {
    if (_filter.text.isEmpty) {
      _data = widget.data!;
    } else {
      _data = widget.data!
          .where(
            (tindakan) => tindakan.namaTindakanLab!
                .toLowerCase()
                .contains(_filter.text.toLowerCase()),
          )
          .toList();
    }
    setState(() {});
  }

  void _selectTindakan(int id) {
    if (_idTindakan.contains(id)) {
      _idTindakan.removeWhere((e) => e == id);
    } else {
      _idTindakan.add(id);
    }
    setState(() {});
  }

  void _confirmTambah() {
    showAnimatedDialog(
      context: context,
      builder: (context) {
        return ConfirmDialogWidget(
          message: 'Anda yakin ingin menambahkan barang ini?',
          onConfirm: () => Navigator.pop(context, 'confirm'),
          labelConfirm: 'Ya, Tambah',
        );
      },
      duration: const Duration(milliseconds: 500),
      animationType: DialogTransitionType.slideFromBottomFade,
    ).then((value) {
      if (value != null) {
        _masterBarangLabBloc.barangSink.add(widget.barang!.id!);
        _masterBarangLabBloc.tindakanLabsSink.add(_idTindakan);
        _masterBarangLabBloc.saveBarangLab();
        _showStreamSaveBarangLab();
      }
    });
  }

  void _showStreamSaveBarangLab() {
    showAnimatedDialog(
      context: context,
      builder: (context) {
        return _buildStreamSaveBarangLab(context);
      },
      duration: const Duration(milliseconds: 500),
      animationType: DialogTransitionType.slideFromBottomFade,
    ).then((value) {
      if (value != null) {
        Future.delayed(const Duration(milliseconds: 500), () {
          if (!mounted) return;
          Navigator.pop(context);
        });
      }
    });
  }

  @override
  void dispose() {
    _filter.removeListener(_filterListen);
    _filter.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SearchWidgetPage(
          filter: _filter,
          hint: 'Pencarian nama tindakan lab',
        ),
        if (_data.isEmpty)
          Flexible(
            child: Center(
              child: ErrorResponse(
                message: 'Data tindakan tidak tersedia',
                onTap: () {
                  _filter.clear();
                },
              ),
            ),
          )
        else
          Flexible(
            child: ListView.separated(
              shrinkWrap: true,
              padding:
                  const EdgeInsets.symmetric(horizontal: 18.0, vertical: 12.0),
              itemBuilder: (context, i) {
                var tindakanLab = _data[i];
                return ListTile(
                  onTap: () => _selectTindakan(tindakanLab.id!),
                  title: Text('${tindakanLab.namaTindakanLab}'),
                  subtitle: Text('${tindakanLab.mitra!.namaMitra}'),
                  trailing: _idTindakan.contains(tindakanLab.id)
                      ? const Icon(
                          Icons.check_circle_outline_rounded,
                          color: kPrimaryColor,
                        )
                      : null,
                );
              },
              separatorBuilder: (context, i) => const SizedBox(
                height: 18,
              ),
              itemCount: _data.length,
            ),
          ),
        Container(
          width: double.infinity,
          padding: const EdgeInsets.fromLTRB(22.0, 18.0, 22.0, 0),
          decoration: const BoxDecoration(color: Colors.white),
          child: SafeArea(
            top: false,
            child: ElevatedButton(
              onPressed: _idTindakan.isEmpty ? null : _confirmTambah,
              style: ElevatedButton.styleFrom(
                minimumSize: const Size.fromHeight(45.0),
              ),
              child: const Text('Tambah Barang Laboratorium'),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildStreamSaveBarangLab(BuildContext context) {
    return StreamBuilder<ApiResponse<MasterBarangLabModel>>(
      stream: _masterBarangLabBloc.saveMasterBarangLabStream,
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
                onTap: () => Navigator.pop(context, 'success'),
              );
          }
        }
        return const SizedBox();
      },
    );
  }
}
