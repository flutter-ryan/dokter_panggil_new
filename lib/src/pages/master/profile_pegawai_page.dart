import 'package:animate_icons/animate_icons.dart';
import 'package:dokter_panggil/src/blocs/master_jabatan_bloc.dart';
import 'package:dokter_panggil/src/blocs/master_pegawai_delete_bloc.dart';
import 'package:dokter_panggil/src/blocs/update_info_pegawai_bloc.dart';
import 'package:dokter_panggil/src/blocs/update_sip_dokter_bloc.dart';
import 'package:dokter_panggil/src/blocs/update_user_bloc.dart';
import 'package:dokter_panggil/src/models/master_jabatan_model.dart';
import 'package:dokter_panggil/src/models/master_pegawai_fetch_model.dart';
import 'package:dokter_panggil/src/models/master_pegawai_save_model.dart';
import 'package:dokter_panggil/src/models/master_role_model.dart';
import 'package:dokter_panggil/src/models/update_info_pegawai_model.dart';
import 'package:dokter_panggil/src/models/update_sip_dokter_model.dart';
import 'package:dokter_panggil/src/models/update_user_model.dart';
import 'package:dokter_panggil/src/pages/components/confirm_dialog.dart';
import 'package:dokter_panggil/src/pages/components/error_dialog.dart';
import 'package:dokter_panggil/src/pages/components/error_response.dart';
import 'package:dokter_panggil/src/pages/components/input_form.dart';
import 'package:dokter_panggil/src/pages/components/list_jabatan_widget.dart';
import 'package:dokter_panggil/src/pages/components/loading_kit.dart';
import 'package:dokter_panggil/src/pages/components/success_dialog.dart';
import 'package:dokter_panggil/src/pages/master/pegawai_page.dart';
import 'package:dokter_panggil/src/repositories/responseApi/api_response.dart';
import 'package:dokter_panggil/src/source/config.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:dokter_panggil/src/source/transition/animated_dialog.dart';
import 'package:intl/intl.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';

class ProfilePegawai extends StatefulWidget {
  const ProfilePegawai({
    super.key,
    this.data,
    this.reload,
  });
  final MasterPegawai? data;
  final Function(MasterPegawai? data)? reload;

  @override
  State<ProfilePegawai> createState() => _ProfilePegawaiState();
}

class _ProfilePegawaiState extends State<ProfilePegawai> {
  final _masterPegawaiDeleteBloc = MasterPegawaiDeleteBloc();
  MasterPegawai? _data;

  @override
  void initState() {
    super.initState();
    _data = widget.data;
  }

  void _editPegawai(MasterPegawai? pegawai) {
    showBarModalBottomSheet(
      context: context,
      builder: (context) {
        return Padding(
          padding:
              EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
          child: EditDataPegawai(
            data: pegawai!,
          ),
        );
      },
    ).then((value) {
      if (value != null) {
        var data = value as MasterPegawai;
        setState(() {
          _data = data;
        });
      }
    });
  }

  void _editSip(MasterPegawai? data) {
    showBarModalBottomSheet(
      context: context,
      builder: (context) {
        return Padding(
          padding:
              EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
          child: EditSip(
            data: data!,
          ),
        );
      },
    ).then((value) {
      if (value != null) {
        var data = value as MasterPegawai;
        setState(() {
          _data = data;
        });
      }
    });
  }

  void _editAkun(User? user) {
    showBarModalBottomSheet(
      context: context,
      builder: (context) {
        return Padding(
          padding:
              EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
          child: EditUser(
            data: user!,
          ),
        );
      },
    ).then((value) {
      if (value != null) {
        var data = value as MasterPegawai;
        setState(() {
          _data = data;
        });
      }
    });
  }

  void _confirmHapus() {
    showAnimatedDialog(
      context: context,
      builder: (context) {
        return ConfirmDialogWidget(
          onConfirm: () => Navigator.pop(context, 'delete'),
          message: 'Anda yakin menghapus data ini?',
        );
      },
      duration: const Duration(milliseconds: 500),
      animationType: DialogTransitionType.slideFromBottomFade,
    ).then((value) {
      if (value != null) {
        _delete();
      }
    });
  }

