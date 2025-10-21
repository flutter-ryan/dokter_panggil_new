import 'dart:async';

import 'package:animate_icons/animate_icons.dart';
import 'package:admin_dokter_panggil/src/blocs/master_jabatan_bloc.dart';
import 'package:admin_dokter_panggil/src/blocs/master_pegawai_save_bloc.dart';
import 'package:admin_dokter_panggil/src/blocs/master_role_bloc.dart';
import 'package:admin_dokter_panggil/src/blocs/pegawai_edit_bloc.dart';
import 'package:admin_dokter_panggil/src/blocs/pegawai_search_bloc.dart';
import 'package:admin_dokter_panggil/src/models/master_jabatan_model.dart';
import 'package:admin_dokter_panggil/src/models/master_pegawai_fetch_model.dart';
import 'package:admin_dokter_panggil/src/models/master_pegawai_save_model.dart';
import 'package:admin_dokter_panggil/src/models/master_role_model.dart';
import 'package:admin_dokter_panggil/src/models/pegawai_edit_model.dart';
import 'package:admin_dokter_panggil/src/models/pegawai_search_model.dart';
import 'package:admin_dokter_panggil/src/pages/components/close_button.dart';
import 'package:admin_dokter_panggil/src/pages/components/error_response.dart';
import 'package:admin_dokter_panggil/src/pages/components/error_dialog.dart';
import 'package:admin_dokter_panggil/src/pages/components/header.dart';
import 'package:admin_dokter_panggil/src/pages/components/input_form.dart';
import 'package:admin_dokter_panggil/src/pages/components/list_jabatan_widget.dart';
import 'package:admin_dokter_panggil/src/pages/components/loading_kit.dart';
import 'package:admin_dokter_panggil/src/pages/components/search_input_form.dart';
import 'package:admin_dokter_panggil/src/pages/components/searcher.dart';
import 'package:admin_dokter_panggil/src/pages/components/success_dialog.dart';
import 'package:admin_dokter_panggil/src/pages/master/profile_pegawai_page.dart';
import 'package:admin_dokter_panggil/src/repositories/responseApi/api_response.dart';
import 'package:admin_dokter_panggil/src/source/config.dart';
import 'package:admin_dokter_panggil/src/source/size_config.dart';
import 'package:admin_dokter_panggil/src/source/transition/slide_bottom_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:admin_dokter_panggil/src/source/transition/animated_dialog.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl/intl.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';

class PegawaiPage extends StatefulWidget {
  const PegawaiPage({super.key});

  @override
  State<PegawaiPage> createState() => _PegawaiPageState();
}

class _PegawaiPageState extends State<PegawaiPage> {
  final _masterPegawaiSaveBloc = MasterPegawaiSaveBloc();
  final _animateIconController = AnimateIconController();
  final _animateIconRoleController = AnimateIconController();
  final _jabatanBloc = MasterJabatanBloc();
  final _formKey = GlobalKey<FormState>();
  final _nama = TextEditingController();
  final _profesi = TextEditingController();
  final _nomorSip = TextEditingController();
  final _tanggalSip = TextEditingController();
  final _email = TextEditingController();
  final _password = TextEditingController();
  final _ulangiPassword = TextEditingController();
  final _role = TextEditingController();

  Jabatan? _selectedJabatan;
  int _selectedIdRole = 99;
  bool _obscureText = true;
  DateTime _selectedDate = DateTime.now();
  final _tanggal = DateFormat('yyyy-MM-dd');

  bool validateAndSave() {
    var formState = _formKey.currentState;
    if (formState!.validate()) {
      return true;
    }
    return false;
  }

