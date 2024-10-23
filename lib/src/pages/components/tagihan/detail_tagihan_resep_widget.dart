import 'package:dokter_panggil/src/blocs/delete_tagihan_resep_bloc.dart';
import 'package:dokter_panggil/src/blocs/tranportasi_resep_bloc.dart';
import 'package:dokter_panggil/src/blocs/update_kunjungan_resep_tagihan_bloc.dart';
import 'package:dokter_panggil/src/models/delete_tagihan_resep_model.dart';
import 'package:dokter_panggil/src/models/pasien_kunjungan_detail_model.dart';
import 'package:dokter_panggil/src/models/transportasi_resep_model.dart';
import 'package:dokter_panggil/src/models/update_kunjungan_resep_tagihan_model.dart';
import 'package:dokter_panggil/src/pages/components/card_tagihan_resep.dart';
import 'package:dokter_panggil/src/pages/components/confirm_dialog.dart';
import 'package:dokter_panggil/src/pages/components/error_dialog.dart';
import 'package:dokter_panggil/src/pages/components/input_form.dart';
import 'package:dokter_panggil/src/pages/components/loading_kit.dart';
import 'package:dokter_panggil/src/pages/components/success_dialog.dart';
import 'package:dokter_panggil/src/pages/components/tagihan/resep_widget.dart';
import 'package:dokter_panggil/src/pages/components/transaksi_resep.dart';
import 'package:dokter_panggil/src/repositories/responseApi/api_response.dart';
import 'package:dokter_panggil/src/source/config.dart';
import 'package:dokter_panggil/src/source/size_config.dart';
import 'package:dokter_panggil/src/source/transition/slide_bottom_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:dokter_panggil/src/source/transition/animated_dialog.dart';
import 'package:intl/intl.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';

class DetailTagihanResepWidget extends StatefulWidget {
  const DetailTagihanResepWidget({
    Key? key,
    required this.data,
    required this.type,
    this.reload,
  }) : super(key: key);

  final DetailKunjungan data;
  final String type;
  final Function(DetailKunjungan? data)? reload;

  @override
  State<DetailTagihanResepWidget> createState() =>
      _DetailTagihanResepWidgetState();
}

class _DetailTagihanResepWidgetState extends State<DetailTagihanResepWidget> {
  final UpdateKunjunganResepTagihanBloc _updateKunjunganResepTagihanBloc =
      UpdateKunjunganResepTagihanBloc();
  final _deleteTagihanResepBloc = DeleteTagihanResepBloc();
  final _formKey = GlobalKey<FormState>();
  final _jumlah = TextEditingController();
  final _rupiah =
      NumberFormat.currency(locale: 'id', symbol: 'Rp. ', decimalDigits: 0);
  final _rupiahNo =
      NumberFormat.currency(locale: 'id', symbol: '', decimalDigits: 0);
  late DetailKunjungan _data;

  bool validateAndSave() {
    var formState = _formKey.currentState;
    if (formState!.validate()) {
      return true;
    }
    return false;
  }

  @override
  void initState() {
    super.initState();
    _data = widget.data;
  }

