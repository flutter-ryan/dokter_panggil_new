import 'package:dokter_panggil/src/blocs/kunjungan_biaya_lain_bloc.dart';
import 'package:dokter_panggil/src/models/pasien_kunjungan_detail_model.dart';
import 'package:dokter_panggil/src/pages/components/confirm_dialog.dart';
import 'package:dokter_panggil/src/pages/components/error_dialog.dart';
import 'package:dokter_panggil/src/pages/components/input_form.dart';
import 'package:dokter_panggil/src/pages/components/loading_kit.dart';
import 'package:dokter_panggil/src/pages/components/success_dialog.dart';
import 'package:dokter_panggil/src/repositories/responseApi/api_response.dart';
import 'package:dokter_panggil/src/source/config.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:dokter_panggil/src/source/transition/animated_dialog.dart';
import 'package:intl/intl.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';

class DetailBiayaLainnyaWidget extends StatefulWidget {
  const DetailBiayaLainnyaWidget({
    super.key,
    this.data,
    this.type,
    this.reload,
  });

  final DetailKunjungan? data;
  final String? type;
  final Function(DetailKunjungan? data)? reload;

  @override
  State<DetailBiayaLainnyaWidget> createState() =>
      _DetailBiayaLainnyaWidgetState();
}

class _DetailBiayaLainnyaWidgetState extends State<DetailBiayaLainnyaWidget> {
  final _kunjunganBiayaLainBloc = KunjunganBiayaLainBloc();
  late DetailKunjungan _data;
  final _rupiahFormat =
      NumberFormat.currency(locale: 'id', decimalDigits: 0, symbol: 'Rp. ');

  @override
  void initState() {
    super.initState();
    _data = widget.data!;
  }

  void _showFormBiayaLain() {
    showMaterialModalBottomSheet(
      context: context,
      isDismissible: false,
      builder: (context) {
        return Padding(
          padding:
              EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
          child: FormInputBiayaLain(
            bloc: _kunjunganBiayaLainBloc,
            idKunjungan: _data.id!,
          ),
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

  void _hapusBiaya(int? id) {
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
        Future.delayed(const Duration(milliseconds: 500), () {
          _showStreamHapusBiaya(id);
        });
      }
    });
  }

  void _showStreamHapusBiaya(int? id) {
    _kunjunganBiayaLainBloc.idBiayaSink.add(id!);
    _kunjunganBiayaLainBloc.deleteBiayaLain();
    showAnimatedDialog(
      context: context,
      builder: (context) {
        return _streamHapusBiaya(context);
      },
      duration: const Duration(milliseconds: 500),
      animationType: DialogTransitionType.slideFromBottomFade,
    ).then((value) {
      var data = value as DetailKunjungan;
      widget.reload!(data);
    });
  }

  @override
  void dispose() {
    _kunjunganBiayaLainBloc.dispose();
    super.dispose();
  }

  @override
  void didUpdateWidget(covariant DetailBiayaLainnyaWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.data!.biayaLain != widget.data!.biayaLain) {
      setState(() {
        _data = widget.data!;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(top: 12.0),
      padding: const EdgeInsets.symmetric(vertical: 12),
      decoration: const BoxDecoration(
        color: Colors.white,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 18.0),
            child: Row(
              children: [
                const Expanded(
                  child: Text(
                    'Biaya Lain-lain',
                    style: TextStyle(
                      fontSize: 16.0,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
                if (widget.type != 'view')
                  CircleAvatar(
                    radius: 15,
                    backgroundColor: Colors.transparent,
                    foregroundColor: kPrimaryColor,
                    child: IconButton(
                      onPressed: _showFormBiayaLain,
                      icon: const Icon(Icons.add),
                      padding: EdgeInsets.zero,
                      iconSize: 22,
                    ),
                  ),
              ],
            ),
          ),
          const Divider(
            height: 22.0,
          ),
          if (_data.biayaLain!.isNotEmpty)
            Column(
              children: ListTile.divideTiles(
                      context: context,
                      tiles: _data.biayaLain!
                          .map(
                            (biaya) => ListTile(
                              dense: true,
                              title: Text('${biaya.deskripsi}'),
                              subtitle: Text(_rupiahFormat.format(biaya.nilai)),
                              trailing: widget.type != 'view'
                                  ? IconButton(
                                      onPressed: () => _hapusBiaya(biaya.id),
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor: Colors.red,
                                        shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(32.0),
                                        ),
                                      ),
                                      icon: const Icon(Icons.delete),
                                      color: Colors.red,
                                    )
                                  : const SizedBox(),
                            ),
                          )
                          .toList())
                  .toList(),
            )
          else
            Padding(
              padding: const EdgeInsets.all(18.0),
              child: Center(
                child: Text(
                  'Data tidak tersedia',
                  style: TextStyle(
                    fontSize: 16.0,
                    color: Colors.grey[400],
                  ),
                ),
              ),
            )
        ],
      ),
    );
  }

