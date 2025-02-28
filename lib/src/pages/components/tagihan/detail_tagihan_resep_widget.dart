import 'dart:io';

import 'package:dokter_panggil/src/blocs/file_eresep_oral_bloc.dart';
import 'package:dokter_panggil/src/blocs/mr_eresep_bloc.dart';
import 'package:dokter_panggil/src/blocs/resep_oral_proses_bloc.dart';
import 'package:dokter_panggil/src/blocs/tagihan_resep_oral_update_bloc.dart';
import 'package:dokter_panggil/src/blocs/tranportasi_resep_bloc.dart';
import 'package:dokter_panggil/src/models/file_eresep_oral_model.dart';
import 'package:dokter_panggil/src/models/pasien_kunjungan_detail_model.dart';
import 'package:dokter_panggil/src/models/resep_oral_proses_model.dart';
import 'package:dokter_panggil/src/models/tagihan_resep_oral_update_model.dart';
import 'package:dokter_panggil/src/models/transportasi_resep_model.dart';
import 'package:dokter_panggil/src/pages/components/card_tagihan_resep.dart';
import 'package:dokter_panggil/src/pages/components/confirm_dialog.dart';
import 'package:dokter_panggil/src/pages/components/error_dialog.dart';
import 'package:dokter_panggil/src/pages/components/input_form.dart';
import 'package:dokter_panggil/src/pages/components/loading_kit.dart';
import 'package:dokter_panggil/src/pages/components/success_dialog.dart';
import 'package:dokter_panggil/src/pages/components/tagihan/resep_widget.dart';
import 'package:dokter_panggil/src/pages/components/tagihan/tile_obat_widget.dart';
import 'package:dokter_panggil/src/pages/components/transaksi_resep.dart';
import 'package:dokter_panggil/src/pages/components/transaksi_resep_mr.dart';
import 'package:dokter_panggil/src/repositories/responseApi/api_response.dart';
import 'package:dokter_panggil/src/source/config.dart';
import 'package:dokter_panggil/src/source/size_config.dart';
import 'package:dokter_panggil/src/source/transition/slide_bottom_route.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:dokter_panggil/src/source/transition/animated_dialog.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:url_launcher/url_launcher.dart';

class DetailTagihanResepWidget extends StatefulWidget {
  const DetailTagihanResepWidget({
    super.key,
    required this.data,
    required this.type,
    this.reload,
  });

  final DetailKunjungan data;
  final String type;
  final Function(DetailKunjungan? tagihan)? reload;

  @override
  State<DetailTagihanResepWidget> createState() =>
      _DetailTagihanResepWidgetState();
}