  @override
  void didUpdateWidget(covariant DetailTagihanResepWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.data != widget.data) {
      setState(() {
        _data = widget.data;
      });
    }
  }

  void _eresep() {
    showBarModalBottomSheet(
      context: context,
      builder: (context) {
        return _buildEresepWidget(context);
      },
      duration: const Duration(milliseconds: 500),
    );
  }

  void _edit(BuildContext context, TagihanResep? data) {
    _jumlah.text = '${data!.jumlah}';
    showBarModalBottomSheet(
      context: context,
      isDismissible: false,
      builder: (context) {
        return _formUpdateTagihan(context, data.id);
      },
      duration: const Duration(milliseconds: 500),
    ).then((value) {
      if (value != null) {
        var data = value as DetailKunjungan;
        widget.reload!(data);
      }
    });
  }

  void _update(int? id) {
    SystemChannels.textInput.invokeMethod('TextInput.hide');
    FocusScope.of(context).unfocus();
    if (validateAndSave()) {
      _updateKunjunganResepTagihanBloc.idSink.add(id!);
      _updateKunjunganResepTagihanBloc.jumlahSink.add(int.parse(_jumlah.text));
      _updateKunjunganResepTagihanBloc.updateTagihanResep();
      _showStreamUpdate();
    }
  }

  void _showStreamUpdate() {
    showAnimatedDialog(
      context: context,
      builder: (context) {
        return _streamUpdateTagihan(context);
      },
      duration: const Duration(milliseconds: 500),
      animationType: DialogTransitionType.slideFromBottomFade,
    ).then((value) {
      var data = value as DetailKunjungan;
      Navigator.pop(context, data);
    });
  }

  void _hapus(BuildContext context, int? id) {
    showAnimatedDialog(
      context: context,
      builder: (context) {
        return ConfirmDialogWidget(
          message: 'Anda yakin menghapus data ini?',
          onConfirm: () => Navigator.pop(context, id),
        );
      },
      animationType: DialogTransitionType.slideFromBottomFade,
      duration: const Duration(milliseconds: 500),
    ).then((value) {
      if (value != null) {
        var id = value as int;
        _deleteTagihanResepBloc.idSink.add(id);
        _deleteTagihanResepBloc.deleteTagihan();
        _showStreamDelete();
      }
    });
  }

  void _showStreamDelete() {
    showAnimatedDialog(
      context: context,
      builder: (context) {
        return _streamDeleteTagihanResep(context);
      },
      duration: const Duration(milliseconds: 500),
      animationType: DialogTransitionType.slideFromBottomFade,
    ).then((value) {
      if (value != null) {
        var data = value as DetailKunjungan;
        Navigator.pop(context, data);
      }
    });
  }

  @override
  void dispose() {
    _updateKunjunganResepTagihanBloc.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return CardTagihanResep(
      title: 'Resep',
      tiles: Column(
        children: [
          if (_data.tagihanResep!.isEmpty)
            SizedBox(
              width: double.infinity,
              height: 180,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(
                    Icons.warning_amber_rounded,
                    color: kPrimaryColor,
                    size: 52,
                  ),
                  const SizedBox(
                    height: 15.0,
                  ),
                  const Text(
                    'Data tagihan resep tidak tersedia',
                    style: TextStyle(fontSize: 15, color: Colors.grey),
                    textAlign: TextAlign.center,
                  ),
                  if (widget.type != 'view')
                    const SizedBox(
                      height: 18.0,
                    ),
                  if (widget.type != 'view')
                    ElevatedButton(
                      onPressed: () => Navigator.push(
                        context,
                        SlideBottomRoute(
                          page: TransaksiResep(
                            idKunjungan: _data.id,
                            dataResep: _data.resep,
                          ),
                        ),
                      ).then((value) {
                        if (value != null) {
                          var data = value as DetailKunjungan;
                          widget.reload!(data);
                        }
                      }),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: kPrimaryColor,
                      ),
                      child: const Text('Transaksi Barang/Obat'),
                    )
                ],
              ),
            ),
          if (_data.tagihanResep!.isNotEmpty && widget.type == 'create')
            Container(
              margin: const EdgeInsets.only(bottom: 12),
              decoration: BoxDecoration(
                color: Colors.green.withAlpha(20),
                border: Border.all(color: Colors.green, width: 0.5),
                borderRadius: BorderRadius.circular(8.0),
              ),
              child: ListTile(
                onTap: () => Navigator.push(
                  context,
                  SlideBottomRoute(
                    page: TransaksiResep(
                      idKunjungan: _data.id,
                      dataResep: _data.resep,
                    ),
                  ),
                ).then((value) {
                  if (value != null) {
                    var data = value as DetailKunjungan;
                    widget.reload!(data);
                  }
                }),
                dense: true,
                title: Text(
                  'Tambah Barang/Obat',
                  style: TextStyle(color: Colors.grey[600]),
                ),
                trailing: const Icon(
                  Icons.keyboard_arrow_right,
                  color: Colors.grey,
                ),
              ),
            ),
          if (_data.tagihanResep!.isNotEmpty)
            Column(
              children: ListTile.divideTiles(
                context: context,
                tiles: _data.tagihanResep!
                    .map(
                      (tagihanResep) => ListTile(
                        onTap: () => _edit(context, tagihanResep),
                        dense: true,
                        contentPadding: EdgeInsets.zero,
                        horizontalTitleGap: 0,
                        title: Row(
                          children: [
                            Flexible(
                              child: Text('${tagihanResep.namaBarang}'),
                            ),
                            if (widget.type != 'view')
                              const SizedBox(
                                width: 12.0,
                              ),
                            if (widget.type != 'view')
                              const Icon(
                                Icons.edit_note_rounded,
                                size: 22.0,
                                color: Colors.blue,
                              )
                          ],
                        ),
                        subtitle: tagihanResep.tagihanMitra != null
                            ? Text(
                                '${tagihanResep.jumlah} x ${_rupiahNo.format(tagihanResep.hargaModal! + tagihanResep.tarifAplikasi!)} - ${tagihanResep.tagihanMitra!.namaMitra}')
                            : Text(
                                '${tagihanResep.jumlah} x ${_rupiahNo.format(tagihanResep.hargaModal! + tagihanResep.tarifAplikasi!)} - Apotek Mentari'),
                        trailing: Text(
                          _rupiah.format(tagihanResep.total),
                        ),
                      ),
                    )
                    .toList(),
              ).toList(),
            ),
          if (_data.tagihanResep!.isNotEmpty) const Divider(),
          if (_data.tagihanResep!.isNotEmpty)
            TransportasiResepNon(
              data: _data,
              reload: (DetailKunjungan? data) => widget.reload!(data),
              type: widget.type,
            )
        ],
      ),
      subTotal: _data.tagihanResep!.isNotEmpty
          ? Text(
              _rupiah.format(_data.totalResep! + _data.transportResep!),
              style: const TextStyle(fontWeight: FontWeight.w600),
            )
          : const Text(
              'Rp. 0',
              style: TextStyle(fontWeight: FontWeight.w600),
            ),
      buttonDetail: InkWell(
        onTap: _eresep,
        child: const Text(
          'E-Resep',
          style: TextStyle(color: Colors.blue, fontSize: 12.0),
        ),
      ),
    );
  }

  Widget _buildEresepWidget(BuildContext context) {
    return SizedBox(
      height: SizeConfig.blockSizeVertical * 70,
      child: DefaultTabController(
        length: widget.data.dokter!.length,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Padding(
              padding: EdgeInsets.symmetric(vertical: 22.0, horizontal: 22.0),
              child: Text(
                'E-Resep',
                style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
              ),
            ),
            const Divider(
              height: 0,
            ),
            TabBar(
              labelColor: Colors.black,
              isScrollable: true,
              unselectedLabelColor: Colors.grey[400],
              indicatorColor: kPrimaryColor,
              tabs: widget.data.dokter!
                  .map(
                    (dokter) => Tab(
                      child: RichText(
                        text: TextSpan(
                          text: '${dokter.dokter}',
                          style: const TextStyle(color: Colors.black),
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  )
                  .toList(),
            ),
            Expanded(
              child: TabBarView(
                children: widget.data.dokter!
                    .map(
                      (dokter) => ResepWidget(dokter: dokter),
                    )
                    .toList(),
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget _formUpdateTagihan(BuildContext context, int? id) {
    return Padding(
      padding: EdgeInsets.only(
        top: 32.0,
        bottom: MediaQuery.of(context).viewInsets.bottom + 32.0,
        left: 18.0,
        right: 18.0,
      ),
      child: Form(
        key: _formKey,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Edit Jumlah Barang/Obat',
                  style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.w600),
                ),
                CircleAvatar(
                  radius: 15.0,
                  backgroundColor: Colors.transparent,
                  child: IconButton(
                    onPressed: () => Navigator.pop(context),
                    padding: EdgeInsets.zero,
                    icon: const Icon(Icons.close),
                    color: Colors.grey,
                  ),
                ),
              ],
            ),
            const SizedBox(
              height: 22.0,
            ),
            Divider(
              height: 0.0,
              color: Colors.grey[300],
            ),
            const SizedBox(
              height: 22.0,
            ),
            Input(
              controller: _jumlah,
              label: 'Jumlah',
              hint: 'Ketikkan jumlah barang/obat',
              validator: (value) {
                if (value!.isEmpty) {
                  return 'Input required';
                }
                return null;
              },
              keyType: TextInputType.number,
            ),
            const SizedBox(
              height: 42.0,
            ),
            Row(
              children: [
                Expanded(
                  child: ElevatedButton(
                    onPressed: () => _hapus(context, id),
                    style: ElevatedButton.styleFrom(
                      minimumSize: const Size(double.infinity, 47),
                      backgroundColor: Colors.grey[200],
                      foregroundColor: Colors.black,
                    ),
                    child: const Text('Delete'),
                  ),
                ),
                const SizedBox(
                  width: 15.0,
                ),
                Expanded(
                  child: ElevatedButton(
                    onPressed: () => _update(id),
                    style: ElevatedButton.styleFrom(
                        minimumSize: const Size(double.infinity, 47),
                        backgroundColor: kPrimaryColor),
                    child: const Text('Update'),
                  ),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }

  Widget _streamUpdateTagihan(BuildContext context) {
    return StreamBuilder<ApiResponse<ResponseUpdateKunjunganResepTagihanModel>>(
      stream: _updateKunjunganResepTagihanBloc.updateTagihanResepStream,
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
                onTap: () => Navigator.pop(context, snapshot.data!.data!.data),
              );
          }
        }
        return const SizedBox();
      },
    );
  }

  Widget _streamDeleteTagihanResep(BuildContext context) {
    return StreamBuilder<ApiResponse<DeleteTagihanResepModel>>(
      stream: _deleteTagihanResepBloc.deleteTagihanResepStream,
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
                onTap: () => Navigator.pop(context, snapshot.data!.data!.data),
              );
          }
        }
        return const SizedBox();
      },
    );
  }
}

