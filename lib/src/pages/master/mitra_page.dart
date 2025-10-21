import 'package:admin_dokter_panggil/src/blocs/mitra_bloc.dart';
import 'package:admin_dokter_panggil/src/models/mitra_filter_model.dart';
import 'package:admin_dokter_panggil/src/models/mitra_model.dart';
import 'package:admin_dokter_panggil/src/pages/components/button_edit_master.dart';
import 'package:admin_dokter_panggil/src/pages/components/close_button.dart';
import 'package:admin_dokter_panggil/src/pages/components/confirm_dialog.dart';
import 'package:admin_dokter_panggil/src/pages/components/error_dialog.dart';
import 'package:admin_dokter_panggil/src/pages/components/header.dart';
import 'package:admin_dokter_panggil/src/pages/components/input_form.dart';
import 'package:admin_dokter_panggil/src/pages/components/loading_kit.dart';
import 'package:admin_dokter_panggil/src/pages/components/search_input_form.dart';
import 'package:admin_dokter_panggil/src/pages/components/success_dialog.dart';
import 'package:admin_dokter_panggil/src/pages/master/mitra_pencarian_page.dart';
import 'package:admin_dokter_panggil/src/repositories/responseApi/api_response.dart';
import 'package:admin_dokter_panggil/src/source/config.dart';
import 'package:admin_dokter_panggil/src/source/transition/slide_left_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:admin_dokter_panggil/src/source/transition/animated_dialog.dart';

class MitraPage extends StatefulWidget {
  const MitraPage({super.key});

  @override
  State<MitraPage> createState() => _MitraPageState();
}

class _MitraPageState extends State<MitraPage> {
  final MitraBloc _mitraBloc = MitraBloc();
  final _formKey = GlobalKey<FormState>();
  final _mitraCon = TextEditingController();
  final _kodeCon = TextEditingController();
  final _persentaseCon = TextEditingController();
  bool _editForm = false;
  String _jenisGroup = 'farmasi';
  int? _persentase;
  String? _mitra, _kode;

  bool validateAndSave() {
    var formState = _formKey.currentState;
    if (formState!.validate()) {
      formState.save();
      return true;
    }
    return false;
  }

  void _simpan() {
    if (validateAndSave()) {
      _mitraBloc.mitraSink.add(_mitra!);
      _mitraBloc.kodeSink.add(_kode!);
      _mitraBloc.jenisSink.add(_jenisGroup);
      _mitraBloc.persentaseSink.add(_persentase!);
      _mitraBloc.saveMitra();
      _dialogStream();
    }
  }

  void _edit(MitraFilter mitra) {
    _mitraCon.text = mitra.namaMitra!;
    _kodeCon.text = mitra.kode!;
    _mitraBloc.idSink.add(mitra.id!);
    _persentaseCon.text = mitra.persentase.toString();
    _jenisGroup = mitra.jenis!;
    setState(() {
      _editForm = true;
    });
  }

  void _batal() {
    _mitraCon.clear();
    _kodeCon.clear();
    _persentaseCon.clear();
    _jenisGroup = 'farmasi';
    setState(() {
      _editForm = false;
    });
  }

  void _update() {
    if (validateAndSave()) {
      _mitraBloc.mitraSink.add(_mitra!);
      _mitraBloc.kodeSink.add(_kode!);
      _mitraBloc.jenisSink.add(_jenisGroup);
      _mitraBloc.persentaseSink.add(_persentase!);
      _mitraBloc.updateMitra();
      _dialogStream();
    }
  }

  void _delete() {
    showAnimatedDialog(
      context: context,
      builder: (context) {
        return ConfirmDialogWidget(
          message: 'Anda yakin menghapus data ini?',
          onConfirm: () => Navigator.pop(context, 'hapus'),
        );
      },
      animationType: DialogTransitionType.scale,
      duration: const Duration(milliseconds: 300),
    ).then((value) {
      if (value != null) {
        Future.delayed(const Duration(milliseconds: 300), () {
          _mitraBloc.deleteMitra();
          _dialogStream();
        });
      }
    });
  }

