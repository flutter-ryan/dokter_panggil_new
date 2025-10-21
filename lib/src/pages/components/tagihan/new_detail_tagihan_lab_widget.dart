import 'package:admin_dokter_panggil/src/blocs/delete_tagihan_tindakan_lab_bloc.dart';
import 'package:admin_dokter_panggil/src/blocs/dokumen_pengantar_lab_bloc.dart';
import 'package:admin_dokter_panggil/src/blocs/kunjungan_tindakan_lab_save_bloc.dart';
import 'package:admin_dokter_panggil/src/blocs/master_tindakan_lab_create_bloc.dart';
import 'package:admin_dokter_panggil/src/blocs/mr_dokumen_pengantar_lab_bloc.dart';
import 'package:admin_dokter_panggil/src/blocs/tagihan_tindakan_lab_bloc.dart';
import 'package:admin_dokter_panggil/src/blocs/tindakan_lab_proses_bloc.dart';
import 'package:admin_dokter_panggil/src/blocs/tindakan_lab_tagihan_bloc.dart';
import 'package:admin_dokter_panggil/src/models/dokumen_pengantar_lab_model.dart';
import 'package:admin_dokter_panggil/src/models/master_tindakan_lab_model.dart';
import 'package:admin_dokter_panggil/src/models/mr_dokumen_pengantar_lab_model.dart';
import 'package:admin_dokter_panggil/src/models/pasien_kunjungan_detail_model.dart';
import 'package:admin_dokter_panggil/src/models/tagihan_tindakan_lab_model.dart';
import 'package:admin_dokter_panggil/src/models/tindakan_lab_proses_model.dart';
import 'package:admin_dokter_panggil/src/models/tindakan_lab_tagihan_modal.dart';
import 'package:admin_dokter_panggil/src/pages/components/card_tagihan_lab.dart';
import 'package:admin_dokter_panggil/src/pages/components/confirm_dialog.dart';
import 'package:admin_dokter_panggil/src/pages/components/error_response.dart';
import 'package:admin_dokter_panggil/src/pages/components/error_dialog.dart';
import 'package:admin_dokter_panggil/src/pages/components/loading_kit.dart';
import 'package:admin_dokter_panggil/src/pages/components/success_dialog.dart';
import 'package:admin_dokter_panggil/src/pages/components/tagihan/tile_obat_widget.dart';
import 'package:admin_dokter_panggil/src/pages/components/tagihan/upload_hasil_lab.dart';
import 'package:admin_dokter_panggil/src/pages/components/transaksi_tindakan_lab.dart';
import 'package:admin_dokter_panggil/src/repositories/responseApi/api_response.dart';
import 'package:admin_dokter_panggil/src/source/config.dart';
import 'package:admin_dokter_panggil/src/source/size_config.dart';
import 'package:admin_dokter_panggil/src/source/transition/slide_bottom_route.dart';
import 'package:admin_dokter_panggil/src/source/transition/slide_left_route.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:admin_dokter_panggil/src/source/transition/animated_dialog.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:intl/intl.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:share_plus/share_plus.dart';

class NewDetailTagihanLabWidget extends StatefulWidget {
  const NewDetailTagihanLabWidget({
    super.key,
    required this.data,
    this.type = 'create',
    this.reload,
  });

  final DetailKunjungan data;
  final Function(DetailKunjungan data)? reload;
  final String type;

  @override
  State<NewDetailTagihanLabWidget> createState() =>
      _NewDetailTagihanLabWidgetState();
}

class _NewDetailTagihanLabWidgetState extends State<NewDetailTagihanLabWidget> {
  final _tindakanLabProsesBloc = TindakanLabProsesBloc();
  final _dokumenPengantarLabBloc = DokumenPengantarLabBloc();
  final _kunjunganTindakanLabSaveBloc = KunjunganTindakanLabSaveBloc();
  final _masterTindakanLabCreateBloc = MasterTindakanLabCreateBloc();
  final _deleteTagihanTindakanLabBloc = DeleteTagihanTindakanLabBloc();
  final _mrDokumenPengantarLabBloc = MrDokumenPengantarLabBloc();
  final _formKey = GlobalKey<FormState>();
  final _rupiah =
      NumberFormat.currency(locale: 'id', symbol: 'Rp. ', decimalDigits: 0);
  DetailKunjungan? _data;