class TransportasiResepNon extends StatefulWidget {
  const TransportasiResepNon({
    Key? key,
    required this.data,
    this.reload,
    this.type = 'create',
  }) : super(key: key);

  final DetailKunjungan data;
  final Function(DetailKunjungan? data)? reload;
  final String type;

  @override
  State<TransportasiResepNon> createState() => _TransportasiResepNonState();
}

class _TransportasiResepNonState extends State<TransportasiResepNon> {
  final TransportasiResepBloc _transportasiResepBloc = TransportasiResepBloc();
  final _rupiah =
      NumberFormat.currency(locale: 'id', symbol: 'Rp. ', decimalDigits: 0);
  final _formKey = GlobalKey<FormState>();
  final _biaya = TextEditingController();

  bool validateAndSave() {
    var formState = _formKey.currentState;
    if (formState!.validate()) {
      return true;
    }
    return false;
  }

  void _tambahTransport() {
    _biaya.text = '${widget.data.transportResep}';
    showBarModalBottomSheet(
      context: context,
      builder: (context) {
        return Padding(
          padding: EdgeInsets.only(
            bottom: MediaQuery.of(context).viewInsets.bottom + 22,
          ),
          child: _formTransportasi(),
        );
      },
    ).then((value) {
      if (value != null) {
        var data = value as DetailKunjungan;
        widget.reload!(data);
      }
    });
  }

