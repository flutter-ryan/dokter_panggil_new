import 'package:admin_dokter_panggil/src/blocs/master_tindakan_rad_save_bloc.dart';
import 'package:admin_dokter_panggil/src/models/master_tindakan_rad_create_mode.dart';
import 'package:admin_dokter_panggil/src/models/master_tindakan_rad_save_model.dart';
import 'package:admin_dokter_panggil/src/pages/components/close_button.dart';
import 'package:admin_dokter_panggil/src/pages/components/confirm_dialog.dart';
import 'package:admin_dokter_panggil/src/pages/components/error_dialog.dart';
import 'package:admin_dokter_panggil/src/pages/components/header.dart';
import 'package:admin_dokter_panggil/src/pages/components/input_form.dart';
import 'package:admin_dokter_panggil/src/pages/components/loading_kit.dart';
import 'package:admin_dokter_panggil/src/pages/components/search_input_form.dart';
import 'package:admin_dokter_panggil/src/pages/components/success_dialog.dart';
import 'package:admin_dokter_panggil/src/pages/master/tindakan_rad_pencarian_page.dart';
import 'package:admin_dokter_panggil/src/repositories/responseApi/api_response.dart';
import 'package:admin_dokter_panggil/src/source/config.dart';
import 'package:admin_dokter_panggil/src/source/transition/slide_left_route.dart';
import 'package:flutter/material.dart';
import 'package:admin_dokter_panggil/src/source/transition/animated_dialog.dart';

class TindakanRadiologiPage extends StatefulWidget {
  const TindakanRadiologiPage({super.key});

  @override
  State<TindakanRadiologiPage> createState() => _TindakanRadiologiPageState();
}

class _TindakanRadiologiPageState extends State<TindakanRadiologiPage> {
  final _masterTindakanRadSaveBloc = MasterTindakanRadSaveBloc();
  final _formKey = GlobalKey<FormState>();
  final _namaTindakan = TextEditingController();
  final _hargaModal = TextEditingController();
  final _persen = TextEditingController();
  bool _isEdit = false;

  bool validateAndSave() {
    final formData = _formKey.currentState;
    if (formData!.validate()) {
      formData.save();
      return true;
    }
    return false;
  }

  void _saveTindakanRad() {
    if (validateAndSave()) {
      _masterTindakanRadSaveBloc.namaTindakanSink.add(_namaTindakan.text);
      _masterTindakanRadSaveBloc.hargaModalSink
          .add(int.parse(_hargaModal.text));
      _masterTindakanRadSaveBloc.persenSink.add(double.parse(_persen.text));
      _masterTindakanRadSaveBloc.saveTindakanRad();
      _showStreamSaveTindakanRad();
    }
  }

  void _showStreamSaveTindakanRad() {
    showAnimatedDialog(
      context: context,
      builder: (context) {
        return _streamSaveTindakanRad(context);
      },
      duration: const Duration(milliseconds: 500),
      animationType: DialogTransitionType.slideFromBottomFade,
    ).then((value) {
      if (value != null) {
        _resetForm();
        setState(() {
          _isEdit = false;
        });
      }
    });
  }

  void _resetForm() {
    _namaTindakan.clear();
    _hargaModal.clear();
    _persen.clear();
  }

  void _edit(MasterTindakanRad data) {
    double persentase = (data.tarifAplikasi! / data.hargaModal!) * 100;
    _namaTindakan.text = '${data.namaTindakan}';
    _hargaModal.text = data.hargaModal.toString();
    _persen.text = persentase.toString();
    _masterTindakanRadSaveBloc.idTindakanRadSink.add(data.id!);
    setState(() {
      _isEdit = true;
    });
  }

  void _updateTindakanRad() {
    if (validateAndSave()) {
      _masterTindakanRadSaveBloc.namaTindakanSink.add(_namaTindakan.text);
      _masterTindakanRadSaveBloc.hargaModalSink
          .add(int.parse(_hargaModal.text));
      _masterTindakanRadSaveBloc.persenSink.add(double.parse(_persen.text));
      _masterTindakanRadSaveBloc.updateTindakanRad();
      _showStreamSaveTindakanRad();
    }
  }