  void _delete() {
    _masterPegawaiDeleteBloc.idPegawaiSink.add(widget.data!.id!);
    _masterPegawaiDeleteBloc.deletePegawai();
    _showStreamDeletePegawai();
  }

  void _showStreamDeletePegawai() {
    showAnimatedDialog(
      context: context,
      builder: (context) {
        return _streamDeletePegawai(context);
      },
      duration: const Duration(milliseconds: 500),
      animationType: DialogTransitionType.slideFromBottomFade,
    ).then((value) {
      if (value != null) {
        var data = value as MasterPegawai;
        widget.reload!(data);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(32.0),
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: 80,
              height: 80,
              padding: const EdgeInsets.all(12.0),
              decoration: BoxDecoration(
                color: Colors.grey[300],
                borderRadius: BorderRadius.circular(8.0),
              ),
              child: Image.asset('images/logo_only.png'),
            ),
            const SizedBox(
              width: 22.0,
            ),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '${_data!.nama}',
                    style: const TextStyle(
                        fontSize: 20, fontWeight: FontWeight.w600),
                  ),
                  const SizedBox(
                    height: 8.0,
                  ),
                  Text('${_data!.profesi!.namaJabatan}'),
                ],
              ),
            ),
          ],
        ),
        const SizedBox(
          height: 42.0,
        ),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Edit Profil Pegawai',
              style: TextStyle(fontWeight: FontWeight.w600, fontSize: 16.0),
            ),
            const SizedBox(
              height: 22.0,
            ),
            ListTile(
              onTap: () => _editPegawai(_data),
              contentPadding: EdgeInsets.zero,
              title: const Text('Informasi pegawai'),
              subtitle: const Text('Atur informasi umum pegawai'),
              trailing: const Icon(Icons.keyboard_arrow_right_rounded),
            ),
            const Divider(
              height: 18,
            ),
            if (_data!.profesi!.group!.id == 1)
              ListTile(
                onTap: () => _editSip(_data),
                contentPadding: EdgeInsets.zero,
                title: const Text('Informasi SIP Dokter'),
                subtitle: const Text('Atur informasi SIP Dokter'),
                trailing: const Icon(Icons.keyboard_arrow_right_rounded),
              ),
            if (_data!.profesi!.group!.id == 1)
              const Divider(
                height: 18,
              ),
            ListTile(
              onTap: () => _editAkun(_data!.user),
              contentPadding: EdgeInsets.zero,
              title: const Text('Informasi akun'),
              subtitle: const Text('Atur informasi akun masuk pegawai'),
              trailing: const Icon(Icons.keyboard_arrow_right_rounded),
            ),
            const SizedBox(
              height: 32.0,
            ),
            ElevatedButton(
              onPressed: _confirmHapus,
              style: ElevatedButton.styleFrom(
                backgroundColor: kPrimaryColor,
                minimumSize: const Size(double.infinity, 45),
              ),
              child: const Text('Hapus'),
            )
          ],
        ),
      ],
    );
  }

  Widget _streamDeletePegawai(BuildContext context) {
    return StreamBuilder<ApiResponse<ResponseMasterPegawaiSaveModel>>(
      stream: _masterPegawaiDeleteBloc.masterPegawaiDeleteStream,
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

class EditUser extends StatefulWidget {
  const EditUser({
    super.key,
    required this.data,
  });

  final User data;

  @override
  State<EditUser> createState() => _EditUserState();
}

class _EditUserState extends State<EditUser> {
  final _animateIconController = AnimateIconController();
  final _updateUserBloc = UpdateUserBloc();
  final _formKey = GlobalKey<FormState>();
  final _name = TextEditingController();
  final _email = TextEditingController();
  final _password = TextEditingController();
  final _confirm = TextEditingController();
  final _role = TextEditingController();
  bool _obscure = true;
  int _selectedIdRole = 0;

  @override
  void initState() {
    super.initState();
    _editUser();
  }

  void _editUser() {
    _name.text = widget.data.name!;
    _email.text = widget.data.email!;
    _selectedIdRole = widget.data.masterRole!.id!;
    _role.text = widget.data.masterRole!.deskripsi!;
    _updateUserBloc.roleSink.add(widget.data.masterRole!.role!);
  }

  bool validateAndSave() {
    var formState = _formKey.currentState;
    if (formState!.validate()) {
      return true;
    }
    return false;
  }

  void _update() {
    if (validateAndSave()) {
      SystemChannels.textInput.invokeMethod('TextInput.hide');
      FocusScope.of(context).requestFocus(FocusNode());
      _updateUserBloc.idSink.add(widget.data.idPegawai!);
      _updateUserBloc.nameSink.add(_name.text);
      _updateUserBloc.emailSink.add(_email.text);
      _updateUserBloc.passwordSink.add(_password.text);
      _updateUserBloc.confirmationSink.add(_confirm.text);
      _updateUserBloc.updateUser();
      _showStreamUpdate();
    }
  }

  void _showStreamUpdate() {
    showAnimatedDialog(
      context: context,
      builder: (context) {
        return _streamUpdate(context);
      },
      animationType: DialogTransitionType.slideFromBottomFade,
      duration: const Duration(milliseconds: 500),
    ).then((value) {
      if (value != null) {
        var data = value as MasterPegawai;
        Future.delayed(const Duration(milliseconds: 500), () {
          Navigator.pop(context, data);
        });
      }
    });
  }

  void _showRole() {
    _animateIconController.animateToEnd();
    showBarModalBottomSheet(
      context: context,
      builder: (context) {
        return RoleUser(
          selectedIdRole: _selectedIdRole,
        );
      },
      duration: const Duration(milliseconds: 500),
    ).then((value) {
      _animateIconController.animateToStart();
      if (value != null) {
        var role = value as MasterRole;
        _role.text = '${role.deskripsi}';
        _updateUserBloc.roleSink.add(role.role!);
        setState(() {
          _selectedIdRole = role.id!;
        });
      }
    });
  }

  @override
  void dispose() {
    _updateUserBloc.dispose();
    _name.dispose();
    _email.dispose();
    _password.dispose();
    _confirm.dispose();
    _role.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: ListView(
        padding: const EdgeInsets.symmetric(horizontal: 22.0, vertical: 32.0),
        shrinkWrap: true,
        children: [
          const Text(
            'Edit User Pegawai',
            style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.w600),
          ),
          const SizedBox(
            height: 32.0,
          ),
          Input(
            controller: _name,
            label: 'Nama',
            hint: 'Nama pengguna',
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
            height: 18.0,
          ),
          Input(
            controller: _email,
            label: 'Email',
            hint: 'Email pengguna',
            readOnly: true,
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
            height: 18.0,
          ),
          Input(
            controller: _password,
            label: 'Password',
            hint: 'Password min 6 karakter',
            obscure: _obscure,
            maxLines: 1,
            suffixIcon: IconButton(
              onPressed: () {
                setState(() {
                  _obscure = !_obscure;
                });
              },
              icon: _obscure
                  ? const Icon(Icons.visibility)
                  : const Icon(Icons.visibility_off),
            ),
            textInputAction: TextInputAction.next,
          ),
          const SizedBox(
            height: 18.0,
          ),
          Input(
            controller: _confirm,
            label: 'Ulangi Password',
            hint: 'Ulangi password untuk konfirmasi',
            obscure: _obscure,
            maxLines: 1,
            textInputAction: TextInputAction.done,
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
              controller: _animateIconController,
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
            height: 52,
          ),
          ElevatedButton(
            onPressed: _update,
            style: ElevatedButton.styleFrom(
              minimumSize: const Size(double.infinity, 45),
              backgroundColor: kPrimaryColor,
            ),
            child: const Text('UPDATE'),
          )
        ],
      ),
    );
  }

  Widget _streamUpdate(BuildContext context) {
    return StreamBuilder<ApiResponse<ResponseUpdateUserModel>>(
      stream: _updateUserBloc.updateUserStream,
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
                onTap: () => Navigator.pop(context, snapshot.data!.data!.data),
              );
          }
        }
        return const SizedBox();
      },
    );
  }
}

