import 'package:admin_dokter_panggil/src/blocs/master_diskon_save_bloc.dart';
import 'package:admin_dokter_panggil/src/models/master_diskon_create_model.dart';
import 'package:admin_dokter_panggil/src/models/master_diskon_save_model.dart';
import 'package:admin_dokter_panggil/src/pages/components/button_edit_master.dart';
import 'package:admin_dokter_panggil/src/pages/components/close_button.dart';
import 'package:admin_dokter_panggil/src/pages/components/confirm_dialog.dart';
import 'package:admin_dokter_panggil/src/pages/components/error_dialog.dart';
import 'package:admin_dokter_panggil/src/pages/components/header.dart';
import 'package:admin_dokter_panggil/src/pages/components/input_form.dart';
import 'package:admin_dokter_panggil/src/pages/components/loading_kit.dart';
import 'package:admin_dokter_panggil/src/pages/components/search_input_form.dart';
import 'package:admin_dokter_panggil/src/pages/components/success_dialog.dart';
import 'package:admin_dokter_panggil/src/pages/master/diskon_pencarian_page.dart';
import 'package:admin_dokter_panggil/src/repositories/responseApi/api_response.dart';
import 'package:admin_dokter_panggil/src/source/config.dart';
import 'package:admin_dokter_panggil/src/source/transition/slide_left_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:admin_dokter_panggil/src/source/transition/animated_dialog.dart';

class DiskonPage extends StatefulWidget {
  const DiskonPage({super.key});

  @override
  State<DiskonPage> createState() => _DiskonPageState();
}

class _DiskonPageState extends State<DiskonPage> {
  final _masterDiskonSaveBloc = MasterDiskonSaveBloc();
  final _deskripsi = TextEditingController();
  final _nilai = TextEditingController();
  int _persen = 0;
  final _formKey = GlobalKey<FormState>();
  bool _editForm = false;

  bool validateAndSave() {
    var formData = _formKey.currentState;
    if (formData!.validate()) {
      return true;
    }
    return false;
  }

  void _simpan() {
    if (validateAndSave()) {
      SystemChannels.textInput.invokeMethod('TextInput.hide');
      FocusScope.of(context).requestFocus(FocusNode());
      _masterDiskonSaveBloc.deskripsiSink.add(_deskripsi.text);
      _masterDiskonSaveBloc.nilaiSink.add(_nilai.text);
      _masterDiskonSaveBloc.persenSink.add(_persen);
      _masterDiskonSaveBloc.saveMasterDiskon();
      _dialogStream();
    }
  }

  void _edit(MasterDiskon data) {
    _deskripsi.text = data.deskripsi;
    _nilai.text = data.nilai.toString();
    _persen = data.isPersen;
    _masterDiskonSaveBloc.idSink.add(data.id);
    setState(() {
      _editForm = true;
    });
  }

  void _update() {
    SystemChannels.textInput.invokeMethod('TextInput.hide');
    FocusScope.of(context).requestFocus(FocusNode());
    _masterDiskonSaveBloc.deskripsiSink.add(_deskripsi.text);
    _masterDiskonSaveBloc.nilaiSink.add(_nilai.text);
    _masterDiskonSaveBloc.persenSink.add(_persen);
    _masterDiskonSaveBloc.updateMasterDiskon();
    _dialogStream();
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
          _masterDiskonSaveBloc.deleteMasterDiskon();
          _dialogStream();
        });
      }
    });
  }

  void _dialogStream() {
    showAnimatedDialog(
      context: context,
      builder: (context) {
        return _streamSave(context);
      },
      animationType: DialogTransitionType.slideFromBottom,
      duration: const Duration(milliseconds: 500),
    ).then((value) {
      if (value != null) {
        _batal();
      }
    });
  }

  void _batal() {
    _deskripsi.clear();
    _nilai.clear();
    setState(() {
      _editForm = false;
    });
  }

  void _tambahDiskon() {
    Navigator.push(
      context,
      SlideLeftRoute(
        page: const DiskonPencarianPage(),
      ),
    ).then((value) {
      if (value != null) {
        var data = value as MasterDiskon;
        if (!mounted) return;
        FocusScope.of(context).requestFocus(FocusNode());
        _formKey.currentState!.reset();
        _edit(data);
      }
    });
  }

  @override
  void dispose() {
    _masterDiskonSaveBloc.dispose();
    _deskripsi.dispose();
    _nilai.dispose();
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
                title: 'Tambaha Diskon',
                subtitle: SearchInputForm(
                  hint: 'Pencarian diskon',
                  isReadOnly: true,
                  onTap: _tambahDiskon,
                ),
                closeButton: const ClosedButton(),
              ),
              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.symmetric(
                      vertical: 32.0, horizontal: 22.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Input(
                        controller: _deskripsi,
                        label: 'Deskripsi',
                        hint: 'Deskripsi diskon',
                        validator: (val) {
                          if (val!.isEmpty) {
                            return 'Input required';
                          }
                          return null;
                        },
                        onSave: (val) {},
                        textCap: TextCapitalization.words,
                      ),
                      const SizedBox(
                        height: 32.0,
                      ),
                      const Text(
                        'Jenis Diskon',
                        style: TextStyle(fontWeight: FontWeight.w600),
                      ),
                      const SizedBox(
                        height: 12.0,
                      ),
                      RadioGroup<int>(
                        groupValue: _persen,
                        onChanged: (int? value) {
                          setState(() {
                            _persen = value!;
                          });
                        },
                        child: Row(
                          children: [
                            Expanded(
                              child: RadioListTile<int>(
                                contentPadding: EdgeInsets.zero,
                                value: 0,
                                shape: RoundedRectangleBorder(
                                  side: const BorderSide(
                                    color: Colors.grey,
                                    width: 0.3,
                                  ),
                                  borderRadius: BorderRadius.circular(12.0),
                                ),
                                title: const Text('Nominal'),
                              ),
                            ),
                            const SizedBox(
                              width: 8.0,
                            ),
                            Expanded(
                              child: RadioListTile<int>(
                                contentPadding: EdgeInsets.zero,
                                value: 1,
                                shape: RoundedRectangleBorder(
                                  side: const BorderSide(
                                      color: Colors.grey, width: 0.3),
                                  borderRadius: BorderRadius.circular(12.0),
                                ),
                                title: const Text('Persen'),
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(
                        height: 32.0,
                      ),
                      Input(
                        controller: _nilai,
                        label: 'Nilai',
                        hint: 'Nilai diskon',
                        validator: (val) {
                          if (val!.isEmpty) {
                            return 'Input required';
                          }
                          return null;
                        },
                        onSave: (val) {},
                        keyType: TextInputType.number,
                      ),
                      const SizedBox(
                        height: 42.0,
                      ),
                      if (_editForm)
                        ButtonEditMaster(
                          update: _update,
                          delete: _delete,
                          batal: _batal,
                        )
                      else
                        ElevatedButton(
                          onPressed: _simpan,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: kPrimaryColor,
                            minimumSize: const Size(double.infinity, 45),
                          ),
                          child: const Text('SIMPAN'),
                        )
                    ],
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget _streamSave(BuildContext context) {
    return StreamBuilder<ApiResponse<ResponseMasterDiskonSaveModel>>(
      stream: _masterDiskonSaveBloc.saveMasterDiskonStream,
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
