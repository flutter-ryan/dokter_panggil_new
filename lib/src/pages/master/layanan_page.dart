import 'package:dokter_panggil/src/blocs/master_group_jabatan_bloc.dart';
import 'package:dokter_panggil/src/blocs/tindakan_bloc.dart';
import 'package:dokter_panggil/src/models/master_group_jabatan_model.dart';
import 'package:dokter_panggil/src/models/master_kategori_tindakan_model.dart';
import 'package:dokter_panggil/src/models/tindakan_edit_model.dart';
import 'package:dokter_panggil/src/models/tindakan_save_model.dart';
import 'package:dokter_panggil/src/pages/components/button_edit_master.dart';
import 'package:dokter_panggil/src/pages/components/close_button.dart';
import 'package:dokter_panggil/src/pages/components/confirm_dialog.dart';
import 'package:dokter_panggil/src/pages/components/error_dialog.dart';
import 'package:dokter_panggil/src/pages/components/header.dart';
import 'package:dokter_panggil/src/pages/components/input_form.dart';
import 'package:dokter_panggil/src/pages/components/loading_kit.dart';
import 'package:dokter_panggil/src/pages/components/search_input_form.dart';
import 'package:dokter_panggil/src/pages/components/success_dialog.dart';
import 'package:dokter_panggil/src/pages/master/layanan_penarian_page.dart';
import 'package:dokter_panggil/src/pages/master/list_kategori_tindakan_page.dart';
import 'package:dokter_panggil/src/repositories/responseApi/api_response.dart';
import 'package:dokter_panggil/src/source/config.dart';
import 'package:dokter_panggil/src/source/transition/slide_left_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:dokter_panggil/src/source/transition/animated_dialog.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:dokter_panggil/src/pages/components/error_response.dart';

class LayananPage extends StatefulWidget {
  const LayananPage({super.key});

  @override
  State<LayananPage> createState() => _LayananPageState();
}

class _LayananPageState extends State<LayananPage> {
  final TindakanBloc _tindakanBloc = TindakanBloc();
  final _masterGroupJabatanBloc = MasterGroupJabatanBloc();
  final _formKey = GlobalKey<FormState>();
  final _layananCon = TextEditingController();
  final _tarifCon = TextEditingController();
  final _jasaCon = TextEditingController();
  final _kategori = TextEditingController();

  bool _selectedBayarLangsung = false;
  bool _selectedGojek = false;
  bool _selectedTransportasi = false;
  bool _editForm = false;
  SelectedGroup? _selectedGroup;
  bool _errorGroupTindakan = false;
  String? _layanan, _tarif, _jasa;

  bool validateAndSave() {
    var formState = _formKey.currentState;
    if (formState!.validate() && _selectedGroup != null) {
      formState.save();
      setState(() {
        _errorGroupTindakan = false;
      });
      return true;
    }
    if (_selectedGroup == null) {
      setState(() {
        _errorGroupTindakan = true;
      });
      return false;
    } else {
      setState(() {
        _errorGroupTindakan = false;
      });
    }
    return false;
  }

  void _simpan() {
    if (validateAndSave()) {
      _tindakanBloc.tindakanSink.add(_layanan!);
      _tindakanBloc.tarifTindakanSink.add(int.parse(_tarif!));
      _tindakanBloc.jasaSink.add(int.parse(_jasa!));
      _tindakanBloc.langsungSink.add(_selectedBayarLangsung);
      _tindakanBloc.gojekSink.add(_selectedGojek);
      _tindakanBloc.transportasiSink.add(_selectedTransportasi);
      _tindakanBloc.idGroupSink.add(_selectedGroup!.id!);
      _tindakanBloc.tindakanSave();
      _dialogStream();
    }
  }