class EditSip extends StatefulWidget {
  const EditSip({
    super.key,
    required this.data,
  });

  final MasterPegawai data;

  @override
  State<EditSip> createState() => _EditSipState();
}

class _EditSipState extends State<EditSip> {
  final _updateSipBloc = UpdateSipDokterBloc();
  final _formKey = GlobalKey<FormState>();
  final _nomor = TextEditingController();
  final _tanggal = TextEditingController();
  final _tanggalFormat = DateFormat('yyyy-MM-dd', 'id');
  DateTime _selectedDate = DateTime.now();

  @override
  void initState() {
    super.initState();
    if (widget.data.sip != null) {
      _nomor.text = widget.data.sip!.nomor!;
      _tanggal.text = _tanggalFormat.format(widget.data.sip!.tanggalBerlaku!);
    }
  }

  bool validateAndSave() {
    var formState = _formKey.currentState;
    if (formState!.validate()) {
      return true;
    }
    return false;
  }

  void _update() {
    if (validateAndSave()) {
      SystemChannels.textInput.invokeListMethod('TextInput.hide');
      FocusScope.of(context).requestFocus(FocusNode());
      _updateSipBloc.idSink.add(widget.data.id!);
      _updateSipBloc.nomorSink.add(_nomor.text);
      _updateSipBloc.tanggalSink.add(_tanggal.text);
      _updateSipBloc.updateSip();
      _showStreamUpdate();
    }
  }