class _DetailTagihanResepWidgetState extends State<DetailTagihanResepWidget> {
  final _mrEresepBloc = MrEresepBloc();
  final _resepOralProsesBloc = ResepOralProsesBloc();
  final _tagihanResepOralUpdateBloc = TagihanResepOralUpdateBloc();
  final _fileEresepOralBloc = FileEresepOralBloc();
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
    if (validateAndSave()) {
      FocusScope.of(context).requestFocus(FocusNode());
      _tagihanResepOralUpdateBloc.idBarangResepOralSink.add(id!);
      _tagihanResepOralUpdateBloc.jumlahSink.add(int.parse(_jumlah.text));
      _tagihanResepOralUpdateBloc.updateTagihanResepOral();
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
        _tagihanResepOralUpdateBloc.idBarangResepOralSink.add(id);
        _tagihanResepOralUpdateBloc.deleteTagihanResepOral();
        _showStreamUpdate();
      }
    });
  }

  void _prosesResep(ResepMr oral) {
    showMaterialModalBottomSheet(
      context: context,
      builder: (context) => _showPilhanProsesResep(context),
    ).then((value) {
      if (value != null) {
        var data = value as String;
        _resepOralProsesBloc.idResepOralSink.add(oral.id!);
        if (data == 'bersedia') {
          _resepOralProsesBloc.isBersedia.add(1);
        } else {
          _resepOralProsesBloc.isBersedia.add(0);
        }
        _resepOralProsesBloc.statusSink.add(1);
        _resepOralProsesBloc.prosesResepOral();
        _showStreamProsesResepOral();
      }
    });
  }

  void _showStreamProsesResepOral() {
    showAnimatedDialog(
      context: context,
      builder: (context) => _streamProsesResepOral(context),
      animationType: DialogTransitionType.slideFromBottomFade,
      duration: const Duration(milliseconds: 500),
    ).then((value) {
      if (value != null) {
        var data = value as ResepMr;
        setState(() {
          _data!.resepMr![
              _data!.resepMr!.indexWhere((oral) => oral.id == data.id)] = data;
        });
      }
    });
  }

  void _eresepOral(ResepMr? resep) {
    showMaterialModalBottomSheet(
      context: context,
      builder: (context) => _eresepOralWidget(context, resep),
    ).then((value) {
      if (value != null) {
        final resep = value as ResepMr;
        Future.delayed(const Duration(milliseconds: 500), () {
          _fileEresepOralBloc.idResepSink.add(resep.id!);
          _fileEresepOralBloc.eresepOral();
          _showStreamEresepOral();
        });
      }
    });
  }

  void _showStreamEresepOral() {
    showAnimatedDialog(
      context: context,
      builder: (context) => _streamEresepOral(context),
      animationType: DialogTransitionType.slideFromBottomFade,
    ).then((value) {
      if (value != null) {
        final resepOral = value as MrEresepOral;
        Future.delayed(const Duration(milliseconds: 500), () async {
          _share(resepOral);
        });
      }
    });
  }

  Future<void> _share(MrEresepOral? data) async {
    var phone = '+6281280023025';
    var text =
        'ERESEP dokter panggil\n\nPasien ${data!.pasien}\n${Uri.parse(data.url!).toString()}';
    var whatsappURlAndroid = "whatsapp://send?phone=$phone&text=$text";
    var whatsappURLIos = "https://wa.me/$phone?text=${Uri.tryParse(text)}";
    if (Platform.isIOS) {
      if (await canLaunchUrl(Uri.parse(whatsappURLIos))) {
        await launchUrl(Uri.parse(whatsappURLIos));
      } else {
        Fluttertoast.showToast(
            msg: 'Whatsapp not installed', toastLength: Toast.LENGTH_LONG);
      }
    } else {
      if (await canLaunchUrl(Uri.parse(whatsappURlAndroid))) {
        await launchUrl(Uri.parse(whatsappURlAndroid));
      } else {
        Fluttertoast.showToast(
            msg: 'Whatsapp not installed', toastLength: Toast.LENGTH_LONG);
      }
    }
  }

  @override
  void dispose() {
    super.dispose();
    _tagihanResepOralUpdateBloc.dispose();
    _resepOralProsesBloc.dispose();
    _mrEresepBloc.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (widget.data.isEmr == 0) {
      return _oldResepWidget(context);
    }
    return CardTagihanResep(
      title: 'Resep',
      tiles: Column(
        children: ListTile.divideTiles(
          context: context,
          color: Colors.grey[400],
          tiles: _data!.resepMr!
              .map(
                (resepOral) => Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding:
                              const EdgeInsets.fromLTRB(0.0, 12.0, 8.0, 8.0),
                          child: Text(
                            '${resepOral.tanggalShort}\n${resepOral.jamShort}',
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
                                  text: '${resepOral.dokter} |',
                                  style: TextStyle(
                                      fontSize: 12,
                                      color: Colors.black,
                                      fontWeight: FontWeight.w600),
                                  children: [
                                    TextSpan(
                                      text: ' E-Resep ',
                                      style:
                                          TextStyle(color: Colors.blueAccent),
                                      recognizer: TapGestureRecognizer()
                                        ..onTap = () => _eresepOral(resepOral),
                                    ),
                                    TextSpan(
                                      text: '|',
                                      style: TextStyle(color: Colors.black),
                                    ),
                                    TextSpan(
                                      text: resepOral.status == 0
                                          ? ' Belum diproses'
                                          : ' Sudah diproses',
                                      style: TextStyle(
                                          color: resepOral.status == 0
                                              ? Colors.red
                                              : Colors.green),
                                      recognizer: TapGestureRecognizer()
                                        ..onTap = widget.type == 'create'
                                            ? () => _prosesResep(resepOral)
                                            : null,
                                    ),
                                    if (resepOral.status == 1)
                                      TextSpan(
                                        text: ' |',
                                        style: TextStyle(color: Colors.black),
                                      ),
                                    if (resepOral.status == 1)
                                      TextSpan(
                                        text: resepOral.isBersedia == 0
                                            ? ' Tidak bersedia'
                                            : ' Bersedia',
                                        style: TextStyle(
                                            color: resepOral.isBersedia == 0
                                                ? Colors.red
                                                : Colors.green),
                                      ),
                                  ]),
                            ),
                          ),
                        ),
                      ],
                    ),
                    ..._data!.tagihanResep!
                        .where((tagihan) => tagihan.resepOralId == resepOral.id)
                        .map(
                          (oral) => TileObatWidget(
                            onTap: widget.type != 'view'
                                ? () => _edit(context, oral)
                                : null,
                            isEdit: widget.type != 'view',
                            leading: Padding(
                              padding: const EdgeInsets.only(top: 2.0),
                              child: Text(
                                '${oral.createdAt}',
                                style: TextStyle(fontSize: 12),
                              ),
                            ),
                            title: '${oral.namaBarang}',
                            subtitle:
                                '${oral.jumlah} x ${_rupiahNo.format(oral.hargaModal! + oral.tarifAplikasi!)}',
                            trailing: _rupiah.format(oral.total),
                          ),
                        ),
                    if (resepOral.status == 1)
                      SizedBox(
                        height: 12,
                      ),
                    if (resepOral.status == 1 &&
                        resepOral.isBersedia == 1 &&
                        widget.type == 'create')
                      ElevatedButton.icon(
                        onPressed: () => Navigator.push(
                          context,
                          SlideBottomRoute(
                            page: TransaksiResepMr(
                              idKunjungan: _data!.id,
                              dataResep: resepOral.obatOral,
                              idResep: resepOral.id,
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
        ).toList(),
      ),
      subTotal: _data!.tagihanResep!.isNotEmpty
          ? Text(
              _rupiah.format(_data!.totalResep! + _data!.transportResep!),
              style: const TextStyle(fontWeight: FontWeight.w600),
            )
          : const Text(
              'Rp. 0',
              style: TextStyle(fontWeight: FontWeight.w600),
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

  Widget _streamProsesResepOral(BuildContext context) {
    return StreamBuilder<ApiResponse<ResepOralProsesModel>>(
      stream: _resepOralProsesBloc.resepOralProsesStream,
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

  Widget _formUpdateTagihan(BuildContext context, TagihanResep? tagihan) {
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
              color: Colors.grey[400],
            ),
            const SizedBox(
              height: 12.0,
            ),
            Text(
              '${tagihan!.namaBarang}',
              style: TextStyle(fontSize: 18.0),
            ),
            const SizedBox(
              height: 12.0,
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
                    onPressed: () => _hapus(context, tagihan.id),
                    style: ElevatedButton.styleFrom(
                      minimumSize: const Size(double.infinity, 42),
                      backgroundColor: Colors.grey[200],
                      foregroundColor: Colors.black,
                      elevation: 0,
                    ),
                    child: const Text('Delete'),
                  ),
                ),
                const SizedBox(
                  width: 15.0,
                ),
                Expanded(
                  child: ElevatedButton(
                    onPressed: () => _update(tagihan.id),
                    style: ElevatedButton.styleFrom(
                      minimumSize: const Size(double.infinity, 42),
                      backgroundColor: kPrimaryColor,
                      elevation: 0,
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
    return StreamBuilder<ApiResponse<TagihanResepOralUpdateModel>>(
      stream: _tagihanResepOralUpdateBloc.tagihanResepOralStream,
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

  Widget _oldResepWidget(BuildContext context) {
    return CardTagihanResep(
      title: 'Resep',
      tiles: Column(
        children: [
          if (_data!.tagihanResep!.isEmpty)
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
                            idKunjungan: _data!.id,
                            dataResep: _data!.resep,
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
          if (_data!.tagihanResep!.isNotEmpty && widget.type == 'create')
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
                      idKunjungan: _data!.id,
                      dataResep: _data!.resep,
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
          if (_data!.tagihanResep!.isNotEmpty)
            Column(
              children: ListTile.divideTiles(
                context: context,
                tiles: _data!.tagihanResep!
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
          if (_data!.tagihanResep!.isNotEmpty) const Divider(),
          if (_data!.tagihanResep!.isNotEmpty)
            TransportasiResepNon(
              data: _data!,
              reload: (DetailKunjungan? data) => widget.reload!(data),
              type: widget.type,
            )
        ],
      ),
      subTotal: _data!.tagihanResep!.isNotEmpty
          ? Text(
              _rupiah.format(_data!.totalResep! + _data!.transportResep!),
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

  Widget _eresepOralWidget(BuildContext context, ResepMr? resep) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 18, vertical: 8),
          child: Row(
            children: [
              Expanded(
                child: Text(
                  'E-Resep Obat Oral/Minum',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
                ),
              ),
              CloseButton(
                onPressed: () => Navigator.pop(context),
                color: Colors.grey[400],
              )
            ],
          ),
        ),
        Divider(
          color: Colors.grey[400],
          height: 0,
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 18.0, vertical: 8),
          child: Container(
            decoration: BoxDecoration(
                color: Colors.grey[200],
                borderRadius: BorderRadius.circular(12)),
            child: ListTile(
              visualDensity: VisualDensity.compact,
              title: Text(
                'Dokter',
                style: TextStyle(fontSize: 12, color: Colors.grey[400]),
              ),
              subtitle: Text('${resep!.dokter}'),
            ),
          ),
        ),
        ...resep.obatOral!.map(
          (obatOral) => ListTile(
            contentPadding: EdgeInsets.symmetric(horizontal: 18, vertical: 8),
            title: Text('${obatOral.barang}'),
            subtitle: Text('${obatOral.aturanPakai}'),
            trailing: Text('${obatOral.jumlah} Pcs'),
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(18),
          child: ElevatedButton(
            onPressed: () => Navigator.pop(context, resep),
            style: ElevatedButton.styleFrom(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(32),
              ),
              minimumSize: Size(double.infinity, 42),
            ),
            child: Text('Kirim E-Resep'),
          ),
        ),
        SizedBox(
          height: MediaQuery.of(context).padding.bottom,
        )
      ],
    );
  }

  Widget _streamEresepOral(BuildContext context) {
    return StreamBuilder<ApiResponse<FileEresepOralModel>>(
      stream: _fileEresepOralBloc.fileEresepOralStream,
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

class TransportasiResepNon extends StatefulWidget {
  const TransportasiResepNon({
    super.key,
    required this.data,
    this.reload,
    this.type = 'create',
  });

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
        if (!mounted) return;
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

class TagihanResepReloadModel {
  int? idResep;
  List<TagihanResep>? tagihans;

  TagihanResepReloadModel({
    this.idResep,
    this.tagihans,
  });
}
