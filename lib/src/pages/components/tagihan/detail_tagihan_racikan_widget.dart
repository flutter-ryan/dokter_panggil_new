import 'package:admin_dokter_panggil/src/blocs/delete_tagihan_resep_racikan_bloc.dart';
import 'package:admin_dokter_panggil/src/blocs/file_eresep_racikan_bloc.dart';
import 'package:admin_dokter_panggil/src/blocs/resep_racikan_proses_bloc.dart';
import 'package:admin_dokter_panggil/src/blocs/tranportasi_resep_racikan_bloc.dart';
import 'package:admin_dokter_panggil/src/blocs/update_kunjungan_resep_racikan_tagihan_bloc.dart';
import 'package:admin_dokter_panggil/src/models/delete_tagihan_resep_model.dart';
import 'package:admin_dokter_panggil/src/models/file_eresep_racikan_model.dart';
import 'package:admin_dokter_panggil/src/models/pasien_kunjungan_detail_model.dart';
import 'package:admin_dokter_panggil/src/models/resep_racikan_proses_model.dart';
import 'package:admin_dokter_panggil/src/models/transportasi_resep_racikan_model.dart';
import 'package:admin_dokter_panggil/src/models/update_kunjungan_resep_tagihan_model.dart';
import 'package:admin_dokter_panggil/src/pages/components/card_tagihan_resep.dart';
import 'package:admin_dokter_panggil/src/pages/components/confirm_dialog.dart';
import 'package:admin_dokter_panggil/src/pages/components/error_dialog.dart';
import 'package:admin_dokter_panggil/src/pages/components/input_form.dart';
import 'package:admin_dokter_panggil/src/pages/components/loading_kit.dart';
import 'package:admin_dokter_panggil/src/pages/components/success_dialog.dart';
import 'package:admin_dokter_panggil/src/pages/components/tagihan/resep_racikan_widget.dart';
import 'package:admin_dokter_panggil/src/pages/components/tagihan/tile_obat_widget.dart';
import 'package:admin_dokter_panggil/src/pages/components/transaksi_resep_racikan.dart';
import 'package:admin_dokter_panggil/src/pages/components/transaksi_resep_racikan_mr.dart';
import 'package:admin_dokter_panggil/src/repositories/responseApi/api_response.dart';
import 'package:admin_dokter_panggil/src/source/config.dart';
import 'package:admin_dokter_panggil/src/source/size_config.dart';
import 'package:admin_dokter_panggil/src/source/transition/slide_bottom_route.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:admin_dokter_panggil/src/source/transition/animated_dialog.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:share_plus/share_plus.dart';

class DetailTagihanRacikanWidget extends StatefulWidget {
  const DetailTagihanRacikanWidget({
    super.key,
    required this.data,
    this.type = 'create',
    this.reload,
  });

  final DetailKunjungan data;
  final String type;
  final Function(DetailKunjungan data)? reload;

  @override
  State<DetailTagihanRacikanWidget> createState() =>
      _DetailTagihanRacikanWidgetState();
}