  void _batal() {
    _layananCon.clear();
    _tarifCon.clear();
    _jasaCon.clear();
    setState(() {
      _editForm = false;
      _selectedBayarLangsung = false;
      _selectedGojek = false;
      _selectedTransportasi = false;
      _selectedGroup = null;
      _kategori.clear();
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

  void _edit(Tindakan tindakan) {
    FocusScope.of(context).requestFocus(FocusNode());
    _tindakanBloc.idSink.add(tindakan.id!);
    _tindakanBloc.idKategoriSink.add(tindakan.kategoriId!);
    _layananCon.text = tindakan.namaTindakan!;
    _tarifCon.text = tindakan.tarif.toString();
    _jasaCon.text = tindakan.jasaDokter.toString();
    _kategori.text = '${tindakan.namaKategori}';
    if (tindakan.groupId != null) {
      _selectedGroup = SelectedGroup(
        id: tindakan.groupId,
        namaGroup: tindakan.groupJabatan,
      );
    }
    setState(() {
      _selectedBayarLangsung = tindakan.bayarLangsung == 1 ? true : false;
      _selectedTransportasi = tindakan.transportasi == 1 ? true : false;
      _selectedGojek = tindakan.gojek == 1 ? true : false;
      _editForm = true;
    });
  }

  void _update() {
    if (validateAndSave()) {
      _tindakanBloc.tindakanSink.add(_layanan!);
      _tindakanBloc.tarifTindakanSink.add(int.parse(_tarif!));
      _tindakanBloc.jasaSink.add(int.parse(_jasa!));
      _tindakanBloc.langsungSink.add(_selectedBayarLangsung);
      _tindakanBloc.gojekSink.add(_selectedGojek);
      _tindakanBloc.transportasiSink.add(_selectedTransportasi);
      if (_selectedGroup != null) {
        _tindakanBloc.idGroupSink.add(_selectedGroup!.id!);
      }
      _tindakanBloc.tindakanUpdate();
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
          _tindakanBloc.tindakanDelete();
          _dialogStream();
        });
      }
    });
  }

  void _selectGroup() {
    _masterGroupJabatanBloc.getMasterGroupJabatan();
    showMaterialModalBottomSheet(
      context: context,
      builder: (context) {
        return _streamGroupJabatan(context);
      },
      duration: const Duration(milliseconds: 500),
    ).then((value) {
      if (value != null) {
        var data = value as MasterGroupJabatan;
        setState(() {
          _selectedGroup = SelectedGroup(
            id: data.id,
            namaGroup: data.groupJabatan,
          );
        });
      }
    });
  }

  void _selectKategori() {
    showMaterialModalBottomSheet(
      context: context,
      builder: (context) => ListKategoriTindakanPage(),
    ).then((value) {
      if (value != null) {
        final data = value as MasterKategoriTindakan;
        _tindakanBloc.idKategoriSink.add(data.id!);
        setState(() {
          _kategori.text = '${data.namaKategori}';
        });
      }
    });
  }

  @override
  void dispose() {
    super.dispose();
    _layananCon.dispose();
    _tarifCon.dispose();
    _jasaCon.dispose();
    _tindakanBloc.dispose();
    _masterGroupJabatanBloc.dispose();
    _kategori.dispose();
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
                title: 'Tambah Tindakan',
                subtitle: SearchInputForm(
                  isReadOnly: true,
                  hint: 'Pencarian tindakan',
                  onTap: () => Navigator.push(
                    context,
                    SlideLeftRoute(
                      page: const LayananPecarianPage(),
                    ),
                  ).then((value) {
                    if (value != null) {
                      var data = value as Tindakan;
                      _edit(data);
                    } else {
                      _batal();
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
                      controller: _layananCon,
                      label: 'Layanan',
                      hint: 'Nama tindakan',
                      validator: (val) {
                        if (val!.isEmpty) {
                          return 'Input required';
                        }
                        return null;
                      },
                      onSave: (val) => _layanan = val,
                      textCap: TextCapitalization.words,
                    ),
                    const SizedBox(
                      height: 32.0,
                    ),
                    Input(
                      controller: _kategori,
                      label: 'Kategori',
                      hint: 'Pilih Kategori tindakan',
                      validator: (val) {
                        if (val!.isEmpty) {
                          return 'Input required';
                        }
                        return null;
                      },
                      readOnly: true,
                      onSave: (val) => _layanan = val,
                      suffixIcon: Icon(Icons.keyboard_arrow_down_rounded),
                      textCap: TextCapitalization.words,
                      onTap: _selectKategori,
                    ),
                    const SizedBox(
                      height: 32.0,
                    ),
                    Input(
                      controller: _tarifCon,
                      label: 'Tarif',
                      hint: 'Tarif tindakan',
                      maxLines: 1,
                      validator: (val) {
                        if (val!.isEmpty) {
                          return 'Input required';
                        }
                        return null;
                      },
                      onSave: (val) => _tarif = val,
                      keyType: TextInputType.number,
                    ),
                    const SizedBox(
                      height: 32.0,
                    ),
                    Input(
                      controller: _jasaCon,
                      label: 'Jasa',
                      hint: 'Jasa dokter',
                      maxLines: 1,
                      validator: (val) {
                        if (val!.isEmpty) {
                          return 'Input required';
                        }
                        return null;
                      },
                      onSave: (val) => _jasa = val,
                      keyType: TextInputType.number,
                    ),
                    const SizedBox(
                      height: 32,
                    ),
                    const Text(
                      'Group tindakan',
                      style: TextStyle(fontWeight: FontWeight.w600),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    Container(
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.grey, width: 0.5),
                        borderRadius: BorderRadius.circular(8.0),
                        color: Colors.blueGrey[50],
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          ListTile(
                            onTap: _selectGroup,
                            title: _selectedGroup != null
                                ? Text('${_selectedGroup!.namaGroup}')
                                : Text(
                                    'Pilih salah satu',
                                    style: TextStyle(color: Colors.grey[400]),
                                  ),
                            trailing: Icon(
                              Icons.keyboard_arrow_right,
                              color: Colors.grey[400],
                            ),
                          ),
                          if (_errorGroupTindakan)
                            const Padding(
                              padding: EdgeInsets.symmetric(
                                  horizontal: 18.0, vertical: 8.0),
                              child: Text(
                                'Input required',
                                style:
                                    TextStyle(fontSize: 12, color: Colors.red),
                              ),
                            ),
                        ],
                      ),
                    ),
                    const SizedBox(
                      height: 32.0,
                    ),
                    const Text(
                      'Pendukung layanan',
                      style: TextStyle(fontWeight: FontWeight.w600),
                    ),
                    CheckboxListTile(
                      contentPadding: EdgeInsets.zero,
                      controlAffinity: ListTileControlAffinity.leading,
                      title: const Text('Bayar langsung'),
                      activeColor: kPrimaryColor,
                      value: _selectedBayarLangsung,
                      onChanged: (val) {
                        setState(() {
                          _selectedBayarLangsung = val!;
                        });
                      },
                    ),
                    CheckboxListTile(
                      contentPadding: EdgeInsets.zero,
                      controlAffinity: ListTileControlAffinity.leading,
                      title: const Text('Transportasi'),
                      activeColor: kPrimaryColor,
                      value: _selectedTransportasi,
                      onChanged: (val) {
                        setState(() {
                          _selectedTransportasi = val!;
                        });
                      },
                    ),
                    CheckboxListTile(
                      contentPadding: EdgeInsets.zero,
                      controlAffinity: ListTileControlAffinity.leading,
                      title: const Text('Gojek'),
                      activeColor: kPrimaryColor,
                      value: _selectedGojek,
                      onChanged: (val) {
                        setState(() {
                          _selectedGojek = val!;
                        });
                      },
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

  Widget _streamGroupJabatan(BuildContext context) {
    return StreamBuilder<ApiResponse<MasterGroupJabatanModel>>(
      stream: _masterGroupJabatanBloc.masterGroupJabatanStream,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          switch (snapshot.data!.status) {
            case Status.loading:
              return const SizedBox(
                height: 200,
                child: Center(
                  child: LoadingKit(
                    color: kPrimaryColor,
                  ),
                ),
              );
            case Status.error:
              return Padding(
                padding: const EdgeInsets.all(22.0),
                child: ErrorResponse(
                  message: snapshot.data!.message,
                  onTap: () {
                    _masterGroupJabatanBloc.getMasterGroupJabatan();
                    setState(() {});
                  },
                ),
              );
            case Status.completed:
              return SafeArea(
                top: false,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Padding(
                      padding: EdgeInsets.all(22.0),
                      child: Text(
                        'Pilih group tindakan',
                        style: TextStyle(
                            fontSize: 20.0, fontWeight: FontWeight.bold),
                      ),
                    ),
                    Column(
                      children: ListTile.divideTiles(
                        context: context,
                        tiles: snapshot.data!.data!.data!
                            .map((group) => Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 8.0),
                                  child: ListTile(
                                    onTap: () => Navigator.pop(context, group),
                                    title: Text('${group.groupJabatan}'),
                                  ),
                                ))
                            .toList(),
                      ).toList(),
                    ),
                    SizedBox(
                      height: 18,
                    ),
                  ],
                ),
              );
          }
        }
        return const SizedBox();
      },
    );
  }

  Widget _streamSave() {
    return StreamBuilder<ApiResponse<ResponseTindakanModel>>(
      stream: _tindakanBloc.masterTindakanStream,
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

class SelectedGroup {
  SelectedGroup({
    this.id,
    this.namaGroup,
  });

  int? id;
  String? namaGroup;
}
