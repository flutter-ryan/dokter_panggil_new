import 'package:animate_icons/animate_icons.dart';
import 'package:dokter_panggil/src/blocs/master_farmasi_bloc.dart';
import 'package:dokter_panggil/src/models/master_farmasi_model.dart';
import 'package:dokter_panggil/src/models/master_farmasi_paginate_model.dart';
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
import 'package:dokter_panggil/src/pages/master/farmasi_pencarian_page.dart';
import 'package:dokter_panggil/src/repositories/responseApi/api_response.dart';
import 'package:dokter_panggil/src/source/config.dart';
import 'package:dokter_panggil/src/source/transition/slide_left_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:dokter_panggil/src/source/transition/animated_dialog.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';

class FarmasiPage extends StatefulWidget {
  const FarmasiPage({super.key});

  @override
  State<FarmasiPage> createState() => _FarmasiPageState();
}

class _FarmasiPageState extends State<FarmasiPage> {
  final MasterFarmasiBloc _masterFarmasiBloc = MasterFarmasiBloc();
  final AnimateIconController _animateIconController = AnimateIconController();
  final _formKey = GlobalKey<FormState>();
  final _mitraCon = TextEditingController();
  final _barangCon = TextEditingController();
  final _hargaCon = TextEditingController();
  bool _editForm = false;
  String? _barang, _harga;

  bool validateAndSave() {
    var formState = _formKey.currentState;
    if (formState!.validate()) {
      formState.save();
      return true;
    }
    return false;
  }

  void _batal() {
    _barangCon.clear();
    _hargaCon.clear();
    _mitraCon.clear();
    setState(() {
      _editForm = false;
    });
  }

  void _simpan() {
    if (validateAndSave()) {
      _masterFarmasiBloc.barangSink.add(_barang!);
      _masterFarmasiBloc.hargaSink.add(int.parse(_harga!));
      _masterFarmasiBloc.saveMasterFarmasi();
      _dialogStream();
    }
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

  void _showMitra() {
    _animateIconController.animateToEnd();
    showMaterialModalBottomSheet(
      context: context,
      builder: (context) {
        return const MitraSelect(
          jenis: 'farmasi',
        );
      },
    ).then((value) {
      _animateIconController.animateToStart();
      if (value != null) {
        var data = value as MitraFilter;
        _masterFarmasiBloc.mitraSink.add(data.id!);
        _masterFarmasiBloc.persenSink.add(data.persentase!);
        _mitraCon.text = data.namaMitra!;
        setState(() {});
      }
    });
  }

  void _edit(BarangFarmasi barang) {
    _mitraCon.text = barang.mitraFarmasi!.namaMitra!;
    _barangCon.text = barang.namaBarang!;
    _hargaCon.text = barang.hargaModal.toString();
    _masterFarmasiBloc.idSink.add(barang.id!);
    _masterFarmasiBloc.mitraSink.add(barang.mitraFarmasi!.id!);
    _masterFarmasiBloc.persenSink.add(barang.mitraFarmasi!.persentase!);
    setState(() {
      _editForm = true;
    });
  }

  void _update() {
    if (validateAndSave()) {
      _masterFarmasiBloc.barangSink.add(_barangCon.text);
      _masterFarmasiBloc.hargaSink.add(int.parse(_harga!));
      _masterFarmasiBloc.updateMasterFarmasi();
      _dialogStream();
    }
  }

  void _confirmDelete() {
    showAnimatedDialog(
      context: context,
      builder: (context) {
        return ConfirmDialogWidget(
          onConfirm: () => Navigator.pop(context, 'hapus'),
          message: 'Anda yakin ingin menghapus data ini?',
        );
      },
      animationType: DialogTransitionType.slideFromBottomFade,
      duration: const Duration(milliseconds: 500),
    ).then((value) {
      if (value != null) {
        _delete();
      }
    });
  }

  void _delete() {
    _masterFarmasiBloc.deleteMasterFarmasi();
    _dialogStream();
  }

  @override
  void dispose() {
    _mitraCon.dispose();
    _barangCon.dispose();
    _hargaCon.dispose();
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
        body: Column(
          children: [
            Header(
              title: 'Tambah Barang Farmasi',
              subtitle: SearchInputForm(
                isReadOnly: true,
                hint: 'Pencarian barang farmasi',
                onTap: () => Navigator.push(
                  context,
                  SlideLeftRoute(
                    page: const FarmasiPencarianPage(),
                  ),
                ).then((value) {
                  if (value != null) {
                    if (!mounted) return;
                    FocusScope.of(context).requestFocus(FocusNode());
                    var data = value as BarangFarmasi;
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
                    vertical: 32.0,
                    horizontal: 22.0,
                  ),
                  children: [
                    Input(
                      controller: _mitraCon,
                      label: 'Mitra',
                      hint: 'Nama mitra/penyedia',
                      validator: (val) {
                        if (val!.isEmpty) {
                          return 'Input required';
                        }
                        return null;
                      },
                      onSave: (val) {},
                      onTap: _editForm
                          ? null
                          : () {
                              FocusScope.of(context).requestFocus(FocusNode());
                              _showMitra();
                            },
                      textCap: TextCapitalization.words,
                      readOnly: true,
                      suffixIcon: _editForm
                          ? null
                          : AnimateIcons(
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
                    Input(
                      controller: _barangCon,
                      label: 'Nama',
                      hint: 'Nama barang/obat',
                      validator: (val) {
                        if (val!.isEmpty) {
                          return 'Input required';
                        }
                        return null;
                      },
                      onSave: (val) => _barang = val,
                      textCap: TextCapitalization.words,
                    ),
                    const SizedBox(
                      height: 22.0,
                    ),
                    Input(
                      controller: _hargaCon,
                      label: 'Harga Modal',
                      hint: 'Harga modal barang/obat mitra',
                      validator: (val) {
                        if (val!.isEmpty) {
                          return 'Input required';
                        }
                        return null;
                      },
                      onSave: (val) => _harga = val,
                      keyType: TextInputType.number,
                    ),
                    const SizedBox(
                      height: 52.0,
                    ),
                    if (!_editForm)
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
                    else
                      ButtonEditMaster(
                        update: _update,
                        delete: _confirmDelete,
                        batal: _batal,
                      )
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget _streamSave() {
    return StreamBuilder<ApiResponse<ResponseMasterFarmasiModel>>(
      stream: _masterFarmasiBloc.masterFarmasiStream,
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