  void _simpan() {
    if (validateAndSave()) {
      SystemChannels.textInput.invokeMethod('TextInput.hide');
      FocusScope.of(context).unfocus();
      _transportasiResepBloc.idKunjunganSink.add(widget.data.id!);
      _transportasiResepBloc.biayaSink.add(int.parse(_biaya.text));
      _transportasiResepBloc.saveTransportasiResep();
      _showStreamTransportasi();
    }
  }

  void _showStreamTransportasi() {
    showAnimatedDialog(
      context: context,
      builder: (context) {
        return _streamTransportResep();
      },
      animationType: DialogTransitionType.slideFromBottomFade,
      duration: const Duration(milliseconds: 500),
    ).then((value) {
      var data = value as DetailKunjungan;
      Future.delayed(const Duration(milliseconds: 300), () {
        Navigator.pop(context, data);
      });
    });
  }

  @override
  dispose() {
    super.dispose();
    _transportasiResepBloc.dispose();
    _biaya.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: widget.type != 'view' ? _tambahTransport : null,
      dense: true,
      contentPadding: EdgeInsets.zero,
      title: Row(
        children: [
          const Text('Transportasi'),
          const SizedBox(
            width: 8,
          ),
          if (widget.type != 'view')
            const Icon(
              Icons.edit_note_rounded,
              size: 22.0,
              color: Colors.blue,
            )
        ],
      ),
      trailing: Text(_rupiah.format(widget.data.transportResep)),
    );
  }

  Widget _formTransportasi() {
    return Form(
      key: _formKey,
      child: Padding(
        padding: const EdgeInsets.all(28.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text(
              'Transportasi Resep',
              style: TextStyle(fontSize: 20.0, fontWeight: FontWeight.w600),
            ),
            const SizedBox(
              height: 32.0,
            ),
            Input(
              controller: _biaya,
              label: 'Biaya Ojek Online',
              hint: 'Input biaya ojek online',
              maxLines: 1,
              validator: (val) {
                if (val!.isEmpty) {
                  return 'Input required';
                }
                return null;
              },
              keyType: TextInputType.number,
            ),
            const SizedBox(
              height: 22.0,
            ),
            ElevatedButton(
              onPressed: _simpan,
              style: ElevatedButton.styleFrom(
                backgroundColor: kPrimaryColor,
                minimumSize: const Size(double.infinity, 48),
              ),
              child: const Text('Simpan'),
            )
          ],
        ),
      ),
    );
  }

  Widget _streamTransportResep() {
    return StreamBuilder<ApiResponse<ResponseTransportasiResepModel>>(
      stream: _transportasiResepBloc.transportasiResepStream,
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
                onTap: () => Navigator.pop(context, snapshot.data!.data!.data),
              );
          }
        }
        return const SizedBox();
      },
    );
  }
}
