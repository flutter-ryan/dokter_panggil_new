import 'package:admin_dokter_panggil/src/blocs/delete_tagihan_tindakan_rad_bloc.dart';
import 'package:admin_dokter_panggil/src/blocs/dokumen_pengantar_rad_bloc.dart';
import 'package:admin_dokter_panggil/src/blocs/master_tindakan_rad_create_bloc.dart';
import 'package:admin_dokter_panggil/src/blocs/mr_dokumen_pengantar_rad_bloc.dart';
import 'package:admin_dokter_panggil/src/blocs/tagihan_tindakan_rad_bloc.dart';
import 'package:admin_dokter_panggil/src/blocs/tindakan_rad_proses_bloc.dart';
import 'package:admin_dokter_panggil/src/models/dokumen_pengantar_rad_model.dart';
import 'package:admin_dokter_panggil/src/models/master_tindakan_rad_create_mode.dart';
import 'package:admin_dokter_panggil/src/models/mr_dokumen_pengantar_rad_model.dart';
import 'package:admin_dokter_panggil/src/models/pasien_kunjungan_detail_model.dart';
import 'package:admin_dokter_panggil/src/models/tagihan_tindakan_rad_model.dart';
import 'package:admin_dokter_panggil/src/models/tindakan_rad_proses_model.dart';
import 'package:admin_dokter_panggil/src/pages/components/card_tagihan_lab.dart';
import 'package:admin_dokter_panggil/src/pages/components/confirm_dialog.dart';
import 'package:admin_dokter_panggil/src/pages/components/error_dialog.dart';
import 'package:admin_dokter_panggil/src/pages/components/loading_kit.dart';
import 'package:admin_dokter_panggil/src/pages/components/success_dialog.dart';
import 'package:admin_dokter_panggil/src/pages/components/tagihan/tile_obat_widget.dart';
import 'package:admin_dokter_panggil/src/pages/components/tagihan/upload_dokumen_rad.dart';
import 'package:admin_dokter_panggil/src/pages/components/transaksi_tindakan_rad.dart';
import 'package:admin_dokter_panggil/src/repositories/responseApi/api_response.dart';
import 'package:admin_dokter_panggil/src/source/config.dart';
import 'package:admin_dokter_panggil/src/source/size_config.dart';
import 'package:admin_dokter_panggil/src/source/transition/slide_bottom_route.dart';
import 'package:admin_dokter_panggil/src/source/transition/slide_left_route.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:admin_dokter_panggil/src/source/transition/animated_dialog.dart';
import 'package:flutter_svg/svg.dart';
import 'package:intl/intl.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:admin_dokter_panggil/src/pages/components/error_response.dart';
import 'package:share_plus/share_plus.dart';

class NewDetailTagihanRadWidget extends StatefulWidget {
  const NewDetailTagihanRadWidget({
    super.key,
    required this.data,
    this.type = 'create',
    this.reload,
  });

  final DetailKunjungan data;
  final Function(DetailKunjungan data)? reload;
  final String type;

  @override
  State<NewDetailTagihanRadWidget> createState() =>
      _NewDetailTagihanRadWidgetState();
}

class _NewDetailTagihanRadWidgetState extends State<NewDetailTagihanRadWidget> {
  final _dokumenPengantarRadBloc = DokumenPengantarRadBloc();
  final _deleteTagihanTindakanRadBloc = DeleteTagihanTindakanRadBloc();
  final _tindakanRadProsesBloc = TindakanRadProsesBloc();
  final _mrDokumenPengantarRadBloc = MrDokumenPengantarRadBloc();
  final _rupiah =
      NumberFormat.currency(locale: 'id', symbol: 'Rp. ', decimalDigits: 0);
  late DetailKunjungan _data;

  @override
  void initState() {
    super.initState();
    _loadTindakanRad();
  }