  void _showJabatan() {
    _animateIconController.animateToEnd();
    _jabatanBloc.getMasterJabatan();
    showBarModalBottomSheet(
      context: context,
      builder: (context) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            const Padding(
              padding: EdgeInsets.only(left: 18.0, top: 22.0, right: 18.0),
              child: Text(
                'Daftar Jabatan',
                style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.w600),
              ),
            ),
            const SizedBox(
              height: 18.0,
            ),
            _streamListMasterJabatan(context)
          ],
        );
      },
      duration: const Duration(milliseconds: 500),
    ).then((value) {
      if (value != null) {
        var jabatan = value as Jabatan;
        _profesi.text = '${jabatan.namaJabatan}';
        setState(() {
          _selectedJabatan = jabatan;
        });
      }
      _animateIconController.animateToStart();
    });
  }

  void _showRole() {
    _animateIconRoleController.animateToEnd();
    showBarModalBottomSheet(
      context: context,
      builder: (context) {
        return RoleUser(
          selectedIdRole: _selectedIdRole,
        );
      },
      duration: const Duration(milliseconds: 500),
    ).then((value) {
      _animateIconRoleController.animateToStart();
      if (value != null) {
        var role = value as MasterRole;
        _role.text = '${role.deskripsi}';
        _masterPegawaiSaveBloc.roleSink.add(role.role!);
        setState(() {
          _selectedIdRole = role.id!;
        });
      }
    });
  }

  void _showDate() {
    showAnimatedDialog(
      context: context,
      builder: (context) {
        return Theme(
          data: ThemeData.light().copyWith(
            colorScheme: const ColorScheme.light(
              primary: kPrimaryColor,
            ),
          ),
          child: DatePickerDialog(
            initialDate: _selectedDate,
            firstDate: DateTime(1900),
            lastDate: DateTime.now(),
            helpText: 'Pilih tanggal sip',
            cancelText: 'Batal',
            confirmText: 'Pilih',
            fieldLabelText: 'Tanggal SIP',
            fieldHintText: 'Tanggal/Bulan/Tahun',
          ),
        );
      },
      animationType: DialogTransitionType.slideFromBottomFade,
      duration: const Duration(milliseconds: 500),
    ).then(
      (value) {
        if (value != null) {
          var picked = value as DateTime;
          _tanggalSip.text = _tanggal.format(picked);
          setState(() {
            _selectedDate = picked;
          });
        }
      },
    );
  }

  void _simpan() {
    if (validateAndSave()) {
      SystemChannels.textInput.invokeMethod('TextInput.hide');
      FocusScope.of(context).requestFocus(FocusNode());
      _masterPegawaiSaveBloc.namaSink.add(_nama.text);
      _masterPegawaiSaveBloc.profesiSink.add(_selectedJabatan!.id!);
      _masterPegawaiSaveBloc.tanggalSipSink.add(_tanggalSip.text);
      _masterPegawaiSaveBloc.nomorSipSink.add(_nomorSip.text);
      _masterPegawaiSaveBloc.emailSink.add(_email.text);
      if (_password.text.isNotEmpty) {
        _masterPegawaiSaveBloc.passwordSink.add(_password.text);
        _masterPegawaiSaveBloc.ulangiPasswordSink.add(_ulangiPassword.text);
      }
      _masterPegawaiSaveBloc.savePegawai();
      _showStreamSavePegawai();
    }
  }

  void _showStreamSavePegawai() {
    showAnimatedDialog(
      context: context,
      builder: (context) {
        return _streamSavePegawai(context);
      },
      animationType: DialogTransitionType.slideFromBottomFade,
      duration: const Duration(milliseconds: 500),
    ).then((value) {
      if (value != null) {
        _nama.clear();
        _profesi.clear();
        _email.clear();
        _password.clear();
        _ulangiPassword.clear();
        _selectedIdRole = 99;
        _role.clear();
        _nomorSip.clear();
        _tanggalSip.clear();
        setState(() {
          _selectedJabatan = null;
        });
      }
    });
  }

  @override
  void dispose() {
    _masterPegawaiSaveBloc.dispose();
    _jabatanBloc.dispose();
    _nama.dispose();
    _profesi.dispose();
    _email.dispose();
    _password.dispose();
    _ulangiPassword.dispose();
    _role.dispose();
    _nomorSip.dispose();
    _tanggalSip.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: const SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarBrightness: Brightness.dark,
        statusBarIconBrightness: Brightness.light,
      ),
      child: Scaffold(
        body: Column(
          children: [
            Header(
              title: 'Master Pegawai',
              subtitle: SearchInputForm(
                isReadOnly: true,
                hint: 'Pencarian pegawai',
                onTap: () => Navigator.push(
                  context,
                  SlideBottomRoute(
                    page: const PencarianPegawai(),
                  ),
                ),
              ),
              closeButton: const ClosedButton(),
            ),
            Expanded(
              child: Form(
                key: _formKey,
                child: ListView(
                  padding: const EdgeInsets.all(32.0),
                  children: [
                    const Text(
                      'Informasi pegawai',
                      style: TextStyle(
                          fontSize: 22.0, fontWeight: FontWeight.w600),
                    ),
                    const Divider(
                      color: Colors.grey,
                      height: 22,
                    ),
                    const SizedBox(
                      height: 18.0,
                    ),
                    Input(
                      controller: _nama,
                      label: 'Nama',
                      hint: 'Nama lengkap pegawai',
                      maxLines: 1,
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
                      controller: _profesi,
                      label: 'Profesi',
                      hint: 'Pilih profesi',
                      maxLines: 1,
                      suffixIcon: AnimateIcons(
                        startIconColor: Colors.grey,
                        endIconColor: Colors.grey,
                        startIcon: Icons.expand_more_rounded,
                        endIcon: Icons.expand_less_rounded,
                        duration: const Duration(milliseconds: 300),
                        onStartIconPress: () {
                          _showJabatan();
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
                      onTap: _showJabatan,
                    ),
                    const SizedBox(
                      height: 52.0,
                    ),
                    if (_selectedJabatan?.group!.id == 1) _buildFormSip(),
                    if (_selectedJabatan?.group!.id == 1)
                      const SizedBox(height: 52.0),
                    const Text(
                      'Informasi akun',
                      style: TextStyle(
                          fontSize: 22.0, fontWeight: FontWeight.w600),
                    ),
                    const Divider(
                      color: Colors.grey,
                      height: 22,
                    ),
                    const SizedBox(
                      height: 18.0,
                    ),
                    Input(
                      controller: _email,
                      label: 'Email',
                      hint: 'Alamat email aktif',
                      maxLines: 1,
                      validator: (val) {
                        if (val!.isEmpty) {
                          return 'Input required';
                        }
                        return null;
                      },
                      keyType: TextInputType.emailAddress,
                      textInputAction: TextInputAction.next,
                    ),
                    const SizedBox(
                      height: 22.0,
                    ),
                    Input(
                      controller: _password,
                      label: 'Password',
                      obscure: _obscureText,
                      hint: 'Kosongkan untuk default',
                      maxLines: 1,
                      suffixIcon: IconButton(
                        onPressed: () {
                          setState(() {
                            _obscureText = !_obscureText;
                          });
                        },
                        icon: _obscureText
                            ? const Icon(Icons.visibility_rounded)
                            : const Icon(Icons.visibility_off_rounded),
                      ),
                      textInputAction: TextInputAction.next,
                    ),
                    const SizedBox(
                      height: 22.0,
                    ),
                    Input(
                      controller: _ulangiPassword,
                      label: 'Ulangi password',
                      obscure: _obscureText,
                      hint: 'Ketikkan ulang password',
                      maxLines: 1,
                    ),
                    const SizedBox(
                      height: 22.0,
                    ),
                    Input(
                      controller: _role,
                      label: 'Role',
                      hint: 'Pilih role user',
                      maxLines: 1,
                      suffixIcon: AnimateIcons(
                        startIconColor: Colors.grey,
                        endIconColor: Colors.grey,
                        startIcon: Icons.expand_more_rounded,
                        endIcon: Icons.expand_less_rounded,
                        duration: const Duration(milliseconds: 300),
                        onStartIconPress: () {
                          _showRole();
                          return false;
                        },
                        onEndIconPress: () {
                          Navigator.pop(context);
                          return false;
                        },
                        controller: _animateIconRoleController,
                      ),
                      validator: (val) {
                        if (val!.isEmpty) {
                          return 'Input required';
                        }
                        return null;
                      },
                      readOnly: true,
                      onTap: _showRole,
                    ),
                    const SizedBox(
                      height: 52.0,
                    ),
                    SizedBox(
                      height: 48,
                      child: ElevatedButton(
                        onPressed: _simpan,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: kPrimaryColor,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(6.0),
                          ),
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
      ),
    );
  }

  Widget _buildFormSip() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Informasi SIP',
          style: TextStyle(fontSize: 22.0, fontWeight: FontWeight.w600),
        ),
        const Divider(
          color: Colors.grey,
          height: 22,
        ),
        const SizedBox(
          height: 18.0,
        ),
        Input(
          controller: _nomorSip,
          label: 'Nomor',
          hint: 'Nomor SIP',
          maxLines: 1,
          validator: (val) {
            if (val!.isEmpty) {
              return 'Input required';
            }
            return null;
          },
        ),
        const SizedBox(
          height: 22.0,
        ),
        Input(
          controller: _tanggalSip,
          label: 'Tanggal',
          hint: 'Tanggal berlaku SIP',
          maxLines: 1,
          suffixIcon: IconButton(
            onPressed: _showDate,
            icon: const Icon(Icons.calendar_month_outlined),
          ),
          validator: (val) {
            if (val!.isEmpty) {
              return 'Input required';
            }
            return null;
          },
          readOnly: true,
          onTap: _showDate,
        ),
      ],
    );
  }

  Widget _streamListMasterJabatan(BuildContext context) {
    return StreamBuilder<ApiResponse<MasterJabatanModel>>(
      stream: _jabatanBloc.masterJabatanStream,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          switch (snapshot.data!.status) {
            case Status.loading:
              return const SizedBox(
                height: 180,
                child: Center(
                  child: LoadingKit(
                    color: kPrimaryColor,
                  ),
                ),
              );
            case Status.error:
              return SizedBox(
                width: double.infinity,
                height: 300,
                child: ErrorResponse(
                  message: snapshot.data!.message,
                  onTap: () {
                    Navigator.pop(context);
                    Future.delayed(const Duration(milliseconds: 500), () {
                      _showJabatan();
                      setState(() {});
                    });
                  },
                ),
              );
            case Status.completed:
              return Flexible(
                child: ListJabatanWidget(
                  data: snapshot.data!.data!.data!,
                  selectId: (Jabatan? jabatan) =>
                      Navigator.pop(context, jabatan),
                  selectedId:
                      _selectedJabatan == null ? 0 : _selectedJabatan!.id!,
                ),
              );
          }
        }
        return const SizedBox(
          height: 180,
        );
      },
    );
  }

  Widget _streamSavePegawai(BuildContext context) {
    return StreamBuilder<ApiResponse<ResponseMasterPegawaiSaveModel>>(
      stream: _masterPegawaiSaveBloc.savePegawaiStream,
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
                onTap: () => Navigator.pop(context, 'reload'),
              );
          }
        }
        return const SizedBox();
      },
    );
  }
}

