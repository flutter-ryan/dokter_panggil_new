import 'package:animate_icons/animate_icons.dart';
import 'package:admin_dokter_panggil/src/blocs/master_group_jabatan_bloc.dart';
import 'package:admin_dokter_panggil/src/blocs/profesi_save_bloc.dart';
import 'package:admin_dokter_panggil/src/models/master_group_jabatan_model.dart';
import 'package:admin_dokter_panggil/src/models/profesi_filter_model.dart';
import 'package:admin_dokter_panggil/src/models/profesi_save_model.dart';
import 'package:admin_dokter_panggil/src/pages/components/button_edit_master.dart';
import 'package:admin_dokter_panggil/src/pages/components/close_button.dart';
import 'package:admin_dokter_panggil/src/pages/components/confirm_dialog.dart';
import 'package:admin_dokter_panggil/src/pages/components/error_dialog.dart';
import 'package:admin_dokter_panggil/src/pages/components/header.dart';
import 'package:admin_dokter_panggil/src/pages/components/input_form.dart';
import 'package:admin_dokter_panggil/src/pages/components/loading_kit.dart';
import 'package:admin_dokter_panggil/src/pages/components/search_input_form.dart';
import 'package:admin_dokter_panggil/src/pages/components/success_dialog.dart';
import 'package:admin_dokter_panggil/src/pages/master/profesi_pencarian_page.dart';
import 'package:admin_dokter_panggil/src/repositories/responseApi/api_response.dart';
import 'package:admin_dokter_panggil/src/source/config.dart';
import 'package:admin_dokter_panggil/src/source/size_config.dart';
import 'package:admin_dokter_panggil/src/source/transition/slide_left_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:admin_dokter_panggil/src/source/transition/animated_dialog.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:admin_dokter_panggil/src/pages/components/error_response.dart';

class ProfesiPage extends StatefulWidget {
  const ProfesiPage({super.key});

  @override
  State<ProfesiPage> createState() => _ProfesiPageState();
}