  bool validateAndSave() {
    var formData = _formKey.currentState;
    if (formData!.validate()) {
      return true;
    }
    return false;
  }

  @override
  void initState() {
    super.initState();
    _loadListTindakanLab();
  }

  void _loadListTindakanLab() {
    _data = widget.data;
  }

  void _epengantar() {
    showMaterialModalBottomSheet(
      context: context,
      builder: (context) {
        return _modalPilihPegawai(context);
      },
      duration: const Duration(milliseconds: 500),
    ).then((value) {
      if (value != null) {
        var data = value as int;
        _dokumenPengantarLabBloc.idPegawaiSink.add(data.toString());
        _dialogEpengantar();
      }
    });
  }

  void _ePengantarLab(PengantarLabMr? pengantar) {
    showMaterialModalBottomSheet(
      context: context,
      builder: (context) {
        return _epengantarLabWidget(context, pengantar);
      },
      duration: const Duration(milliseconds: 500),
    ).then((value) {
      if (value != null) {
        Future.delayed(const Duration(milliseconds: 500), () {
          _kirimPengantarLab(pengantar);
        });
      }
    });
  }

  void _dialogEpengantar() {
    showAnimatedDialog(
      context: context,
      builder: (context) {
        return ConfirmDialogWidget(
          message: 'Anda yakin mengirim pengantar laboratorium ini?',
          onConfirm: () => Navigator.pop(context, 'kirim'),
          labelConfirm: 'Ya, Kirim',
        );
      },
      duration: const Duration(milliseconds: 500),
      animationType: DialogTransitionType.slideFromBottomFade,
    ).then((value) {
      if (value != null) {
        _dokumenPengantarLabBloc.idKunjunganSink.add(_data!.id!);
        _dokumenPengantarLabBloc.getDokumenPengantarLab();
        _showStreamDokumenPengantarLab();
      }
    });
  }

  void _showStreamDokumenPengantarLab() {
    showAnimatedDialog(
      context: context,
      builder: (context) {
        return _streamDokumenPengantarLab(context);
      },
      duration: const Duration(milliseconds: 500),
      animationType: DialogTransitionType.slideFromBottomFade,
    ).then((value) async {
      if (value != null) {
        var data = value as DokumenPengantarLab;
        Future.delayed(const Duration(milliseconds: 500), () {
          _shareDokumenPengantarLab(data);
        });
      }
    });
  }

  Future<void> _shareDokumenPengantarLab(DokumenPengantarLab data) async {
    SharePlus.instance.share(
      ShareParams(
        title: 'Pengantar Lab ${data.pasien!.namaPasien}',
        text:
            'Hai, ${data.pasien!.namaPasien}.\n\nDokumen ini adalah Pengantar Laboratorium\n${Uri.parse(data.linkDoc!).toString()}',
        subject: 'E-Pengantar ${data.pasien!.namaPasien}',
      ),
    );
  }

  void _showTindakanLab() {
    showBarModalBottomSheet(
      context: context,
      builder: (context) {
        return FormTagihanTindakanLab(
          data: widget.data,
        );
      },
      duration: const Duration(milliseconds: 500),
    ).then((value) {
      if (value != null) {
        var data = value as DetailKunjungan;
        widget.reload!(data);
      }
    });
  }

  void _deleteTindakanLab(int? id) {
    showAnimatedDialog(
      context: context,
      builder: (context) {
        return ConfirmDialogWidget(
          onConfirm: () => Navigator.pop(context, 'confirm'),
        );
      },
      animationType: DialogTransitionType.slideFromBottomFade,
    ).then((value) {
      if (value != null) {
        Future.delayed(const Duration(milliseconds: 500), () {
          _deleteTagihanTindakanLabBloc.idSink.add(id!);
          _deleteTagihanTindakanLabBloc.deleteTagihanTindakanLab();
          _showStreamDeleteTagihan();
        });
      }
    });
  }

  void _showStreamDeleteTagihan() {
    showAnimatedDialog(
      context: context,
      builder: (context) {
        return _buildStreamDeleteTagihan(context);
      },
      duration: const Duration(milliseconds: 500),
      animationType: DialogTransitionType.slideFromBottomFade,
    ).then((value) {
      if (value != null) {
        var data = value as DetailKunjungan;
        widget.reload!(data);
      }
    });
  }