class PencarianPegawai extends StatefulWidget {
  const PencarianPegawai({super.key});

  @override
  State<PencarianPegawai> createState() => _PencarianPegawaiState();
}

class _PencarianPegawaiState extends State<PencarianPegawai> {
  final PegawaiSearchBloc _pegawaiSearchBloc = PegawaiSearchBloc();
  final _filterCon = TextEditingController();
  final _filterFocus = FocusNode();
  bool _isStream = false;
  bool _show = false;
  int? _id;
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _load();
    _filterCon.addListener(_inputListener);
  }

  void _load() {
    _pegawaiSearchBloc.filterSink.add(_filterCon.text);
    _pegawaiSearchBloc.filter();
  }

  void _reload(MasterPegawai? pegawai) {
    _load();
    setState(() {
      _isStream = true;
      _show = false;
    });
  }

  void _inputListener() {
    _timer?.cancel();
    if (_filterCon.text.length < 3) return;
    Timer.periodic(const Duration(milliseconds: 700), (timer) {
      timer.cancel();
      _pegawaiSearchBloc.filterSink.add(_filterCon.text);
      _pegawaiSearchBloc.filter();
      setState(() {
        _isStream = true;
        _show = false;
        _timer = timer;
      });
    });
  }

  @override
  void dispose() {
    super.dispose();
    _pegawaiSearchBloc.dispose();
    _filterCon.dispose();
    _filterFocus.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: const SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarBrightness: Brightness.light,
        statusBarIconBrightness: Brightness.dark,
      ),
      child: Searcher(
        controller: _filterCon,
        focus: _filterFocus,
        suffixIcon: _isStream
            ? InkWell(
                onTap: () {
                  _filterFocus.requestFocus(FocusNode());
                  setState(() {
                    _filterCon.clear();
                    _pegawaiSearchBloc.filterSink.add(_filterCon.text);
                    _pegawaiSearchBloc.filter();
                  });
                },
                child: FaIcon(
                  FontAwesomeIcons.circleXmark,
                  size: 20,
                  color: Colors.grey[600],
                ),
              )
            : null,
        result: Expanded(
          child: _buildStreamFilter(),
        ),
        hint: 'Pencarian pegawai',
      ),
    );
  }

  Widget _buildStreamFilter() {
    if (_show) {
      return StreamShowPegawai(
        id: _id!,
        reload: _reload,
      );
    }
    return StreamBuilder<ApiResponse<ResultPegawaiSearchModel>>(
      stream: _pegawaiSearchBloc.pegawaiSearchStream,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          switch (snapshot.data!.status) {
            case Status.loading:
              return const Align(
                alignment: Alignment.topCenter,
                child: SizedBox(
                  width: 22,
                  height: 22,
                  child: CircleAvatar(
                    backgroundColor: Colors.transparent,
                    child: CircularProgressIndicator(),
                  ),
                ),
              );
            case Status.error:
              return Align(
                alignment: Alignment.topCenter,
                child: Text(
                  snapshot.data!.message,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                      color: Colors.grey, fontStyle: FontStyle.italic),
                ),
              );
            case Status.completed:
              return ListView.builder(
                padding: const EdgeInsets.symmetric(horizontal: 12.0),
                itemCount: snapshot.data!.data!.result!.length,
                shrinkWrap: true,
                itemBuilder: (context, i) {
                  var data = snapshot.data!.data!.result![i];
                  return ListTile(
                    onTap: () {
                      FocusScope.of(context).requestFocus(FocusNode());
                      setState(() {
                        _id = data.id;
                        _show = true;
                      });
                    },
                    leading: const Icon(Icons.search),
                    title: Text('${data.nama}'),
                    subtitle: Text('${data.profesi!.namaJabatan}'),
                  );
                },
              );
          }
        }
        return const SizedBox();
      },
    );
  }
}

