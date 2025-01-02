import 'package:dokter_panggil/src/blocs/diagnosa_bloc.dart';
import 'package:dokter_panggil/src/models/diagnosa_filter_model.dart';
import 'package:dokter_panggil/src/models/diagnosa_model.dart';
import 'package:dokter_panggil/src/pages/components/button_edit_master.dart';
import 'package:dokter_panggil/src/pages/components/close_button.dart';
import 'package:dokter_panggil/src/pages/components/confirm_dialog.dart';
import 'package:dokter_panggil/src/pages/components/error_dialog.dart';
import 'package:dokter_panggil/src/pages/components/header.dart';
import 'package:dokter_panggil/src/pages/components/input_form.dart';
import 'package:dokter_panggil/src/pages/components/loading_kit.dart';
import 'package:dokter_panggil/src/pages/components/search_input_form.dart';
import 'package:dokter_panggil/src/pages/components/success_dialog.dart';
import 'package:dokter_panggil/src/pages/master/diagnosa_pencarian_page.dart';
import 'package:dokter_panggil/src/repositories/responseApi/api_response.dart';
import 'package:dokter_panggil/src/source/config.dart';
import 'package:dokter_panggil/src/source/transition/slide_left_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:dokter_panggil/src/source/transition/animated_dialog.dart';

class DiagnosaPage extends StatefulWidget {
  const DiagnosaPage({super.key});

  @override
  State<DiagnosaPage> createState() => _DiagnosaPageState();
}

class _DiagnosaPageState extends State<DiagnosaPage> {
  final DiagnosaBloc _diagnosaBloc = DiagnosaBloc();
  final _formKey = GlobalKey<FormState>();
  final _diagnosaCon = TextEditingController();
  final _kodeCon = TextEditingController();
  bool _editForm = false;
  String? _diagnosa, _kode;

  bool validateAndSave() {
    var formState = _formKey.currentState;
    if (formState!.validate()) {
      formState.save();
      return true;
    }
    return false;
  }

  void _edit(Diagnosa diagnosa) {
    _diagnosaCon.text = diagnosa.namaDiagnosa!;
    _kodeCon.text = diagnosa.kodeIcd10!;
    _diagnosaBloc.idSink.add(diagnosa.id!);
    setState(() {
      _editForm = true;
    });
  }

  void _simpan() {
    if (validateAndSave()) {
      _diagnosaBloc.diagnosaSink.add(_diagnosa!);
      _diagnosaBloc.kodeSink.add(_kode!);
      _diagnosaBloc.saveDiagnosa();
      _dialogStream();
    }
  }

  void _batal() {
    _diagnosaCon.clear();
    _kodeCon.clear();
    setState(() {
      _editForm = false;
    });
  }

  void _update() {
    if (validateAndSave()) {
      _diagnosaBloc.diagnosaSink.add(_diagnosa!);
      _diagnosaBloc.kodeSink.add(_kode!);
      _diagnosaBloc.updateDiagnosa();
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
          _diagnosaBloc.deleteDiagnosa();
          _dialogStream();
        });
      }
    });
  }

  void _dialogStream() {
    showDialog(
      context: context,
      builder: (context) {
        return _streamSave();
      },
    ).then((value) {
      if (value != null) {
        _batal();
      }
    });
  }

  @override
  void dispose() {
    _diagnosaCon.dispose();
    _kodeCon.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: const SystemUiOverlayStyle(
        statusBarBrightness: Brightness.dark,
        statusBarIconBrightness: Brightness.light,
        statusBarColor: Colors.transparent,
      ),
      child: Scaffold(
        body: Form(
          key: _formKey,
          child: Column(
            children: [
              Header(
                title: 'Tambah Diagnosa',
                subtitle: SearchInputForm(
                  isReadOnly: true,
                  hint: 'Pencarian diagnosa',
                  onTap: () => Navigator.push(
                    context,
                    SlideLeftRoute(
                      page: const DiagnosaPencarianPage(),
                    ),
                  ).then((value) {
                    if (value != null) {
                      if (!mounted) return;
                      FocusScope.of(context).requestFocus(FocusNode());
                      var data = value as Diagnosa;
                      _edit(data);
                    }
                  }),
                ),
                closeButton: const ClosedButton(),
              ),
              Expanded(
                child: ListView(
                  padding: const EdgeInsets.symmetric(
                      vertical: 32.0, horizontal: 22.0),
                  children: [
                    Input(
                      controller: _diagnosaCon,
                      label: 'Diagnosa',
                      hint: 'Nama diagnosa',
                      validator: (val) {
                        if (val!.isEmpty) {
                          return 'Input required';
                        }
                        return null;
                      },
                      onSave: (val) => _diagnosa = val,
                      textCap: TextCapitalization.words,
                    ),
                    const SizedBox(
                      height: 32.0,
                    ),
                    Input(
                      controller: _kodeCon,
                      label: 'Kode',
                      hint: 'Kode  icd 10',
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

  Widget _streamSave() {
    return StreamBuilder<ApiResponse<ResponseDiagnosaModel>>(
      stream: _diagnosaBloc.masterDiagnosaStream,
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