  Widget _streamHapusBiaya(BuildContext context) {
    return StreamBuilder<ApiResponse<PasienKunjunganDetailModel>>(
      stream: _kunjunganBiayaLainBloc.biayaLainStream,
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
                    Navigator.pop(context, snapshot.data!.data!.detail),
              );
          }
        }
        return const SizedBox();
      },
    );
  }
}

class FormInputBiayaLain extends StatefulWidget {
  const FormInputBiayaLain({
    super.key,
    required this.idKunjungan,
    required this.bloc,
  });

  final int idKunjungan;
  final KunjunganBiayaLainBloc bloc;

  @override
  State<FormInputBiayaLain> createState() => _FormInputBiayaLainState();
}

class _FormInputBiayaLainState extends State<FormInputBiayaLain> {
  final _formKey = GlobalKey<FormState>();
  final _deksripsi = TextEditingController();
  final _nilai = TextEditingController();

  bool validateAndSave() {
    var formState = _formKey.currentState;
    if (formState!.validate()) {
      return true;
    }
    return false;
  }

  void _simpan() {
    if (validateAndSave()) {
      SystemChannels.textInput.invokeMethod('TextInput.hide');
      widget.bloc.idKunjunganSink.add(widget.idKunjungan);
      widget.bloc.deskripsiSink.add(_deksripsi.text);
      widget.bloc.nilaiSink.add(int.parse(_nilai.text));
      widget.bloc.saveBiayaLain();
      _showStreamBiayaLain();
    }
  }

  void _showStreamBiayaLain() {
    showAnimatedDialog(
      context: context,
      builder: (context) {
        return _streamBiayaLain(context);
      },
      duration: const Duration(milliseconds: 500),
      animationType: DialogTransitionType.slideFromBottomFade,
    ).then((value) {
      if (value != null) {
        var data = value as DetailKunjungan;
        Future.delayed(const Duration(milliseconds: 500), () {
          Navigator.pop(context, data);
        });
      }
    });
  }

  @override
  void dispose() {
    _deksripsi.dispose();
    _nilai.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          const Padding(
            padding: EdgeInsets.all(18.0),
            child: Text(
              'Input Biaya',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
          ),
          const Divider(
            height: 0.0,
          ),
          Padding(
            padding: const EdgeInsets.all(18.0),
            child: Input(
              controller: _deksripsi,
              label: 'Deskripsi',
              hint: 'Ketikkan deskripsi biaya lain-lain',
              textCap: TextCapitalization.sentences,
              textInputAction: TextInputAction.next,
              validator: (val) {
                if (val!.isEmpty) {
                  return 'Input required';
                }
                return null;
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(18.0, 4.0, 18.0, 18.0),
            child: Input(
              controller: _nilai,
              label: 'Nilai',
              hint: 'Ketikkan nilai biaya lain-lain',
              textInputAction: TextInputAction.done,
              keyType: TextInputType.number,
              inputFormatters: <TextInputFormatter>[
                FilteringTextInputFormatter.allow(RegExp(r'[0-9]')),
              ],
              validator: (val) {
                if (val!.isEmpty) {
                  return 'Input required';
                }
                return null;
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(18.0),
            child: ElevatedButton(
              onPressed: _simpan,
              style: ElevatedButton.styleFrom(
                backgroundColor: kPrimaryColor,
                minimumSize: const Size(double.infinity, 52.0),
              ),
              child: const Text('SIMPAN'),
            ),
          )
        ],
      ),
    );
  }

  Widget _streamBiayaLain(BuildContext context) {
    return StreamBuilder<ApiResponse<PasienKunjunganDetailModel>>(
      stream: widget.bloc.biayaLainStream,
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
                    Navigator.pop(context, snapshot.data!.data!.detail),
              );
          }
        }
        return const SizedBox();
      },
    );
  }
}