class StreamShowPegawai extends StatefulWidget {
  const StreamShowPegawai({
    super.key,
    required this.id,
    this.reload,
  });

  final int id;
  final Function(MasterPegawai? pegawai)? reload;

  @override
  State<StreamShowPegawai> createState() => _StreamShowPegawaiState();
}

class _StreamShowPegawaiState extends State<StreamShowPegawai> {
  final PegawaiEditBloc _pegawaiEditBloc = PegawaiEditBloc();

  @override
  void initState() {
    super.initState();
    _pegawaiEditBloc.idSink.add(widget.id);
    _pegawaiEditBloc.editPegawai();
  }

  @override
  void dispose() {
    _pegawaiEditBloc.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<ApiResponse<PegawaiEditModel>>(
      stream: _pegawaiEditBloc.pegawaiEditStream,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          switch (snapshot.data!.status) {
            case Status.loading:
              return const Center(
                child: LoadingKit(
                  color: kPrimaryColor,
                ),
              );
            case Status.error:
              return SizedBox(
                width: double.infinity,
                child: ErrorResponse(
                  message: snapshot.data!.message,
                  onTap: () {
                    _pegawaiEditBloc.editPegawai();
                    setState(() {});
                  },
                ),
              );
            case Status.completed:
              return ProfilePegawai(
                data: snapshot.data!.data!.pegawai,
                reload: widget.reload,
              );
          }
        }
        return const SizedBox();
      },
    );
  }
}