  @override
  void didUpdateWidget(covariant NewDetailTagihanLabWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.data != widget.data) {
      if (oldWidget.data != widget.data) {
        _loadListTindakanLab();
        setState(() {});
      }
    }
  }

  void _prosesLab(PengantarLabMr? pengantar) {
    showMaterialModalBottomSheet(
      context: context,
      builder: (context) => _showPilhanProsesLab(context),
    ).then((value) {
      if (value != null) {
        var data = value as String;
        _tindakanLabProsesBloc.idPengantarSink.add(pengantar!.id!);
        _tindakanLabProsesBloc.statusSink.add(1);
        if (data == 'bersedia') {
          _tindakanLabProsesBloc.isBersediaSink.add(1);
        } else {
          _tindakanLabProsesBloc.isBersediaSink.add(0);
        }
        _tindakanLabProsesBloc.prosesTindakanLab();
        _showStreamTindakanLabProses();
      }
    });
  }

  void _showStreamTindakanLabProses() {
    showAnimatedDialog(
      context: context,
      builder: (context) => _buildStreamTindakanLabProsesWidget(context),
      animationType: DialogTransitionType.slideFromBottomFade,
    ).then((value) {
      if (value != null) {
        final data = value as PengantarLabMr;
        setState(() {
          _data!.pengantarLabMr![_data!.pengantarLabMr!
              .indexWhere((pengantar) => pengantar.id == data.id)] = data;
        });
      }
    });
  }

  void _kirimPengantarLab(PengantarLabMr? pengantar) {
    _mrDokumenPengantarLabBloc.idPengantarSink.add(pengantar!.id!);
    _mrDokumenPengantarLabBloc.getDokumenPengantarLab();
    _showStreamKirimPengantar();
  }

  void _showStreamKirimPengantar() {
    showAnimatedDialog(
      context: context,
      builder: (context) => _buildStreamKirimPengantar(context),
      animationType: DialogTransitionType.slideFromBottomFade,
    ).then((value) {
      if (value != null) {
        final data = value as DokumenPengantarLab;
        _shareDokumenPengantarLab(data);
      }
    });
  }

  void _uploadDokumen(PengantarLabMr pengantar) {
    Navigator.push(
      context,
      SlideLeftRoute(
        page: UploadHasilLab(
          idPengantar: pengantar.id,
        ),
      ),
    );
  }

  @override
  void dispose() {
    super.dispose();
    _masterTindakanLabCreateBloc.dispose();
    _deleteTagihanTindakanLabBloc.dispose();
    _kunjunganTindakanLabSaveBloc.dispose();
    _tindakanLabProsesBloc.dispose();
    _mrDokumenPengantarLabBloc.dispose();
  }

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    if (widget.data.isEmr == 0) return _oldTagihanLabWidget(context);
    return CardTagihanLab(
      title: 'Tindakan Laboratorium',
      subTotal: Text(
        _rupiah.format(_data!.totalTindakanLab! + _data!.transportLab!),
        style: const TextStyle(fontWeight: FontWeight.w600),
      ),
      tiles: Column(
        children: _data!.pengantarLabMr!
            .map(
              (pengantar) => Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.fromLTRB(0.0, 12.0, 8.0, 8.0),
                        child: Text(
                          '${pengantar.tanggalShort}\n${pengantar.jamShort}',
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
                                text: pengantar.petugasSbar == null
                                    ? '${pengantar.dokter} |'
                                    : '${pengantar.petugasSbar!.namaPetugas} |',
                                style: TextStyle(
                                    fontSize: 12,
                                    color: Colors.black,
                                    fontWeight: FontWeight.w600),
                                children: [
                                  TextSpan(
                                    text: ' E-Pengantar ',
                                    style: TextStyle(color: Colors.blueAccent),
                                    recognizer: TapGestureRecognizer()
                                      ..onTap = () => _ePengantarLab(pengantar),
                                  ),
                                  TextSpan(
                                    text: '|',
                                    style: TextStyle(color: Colors.black),
                                  ),
                                  TextSpan(
                                    text: pengantar.status == 0
                                        ? ' Belum diproses'
                                        : ' Sudah diproses',
                                    style: TextStyle(
                                        color: pengantar.status == 0
                                            ? Colors.red
                                            : Colors.green),
                                    recognizer: TapGestureRecognizer()
                                      ..onTap = widget.type == 'create'
                                          ? () => _prosesLab(pengantar)
                                          : null,
                                  ),
                                  if (pengantar.status == 1)
                                    TextSpan(
                                      text: ' |',
                                      style: TextStyle(color: Colors.black),
                                    ),
                                  if (pengantar.status == 1)
                                    TextSpan(
                                      text: pengantar.isBersedia == 0
                                          ? ' Tidak bersedia'
                                          : ' Bersedia',
                                      style: TextStyle(
                                          color: pengantar.isBersedia == 0
                                              ? Colors.red
                                              : Colors.green),
                                    ),
                                  TextSpan(
                                    text: ' |',
                                    style: TextStyle(color: Colors.black),
                                  ),
                                  TextSpan(
                                      text: ' Upload Hasil',
                                      style: TextStyle(color: Colors.blue),
                                      recognizer: TapGestureRecognizer()
                                        ..onTap =
                                            () => _uploadDokumen(pengantar)),
                                ]),
                          ),
                        ),
                      ),
                    ],
                  ),
                  ..._data!.tagihanTindakanLab!
                      .where((tagihan) => tagihan.pengantarId == pengantar.id)
                      .map((tagihanLab) => TileObatWidget(
                            onTap: widget.type != 'view'
                                ? () => _deleteTindakanLab(tagihanLab.id)
                                : null,
                            isEdit: widget.type != 'view',
                            title: '${tagihanLab.tindakanLab!.namaTindakanLab}',
                            leading: Padding(
                              padding: const EdgeInsets.only(top: 0.0),
                              child: Text(
                                '${tagihanLab.createdAt}',
                                style: TextStyle(fontSize: 12),
                              ),
                            ),
                            trailing: _rupiah.format(tagihanLab.total),
                            iconData: Icons.delete_rounded,
                          )),
                  if (pengantar.status == 1)
                    SizedBox(
                      height: 12,
                    ),
                  if (pengantar.status == 1 &&
                      pengantar.isBersedia == 1 &&
                      widget.type == 'create')
                    ElevatedButton.icon(
                      onPressed: () => Navigator.push(
                        context,
                        SlideBottomRoute(
                          page: TransaksiTindakanLab(
                            idKunjungan: _data!.id!,
                            dataLab: pengantar.tindakanLab!,
                            idPengantar: pengantar.id,
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
                        'Transaksi Tindakan Laboratorium',
                      ),
                    )
                ],
              ),
            )
            .toList(),
      ),
    );
  }

  Widget _oldTagihanLabWidget(BuildContext context) {
    return CardTagihanLab(
      title: 'Laboratorium',
      buttonDetail: CircleAvatar(
        backgroundColor: Colors.grey[100],
        child: IconButton(
          onPressed: _epengantar,
          icon: SvgPicture.asset(
            'images/document.svg',
            height: 18,
          ),
        ),
      ),
      tiles: Column(
        children: [
          const SizedBox(
            height: 12.0,
          ),
          if (_data!.tagihanTindakanLab!.isNotEmpty)
            Container(
              margin: const EdgeInsets.only(bottom: 12),
              decoration: BoxDecoration(
                color: Colors.green.withAlpha(20),
                border: Border.all(color: Colors.green, width: 0.5),
                borderRadius: BorderRadius.circular(8.0),
              ),
              child: ListTile(
                onTap: _showTindakanLab,
                dense: true,
                title: Text(
                  'Transaksi tindakan lab',
                  style: TextStyle(color: Colors.grey[600]),
                ),
                trailing: const Icon(
                  Icons.keyboard_arrow_right,
                  color: Colors.grey,
                ),
              ),
            ),
          if (_data!.tagihanTindakanLab!.isEmpty)
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
                    'Data tagihan tindakan laboratorium tidak tersedia',
                    style: TextStyle(fontSize: 15, color: Colors.grey),
                    textAlign: TextAlign.center,
                  ),
                  if (widget.type != 'view')
                    const SizedBox(
                      height: 18.0,
                    ),
                  if (widget.type != 'view')
                    ElevatedButton(
                      onPressed: _showTindakanLab,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: kPrimaryColor,
                      ),
                      child: const Text('Transaksi tindakan lab'),
                    )
                ],
              ),
            )
          else
            Column(
              children: ListTile.divideTiles(
                      context: context,
                      tiles: _data!.tagihanTindakanLab!
                          .map(
                            (TagihanTindakanLab tindakanLab) => Column(
                              children: [
                                ListTile(
                                  onTap: widget.type != 'view'
                                      ? () => _deleteTindakanLab(tindakanLab.id)
                                      : null,
                                  dense: true,
                                  horizontalTitleGap: 0,
                                  contentPadding: EdgeInsets.zero,
                                  title: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Flexible(
                                        child: Text(
                                            '${tindakanLab.tindakanLab!.namaTindakanLab}'),
                                      ),
                                      const SizedBox(
                                        width: 12.0,
                                      ),
                                      if (widget.type != 'view')
                                        const Icon(
                                          Icons.delete_outline_rounded,
                                          size: 22.0,
                                          color: Colors.red,
                                        )
                                    ],
                                  ),
                                  trailing: Text(
                                    _rupiah.format(tindakanLab.total),
                                  ),
                                ),
                              ],
                            ),
                          )
                          .toList())
                  .toList(),
            ),
        ],
      ),
      subTotal: Text(
        _rupiah.format(_data!.totalTindakanLab! + _data!.transportLab!),
        style: const TextStyle(fontWeight: FontWeight.w600),
      ),
    );
  }

  Widget _streamDokumenPengantarLab(BuildContext context) {
    return StreamBuilder<ApiResponse<ResponseDokumenPengantarLabModel>>(
      stream: _dokumenPengantarLabBloc.dokumenPengantarLabStream,
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

  Widget _modalPilihPegawai(BuildContext context) {
    return SizedBox(
      height: SizeConfig.blockSizeVertical * 70,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 16.0),
            child: Text(
              'Pengantar Laboratorium',
              style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),
            ),
          ),
          const Divider(
            height: 0,
          ),
          Flexible(
            child: DefaultTabController(
              length: _data!.pegawai!.length,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  TabBar(
                    labelColor: Colors.black,
                    isScrollable: true,
                    unselectedLabelColor: Colors.grey[400],
                    indicatorColor: kPrimaryColor,
                    tabs: _data!.pegawai!
                        .map(
                          (pegawai) => Tab(
                            text: '${pegawai.nama}',
                          ),
                        )
                        .toList(),
                  ),
                  const Divider(
                    height: 0,
                  ),
                  Flexible(
                    child: TabBarView(
                      children: _data!.pegawai!
                          .map(
                            (pegawai) => ListTindakanPengantarLab(
                              idKunjungan: _data!.id!,
                              idPegawai: pegawai.id!,
                            ),
                          )
                          .toList(),
                    ),
                  )
                ],
              ),
            ),
          )
        ],
      ),
    );
  }

  Widget _epengantarLabWidget(BuildContext context, PengantarLabMr? pengantar) {
    return Container(
      constraints: BoxConstraints(
        maxHeight: SizeConfig.blockSizeVertical * 92,
      ),
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
                    'Pengantar Laboratorium',
                    style:
                        TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),
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
            child: ListView.separated(
              shrinkWrap: true,
              padding: const EdgeInsets.symmetric(vertical: 12.0),
              itemCount: pengantar!.tindakanLab!.length,
              itemBuilder: (context, i) {
                var tindakan = pengantar.tindakanLab![i];
                return ListTile(
                  contentPadding: const EdgeInsets.symmetric(horizontal: 22.0),
                  title: Text('${tindakan.tindakanLab}'),
                );
              },
              separatorBuilder: (context, i) => const Divider(
                height: 0,
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
              child: const Text('Kirim E-pengantar'),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStreamDeleteTagihan(BuildContext context) {
    return StreamBuilder<ApiResponse<ResponseTagihanTindakanLabModel>>(
        stream: _deleteTagihanTindakanLabBloc.deleteTagihanTindakanLabStream,
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
                var data = snapshot.data!.data!.data;
                return SuccessDialog(
                  message: snapshot.data!.data!.message,
                  onTap: () => Navigator.pop(context, data),
                );
            }
          }
          return const SizedBox();
        });
  }

  Widget _showPilhanProsesLab(BuildContext context) {
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

  Widget _buildStreamTindakanLabProsesWidget(BuildContext context) {
    return StreamBuilder<ApiResponse<TindakanLabProsesModel>>(
      stream: _tindakanLabProsesBloc.tindakanLabProsesStream,
      builder: (contex, snapshot) {
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

  Widget _buildStreamKirimPengantar(BuildContext context) {
    return StreamBuilder<ApiResponse<MrDokumenPengantarLabModel>>(
      stream: _mrDokumenPengantarLabBloc.dokumenPengantarLabStream,
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

class ListTindakanPengantarLab extends StatefulWidget {
  const ListTindakanPengantarLab({
    super.key,
    required this.idPegawai,
    required this.idKunjungan,
  });

  final int idPegawai;
  final int idKunjungan;

  @override
  State<ListTindakanPengantarLab> createState() =>
      _ListTindakanPengantarLabState();
}

class _ListTindakanPengantarLabState extends State<ListTindakanPengantarLab> {
  final _dokumenPengantarLabBloc = DokumenPengantarLabBloc();
  @override
  void initState() {
    super.initState();
    _getListTindakan();
  }

  void _getListTindakan() {
    _dokumenPengantarLabBloc.idPegawaiSink.add(widget.idPegawai.toString());
    _dokumenPengantarLabBloc.idKunjunganSink.add(widget.idKunjungan);
    _dokumenPengantarLabBloc.getListTindakanLab();
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<ApiResponse<ResponseListTindakanLabPengantarModel>>(
      stream: _dokumenPengantarLabBloc.listTindakanLabStream,
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
                  _getListTindakan();
                  setState(() {});
                },
              );
            case Status.completed:
              return Column(
                children: [
                  Expanded(
                    child: ListView.separated(
                      padding: const EdgeInsets.symmetric(vertical: 12.0),
                      itemCount: snapshot.data!.data!.data!.length,
                      itemBuilder: (context, i) {
                        var tindakan = snapshot.data!.data!.data![i];
                        return ListTile(
                          contentPadding:
                              const EdgeInsets.symmetric(horizontal: 22.0),
                          title: Text('${tindakan.tindakan}'),
                        );
                      },
                      separatorBuilder: (context, i) => const Divider(
                        height: 0,
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(18),
                    child: ElevatedButton(
                      onPressed: () => Navigator.pop(context, widget.idPegawai),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: kPrimaryColor,
                        minimumSize: const Size(double.infinity, 45),
                      ),
                      child: const Text('Kirim E-pengantar'),
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

class EditTindakanLabModel {
  EditTindakanLabModel({
    this.id,
    this.tindakanLab,
  });

  final int? id;
  final MasterTindakanLab? tindakanLab;
}

class FormTagihanTindakanLab extends StatefulWidget {
  const FormTagihanTindakanLab({
    super.key,
    this.data,
  });

  final DetailKunjungan? data;

  @override
  State<FormTagihanTindakanLab> createState() => _FormTagihanTindakanLabState();
}

class _FormTagihanTindakanLabState extends State<FormTagihanTindakanLab> {
  final _tagihanTindakanLabBloc = TagihanTindakanLabBloc();
  final _tindakanLabTagihanBloc = TindakanLabTagihanBloc();
  final List<TindakanLabTagihan> _selectedTindakan = [];
  final _isPaket = false;

  @override
  void initState() {
    super.initState();
    _tindakanLabTagihanBloc.getTindakanLabTagihan();
  }

  void _selectTindakanLab(TindakanLabTagihan? tindakan) {
    _selectedTindakan.add(tindakan!);
    setState(() {});
  }

  void _saveTindakanLab() {
    List<int> idTindakan = [];
    List<int> hargaModal = [];
    List<int> tarifAplikasi = [];
    for (var tindakan in _selectedTindakan) {
      idTindakan.add(tindakan.id!);
      hargaModal.add(tindakan.hargaModal!);
      tarifAplikasi.add(tindakan.tarifAplikasi!);
    }
    _tagihanTindakanLabBloc.normSink.add(widget.data!.pasien!.norm!);
    _tagihanTindakanLabBloc.idTindakanSink.add(idTindakan);
    _tagihanTindakanLabBloc.hargaModalSink.add(hargaModal);
    _tagihanTindakanLabBloc.tarifAplikasiSink.add(tarifAplikasi);
    _tagihanTindakanLabBloc.idKunjunganSink.add(widget.data!.id!);
    _tagihanTindakanLabBloc.isPaketSink.add(_isPaket);
    _tagihanTindakanLabBloc.saveTindakanLab();
    _showStreamTindakanLab();
  }

  void _showStreamTindakanLab() {
    showAnimatedDialog(
      context: context,
      builder: (context) {
        return _buildStreamTindakanLab(context);
      },
      duration: const Duration(milliseconds: 500),
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

  @override
  void dispose() {
    _tindakanLabTagihanBloc.dispose();
    _tagihanTindakanLabBloc.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<ApiResponse<TindakanLabTagihanModel>>(
      stream: _tindakanLabTagihanBloc.tindakanLabTagihanStream,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          switch (snapshot.data!.status) {
            case Status.loading:
              return SizedBox(
                height: SizeConfig.blockSizeVertical * 40,
                child: const LoadingKit(
                  color: kPrimaryColor,
                ),
              );
            case Status.error:
              return SizedBox(
                height: SizeConfig.blockSizeVertical * 40,
                child: Center(
                  child: ErrorResponse(
                    message: snapshot.data!.message,
                    onTap: () {
                      _tindakanLabTagihanBloc.getTindakanLabTagihan();
                      setState(() {});
                    },
                  ),
                ),
              );
            case Status.completed:
              var data = snapshot.data!.data!.data;
              return Container(
                constraints: BoxConstraints(
                  maxHeight: SizeConfig.blockSizeVertical * 90,
                ),
                child: DefaultTabController(
                  length: data!.length,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Padding(
                        padding: EdgeInsets.all(22.0),
                        child: Text(
                          'Tindakan Laboratoium',
                          style: TextStyle(
                              fontSize: 20, fontWeight: FontWeight.bold),
                        ),
                      ),
                      const Divider(
                        height: 0,
                      ),
                      TabBar(
                        isScrollable: true,
                        padding: const EdgeInsets.all(12),
                        indicatorSize: TabBarIndicatorSize.label,
                        labelPadding:
                            const EdgeInsets.symmetric(horizontal: 6.0),
                        tabs: data
                            .map((mitra) => Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 22,
                                  ),
                                  decoration: BoxDecoration(
                                    border: Border.all(color: kPrimaryColor),
                                    borderRadius: BorderRadius.circular(32),
                                  ),
                                  child: Tab(
                                    text: mitra.namaMitra,
                                  ),
                                ))
                            .toList(),
                        unselectedLabelColor: Colors.red[200],
                        indicator: ShapeDecoration(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(32),
                          ),
                          color: kPrimaryColor,
                        ),
                      ),
                      Expanded(
                        child: TabBarView(
                          children: data
                              .map(
                                (mitra) => Column(
                                  children: [
                                    Expanded(
                                      child: ListView.separated(
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 10.0, vertical: 6),
                                        itemBuilder: (_, i) {
                                          var data = mitra.tindakanLab?[i];
                                          return ListTile(
                                            onTap: () =>
                                                _selectTindakanLab(data),
                                            title: Text(
                                                '${data?.namaTindakanLab}'),
                                            titleTextStyle: const TextStyle(
                                                fontSize: 15,
                                                fontWeight: FontWeight.normal,
                                                color: Colors.black),
                                            trailing: _selectedTindakan
                                                    .where((tindakan) =>
                                                        tindakan.id == data!.id)
                                                    .isNotEmpty
                                                ? const Icon(
                                                    Icons.check_circle,
                                                    color: Colors.green,
                                                  )
                                                : const SizedBox(),
                                          );
                                        },
                                        separatorBuilder: (_, i) =>
                                            const Divider(
                                          height: 0,
                                        ),
                                        itemCount: mitra.tindakanLab!.length,
                                      ),
                                    ),
                                  ],
                                ),
                              )
                              .toList(),
                        ),
                      ),
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.symmetric(
                            horizontal: 18.0, vertical: 12),
                        decoration: const BoxDecoration(
                            color: Colors.white,
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black12,
                                blurRadius: 6,
                                offset: Offset(0, -3),
                              )
                            ]),
                        child: SafeArea(
                          top: false,
                          child: ElevatedButton(
                            onPressed: _saveTindakanLab,
                            style: ElevatedButton.styleFrom(
                              minimumSize: const Size.fromHeight(45),
                              backgroundColor: kPrimaryColor,
                            ),
                            child: const Text('Simpan Tindakan Lab'),
                          ),
                        ),
                      )
                    ],
                  ),
                ),
              );
          }
        }
        return const SizedBox();
      },
    );
  }

  Widget _buildStreamTindakanLab(BuildContext context) {
    return StreamBuilder<ApiResponse<ResponseTagihanTindakanLabModel>>(
        stream: _tagihanTindakanLabBloc.tagihanTindakanLabStream,
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
                  onTap: () =>
                      Navigator.pop(context, snapshot.data!.data!.data),
                );
            }
          }
          return const SizedBox();
        });
  }
}