  void _deleteTindakanRad() {
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
        _masterTindakanRadSaveBloc.deleteTindakanRad();
        _showStreamSaveTindakanRad();
      }
    });
  }

  void _cariTindakanRadiologi() {
    Navigator.push(
      context,
      SlideLeftRoute(
        page: const TindakanRadPencarianPage(),
      ),
    ).then((value) {
      if (value != null) {
        if (!mounted) return;
        FocusScope.of(context).requestFocus(FocusNode());
        var data = value as MasterTindakanRad;
        _edit(data);
      }
    });
  }

  @override
  void dispose() {
    _namaTindakan.dispose();
    _hargaModal.dispose();
    _persen.dispose();
    _masterTindakanRadSaveBloc.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Header(
            title: 'Tambah Tindakan Radiologi',
            subtitle: SearchInputForm(
              isReadOnly: true,
              hint: 'Pencarian tindakan radiologi',
              onTap: _cariTindakanRadiologi,
            ),
            closeButton: const ClosedButton(),
          ),
          Expanded(
            child: Form(
              key: _formKey,
              child: ListView(
                padding: const EdgeInsets.symmetric(
                    vertical: 32.0, horizontal: 22.0),
                children: [
                  Input(
                    controller: _namaTindakan,
                    label: 'Nama Tindakan',
                    hint: 'Nama tindakan radiologi',
                    textInputAction: TextInputAction.next,
                    textCap: TextCapitalization.words,
                    validator: (val) {
                      if (val!.isEmpty) {
                        return 'Input required';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(
                    height: 22,
                  ),
                  Input(
                    controller: _hargaModal,
                    label: 'Harga Modal',
                    hint: 'Harga modal tindakan radiologi',
                    textInputAction: TextInputAction.next,
                    keyType: TextInputType.number,
                    validator: (val) {
                      if (val!.isEmpty) {
                        return 'Input required';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(
                    height: 22,
                  ),
                  Input(
                    controller: _persen,
                    label: 'Persentase',
                    hint: 'Persentase harga modal',
                    textInputAction: TextInputAction.next,
                    keyType: TextInputType.number,
                    validator: (val) {
                      if (val!.isEmpty) {
                        return 'Input required';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(
                    height: 52.0,
                  ),
                  if (_isEdit)
                    Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Row(
                          children: [
                            Expanded(
                              child: ElevatedButton(
                                onPressed: _deleteTindakanRad,
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: kPrimaryColor,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(4.0),
                                  ),
                                  minimumSize: const Size.fromHeight(48.0),
                                ),
                                child: const Text('HAPUS'),
                              ),
                            ),
                            const SizedBox(
                              width: 12.0,
                            ),
                            Expanded(
                              child: ElevatedButton(
                                onPressed: _updateTindakanRad,
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.blue,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(4.0),
                                  ),
                                  minimumSize: const Size.fromHeight(48.0),
                                ),
                                child: const Text('UPDATE'),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(
                          height: 12,
                        ),
                        ElevatedButton(
                          onPressed: () {
                            _resetForm();
                            setState(() {
                              _isEdit = false;
                            });
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.grey[200],
                            foregroundColor: Colors.black,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(4.0),
                            ),
                            minimumSize: const Size(double.infinity, 48.0),
                          ),
                          child: const Text('BATAL'),
                        ),
                      ],
                    )
                  else
                    ElevatedButton(
                      onPressed: _saveTindakanRad,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: kPrimaryColor,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(4.0),
                        ),
                        minimumSize: const Size(double.infinity, 48.0),
                      ),
                      child: const Text('SIMPAN'),
                    )
                ],
              ),
            ),
          )
        ],
      ),
    );
  }

  Widget _streamSaveTindakanRad(BuildContext context) {
    return StreamBuilder<ApiResponse<ResponseMasterTindakanRadSaveModel>>(
      stream: _masterTindakanRadSaveBloc.masterTindakanRadSaveStream,
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
}