class RoleUser extends StatefulWidget {
  const RoleUser({
    super.key,
    this.selectedIdRole,
  });

  final int? selectedIdRole;

  @override
  State<RoleUser> createState() => _RoleUserState();
}

class _RoleUserState extends State<RoleUser> {
  final _masterRoleBloc = MasterRoleBloc();
  int _selected = 0;

  @override
  void initState() {
    super.initState();
    _masterRoleBloc.getMasterRole();
    _selected = widget.selectedIdRole!;
  }

  void _pilihRole(MasterRole role) {
    setState(() {
      _selected = role.id!;
    });
    Future.delayed(const Duration(milliseconds: 100), () {
      if (!mounted) return;
      Navigator.pop(context, role);
    });
  }

  @override
  void dispose() {
    _masterRoleBloc.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<ApiResponse<List<MasterRole>>>(
        stream: _masterRoleBloc.masterRoleStream,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            switch (snapshot.data!.status) {
              case Status.loading:
                return const SizedBox(
                  height: 200,
                  child: LoadingKit(
                    color: kPrimaryColor,
                  ),
                );
              case Status.error:
                return ErrorResponse(
                  message: snapshot.data!.message,
                  button: true,
                  onTap: () => setState(() {
                    _masterRoleBloc.getMasterRole();
                  }),
                );
              case Status.completed:
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Padding(
                      padding:
                          EdgeInsets.only(left: 18.0, top: 22.0, right: 18.0),
                      child: Text(
                        'Pilih Role User',
                        style: TextStyle(
                            fontSize: 18, fontWeight: FontWeight.w600),
                      ),
                    ),
                    const SizedBox(
                      height: 18.0,
                    ),
                    Flexible(
                      child: ListView.separated(
                        shrinkWrap: true,
                        itemBuilder: (context, i) {
                          var role = snapshot.data!.data![i];
                          return ListTile(
                            onTap: () => _pilihRole(role),
                            contentPadding: const EdgeInsets.symmetric(
                                horizontal: 22.0, vertical: 8.0),
                            title: Text('${role.deskripsi}'),
                            trailing: _selected == role.id
                                ? const Icon(
                                    Icons.check_box_rounded,
                                    color: Colors.green,
                                  )
                                : null,
                          );
                        },
                        separatorBuilder: (context, i) => const Divider(
                          height: 0,
                        ),
                        itemCount: snapshot.data!.data!.length,
                      ),
                    )
                  ],
                );
            }
          }
          return const SizedBox(
            height: 200,
          );
        });
  }
}