  void _showStreamUpdate() {
    showAnimatedDialog(
      context: context,
      builder: (context) {
        return _streamUpdate(context);
      },
      animationType: DialogTransitionType.slideFromBottomFade,
      duration: const Duration(milliseconds: 500),
    ).then((value) {
      if (value != null) {
        var data = value as MasterPegawai;
        Future.delayed(const Duration(milliseconds: 500), () {
          Navigator.pop(context, data);
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
          _tanggal.text = _tanggalFormat.format(picked);
          setState(() {
            _selectedDate = picked;
          });
        }
      },
    );
  }

  @override
  void dispose() {
    _updateSipBloc.dispose();
    _nomor.dispose();
    _tanggal.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 22.0, vertical: 32.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Edit SIP Dokter',
              style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.w600),
            ),
            const SizedBox(
              height: 32.0,
            ),
            Input(
              controller: _nomor,
              label: 'Nomor',
              hint: 'Nomor Surat Izin Praktek',
              maxLines: 1,
              validator: (val) {
                if (val!.isEmpty) {
                  return 'Input required';
                }
                return null;
              },
              textInputAction: TextInputAction.next,
            ),
            const SizedBox(height: 22.0),
            Input(
              controller: _tanggal,
              label: 'Tanggal',
              hint: 'Tanggal Surat Izin Praktek',
              readOnly: true,
              onTap: _showDate,
              maxLines: 1,
              validator: (val) {
                if (val!.isEmpty) {
                  return 'Input required';
                }
                return null;
              },
              suffixIcon: IconButton(
                onPressed: _showDate,
                icon: const Icon(Icons.calendar_month),
              ),
              textInputAction: TextInputAction.done,
            ),
            const SizedBox(
              height: 42.0,
            ),
            ElevatedButton(
              onPressed: _update,
              style: ElevatedButton.styleFrom(
                minimumSize: const Size(double.infinity, 45),
                backgroundColor: kPrimaryColor,
              ),
              child: const Text('UPDATE'),
            )
          ],
        ),
      ),
    );
  }

  Widget _streamUpdate(BuildContext context) {
    return StreamBuilder<ApiResponse<ResponseUpdateSipDokterModel>>(
      stream: _updateSipBloc.updateSipStream,
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
                onTap: () => Navigator.pop(context, snapshot.data!.data!.data),
              );
          }
        }
        return const SizedBox();
      },
    );
  }
}

