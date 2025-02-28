import 'dart:io';

import 'package:animate_icons/animate_icons.dart';
import 'package:dokter_panggil/src/blocs/kunjungan_obat_injeksi_update_bloc.dart';
import 'package:dokter_panggil/src/blocs/mr_eresep_bloc.dart';
import 'package:dokter_panggil/src/models/kunjungan_obat_injeksi_update_model.dart';
import 'package:dokter_panggil/src/models/master_bhp_model.dart';
import 'package:dokter_panggil/src/models/mr_eresep_model.dart';
import 'package:dokter_panggil/src/models/pasien_kunjungan_detail_model.dart';
import 'package:dokter_panggil/src/pages/components/card_obat_injeksi.dart';
import 'package:dokter_panggil/src/pages/components/card_tagihan.dart';
import 'package:dokter_panggil/src/pages/components/error_dialog.dart';
import 'package:dokter_panggil/src/pages/components/input_form.dart';
import 'package:dokter_panggil/src/pages/components/loading_kit.dart';
import 'package:dokter_panggil/src/pages/components/success_dialog.dart';
import 'package:dokter_panggil/src/pages/components/tagihan/detail_bhp_widget.dart';
import 'package:dokter_panggil/src/pages/components/tagihan/tile_obat_widget.dart';
import 'package:dokter_panggil/src/repositories/responseApi/api_response.dart';
import 'package:dokter_panggil/src/source/config.dart';
import 'package:dokter_panggil/src/source/transition/slide_bottom_route.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:dokter_panggil/src/source/transition/animated_dialog.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:url_launcher/url_launcher.dart';

class DetailObatInjeksiWidget extends StatefulWidget {
  const DetailObatInjeksiWidget({
    super.key,
    required this.data,
    this.type,
    this.reload,
    this.role,
  });

  final DetailKunjungan data;
  final String? type;
  final Function(DetailKunjungan kunjungan)? reload;
  final int? role;

  @override
  State<DetailObatInjeksiWidget> createState() =>
      _DetailObatInjeksiWidgetState();
}

class _DetailObatInjeksiWidgetState extends State<DetailObatInjeksiWidget> {
  final _mrEresepBloc = MrEresepBloc();
  final _kunjunganObatInjeksiUpdateBloc = KunjunganObatInjeksiUpdateBloc();
  final _animateIconController = AnimateIconController();
  final _scrollCon = ScrollController();
  final _rupiah =
      NumberFormat.currency(locale: 'id', symbol: 'Rp. ', decimalDigits: 0);
  final _rupiahNo =
      NumberFormat.currency(locale: 'id', symbol: '', decimalDigits: 0);
  final _namaBarang = TextEditingController();
  final _jumlah = TextEditingController();
  final _alasan = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  List<KunjunganObatInjeksi> _data = [];
  List<ObatInjeksiMr> _dataMr = [];
  int? _selectedId;
  int _hargaModal = 0;
  int _tarifAplikasi = 0;

  @override
  void initState() {
    super.initState();
    if (widget.data.obatInjeksiMr!.isNotEmpty) {
      _dataMr = widget.data.obatInjeksiMr!;
    }
    if (widget.data.obatInjeksi!.isNotEmpty) {
      _data = widget.data.obatInjeksi!;
    }
  }

  bool validateAndSave() {
    var formData = _formKey.currentState;
    if (formData!.validate()) {
      formData.save();
      return true;
    }
    return false;
  }

  void _edit(BuildContext context, dynamic resep) {
    if (widget.data.isEmr == 0) {
      final obat = resep as KunjunganObatInjeksi;
      _kunjunganObatInjeksiUpdateBloc.idSink.add(obat.id!);
      _selectedId = obat.id;
      _namaBarang.text = '${obat.barang!.namaBarang}';
      _jumlah.text = '${obat.jumlah}';
      _tarifAplikasi = obat.tarifAplikasi!;
      _hargaModal = obat.hargaModal!;
      showBarModalBottomSheet(
        context: context,
        builder: (context) {
          return Padding(
            padding: EdgeInsets.only(
                bottom: MediaQuery.of(context).viewInsets.bottom),
            child: _editFormObatInjeksi(resep),
          );
        },
        duration: const Duration(milliseconds: 500),
      );
    } else {
      resep as ObatInjeksiMr;
    }
  }

  void _updateKunjunganObatInjeksi() {
    if (validateAndSave()) {
      SystemChannels.textInput.invokeListMethod('TextInput.hide');
      _kunjunganObatInjeksiUpdateBloc.barangSink.add(_selectedId!);
      _kunjunganObatInjeksiUpdateBloc.jumlahSink.add(int.parse(_jumlah.text));
      _kunjunganObatInjeksiUpdateBloc.hargaModalSink.add(_hargaModal);
      _kunjunganObatInjeksiUpdateBloc.tarifAplikasiSink.add(_tarifAplikasi);
      _kunjunganObatInjeksiUpdateBloc.alasanSink.add(_alasan.text);
      _kunjunganObatInjeksiUpdateBloc.updateObatInjeksi();
      _showStreamUpdateObat();
    }
  }

