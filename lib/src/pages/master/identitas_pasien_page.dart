import 'package:dokter_panggil/src/blocs/master_idenetitas_bloc.dart';
import 'package:dokter_panggil/src/models/master_identitas_model.dart';
import 'package:dokter_panggil/src/pages/components/button_edit_master.dart';
import 'package:dokter_panggil/src/pages/components/close_button.dart';
import 'package:dokter_panggil/src/pages/components/confirm_dialog.dart';
import 'package:dokter_panggil/src/pages/components/error_dialog.dart';
import 'package:dokter_panggil/src/pages/components/header.dart';
import 'package:dokter_panggil/src/pages/components/input_form.dart';
import 'package:dokter_panggil/src/pages/components/loading_kit.dart';
import 'package:dokter_panggil/src/pages/components/search_input_form.dart';
import 'package:dokter_panggil/src/pages/components/success_dialog.dart';
import 'package:dokter_panggil/src/pages/master/identitas_pasien_pencarian_page.dart';
import 'package:dokter_panggil/src/repositories/responseApi/api_response.dart';
import 'package:dokter_panggil/src/source/config.dart';
import 'package:dokter_panggil/src/source/transition/slide_left_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:dokter_panggil/src/source/transition/animated_dialog.dart';

class IdentitasPasienPage extends StatefulWidget {
  const IdentitasPasienPage({super.key});

  @override
  State<IdentitasPasienPage> createState() => _IdentitasPasienPageState();
}

class _IdentitasPasienPageState extends State<IdentitasPasienPage> {
  final _masterIdentitasBloc = MasterIdentitasBloc();
  final _formKey = GlobalKey<FormState>();
  final _jenis = TextEditingController();
  bool _isEdit = false;

  bool validateAndSave() {
    var formData = _formKey.currentState;
    if (formData!.validate()) {
      formData.save();
      return true;
    }
    return false;
  }

  void _simpan() {
    if (validateAndSave()) {
      SystemChannels.textInput.invokeMethod('TextInput.hide');
      _masterIdentitasBloc.saveMasterIdentitas();
      _showStreamIdentitas();
    }
  }

  void _update() {
    if (validateAndSave()) {
      SystemChannels.textInput.invokeMethod('TextInput.hide');
      _masterIdentitasBloc.jenisSink.add(_jenis.text);
      _masterIdentitasBloc.updateMasterIdentitas();
      _showStreamIdentitas();
    }
  }

  void _delete() {
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
        _masterIdentitasBloc.deleteMasterTindakan();
        _showStreamIdentitas();
      }
    });
  }

  void _showStreamIdentitas() {
    showAnimatedDialog(
      context: context,
      builder: (context) {
        return _streamIdentitas(context);
      },
      animationType: DialogTransitionType.slideFromBottomFade,
      duration: const Duration(milliseconds: 500),
    ).then((value) {
      if (value != null) {
        _formKey.currentState?.reset();
        _jenis.clear();
        setState(() {
          _isEdit = false;
        });
      }
    });
  }

  @override
  void dispose() {
    _masterIdentitasBloc.dispose();
    _jenis.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: const SystemUiOverlayStyle(
        statusBarBrightness: Brightness.dark,
        statusBarIconBrightness: Brightness.light,
        statusBarColor: Colors.transparent,
        systemNavigationBarColor: Colors.white,
      ),
      child: Scaffold(
        body: Form(
          key: _formKey,
          child: Column(
            children: [
              Header(
                title: 'Identitas Pasien',
                subtitle: SearchInputForm(
                  isReadOnly: true,
                  hint: 'Pencarian jenis identitas',
                  onTap: () => Navigator.push(
                    context,
                    SlideLeftRoute(
                      page: const IdentitasPasienPencarianPage(),
                    ),
                  ).then((value) {
                    if (value != null) {
                      var identitas = value as MasterIdentitas;
                      _formKey.currentState!.reset();
                      _masterIdentitasBloc.idIdentitasSink.add(identitas.id!);
                      setState(() {
                        _jenis.text = '${identitas.jenis}';
                        _isEdit = true;
                      });
                    }
                  }),
                ),
                closeButton: const ClosedButton(),
              ),
              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.all(32.0),
                  child: Column(
                    children: [
                      Input(
                        controller: _jenis,
                        label: 'Jenis Identitas',
                        hint: 'Nama jenis identitas',
                        maxLines: 1,
                        validator: (val) {
                          if (val!.isEmpty) {
                            return 'Input required';
                          }
                          return null;
                        },
                        onSave: (val) {
                          _masterIdentitasBloc.jenisSink.add('$val');
                        },
                        textCap: TextCapitalization.words,
                      ),
                      const SizedBox(
                        height: 52.0,
                      ),
                      if (_isEdit)
                        ButtonEditMaster(
                          update: _update,
                          delete: _delete,
                          batal: () {
                            setState(() {
                              _isEdit = false;
                              _formKey.currentState!.reset();
                              _jenis.text = '';
                            });
                          },
                        )
                      else
                        ElevatedButton(
                          onPressed: _simpan,
                          style: ElevatedButton.styleFrom(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8.0),
                            ),
                            minimumSize: const Size(double.infinity, 45),
                            backgroundColor: kPrimaryColor,
                          ),
                          child: const Text('SIMPAN'),
                        ),
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

  Widget _streamIdentitas(BuildContext context) {
    return StreamBuilder<ApiResponse<ResponseMasterIdentitasRequestModel>>(
      stream: _masterIdentitasBloc.masterIdentitasSaveStream,
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
                onTap: () => Navigator.pop(context, 'confirm'),
              );
          }
        }
        return const SizedBox();
      },
    );
  }
}
