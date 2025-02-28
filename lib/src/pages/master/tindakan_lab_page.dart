import 'package:animate_icons/animate_icons.dart';
import 'package:dokter_panggil/src/blocs/master_tindakan_lab_save_bloc.dart';
import 'package:dokter_panggil/src/models/master_tindakan_lab_all_model.dart';
import 'package:dokter_panggil/src/models/master_tindakan_lab_save_model.dart';
import 'package:dokter_panggil/src/models/mitra_filter_model.dart';
import 'package:dokter_panggil/src/pages/components/button_edit_master.dart';
import 'package:dokter_panggil/src/pages/components/close_button.dart';
import 'package:dokter_panggil/src/pages/components/confirm_dialog.dart';
import 'package:dokter_panggil/src/pages/components/error_dialog.dart';
import 'package:dokter_panggil/src/pages/components/header.dart';
import 'package:dokter_panggil/src/pages/components/input_form.dart';
import 'package:dokter_panggil/src/pages/components/loading_kit.dart';
import 'package:dokter_panggil/src/pages/components/mitra_select.dart';
import 'package:dokter_panggil/src/pages/components/search_input_form.dart';
import 'package:dokter_panggil/src/pages/components/success_dialog.dart';
import 'package:dokter_panggil/src/pages/master/tindakan_lab_pencarian_page.dart';
import 'package:dokter_panggil/src/repositories/responseApi/api_response.dart';
import 'package:dokter_panggil/src/source/config.dart';
import 'package:dokter_panggil/src/source/transition/slide_left_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:dokter_panggil/src/source/transition/animated_dialog.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';

class TindakanLabPage extends StatefulWidget {
  const TindakanLabPage({super.key});

  @override
  State<TindakanLabPage> createState() => _TindakanLabPageState();
}

class _TindakanLabPageState extends State<TindakanLabPage> {
  final _masterTindakanLabSaveBloc = MasterTindakanLabSaveBloc();
  final _animateIconController = AnimateIconController();
  final _formKey = GlobalKey<FormState>();
  final _kode = TextEditingController();
  final _namaTindakanLab = TextEditingController();
  final _hargaModal = TextEditingController();
  final _mitra = TextEditingController();
  bool _editForm = false;
  int _jenisTindakan = 1;

  bool validateAndSave() {
    var formState = _formKey.currentState;
    if (formState!.validate()) {
      formState.save();
      return true;
    }
    return false;
  }

  void _showMitra() {
    _animateIconController.animateToEnd();
    showBarModalBottomSheet(
      context: context,
      builder: (context) {
        return const MitraSelect(
          jenis: 'tindakan_lab',
        );
      },
    ).then((value) {
      _animateIconController.animateToStart();
      if (value != null) {
        var data = value as MitraFilter;
        _masterTindakanLabSaveBloc.mitraSink.add(data.id.toString());
        _masterTindakanLabSaveBloc.persenSink.add(data.persentase!);
        _mitra.text = data.namaMitra!;
        setState(() {});
      }
    });
  }

  void _simpan() {
    if (validateAndSave()) {
      SystemChannels.textInput.invokeMethod('TextInput.hide');
      FocusScope.of(context).unfocus();
      String jenis = _jenisTindakan == 1 ? 'konsul' : 'non-konsul';
      _masterTindakanLabSaveBloc.kodeSink.add(_kode.text);
      _masterTindakanLabSaveBloc.namaTindakanLabSink.add(_namaTindakanLab.text);
      _masterTindakanLabSaveBloc.jenisSink.add(jenis);
      _masterTindakanLabSaveBloc.hargaModalSink
          .add(int.parse(_hargaModal.text));
      _masterTindakanLabSaveBloc.saveTindakanLab();
      _showStreamTindakanLabSave();
    }
  }

  void _edit(MasterTindakanLabAll data) {
    if (data.kodeLayanan != null) {
      _kode.text = '${data.kodeLayanan}';
    } else {
      _kode.clear();
    }
    if (data.mitra != null) {
      _masterTindakanLabSaveBloc.mitraSink.add(data.mitra!.id.toString());
      _masterTindakanLabSaveBloc.persenSink.add(data.mitra!.persentase!);
      _mitra.text = '${data.mitra!.namaMitra}';
    } else {
      _masterTindakanLabSaveBloc.mitraSink.add('');
      _masterTindakanLabSaveBloc.persenSink.add('');
      _mitra.clear();
    }
    _masterTindakanLabSaveBloc.idSink.add(data.id!);
    _namaTindakanLab.text = '${data.namaTindakanLab}';
    _hargaModal.text = data.hargaModal.toString();
    _jenisTindakan = data.jenis!;
    setState(() {
      _editForm = true;
    });
  }

  void _update() {
    if (validateAndSave()) {
      SystemChannels.textInput.invokeMethod('TextInput.hide');
      FocusScope.of(context).unfocus();
      String jenis = _jenisTindakan == 1 ? 'konsul' : 'non-konsul';
      _masterTindakanLabSaveBloc.kodeSink.add(_kode.text);
      _masterTindakanLabSaveBloc.namaTindakanLabSink.add(_namaTindakanLab.text);
      _masterTindakanLabSaveBloc.hargaModalSink
          .add(int.parse(_hargaModal.text));
      _masterTindakanLabSaveBloc.jenisSink.add(jenis);
      _masterTindakanLabSaveBloc.updateTindakanLab();
      _showStreamTindakanLabSave();
    }
  }