  void _showStreamUpdateObat() {
    showAnimatedDialog(
      context: context,
      builder: (context) {
        return _streamUpdateObat(context);
      },
      duration: const Duration(milliseconds: 500),
      animationType: DialogTransitionType.slideFromBottomFade,
    ).then((value) {
      if (value != null) {
        var data = value as ObatInjeksiMr;
        _namaBarang.clear();
        _jumlah.clear();
        _alasan.clear();
        Future.delayed(const Duration(milliseconds: 500), () {
          if (!mounted) return;
          Navigator.pop(context);
          _dataMr[_dataMr.indexWhere((e) => e.id == data.id)] = data;
          setState(() {});
        });
      }
    });
  }

  void _showMasterBhp() {
    Navigator.push(
      context,
      SlideBottomRoute(
        page: ListMasterBhp(
          selectedId: _selectedId,
        ),
      ),
    ).then((value) {
      if (value != null) {
        var data = value as MasterBhp;
        setState(() {
          _selectedId = data.id;
          _namaBarang.text = data.namaBarang!;
          _tarifAplikasi = data.tarifAplikasi!;
          _hargaModal = data.hargaModal!;
        });
      }
    });
  }

  void _eresep(ObatInjeksiMr? resep) {
    showMaterialModalBottomSheet(
      context: context,
      builder: (context) {
        return _eresepInjeksiWidget(context, resep);
      },
    ).then((value) {
      if (value != null) {
        Future.delayed(const Duration(milliseconds: 500), () {
          _mrEresepBloc.idResepSink.add(resep!.id!);
          _mrEresepBloc.getResepInjeksi();
          _showStreamEresep();
        });
      }
    });
  }