class EditDataPegawai extends StatefulWidget {
  const EditDataPegawai({
    Key? key,
    required this.data,
  }) : super(key: key);

  final MasterPegawai data;

  @override
  State<EditDataPegawai> createState() => _EditDataPegawaiState();
}

class _EditDataPegawaiState extends State<EditDataPegawai> {
  final _updateInfoBloc = UpdateInfoPegawaiBloc();
  final _jabatanBloc = MasterJabatanBloc();
  final _animateIconController = AnimateIconController();
  final _formKey = GlobalKey<FormState>();
  final _nama = TextEditingController();
  final _profesi = TextEditingController();
  int _selectedIdJabatan = 0;
  late MasterPegawai _data;

  bool validateAndSave() {
    var formState = _formKey.currentState;
    if (formState!.validate()) {
      return true;
    }
    return false;
  }

  @override
  void initState() {
    super.initState();
    _data = widget.data;
    _edit();
  }

  void _edit() {
    _nama.text = '${_data.nama}';
    _profesi.text = '${_data.profesi!.namaJabatan}';
    _selectedIdJabatan = _data.profesi!.id!;
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
          _selectedIdJabatan = jabatan.id!;
        });
      }
      _animateIconController.animateToStart();
    });
  }

  void _update() {
    if (validateAndSave()) {
      SystemChannels.textInput.invokeMethod('TextInput.hide');
      FocusScope.of(context).requestFocus(FocusNode());
      _updateInfoBloc.idSink.add(widget.data.id!);
      _updateInfoBloc.namaSink.add(_nama.text);
      _updateInfoBloc.profesiSink.add(_selectedIdJabatan);
      _updateInfoBloc.updateInfoPegawai();
      _showStreamUpdate();
    }
  }

  void _showStreamUpdate() {
    showAnimatedDialog(
      context: context,
      builder: (context) {
        return _streamUpdate(context);
      },
      duration: const Duration(milliseconds: 500),
      animationType: DialogTransitionType.slideFromBottomFade,
    ).then((value) {
      if (value != null) {
        var data = value as MasterPegawai;
        Future.delayed(const Duration(milliseconds: 500), () {
          Navigator.pop(context, data);
        });
      }
    });
  }

  @override
  void dispose() {
    _nama.dispose();
    _profesi.dispose();
    _jabatanBloc.dispose();
    _updateInfoBloc.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 22.0, vertical: 32.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Edit Data Pegawai',
              style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.w600),
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
              height: 32.0,
            ),
            SizedBox(
              width: double.infinity,
              height: 48,
              child: ElevatedButton(
                onPressed: _update,
                style: ElevatedButton.styleFrom(
                  backgroundColor: kPrimaryColor,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(6.0),
                  ),
                ),
                child: const Text('UPDATE'),
              ),
            )
          ],
        ),
      ),
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
                  selectedId: _selectedIdJabatan,
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

  Widget _streamUpdate(BuildContext context) {
    return StreamBuilder<ApiResponse<ResponseUpdateInfoPegawaiModel>>(
      stream: _updateInfoBloc.updateInfoPegawaiStream,
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
                onTap: () => Navigator.pop(context, snapshot.data!.data!.data),
              );
          }
        }
        return const SizedBox();
      },
    );
  }
}

class EditSipDokter extends StatefulWidget {
  const EditSipDokter({super.key});

  @override
  State<EditSipDokter> createState() => _EditSipDokterState();
}

class _EditSipDokterState extends State<EditSipDokter> {
  final _nomorSip = TextEditingController();
  final _tanggalSip = TextEditingController();
  DateTime _selectedDate = DateTime.now();
  final _tanggal = DateFormat('yyyy-MM-dd');
  final _formKey = GlobalKey<FormState>();

  bool validateAndSave() {
    var formState = _formKey.currentState;
    if (formState!.validate()) {
      return true;
    }
    return false;
  }

  void _simpan() {
    if (validateAndSave()) {
      //
    }
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

  @override
  Widget build(BuildContext context) {
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
        const SizedBox(
          height: 32.0,
        ),
        SizedBox(
          width: double.infinity,
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
    );
  }
}