class _DetailTagihanRacikanWidgetState
    extends State<DetailTagihanRacikanWidget> {
  final _resepRacikanProsesBloc = ResepRacikanProsesBloc();
  final _updateKunjunganResepRacikanTagihanBloc =
      UpdateKunjunganResepRacikanTagihanBloc();
  final _deleteTagihanResepRacikanBloc = DeleteTagihanResepRacikanBloc();
  final _fileEresepRacikanBloc = FileEresepRacikanBloc();
  final _formKey = GlobalKey<FormState>();
  final _jumlah = TextEditingController();
  final _rupiah =
      NumberFormat.currency(locale: 'id', symbol: 'Rp. ', decimalDigits: 0);
  final _rupiahNo =
      NumberFormat.currency(locale: 'id', symbol: '', decimalDigits: 0);
  DetailKunjungan? _data;

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
    _loadListResep();
  }

  @override
  void didUpdateWidget(covariant DetailTagihanRacikanWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.data != widget.data) {
      _loadListResep();
      setState(() {});
    }
  }

  void _loadListResep() {
    _data = widget.data;
  }

  void _eresepRacikan() {
    showBarModalBottomSheet(
      context: context,
      builder: (context) {
        return _buildEresepRacikanWidget(context);
      },
      duration: const Duration(milliseconds: 500),
    );
  }

  void _edit(BuildContext context, TagihanResepRacikan data) {
    _jumlah.text = '${data.jumlah}';
    showBarModalBottomSheet(
      context: context,
      builder: (context) {
        return _formUpdateTagihan(context, data);
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
    FocusScope.of(context).requestFocus(FocusNode());
    if (validateAndSave()) {
      _updateKunjunganResepRacikanTagihanBloc.idSink.add(id!);
      _updateKunjunganResepRacikanTagihanBloc.jumlahSink
          .add(int.parse(_jumlah.text));
      _updateKunjunganResepRacikanTagihanBloc.updateTagihanResepRacikan();
      _showStreamUpdate();
    }
  }

  void _showStreamUpdate() {
    showAnimatedDialog(
      context: context,
      builder: (context) {
        return _streamUpdateTagihan(context);
      },
      animationType: DialogTransitionType.slideFromBottomFade,
    ).then((value) {
      var data = value as DetailKunjungan;
      Future.delayed(const Duration(milliseconds: 500), () {
        if (!mounted) return;
        Navigator.pop(context, data);
      });
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
        _deleteTagihanResepRacikanBloc.idSink.add(id);
        _deleteTagihanResepRacikanBloc.deleteTagihanRacikan();
        _showStreamDelete();
      }
    });
  }

  void _showStreamDelete() {
    showAnimatedDialog(
      context: context,
      builder: (context) {
        return _streamDeleteTagihanResepRacikan(context);
      },
      duration: const Duration(milliseconds: 500),
      animationType: DialogTransitionType.slideFromBottomFade,
    ).then((value) {
      if (value != null) {
        var data = value as DetailKunjungan;
        if (!mounted) return;
        Navigator.pop(context, data);
      }
    });
  }

  void _prosesResep(ResepRacikan racikan) {
    showMaterialModalBottomSheet(
      context: context,
      builder: (context) => _showPilhanProsesResep(context),
    ).then((value) {
      if (value != null) {
        var data = value as String;
        _resepRacikanProsesBloc.idResepRacikanSink.add(racikan.id!);
        if (data == 'bersedia') {
          _resepRacikanProsesBloc.isBersedia.add(1);
        } else {
          _resepRacikanProsesBloc.isBersedia.add(0);
        }
        _resepRacikanProsesBloc.statusSink.add(1);
        _resepRacikanProsesBloc.prosesResepRacikan();
        _showStreamProsesResepRacikan();
      }
    });
  }

  void _showStreamProsesResepRacikan() {
    showAnimatedDialog(
      context: context,
      builder: (context) => _streamProsesResepRacikan(context),
      animationType: DialogTransitionType.slideFromBottomFade,
      duration: const Duration(milliseconds: 500),
    ).then((value) {
      if (value != null) {
        var data = value as ResepRacikan;
        setState(() {
          _data!.resepRacikan![_data!.resepRacikan!
              .indexWhere((oral) => oral.id == data.id)] = data;
        });
      }
    });
  }

  void _eresepMrRacikan(ResepRacikan racikan) {
    showMaterialModalBottomSheet(
      context: context,
      builder: (context) {
        return _eresepRacikanWidget(context, racikan);
      },
      duration: const Duration(milliseconds: 500),
    ).then((value) {
      if (value != null) {
        Future.delayed(const Duration(milliseconds: 500), () {
          _fileEresepRacikanBloc.idResepSink.add(racikan.id!);
          _fileEresepRacikanBloc.eresepRacikan();
          _showStreamEresepRacikan();
        });
      }
    });
  }

  void _showStreamEresepRacikan() {
    showAnimatedDialog(
      context: context,
      builder: (context) => _streamEresepRacikn(context),
      animationType: DialogTransitionType.slideFromBottomFade,
    ).then((value) {
      if (value != null) {
        final resep = value as FileEresepRacikan;
        Future.delayed(const Duration(milliseconds: 500), () async {
          _shareResepRacikan(resep);
        });
      }
    });
  }

  Future<void> _shareResepRacikan(FileEresepRacikan resep) async {
    SharePlus.instance.share(
      ShareParams(
          title: 'E-Resep Pasien ${resep.pasien}',
          text:
              'ERESEP dokter panggil\n\nPasien ${resep.pasien} ${Uri.parse(resep.url!).toString()}',
          subject: 'E-Resep Racikan ${resep.pasien}'),
    );
  }

  @override
  void dispose() {
    super.dispose();
    _updateKunjunganResepRacikanTagihanBloc.dispose();
    _deleteTagihanResepRacikanBloc.dispose();
    _fileEresepRacikanBloc.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (widget.data.isEmr == 0) {
      return _oldRacikanWidget(context);
    }
    return CardTagihanResep(
      title: 'Resep Racikan',
      tiles: Column(
          children: ListTile.divideTiles(
        context: context,
        color: Colors.grey[400],
        tiles: _data!.resepRacikan!
            .map(
              (resepRacikan) => Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.fromLTRB(0.0, 12.0, 8.0, 8.0),
                        child: Text(
                          '${resepRacikan.tanggalShort}\n${resepRacikan.jamShort}',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              fontSize: 12, fontWeight: FontWeight.w600),
                        ),
                      ),
                      Expanded(
                        child: Padding(
                          padding:
                              const EdgeInsets.fromLTRB(8.0, 14.0, 0.0, 8.0),
                          child: RichText(
                            text: TextSpan(
                                text: resepRacikan.petugasSbar == null
                                    ? '${resepRacikan.dokter} |'
                                    : '${resepRacikan.petugasSbar!.namaPetugas} |',
                                style: TextStyle(
                                    fontSize: 12,
                                    color: Colors.black,
                                    fontWeight: FontWeight.w600),
                                children: [
                                  TextSpan(
                                    text: ' E-Resep ',
                                    style: TextStyle(color: Colors.blueAccent),
                                    recognizer: TapGestureRecognizer()
                                      ..onTap =
                                          () => _eresepMrRacikan(resepRacikan),
                                  ),
                                  TextSpan(
                                    text: '|',
                                    style: TextStyle(color: Colors.black),
                                  ),
                                  TextSpan(
                                    text: resepRacikan.status == 0
                                        ? ' Belum diproses'
                                        : ' Sudah diproses',
                                    style: TextStyle(
                                        color: resepRacikan.status == 0
                                            ? Colors.red
                                            : Colors.green),
                                    recognizer: TapGestureRecognizer()
                                      ..onTap = widget.type == 'create'
                                          ? () => _prosesResep(resepRacikan)
                                          : null,
                                  ),
                                  if (resepRacikan.status == 1)
                                    TextSpan(
                                      text: ' |',
                                      style: TextStyle(color: Colors.black),
                                    ),
                                  if (resepRacikan.status == 1)
                                    TextSpan(
                                      text: resepRacikan.isBersedia == 0
                                          ? ' Tidak bersedia'
                                          : ' Bersedia',
                                      style: TextStyle(
                                          color: resepRacikan.isBersedia == 0
                                              ? Colors.red
                                              : Colors.green),
                                    ),
                                ]),
                          ),
                        ),
                      ),
                    ],
                  ),
                  ..._data!.tagihanResepRacikan!
                      .where((tagihan) =>
                          tagihan.kunjunganRacikanId == resepRacikan.id)
                      .map(
                        (obatRacikan) => TileObatWidget(
                          onTap: widget.type != 'view'
                              ? () => _edit(context, obatRacikan)
                              : null,
                          isEdit: widget.type != 'view',
                          leading: Padding(
                            padding: const EdgeInsets.only(top: 2.0),
                            child: Text(
                              '${obatRacikan.createdAt}',
                              style: TextStyle(fontSize: 12),
                            ),
                          ),
                          title: '${obatRacikan.namaBarang}',
                          subtitle:
                              '${obatRacikan.jumlah} x ${_rupiahNo.format(obatRacikan.hargaModal! + obatRacikan.tarifAplikasi!)}',
                          trailing: _rupiah.format(obatRacikan.total),
                        ),
                      ),
                  if (resepRacikan.status == 1 && resepRacikan.isBersedia == 1)
                    TransportasiResepRacikan(
                      data: _data!,
                      idResep: resepRacikan.id,
                      reload: (DetailKunjungan? data) => setState(() {
                        _data = data!;
                      }),
                      type: widget.type,
                    ),
                  if (resepRacikan.status == 1)
                    SizedBox(
                      height: 12,
                    ),
                  if (resepRacikan.status == 1 &&
                      resepRacikan.isBersedia == 1 &&
                      widget.type == 'create')
                    ElevatedButton.icon(
                      onPressed: () => Navigator.push(
                        context,
                        SlideBottomRoute(
                          page: TransaksiResepRacikanMr(
                            idKunjungan: _data!.id!,
                            dataResepRacikan: resepRacikan,
                          ),
                        ),
                      ).then((value) {
                        if (value != null) {
                          var data = value as DetailKunjungan;
                          widget.reload!(data);
                        }
                      }),
                      icon: Icon(
                        Icons.add_circle_outline_rounded,
                        size: 18,
                      ),
                      style: ElevatedButton.styleFrom(
                          visualDensity: VisualDensity.compact,
                          backgroundColor: Colors.grey[100],
                          elevation: 0,
                          foregroundColor: Colors.blueAccent,
                          textStyle: TextStyle(fontSize: 12),
                          minimumSize: Size(double.infinity, 40)),
                      label: Text(
                        'Transaksi Barang/Obat',
                      ),
                    )
                ],
              ),
            )
            .toList(),
      ).toList()),
      subTotal: _data!.tagihanResepRacikan!.isNotEmpty ||
              _data!.transportasiResepRacikanMr!.isNotEmpty
          ? Text(
              _rupiah.format(
                  _data!.totalResepRacikan! + _data!.transportResepRacikan!),
              style: const TextStyle(fontWeight: FontWeight.w600),
            )
          : const Text('Rp. 0', style: TextStyle(fontWeight: FontWeight.w600)),
    );
  }

  Widget _buildEresepRacikanWidget(BuildContext context) {
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
                'E-Resep Racikan',
                style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
              ),
            ),
            TabBar(
              labelColor: Colors.black,
              isScrollable: true,
              unselectedLabelColor: Colors.grey[400],
              indicatorColor: kPrimaryColor,
              tabs: widget.data.dokter!
                  .map(
                    (dokter) => Tab(
                      text: '${dokter.dokter}',
                    ),
                  )
                  .toList(),
            ),
            Expanded(
              child: TabBarView(
                children: widget.data.dokter!
                    .map(
                      (dokter) => ResepRacikanWidget(dokter: dokter),
                    )
                    .toList(),
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget _formUpdateTagihan(BuildContext context, TagihanResepRacikan? data) {
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
            const Text(
              'Edit Jumlah Barang/Obat',
              style: TextStyle(fontSize: 16.0, fontWeight: FontWeight.w600),
            ),
            Text(
              '${data!.namaBarang}',
              style: TextStyle(fontSize: 16),
            ),
            Input(
              controller: _jumlah,
              label: '',
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
              height: 32.0,
            ),
            Row(
              children: [
                Expanded(
                  child: ElevatedButton(
                    onPressed: () => _hapus(context, data.id),
                    style: ElevatedButton.styleFrom(
                      minimumSize: const Size(double.infinity, 42),
                      backgroundColor: Colors.grey[200],
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(32),
                      ),
                      foregroundColor: Colors.black,
                    ),
                    child: const Text('Hapus'),
                  ),
                ),
                const SizedBox(
                  width: 15.0,
                ),
                Expanded(
                  child: ElevatedButton(
                    onPressed: () => _update(data.id),
                    style: ElevatedButton.styleFrom(
                      minimumSize: const Size(double.infinity, 42),
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(32)),
                      backgroundColor: Colors.green,
                    ),
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
      stream: _updateKunjunganResepRacikanTagihanBloc
          .updateTagihanResepRacikanStream,
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

  Widget _streamDeleteTagihanResepRacikan(BuildContext context) {
    return StreamBuilder<ApiResponse<DeleteTagihanResepModel>>(
      stream: _deleteTagihanResepRacikanBloc.deleteTagihanResepRacikanStream,
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

  Widget _oldRacikanWidget(BuildContext context) {
    return CardTagihanResep(
      title: 'Resep Racikan',
      tiles: Column(
        children: [
          if (_data!.tagihanResepRacikan!.isEmpty)
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
                    'Data tagihan resep racikan tidak tersedia',
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
                          page: TransaksiResepRacikan(
                            idKunjungan: _data!.id!,
                            dataResepRacikan: _data!.resepRacikan!,
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
          if (_data!.tagihanResepRacikan!.isNotEmpty && widget.type == 'create')
            Container(
              margin: const EdgeInsets.only(bottom: 12.0),
              decoration: BoxDecoration(
                color: Colors.green.withAlpha(20),
                border: Border.all(color: Colors.green, width: 0.5),
                borderRadius: BorderRadius.circular(8.0),
              ),
              child: ListTile(
                onTap: () => Navigator.push(
                  context,
                  SlideBottomRoute(
                    page: TransaksiResepRacikan(
                      idKunjungan: _data!.id!,
                      dataResepRacikan: _data!.resepRacikan!,
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
          if (_data!.tagihanResepRacikan!.isNotEmpty)
            Column(
              children: ListTile.divideTiles(
                      context: context,
                      tiles: _data!.tagihanResepRacikan!
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
                          .toList())
                  .toList(),
            ),
          if (_data!.tagihanResepRacikan!.isNotEmpty)
            const Divider(height: 0.0),
          if (_data!.tagihanResepRacikan!.isNotEmpty)
            TransportasiResepRacikan(
              data: _data!,
              reload: (DetailKunjungan? data) => setState(() {
                _data = data!;
              }),
              type: widget.type,
            )
        ],
      ),
      subTotal: _data!.tagihanResepRacikan!.isNotEmpty
          ? Text(
              _rupiah.format(
                  _data!.totalResepRacikan! + _data!.transportResepRacikan!),
              style: const TextStyle(fontWeight: FontWeight.w600),
            )
          : const Text('Rp. 0', style: TextStyle(fontWeight: FontWeight.w600)),
      buttonDetail: InkWell(
        onTap: _eresepRacikan,
        child: const Text(
          'E-Resep',
          style: TextStyle(color: Colors.blue, fontSize: 12.0),
        ),
      ),
    );
  }

  Widget _showPilhanProsesResep(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.all(22),
          child: Text(
            'Pilih salah satu',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
          ),
        ),
        ListTile(
          onTap: () => Navigator.pop(context, 'bersedia'),
          contentPadding: EdgeInsets.symmetric(horizontal: 22, vertical: 8),
          title: Text('Bersedia'),
        ),
        Divider(
          height: 0,
          color: Colors.grey[400],
        ),
        ListTile(
          onTap: () => Navigator.pop(context, 'tidak'),
          contentPadding: EdgeInsets.symmetric(horizontal: 22, vertical: 8),
          title: Text('Tidak Bersedia'),
        ),
        SizedBox(
          height: MediaQuery.of(context).padding.bottom + 12,
        )
      ],
    );
  }

  Widget _streamProsesResepRacikan(BuildContext context) {
    return StreamBuilder<ApiResponse<ResepRacikanProsesModel>>(
      stream: _resepRacikanProsesBloc.resepRacikanProsesStream,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          switch (snapshot.data!.status) {
            case Status.loading:
              return LoadingKit();
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

  Widget _eresepRacikanWidget(BuildContext context, ResepRacikan racikan) {
    return Container(
      constraints: BoxConstraints(
        maxHeight: SizeConfig.blockSizeVertical * 92,
      ),
      child: SafeArea(
        top: false,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 22.0, vertical: 12.0),
              child: Row(
                children: [
                  Expanded(
                    child: Text(
                      'Resep Racikan',
                      style: TextStyle(
                          fontSize: 18.0, fontWeight: FontWeight.bold),
                    ),
                  ),
                  CloseButton(
                    color: Colors.grey[400],
                    onPressed: () => Navigator.pop(context),
                  )
                ],
              ),
            ),
            const Divider(
              height: 0,
            ),
            Flexible(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8.0),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    ListTile(
                      title: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Nama Racikan',
                            style: TextStyle(fontSize: 12, color: Colors.grey),
                          ),
                          Text(
                            '${racikan.namaRacikan}',
                          ),
                        ],
                      ),
                      subtitle: Text('${racikan.aturanPakai}'),
                    ),
                    ...racikan.barang!.map(
                      (barang) => ListTile(
                        visualDensity: VisualDensity.compact,
                        leading: Icon(Icons.keyboard_arrow_right_rounded),
                        horizontalTitleGap: 0,
                        dense: true,
                        title: Text('${barang.barang}'),
                      ),
                    ),
                    ListTile(
                      title: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Petunjuk Racikan',
                            style: TextStyle(fontSize: 12, color: Colors.grey),
                          ),
                          Text(
                            '${racikan.petunjuk}',
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(22),
              child: ElevatedButton(
                onPressed: () => Navigator.pop(context, 'kirim'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: kPrimaryColor,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(32)),
                  minimumSize: const Size(double.infinity, 45),
                ),
                child: const Text('Kirim E-Resep'),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _streamEresepRacikn(BuildContext context) {
    return StreamBuilder<ApiResponse<FileEresepRacikanModel>>(
      stream: _fileEresepRacikanBloc.fileEresepRacikanStream,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          switch (snapshot.data!.status) {
            case Status.loading:
              return LoadingKit();
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

class TransportasiResepRacikan extends StatefulWidget {
  const TransportasiResepRacikan({
    super.key,
    required this.data,
    this.idResep,
    this.reload,
    this.type = 'create',
  });

  final DetailKunjungan data;
  final Function(DetailKunjungan? data)? reload;
  final String type;
  final int? idResep;

  @override
  State<TransportasiResepRacikan> createState() =>
      _TransportasiResepRacikanState();
}

class _TransportasiResepRacikanState extends State<TransportasiResepRacikan> {
  final _transportasiResepRacikanBloc = TransportasiResepRacikanBloc();
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
    if (widget.data.transportasiResepRacikanMr!
        .where((transport) => transport.resepRacikanId == widget.idResep)
        .isNotEmpty) {
      _biaya.text =
          '${widget.data.transportasiResepRacikanMr!.where((transport) => transport.resepRacikanId == widget.idResep).first.biaya}';
    }
    showBarModalBottomSheet(
      context: context,
      builder: (context) {
        return Padding(
          padding: EdgeInsets.only(
              bottom: MediaQuery.of(context).viewInsets.bottom + 22),
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
      if (widget.idResep != null) {
        _transportasiResepRacikanBloc.idResepSink.add('${widget.idResep}');
      }
      _transportasiResepRacikanBloc.idKunjunganSink.add(widget.data.id!);
      _transportasiResepRacikanBloc.biayaSink.add(int.parse(_biaya.text));
      _transportasiResepRacikanBloc.saveTransportasiResepRacikan();
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
        if (!mounted) return;
        Navigator.pop(context, data);
      });
    });
  }

  @override
  dispose() {
    super.dispose();
    _transportasiResepRacikanBloc.dispose();
    _biaya.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: widget.type != 'view' ? _tambahTransport : null,
      dense: true,
      visualDensity: VisualDensity.compact,
      contentPadding: EdgeInsets.zero,
      title: Row(
        children: [
          const Text('Transportasi'),
          const SizedBox(
            width: 8.0,
          ),
          if (widget.type != 'view')
            const Icon(
              Icons.edit_note_rounded,
              size: 22.0,
              color: Colors.blue,
            )
        ],
      ),
      trailing: Text(_rupiah.format(widget.data.transportasiResepRacikanMr!
              .where((transport) => transport.resepRacikanId == widget.idResep)
              .isEmpty
          ? 0
          : widget.data.transportasiResepRacikanMr!
              .where((transport) => transport.resepRacikanId == widget.idResep)
              .first
              .biaya)),
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
    return StreamBuilder<ApiResponse<ResponseTransportasiResepRacikanModel>>(
      stream: _transportasiResepRacikanBloc.transportasiResepRacikanStream,
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