  void _showStreamEresep() {
    showAnimatedDialog(
      context: context,
      builder: (context) {
        return _streamEresep();
      },
      animationType: DialogTransitionType.slideFromBottomFade,
      duration: const Duration(milliseconds: 500),
    ).then((value) async {
      if (value != null) {
        var data = value as MrEresep;
        var phone = '+6281280023025';
        var text =
            'ERESEP dokter panggil\n\nPasien ${data.namaPasien}\n${Uri.parse(data.url!).toString()}';
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
    });
  }

  @override
  void dispose() {
    _kunjunganObatInjeksiUpdateBloc.dispose();
    _mrEresepBloc.dispose();
    _namaBarang.dispose();
    _jumlah.dispose();
    _alasan.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (widget.data.isEmr == 0) {
      return _oldObatInjeksiWidget(context);
    }
    return Cardtagihan(
      title: 'Obat Injeksi',
      subTotal: Text(
        _rupiah.format(widget.data.totalObatInjeksi),
        style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 12),
      ),
      tiles: ListTile.divideTiles(
        context: context,
        tiles: _dataMr
            .map((resep) => Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.fromLTRB(0.0, 12.0, 8.0, 8.0),
                      child: Text(
                        '${resep.tanggalShort}\n${resep.jamShort}',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            fontSize: 12, fontWeight: FontWeight.w600),
                      ),
                    ),
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.fromLTRB(8.0, 14.0, 0.0, 8.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            RichText(
                              text: TextSpan(
                                  text: '${resep.dokter} |',
                                  style: TextStyle(
                                    fontSize: 12,
                                    color: Colors.black,
                                    fontWeight: FontWeight.w600,
                                  ),
                                  children: [
                                    TextSpan(
                                      text: ' E-Resep',
                                      style:
                                          TextStyle(color: Colors.blueAccent),
                                      recognizer: TapGestureRecognizer()
                                        ..onTap = () => _eresep(resep),
                                    ),
                                  ]),
                            ),
                            ...resep.obatInjeksi!.map((obat) => TileObatWidget(
                                  title: '${obat.barang!.namaBarang}',
                                  subtitle:
                                      '${obat.jumlah} x ${_rupiahNo.format(obat.hargaModal! + obat.tarifAplikasi!)}',
                                  trailing: _rupiah.format(obat.tarif),
                                ))
                          ],
                        ),
                      ),
                    ),
                  ],
                ))
            .toList(),
      ).toList(),
    );
  }

  Widget _editFormObatInjeksi(KunjunganObatInjeksi obat) {
    return Form(
      key: _formKey,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 18.0),
            child: Row(
              children: [
                const SizedBox(
                  width: 22.0,
                ),
                const Expanded(
                  child: Text(
                    'Edit Barang Habis Pakai',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
                  ),
                ),
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  style: TextButton.styleFrom(foregroundColor: Colors.grey),
                  child: const Icon(Icons.close_rounded),
                ),
              ],
            ),
          ),
          Flexible(
            child: ListView(
              controller: _scrollCon,
              padding:
                  const EdgeInsets.symmetric(horizontal: 22.0, vertical: 18.0),
              shrinkWrap: true,
              children: [
                Input(
                  controller: _namaBarang,
                  label: 'Nama Barang',
                  hint: 'Inputkan nama barang',
                  validator: (value) {
                    if (value!.isEmpty) return 'Input required';
                    return null;
                  },
                  readOnly: true,
                  suffixIcon: AnimateIcons(
                    startIconColor: Colors.grey,
                    endIconColor: Colors.grey,
                    startIcon: Icons.expand_more_rounded,
                    endIcon: Icons.expand_less_rounded,
                    duration: const Duration(milliseconds: 300),
                    onStartIconPress: () {
                      _showMasterBhp();
                      return false;
                    },
                    onEndIconPress: () {
                      Navigator.pop(context);
                      return false;
                    },
                    controller: _animateIconController,
                  ),
                  onTap: _showMasterBhp,
                ),
                const SizedBox(
                  height: 28.0,
                ),
                Input(
                  controller: _jumlah,
                  label: 'Jumlah',
                  hint: 'Inputkan jumlah barang',
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'Input required';
                    }
                    return null;
                  },
                ),
                const SizedBox(
                  height: 28.0,
                ),
                Input(
                  controller: _alasan,
                  label: 'Alasan Perubahan',
                  hint: 'Inputkan alasan perubahan barang',
                  minLines: 3,
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'Input required';
                    }
                    return null;
                  },
                  textCap: TextCapitalization.sentences,
                ),
                const SizedBox(
                  height: 42.0,
                ),
                ElevatedButton(
                  onPressed: _updateKunjunganObatInjeksi,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: kPrimaryColor,
                    minimumSize: const Size(double.infinity, 45),
                  ),
                  child: const Text('Update BHP'),
                ),
                const SizedBox(
                  height: 22.0,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _streamUpdateObat(BuildContext context) {
    return StreamBuilder<ApiResponse<ResponseKunjunganObatInkjeksiUpdateModel>>(
      stream: _kunjunganObatInjeksiUpdateBloc.obatInjeksiUpdateStream,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          switch (snapshot.data!.status) {
            case Status.loading:
              return const LoadingKit(
                color: Colors.white,
              );
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

  Widget _oldObatInjeksiWidget(BuildContext context) {
    return CardObatInjeksi(
      title: 'Obat Injeksi',
      subTotal: Text(
        _rupiah.format(widget.data.totalObatInjeksi),
        style: const TextStyle(fontWeight: FontWeight.w600),
      ),
      tiles: Column(
        children: ListTile.divideTiles(
          context: context,
          tiles: _data
              .map(
                (obat) => ListTile(
                  onTap: () => widget.type != 'view' && widget.role == 99
                      ? _edit(context, obat)
                      : null,
                  dense: true,
                  contentPadding:
                      const EdgeInsets.symmetric(vertical: 4.0, horizontal: 0),
                  horizontalTitleGap: 0,
                  title: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Flexible(child: Text('${obat.barang!.namaBarang}')),
                      if (widget.type != 'view' && widget.role == 99)
                        const SizedBox(
                          width: 12,
                        ),
                      if (widget.type != 'view' && widget.role == 99)
                        const Icon(
                          Icons.edit_note_rounded,
                          size: 22.0,
                          color: Colors.blue,
                        )
                    ],
                  ),
                  subtitle: Text(
                      '${obat.jumlah} x ${_rupiahNo.format(obat.hargaModal! + obat.tarifAplikasi!)}'),
                  trailing: Text(
                    _rupiah.format(obat.tarif),
                  ),
                ),
              )
              .toList(),
        ).toList(),
      ),
    );
  }

  Widget _streamEresep() {
    return StreamBuilder<ApiResponse<MrEresepModel>>(
      stream: _mrEresepBloc.eresepStream,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          switch (snapshot.data!.status) {
            case Status.loading:
              return const LoadingKit(
                color: Colors.white,
              );
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

  Widget _eresepInjeksiWidget(BuildContext context, ObatInjeksiMr? resep) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 18, vertical: 12),
          child: Row(
            children: [
              Expanded(
                child: Text(
                  'E-Resep Obat Injeksi',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
                ),
              ),
              CloseButton(
                onPressed: () => Navigator.pop(context),
              )
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 18.0, vertical: 8),
          child: Container(
            decoration: BoxDecoration(
              color: Colors.grey[200],
              borderRadius: BorderRadius.circular(12),
            ),
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
        ...resep.obatInjeksi!.map(
          (obatInjeksi) => ListTile(
            contentPadding: EdgeInsets.symmetric(horizontal: 22, vertical: 8),
            title: Text('${obatInjeksi.barang!.namaBarang}'),
            subtitle: Text('${obatInjeksi.aturanPakai}'),
            trailing: Text('${obatInjeksi.jumlah} Pcs'),
          ),
        ),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 22, vertical: 18),
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
}