  void _delete() {
    showAnimatedDialog(
      context: context,
      builder: (context) {
        return ConfirmDialogWidget(
          message: 'Anda yakin menghapus data ini?',
          onConfirm: () => Navigator.pop(context, 'confirm'),
        );
      },
      duration: const Duration(milliseconds: 500),
      animationType: DialogTransitionType.slideFromBottomFade,
    ).then((value) {
      if (value != null) {
        _masterTindakanLabSaveBloc.deleteTindakanLab();
        _showStreamTindakanLabSave();
      }
    });
  }

  void _batal() {
    _kode.clear();
    _namaTindakanLab.clear();
    _hargaModal.clear();
    _mitra.clear();
    _masterTindakanLabSaveBloc.mitraSink.add('');
    _masterTindakanLabSaveBloc.persenSink.add('');
    _jenisTindakan = 1;
    setState(() {
      _editForm = false;
    });
  }

  void _showStreamTindakanLabSave() {
    showAnimatedDialog(
      context: context,
      builder: (context) {
        return _streamTindakanLabSave(context);
      },
      duration: const Duration(milliseconds: 500),
      animationType: DialogTransitionType.slideFromBottomFade,
    ).then((value) {
      if (value != null) {
        _batal();
        setState(() {});
      }
    });
  }

  @override
  void dispose() {
    _masterTindakanLabSaveBloc.dispose();
    _kode.dispose();
    _namaTindakanLab.dispose();
    _hargaModal.dispose();
    _mitra.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Header(
            title: 'Tambah Tindakan Laboratorium',
            subtitle: SearchInputForm(
              isReadOnly: true,
              hint: 'Pencarian tindakan',
              onTap: () => Navigator.push(
                context,
                SlideLeftRoute(
                  page: const TindakanLabPencarianPage(),
                ),
              ).then((value) {
                if (value != null) {
                  if (!mounted) return;
                  FocusScope.of(context).requestFocus(FocusNode());
                  var data = value as MasterTindakanLabAll;
                  _edit(data);
                }
              }),
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
                    controller: _kode,
                    label: 'Kode Tindakan',
                    hint: 'Kode tindakan laboratorium',
                    textInputAction: TextInputAction.next,
                  ),
                  const SizedBox(
                    height: 22.0,
                  ),
                  Input(
                    controller: _namaTindakanLab,
                    label: 'Nama Tindakan',
                    hint: 'Nama tindakan laboratorium',
                    validator: (val) {
                      if (val!.isEmpty) {
                        return 'Input required';
                      }
                      return null;
                    },
                    textCap: TextCapitalization.words,
                    textInputAction: TextInputAction.next,
                  ),
                  const SizedBox(
                    height: 22.0,
                  ),
                  Input(
                    controller: _hargaModal,
                    label: 'Harga modal',
                    hint: 'Harga modal tindakan laboratorium',
                    validator: (val) {
                      if (val!.isEmpty) {
                        return 'Input required';
                      }
                      return null;
                    },
                    keyType: TextInputType.number,
                    textInputAction: TextInputAction.done,
                  ),
                  const SizedBox(
                    height: 22.0,
                  ),
                  Input(
                    controller: _mitra,
                    label: 'Mitra',
                    hint: 'Nama mitra/penyedia',
                    onSave: (val) {},
                    onTap: _showMitra,
                    textCap: TextCapitalization.words,
                    readOnly: true,
                    validator: (val) {
                      if (val!.isEmpty) {
                        return 'Input required';
                      }
                      return null;
                    },
                    suffixIcon: AnimateIcons(
                      startIconColor: Colors.grey,
                      endIconColor: Colors.grey,
                      startIcon: Icons.expand_more_rounded,
                      endIcon: Icons.expand_less_rounded,
                      duration: const Duration(milliseconds: 300),
                      onStartIconPress: () {
                        _showMitra();
                        return false;
                      },
                      onEndIconPress: () {
                        Navigator.pop(context);
                        return false;
                      },
                      controller: _animateIconController,
                    ),
                  ),
                  const SizedBox(
                    height: 22.0,
                  ),
                  const Text(
                    'Jenis Tindakan',
                    style: TextStyle(fontWeight: FontWeight.w600),
                  ),
                  const SizedBox(
                    height: 12.0,
                  ),
                  Row(
                    children: [
                      Expanded(
                        child: RadioListTile(
                          contentPadding: EdgeInsets.zero,
                          value: 1,
                          groupValue: _jenisTindakan,
                          shape: RoundedRectangleBorder(
                            side: const BorderSide(
                                color: Colors.grey, width: 0.3),
                            borderRadius: BorderRadius.circular(12.0),
                          ),
                          onChanged: (int? value) {
                            setState(() {
                              _jenisTindakan = value!;
                            });
                          },
                          title: const Text('Konsul'),
                        ),
                      ),
                      const SizedBox(
                        width: 8.0,
                      ),
                      Expanded(
                        child: RadioListTile(
                          contentPadding: EdgeInsets.zero,
                          value: 0,
                          groupValue: _jenisTindakan,
                          shape: RoundedRectangleBorder(
                            side: const BorderSide(
                                color: Colors.grey, width: 0.3),
                            borderRadius: BorderRadius.circular(12.0),
                          ),
                          onChanged: (int? value) {
                            setState(() {
                              _jenisTindakan = value!;
                            });
                          },
                          title: const Text('Non Konsul'),
                        ),
                      ),
                    ],
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
            ),
          )
        ],
      ),
    );
  }

  Widget _streamTindakanLabSave(BuildContext context) {
    return StreamBuilder<ApiResponse<ResponseMasterTindakanLabSaveModel>>(
      stream: _masterTindakanLabSaveBloc.tindakanLabSaveStream,
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
}