  void _dialogStream() {
    showDialog(
      context: context,
      builder: (context) {
        return _streamSaveMitra();
      },
    ).then((value) {
      if (value != null) {
        _batal();
      }
    });
  }

  void _pencarianMitra() {
    Navigator.push(
      context,
      SlideLeftRoute(
        page: const MitraPencarianPage(),
      ),
    ).then((value) {
      if (value != null) {
        var data = value as MitraFilter;
        _edit(data);
        if (!mounted) return;
        FocusScope.of(context).requestFocus(FocusNode());
      }
    });
  }

  @override
  void dispose() {
    _mitraCon.dispose();
    _kodeCon.dispose();
    _persentaseCon.dispose();
    _mitraBloc.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: const SystemUiOverlayStyle(
        statusBarBrightness: Brightness.dark,
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.light,
      ),
      child: Scaffold(
        body: Form(
          key: _formKey,
          child: Column(
            children: [
              Header(
                title: 'Tambah Mitra',
                subtitle: SearchInputForm(
                  isReadOnly: true,
                  hint: 'Pencarian mitra',
                  onTap: _pencarianMitra,
                ),
                closeButton: const ClosedButton(),
              ),
              Expanded(
                child: ListView(
                  padding: const EdgeInsets.all(32.0),
                  children: [
                    Input(
                      controller: _mitraCon,
                      label: 'Mitra',
                      hint: 'Nama mitra',
                      maxLines: 1,
                      validator: (val) {
                        if (val!.isEmpty) {
                          return 'Input required';
                        }
                        return null;
                      },
                      onSave: (val) => _mitra = val,
                      textCap: TextCapitalization.words,
                    ),
                    const SizedBox(
                      height: 22.0,
                    ),
                    Input(
                      controller: _kodeCon,
                      label: 'Kode',
                      hint: 'Kode mitra',
                      maxLines: 1,
                      validator: (val) {
                        if (val!.isEmpty) {
                          return 'Input required';
                        }
                        return null;
                      },
                      onSave: (val) => _kode = val,
                      textCap: TextCapitalization.characters,
                    ),
                    const SizedBox(
                      height: 22.0,
                    ),
                    const Text(
                      'Jenis Mitra',
                      style: TextStyle(fontWeight: FontWeight.w600),
                    ),
                    RadioListTile(
                      contentPadding: const EdgeInsets.symmetric(vertical: 0.0),
                      value: 'farmasi',
                      groupValue: _jenisGroup,
                      onChanged: (value) {
                        setState(() {
                          _jenisGroup = value as String;
                        });
                      },
                      title: const Text('Farmasi'),
                    ),
                    RadioListTile(
                      contentPadding: const EdgeInsets.symmetric(vertical: 0.0),
                      value: 'tindakan_lab',
                      groupValue: _jenisGroup,
                      onChanged: (value) {
                        setState(() {
                          _jenisGroup = value as String;
                        });
                      },
                      title: const Text('Tindakan lab'),
                    ),
                    const SizedBox(
                      height: 22.0,
                    ),
                    Input(
                      controller: _persentaseCon,
                      label: 'Persentase',
                      hint: 'Persentase harga jual',
                      maxLines: 1,
                      validator: (val) {
                        if (val!.isEmpty) {
                          return 'Input required';
                        }
                        return null;
                      },
                      onSave: (val) => _persentase = int.parse(val!),
                      keyType: TextInputType.number,
                    ),
                    const SizedBox(
                      height: 52.0,
                    ),
                    if (_editForm)
                      ButtonEditMaster(
                        update: _update,
                        delete: _delete,
                        batal: _batal,
                      )
                    else
                      SizedBox(
                        height: 48.0,
                        child: ElevatedButton(
                          onPressed: _simpan,
                          style: ElevatedButton.styleFrom(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(4.0),
                            ),
                            backgroundColor: kPrimaryColor,
                          ),
                          child: const Text('SIMPAN'),
                        ),
                      )
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget _streamSaveMitra() {
    return StreamBuilder<ApiResponse<ResponseMitraModel>>(
      stream: _mitraBloc.masterMitraStream,
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
                onTap: () => Navigator.pop(context, 'reload'),
              );
          }
        }
        return const SizedBox();
      },
    );
  }
}