class _ProfesiPageState extends State<ProfesiPage> {
  final AnimateIconController _animateIconController = AnimateIconController();
  final MasterGroupJabatanBloc _masterGroupJabatanBloc =
      MasterGroupJabatanBloc();
  final ProfesiSaveBloc _profesiSaveBloc = ProfesiSaveBloc();
  final _profesiCon = TextEditingController();
  final _groupCon = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  String? _profesi;
  int _selectedGroup = 0;
  bool _editForm = false;

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
      _profesiSaveBloc.profesiSink.add(_profesi!);
      _profesiSaveBloc.groupSink.add(_selectedGroup);
      _profesiSaveBloc.saveProfesi();
      _dialogStream();
    }
  }

  void _edit(Profesi data) {
    _profesiSaveBloc.idSink.add(data.id!);
    _profesiCon.text = data.namaJabatan!;
    _selectedGroup = data.group!.id!;
    _groupCon.text = '${data.group!.groupJabatan}';
    setState(() {
      _editForm = true;
    });
  }

  void _update() {
    if (validateAndSave()) {
      _profesiSaveBloc.profesiSink.add(_profesi!);
      _profesiSaveBloc.groupSink.add(_selectedGroup);
      _profesiSaveBloc.updateProfesi();
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
          _profesiSaveBloc.deleteProfesi();
          _dialogStream();
        });
      }
    });
  }

  void _batal() {
    _profesiCon.clear();
    _groupCon.clear();
    _selectedGroup = 0;
    setState(() {
      _editForm = false;
    });
  }

  void _dialogStream() {
    showAnimatedDialog(
      context: context,
      builder: (context) {
        return _streamSaveProfesi();
      },
      animationType: DialogTransitionType.slideFromBottomFade,
      duration: const Duration(milliseconds: 500),
    ).then((value) {
      if (value != null) {
        _batal();
      }
    });
  }

  void _showGroup() {
    _masterGroupJabatanBloc.getMasterGroupJabatan();
    showMaterialModalBottomSheet(
      context: context,
      builder: (context) {
        return Container(
          constraints: BoxConstraints(
            maxHeight: SizeConfig.blockSizeVertical * 60,
          ),
          child: _streamGroupJabatan(context),
        );
      },
      duration: const Duration(milliseconds: 500),
    ).then((value) {
      if (value != null) {
        var selected = value as MasterGroupJabatan;
        _groupCon.text = selected.groupJabatan!;
        setState(() {
          _selectedGroup = selected.id!;
        });
      }
    });
  }

  void _cariProfesi() {
    Navigator.push(
      context,
      SlideLeftRoute(
        page: const ProfesiPencarianPage(),
      ),
    ).then((value) {
      if (value != null) {
        if (!mounted) return;
        FocusScope.of(context).requestFocus(FocusNode());
        var data = value as Profesi;
        _edit(data);
      }
    });
  }

  @override
  void dispose() {
    _profesiCon.dispose();
    _profesiSaveBloc.dispose();
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
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Header(
                title: 'Tambah Profesi',
                subtitle: SearchInputForm(
                  isReadOnly: true,
                  hint: 'Pencarian profesi',
                  onTap: _cariProfesi,
                ),
                closeButton: const ClosedButton(),
              ),
              Expanded(
                child: ListView(
                  padding: const EdgeInsets.all(32.0),
                  children: [
                    Input(
                      controller: _profesiCon,
                      label: 'Profesi',
                      hint: 'Nama profesi',
                      maxLines: 1,
                      validator: (val) {
                        if (val!.isEmpty) {
                          return 'Input required';
                        }
                        return null;
                      },
                      onSave: (val) => _profesi = val,
                      textCap: TextCapitalization.words,
                    ),
                    const SizedBox(
                      height: 22.0,
                    ),
                    Input(
                      controller: _groupCon,
                      label: 'Grup Profesi',
                      hint: 'Pilih Grup profesi',
                      maxLines: 1,
                      suffixIcon: AnimateIcons(
                        startIconColor: Colors.grey,
                        endIconColor: Colors.grey,
                        startIcon: Icons.expand_more_rounded,
                        endIcon: Icons.expand_less_rounded,
                        duration: const Duration(milliseconds: 300),
                        onStartIconPress: () {
                          _showGroup();
                          return false;
                        },
                        onEndIconPress: () {
                          Navigator.pop(context);
                          return false;
                        },
                        controller: _animateIconController,
                      ),
                      validator: (val) {
                        if (val!.isEmpty) {
                          return 'Input required';
                        }
                        return null;
                      },
                      readOnly: true,
                      onTap: _showGroup,
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

  Widget _streamSaveProfesi() {
    return StreamBuilder<ApiResponse<ResponseProfesiSaveModel>>(
      stream: _profesiSaveBloc.profesiSaveStream,
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

  Widget _streamGroupJabatan(BuildContext context) {
    return StreamBuilder<ApiResponse<MasterGroupJabatanModel>>(
      stream: _masterGroupJabatanBloc.masterGroupJabatanStream,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          switch (snapshot.data!.status) {
            case Status.loading:
              return const LoadingKit(
                color: kPrimaryColor,
              );
            case Status.error:
              return ErrorResponse(
                message: snapshot.data!.message,
                onTap: () => Navigator.pop(context),
              );
            case Status.completed:
              return ListGroupJabatan(
                  data: snapshot.data!.data!.data,
                  selectedGroup: _selectedGroup);
          }
        }
        return const SizedBox();
      },
    );
  }
}

class ListGroupJabatan extends StatelessWidget {
  const ListGroupJabatan({
    super.key,
    this.data,
    this.selectedGroup,
  });

  final List<MasterGroupJabatan>? data;
  final int? selectedGroup;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Padding(
          padding: EdgeInsets.symmetric(horizontal: 22.0, vertical: 12.0),
          child: Text(
            'Pilih Group Jabatan',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
        ),
        Flexible(
          child: ListView.separated(
            padding: const EdgeInsets.symmetric(vertical: 12.0),
            shrinkWrap: true,
            itemBuilder: (context, i) {
              var group = data![i];
              return ListTile(
                onTap: () => Navigator.pop(context, group),
                contentPadding: const EdgeInsets.symmetric(horizontal: 22),
                title: Text('${group.groupJabatan}'),
                trailing: selectedGroup == group.id
                    ? const Icon(
                        Icons.check_circle,
                        color: Colors.green,
                      )
                    : null,
              );
            },
            separatorBuilder: (context, i) => const Divider(),
            itemCount: data!.length,
          ),
        ),
      ],
    );
  }
}