  void _loadTindakanRad() {
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
        _dokumenPengantarRadBloc.idPegawaiSink.add(data.toString());
        _dialogEpengantar();
      }
    });
  }

  void _ePengantarRad(PengantarRadMr? pengantar) {
    showMaterialModalBottomSheet(
      context: context,
      builder: (context) => _modalEresepMr(context, pengantar),
    ).then((value) {
      if (value != null) {
        Future.delayed(const Duration(milliseconds: 500), () {
          _kirimPengantar(pengantar);
        });
      }
    });
  }

  void _dialogEpengantar() {
    showAnimatedDialog(
      context: context,
      builder: (context) {
        return ConfirmDialogWidget(
          message: 'Anda yakin mengirim pengantar radiologi ini?',
          onConfirm: () => Navigator.pop(context, 'kirim'),
          labelConfirm: 'Ya, Kirim',
        );
      },
      duration: const Duration(milliseconds: 500),
      animationType: DialogTransitionType.slideFromBottomFade,
    ).then((value) {
      if (value != null) {
        _dokumenPengantarRadBloc.idKunjunganSink.add(_data.id!);
        _dokumenPengantarRadBloc.getDokumenPengantarRad();
        _showStreamDokumenPengantarRad();
      }
    });
  }

  void _showStreamDokumenPengantarRad() {
    showAnimatedDialog(
      context: context,
      builder: (context) {
        return _streamDokumenPengantarRad(context);
      },
      duration: const Duration(milliseconds: 500),
      animationType: DialogTransitionType.slideFromBottomFade,
    ).then((value) {
      if (value != null) {
        var data = value as DokumenPengantarRad;
        Future.delayed(const Duration(milliseconds: 500), () {
          _shareDokumenPengantarRad(data);
        });
      }
    });
  }

  Future<void> _shareDokumenPengantarRad(DokumenPengantarRad data) async {
    SharePlus.instance.share(
      ShareParams(
        title: 'Pengantar Lab ${data.pasien!.namaPasien}',
        text:
            'Hai, ${data.pasien!.namaPasien}.\n\nDokumen ini adalah Pengantar Radiologi\n${Uri.parse(data.linkDoc!).toString()}',
        subject: 'E-Pengantar ${data.pasien!.namaPasien}',
      ),
    );
  }

  void _showTindakanRad() {
    showMaterialModalBottomSheet(
      context: context,
      builder: (context) {
        return FormTagihanTindakanRad(
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

  void _deleteTindakanRad(int? id) {
    showAnimatedDialog(
      context: context,
      builder: (context) {
        return ConfirmDialogWidget(
          onConfirm: () => Navigator.pop(context, 'confirm'),
        );
      },
      duration: const Duration(milliseconds: 500),
      animationType: DialogTransitionType.slideFromBottomFade,
    ).then((value) {
      if (value != null) {
        _deleteTagihanTindakanRadBloc.idTagihanRadSink.add(id!);
        _deleteTagihanTindakanRadBloc.deleteTagihanRad();
        Future.delayed(const Duration(milliseconds: 500), () {
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

  void _prosesRad(PengantarRadMr? pengantar) {
    showMaterialModalBottomSheet(
      context: context,
      builder: (context) => _showPilhanProsesRad(context),
    ).then((value) {
      if (value != null) {
        var data = value as String;
        _tindakanRadProsesBloc.idPengantarSink.add(pengantar!.id!);
        if (data == 'bersedia') {
          _tindakanRadProsesBloc.isBersediaSink.add(1);
        } else {
          _tindakanRadProsesBloc.isBersediaSink.add(0);
        }
        _tindakanRadProsesBloc.statusSink.add(1);
        _tindakanRadProsesBloc.prosesTindakanRad();
        _showStreamProsesRad();
      }
    });
  }

  void _showStreamProsesRad() {
    showAnimatedDialog(
      context: context,
      builder: (context) => _buildStreamRadProsesWidget(context),
      animationType: DialogTransitionType.slideFromBottomFade,
    ).then((value) {
      if (value != null) {
        final data = value as PengantarRadMr;
        setState(() {
          _data.pengantarRadMr![_data.pengantarRadMr!
              .indexWhere((pengantar) => pengantar.id == data.id)] = data;
        });
      }
    });
  }

  void _kirimPengantar(PengantarRadMr? pengantar) {
    _mrDokumenPengantarRadBloc.idPengantarSink.add(pengantar!.id!);
    _mrDokumenPengantarRadBloc.getDokumenPengantarRad();
    _showStreamKirimPengantar();
  }

  void _showStreamKirimPengantar() {
    showAnimatedDialog(
      context: context,
      builder: (context) => _buildStreamKirimPengantar(context),
      animationType: DialogTransitionType.slideFromBottomFade,
    ).then((value) {
      if (value != null) {
        final data = value as DokumenPengantarRad;
        _shareDokumenPengantarRad(data);
      }
    });
  }

  void _uploadDokumenRad(PengantarRadMr pengantar) {
    Navigator.push(
      context,
      SlideLeftRoute(
        page: UploadDokumenRad(
          idPengantar: pengantar.id,
        ),
      ),
    );
  }

  @override
  void dispose() {
    _dokumenPengantarRadBloc.dispose();
    _deleteTagihanTindakanRadBloc.dispose();
    _tindakanRadProsesBloc.dispose();
    super.dispose();
  }

  @override
  void didUpdateWidget(covariant NewDetailTagihanRadWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.data != widget.data) {
      _loadTindakanRad();
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    if (widget.data.isEmr == 0) {
      return _oldTindakanRad(context);
    }
    return CardTagihanLab(
      title: 'Tindakan Radiologi',
      tiles: Column(
          children: _data.pengantarRadMr!
              .map(
                (pengantar) => Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding:
                              const EdgeInsets.fromLTRB(0.0, 12.0, 8.0, 8.0),
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
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                RichText(
                                  text: TextSpan(
                                      text: pengantar.petugasSbar == null
                                          ? '${pengantar.dokter} |'
                                          : '${pengantar.petugasSbar!.namaPetugas}',
                                      style: TextStyle(
                                          fontSize: 12,
                                          color: Colors.black,
                                          fontWeight: FontWeight.w600),
                                      children: [
                                        TextSpan(
                                          text: ' E-Pengantar ',
                                          style: TextStyle(
                                              color: Colors.blueAccent),
                                          recognizer: TapGestureRecognizer()
                                            ..onTap =
                                                () => _ePengantarRad(pengantar),
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
                                                ? () => _prosesRad(pengantar)
                                                : null,
                                        ),
                                        if (pengantar.status == 1)
                                          TextSpan(
                                            text: ' |',
                                            style:
                                                TextStyle(color: Colors.black),
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
                                          style: TextStyle(
                                              color: Colors.blueAccent),
                                          recognizer: TapGestureRecognizer()
                                            ..onTap = widget.type == 'create'
                                                ? () =>
                                                    _uploadDokumenRad(pengantar)
                                                : null,
                                        )
                                      ]),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                    ..._data.tagihanTindakanRad!
                        .where((tagihan) => tagihan.pengantarId == pengantar.id)
                        .map((tagihanRad) => TileObatWidget(
                              onTap: widget.type != 'view'
                                  ? () => _deleteTindakanRad(tagihanRad.id)
                                  : null,
                              isEdit: widget.type != 'view',
                              title: '${tagihanRad.tindakanRad!.namaTindakan}',
                              leading: Padding(
                                padding: const EdgeInsets.only(top: 0.0),
                                child: Text(
                                  '${tagihanRad.createdAt}',
                                  style: TextStyle(fontSize: 12),
                                ),
                              ),
                              trailing: _rupiah.format(tagihanRad.total),
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
                            page: TransaksiTindakanRad(
                              idKunjungan: _data.id!,
                              dataRad: pengantar.tindakanRad!,
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
                          'Transaksi Tindakan Radiologi',
                        ),
                      )
                  ],
                ),
              )
              .toList()),
      subTotal: Text(
        _rupiah.format(_data.totalTindakanRad! + _data.transportRad!),
        style: const TextStyle(fontWeight: FontWeight.w600),
      ),
    );
  }

  Widget _oldTindakanRad(BuildContext context) {
    return CardTagihanLab(
      title: 'Tindakan Radiologi',
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
      tiles: Column(children: [
        const SizedBox(height: 12.0),
        if (_data.tagihanTindakanRad!.isNotEmpty)
          Container(
            margin: const EdgeInsets.only(bottom: 12),
            decoration: BoxDecoration(
              color: Colors.green.withAlpha(20),
              border: Border.all(color: Colors.green, width: 0.5),
              borderRadius: BorderRadius.circular(8.0),
            ),
            child: ListTile(
              onTap: _showTindakanRad,
              dense: true,
              title: Text(
                'Transaksi tindakan rad',
                style: TextStyle(color: Colors.grey[600]),
              ),
              trailing: const Icon(
                Icons.keyboard_arrow_right,
                color: Colors.grey,
              ),
            ),
          ),
        if (_data.tagihanTindakanRad!.isEmpty)
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
                  'Data tagihan radiologi tidak tersedia',
                  style: TextStyle(fontSize: 15, color: Colors.grey),
                  textAlign: TextAlign.center,
                ),
                if (widget.type != 'view')
                  const SizedBox(
                    height: 18.0,
                  ),
                if (widget.type != 'view')
                  ElevatedButton(
                    onPressed: _showTindakanRad,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: kPrimaryColor,
                    ),
                    child: const Text('Transaksi tindakan Rad'),
                  )
              ],
            ),
          )
        else
          Column(
            children: ListTile.divideTiles(
              context: context,
              tiles: _data.tagihanTindakanRad!
                  .map(
                    (tindakanRad) => Column(
                      children: [
                        ListTile(
                          onTap: widget.type != 'view'
                              ? () => _deleteTindakanRad(tindakanRad.id)
                              : null,
                          dense: true,
                          horizontalTitleGap: 0,
                          contentPadding: EdgeInsets.zero,
                          title: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Flexible(
                                  child: Text(
                                      '${tindakanRad.tindakanRad!.namaTindakan}')),
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
                            _rupiah.format(tindakanRad.total),
                          ),
                        ),
                      ],
                    ),
                  )
                  .toList(),
            ).toList(),
          )
      ]),
      subTotal: Text(
        _rupiah.format(_data.totalTindakanRad! + _data.transportRad!),
        style: const TextStyle(fontWeight: FontWeight.w600),
      ),
    );
  }

  Widget _modalEresepMr(BuildContext context, PengantarRadMr? pengantar) {
    return Container(
      constraints: BoxConstraints(
          minHeight: SizeConfig.blockSizeVertical * 20,
          maxHeight: SizeConfig.blockSizeVertical * 94),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 22, vertical: 12),
            child: Row(
              children: [
                Expanded(
                  child: Text(
                    'E-PENGANTAR Tindakan Radiologi',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
                  ),
                ),
                CloseButton(
                  color: Colors.grey[400],
                  onPressed: () => Navigator.pop(context),
                )
              ],
            ),
          ),
          Flexible(
            child: ListView.separated(
              shrinkWrap: true,
              padding: EdgeInsets.all(12),
              itemBuilder: (context, i) {
                final tindakanRad = pengantar.tindakanRad![i];
                return ListTile(
                  title: Text('${tindakanRad.tindakanRad}'),
                  contentPadding: EdgeInsets.symmetric(horizontal: 16),
                );
              },
              separatorBuilder: (context, i) => SizedBox(
                height: 18,
              ),
              itemCount: pengantar!.tindakanRad!.length,
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 22.0),
            child: ElevatedButton(
              onPressed: () => Navigator.pop(context, 'kirim'),
              style: ElevatedButton.styleFrom(
                  minimumSize: Size(double.infinity, 42),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(32),
                  )),
              child: Text('Kirim E-Pengantar'),
            ),
          ),
          SizedBox(
            height: MediaQuery.of(context).padding.bottom,
          )
        ],
      ),
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
              'Pengantar Radiologi',
              style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),
            ),
          ),
          const Divider(
            height: 0,
          ),
          Flexible(
            child: DefaultTabController(
              length: _data.pegawai!.length,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  TabBar(
                    labelColor: Colors.black,
                    isScrollable: true,
                    unselectedLabelColor: Colors.grey[400],
                    indicatorColor: kPrimaryColor,
                    tabs: _data.pegawai!
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
                      children: _data.pegawai!
                          .map(
                            (pegawai) => ListTindakanPengantarRad(
                              idKunjungan: _data.id!,
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

  Widget _streamDokumenPengantarRad(BuildContext context) {
    return StreamBuilder<ApiResponse<ResponseDokumenPengantarRadModel>>(
      stream: _dokumenPengantarRadBloc.dokumenPengantarRadStream,
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

  Widget _buildStreamDeleteTagihan(BuildContext context) {
    return StreamBuilder<ApiResponse<ResponseTagihanTindakanRadModel>>(
        stream: _deleteTagihanTindakanRadBloc.tagihanTindakanRadStream,
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

  Widget _showPilhanProsesRad(BuildContext context) {
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

  Widget _buildStreamRadProsesWidget(BuildContext context) {
    return StreamBuilder<ApiResponse<TindakanRadProsesModel>>(
      stream: _tindakanRadProsesBloc.tindakanRadProsesStream,
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

  Widget _buildStreamKirimPengantar(BuildContext context) {
    return StreamBuilder<ApiResponse<MrDokumenPengantarRadModel>>(
      stream: _mrDokumenPengantarRadBloc.dokumenPengantarRadStream,
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

class ListTindakanPengantarRad extends StatefulWidget {
  const ListTindakanPengantarRad({
    super.key,
    required this.idKunjungan,
    required this.idPegawai,
  });

  final int idKunjungan;
  final int idPegawai;

  @override
  State<ListTindakanPengantarRad> createState() =>
      _ListTindakanPengantarRadState();
}

class _ListTindakanPengantarRadState extends State<ListTindakanPengantarRad> {
  final _dokumenPengantarRadBloc = DokumenPengantarRadBloc();

  @override
  void initState() {
    super.initState();
    _getListTindakanRad();
  }

  void _getListTindakanRad() {
    _dokumenPengantarRadBloc.idKunjunganSink.add(widget.idKunjungan);
    _dokumenPengantarRadBloc.idPegawaiSink.add(widget.idPegawai.toString());
    _dokumenPengantarRadBloc.getListTindakanRad();
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<ApiResponse<ResponseListTindakanRadPengantarModel>>(
      stream: _dokumenPengantarRadBloc.listTindakanRadStream,
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
                  _getListTindakanRad();
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

class FormTagihanTindakanRad extends StatefulWidget {
  const FormTagihanTindakanRad({
    super.key,
    this.data,
  });

  final DetailKunjungan? data;

  @override
  State<FormTagihanTindakanRad> createState() => _FormTagihanTindakanRadState();
}

class _FormTagihanTindakanRadState extends State<FormTagihanTindakanRad> {
  final _masterTindakanRadCreateBloc = MasterTindakanRadCreateBloc();
  final _tagihanTindakanRadBloc = TagihanTindakanRadBloc();
  final List<MasterTindakanRad> _selectedTindakanRad = [];

  @override
  void initState() {
    super.initState();
    _getTindakanRad();
  }

  void _getTindakanRad() {
    _masterTindakanRadCreateBloc.getTindakanRad();
  }

  void _selectTindakanRad(MasterTindakanRad tindakanRad) {
    if (_selectedTindakanRad
        .where((selected) => selected.id == tindakanRad.id)
        .isEmpty) {
      setState(() {
        _selectedTindakanRad.add(tindakanRad);
      });
    } else {
      setState(() {
        _selectedTindakanRad.remove(tindakanRad);
      });
    }
  }

  void _simpanTindakanRad() {
    List<int> idTindakan = [];
    List<int> hargaModal = [];
    List<int> tarifAplikasi = [];
    _selectedTindakanRad.map((tindakan) {
      idTindakan.add(tindakan.id!);
      hargaModal.add(tindakan.hargaModal!);
      tarifAplikasi.add(tindakan.tarifAplikasi!);
    }).toList();
    _tagihanTindakanRadBloc.normSink.add(widget.data!.pasien!.norm!);
    _tagihanTindakanRadBloc.idKunjunganSink.add(widget.data!.id!);
    _tagihanTindakanRadBloc.idTindakanSink.add(idTindakan);
    _tagihanTindakanRadBloc.hargaModalSink.add(hargaModal);
    _tagihanTindakanRadBloc.tarifAplikasiSink.add(tarifAplikasi);
    _tagihanTindakanRadBloc.saveTindakanRad();
    _showStreamTindakanRad();
  }

  void _showStreamTindakanRad() {
    showAnimatedDialog(
      context: context,
      builder: (context) => _buildStreamTindakanRad(context),
      duration: const Duration(milliseconds: 500),
      animationType: DialogTransitionType.slideFromBottomFade,
    ).then((value) {
      if (value != null) {
        final data = value as DetailKunjungan;
        Future.delayed(const Duration(milliseconds: 500), () {
          if (!mounted) return;
          Navigator.pop(context, data);
        });
      }
    });
  }

  @override
  void dispose() {
    _masterTindakanRadCreateBloc.dispose();
    _tagihanTindakanRadBloc.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<ApiResponse<MasterTindakanRadCreateModel>>(
        stream: _masterTindakanRadCreateBloc.tindakanRadStream,
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
                        _getTindakanRad();
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
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Padding(
                        padding: EdgeInsets.all(22.0),
                        child: Text(
                          'Tindakan Radiologi',
                          style: TextStyle(
                              fontSize: 20, fontWeight: FontWeight.bold),
                        ),
                      ),
                      const Divider(
                        height: 0,
                      ),
                      Flexible(
                        child: ListView.separated(
                          shrinkWrap: true,
                          padding:
                              const EdgeInsets.only(bottom: 22.0, top: 12.0),
                          itemBuilder: (context, i) {
                            var tindakan = data[i];
                            return ListTile(
                              onTap: () => _selectTindakanRad(tindakan),
                              title: Text('${tindakan.namaTindakan}'),
                              trailing: _selectedTindakanRad
                                      .where((data) => data.id == tindakan.id)
                                      .isNotEmpty
                                  ? const Icon(
                                      Icons.check_circle,
                                      color: Colors.green,
                                    )
                                  : const SizedBox(),
                            );
                          },
                          separatorBuilder: (context, i) => const SizedBox(
                            height: 12.0,
                          ),
                          itemCount: data!.length,
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.all(22),
                        color: Colors.white,
                        child: ElevatedButton(
                          onPressed: _selectedTindakanRad.isNotEmpty
                              ? _simpanTindakanRad
                              : null,
                          style: ElevatedButton.styleFrom(
                            minimumSize: const Size.fromHeight(45),
                            backgroundColor: kPrimaryColor,
                          ),
                          child: const Text('Simpan Tindakan Rad'),
                        ),
                      )
                    ],
                  ),
                );
            }
          }
          return const SizedBox();
        });
  }

  Widget _buildStreamTindakanRad(BuildContext context) {
    return StreamBuilder<ApiResponse<ResponseTagihanTindakanRadModel>>(
        stream: _tagihanTindakanRadBloc.tagihanTindakanRadStream,
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
