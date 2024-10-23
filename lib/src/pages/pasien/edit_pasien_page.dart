import 'package:animate_icons/animate_icons.dart';
import 'package:dokter_panggil/src/blocs/pasien_bloc.dart';
import 'package:dokter_panggil/src/models/pasien_model.dart';
import 'package:dokter_panggil/src/models/pasien_show_model.dart';
import 'package:dokter_panggil/src/pages/components/error_dialog.dart';
import 'package:dokter_panggil/src/pages/components/input_form.dart';
import 'package:dokter_panggil/src/pages/components/loading_kit.dart';
import 'package:dokter_panggil/src/pages/components/success_dialog.dart';
import 'package:dokter_panggil/src/pages/pasien/pilih_identitas_widget.dart';
import 'package:dokter_panggil/src/repositories/responseApi/api_response.dart';
import 'package:dokter_panggil/src/source/config.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:dokter_panggil/src/source/transition/animated_dialog.dart';
import 'package:intl/intl.dart';
import 'package:intl_phone_field/intl_phone_field.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';

class EditPasienPage extends StatefulWidget {
  const EditPasienPage({
    super.key,
    required this.data,
  });

  final Pasien data;

  @override
  State<EditPasienPage> createState() => _EditPasienPageState();
}

class _EditPasienPageState extends State<EditPasienPage> {
  final _pasienBloc = PasienBloc();
  final _animateIconController = AnimateIconController();
  final _formKey = GlobalKey<FormState>();
  final _nikCon = TextEditingController();
  final _namaCon = TextEditingController();
  final _tempatLahirCon = TextEditingController();
  final _tanggalLahirCon = TextEditingController();
  final _alamatCon = TextEditingController();
  final _nomorHpCon = TextEditingController();
  final _jenisKelaminCon = TextEditingController();
  DateTime _selectedDate = DateTime.parse('1990-01-01');
  final DateFormat _tanggal = DateFormat('yyyy-MM-dd');
  int _selectedJk = 2;
  String? _noHp;
  int? _jenisIdentitas;

  @override
  void initState() {
    super.initState();
    _loadPasien();
  }

  void _loadPasien() {
    if (widget.data.identitas == null) {
      _nikCon.text = '${widget.data.nik}';
    } else {
      _nikCon.text = '${widget.data.identitas?.nomorIdentitas}';
    }
    _namaCon.text = '${widget.data.namaPasien}';
    _tempatLahirCon.text = '${widget.data.tempatLahir}';
    _tanggalLahirCon.text = '${widget.data.tanggalLahir}';
    _jenisKelaminCon.text = '${widget.data.jenisKelamin}';
    _selectedJk = widget.data.jk!;
    _alamatCon.text = '${widget.data.alamat}';
    _nomorHpCon.text = '${widget.data.nomorTelepon}';
  }

  bool validateAndSave() {
    var formState = _formKey.currentState;
    if (formState!.validate()) {
      formState.save();
      return true;
    }
    return false;
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
            helpText: 'Pilih tanggal lahir',
            cancelText: 'Batal',
            confirmText: 'Pilih',
            fieldLabelText: 'Tanggal lahir',
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
          _tanggalLahirCon.text = _tanggal.format(picked);
          setState(() {
            _selectedDate = picked;
          });
        }
      },
    );
  }

  void _showJenisKelamin() {
    _animateIconController.animateToEnd();
    showMaterialModalBottomSheet(
      context: context,
      useRootNavigator: true,
      builder: (context) {
        return Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Padding(
              padding: EdgeInsets.only(top: 22.0, left: 18.0, right: 18.0),
              child: Text(
                'Pilih jenis kelamin',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
              ),
            ),
            const SizedBox(
              height: 18.0,
            ),
            ListTile(
              onTap: () =>
                  Navigator.pop(context, {'id': "1", 'jenis': 'Laki-laki'}),
              leading: const Icon(Icons.male),
              title: const Text('Laki-laki'),
            ),
            const Divider(height: 0.0),
            ListTile(
              onTap: () =>
                  Navigator.pop(context, {'id': "2", 'jenis': 'Perempuan'}),
              leading: const Icon(Icons.female),
              title: const Text('Perempuan'),
            ),
            const SizedBox(
              height: 22.0,
            ),
          ],
        );
      },
    ).then((value) {
      _animateIconController.animateToStart();
      if (value != null) {
        var data = value as Map<String, dynamic>;
        _jenisKelaminCon.text = data['jenis'];
        _pasienBloc.jenisKelaminSink.add(data['id']);
        setState(() {
          _selectedJk = int.parse(data['id']);
        });
      }
    });
  }

  void _update() {
    if (validateAndSave()) {
      SystemChannels.textInput.invokeMethod('TextInput.hide');
      _pasienBloc.nikSink.add(_nikCon.text);
      _pasienBloc.jenisSink.add('$_jenisIdentitas');
      _pasienBloc.idSink.add(widget.data.id!);
      _pasienBloc.namaSink.add(_namaCon.text);
      _pasienBloc.tempatLahirSink.add(_tempatLahirCon.text);
      _pasienBloc.tanggalLahirSink.add(_tanggalLahirCon.text);
      _pasienBloc.jenisKelaminSink.add(_selectedJk.toString());
      _pasienBloc.alamatSink.add(_alamatCon.text);
      _pasienBloc.nomorHpSink.add(_noHp!);
      _pasienBloc.updatePasien();
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
        var data = value as Pasien;
        Future.delayed(const Duration(milliseconds: 500), () {
          Navigator.pop(context, data);
        });
      }
    });
  }

  void _pilihIdentitas() {
    showMaterialModalBottomSheet(
      context: context,
      useRootNavigator: true,
      builder: (context) {
        return Padding(
          padding:
              EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
          child: PilihIdentitasWidget(
            pasien: widget.data,
          ),
        );
      },
    ).then((value) {
      if (value != null) {
        var identitas = value as PilihIdentitasModel;
        _nikCon.text = identitas.nomor;
        setState(() {
          _jenisIdentitas = identitas.id;
        });
      }
    });
  }

  @override
  void dispose() {
    _pasienBloc.dispose();
    _namaCon.dispose();
    _nikCon.dispose();
    _tempatLahirCon.dispose();
    _tanggalLahirCon.dispose();
    _jenisKelaminCon.dispose();
    _alamatCon.dispose();
    _nomorHpCon.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Edit Pasien'),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(vertical: 32.0, horizontal: 22.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Input(
                controller: _nikCon,
                label: 'NIK',
                hint: 'Nomor identitas/no. ktp',
                maxLines: 1,
                keyType: TextInputType.number,
                readOnly: true,
                onTap: _pilihIdentitas,
              ),
              const SizedBox(
                height: 32.0,
              ),
              Input(
                controller: _namaCon,
                label: 'Nama pasien',
                hint: 'Nama sesuai identitas',
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
                height: 32.0,
              ),
              Input(
                controller: _tempatLahirCon,
                label: 'Tempat lahir',
                hint: 'Tempat lahir sesuai identitas',
                suffixIcon: const Icon(Icons.place),
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
                height: 32.0,
              ),
              Input(
                controller: _tanggalLahirCon,
                label: 'Tanggal lahir',
                hint: 'Tanggal lahir sesuai identitas',
                maxLines: 1,
                suffixIcon: const Icon(
                  Icons.calendar_month,
                  color: Colors.grey,
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
              Input(
                controller: _jenisKelaminCon,
                label: 'Jenis kelamin',
                hint: 'Jenis kelamin pasien',
                suffixIcon: AnimateIcons(
                  startIconColor: Colors.grey,
                  endIconColor: Colors.grey,
                  startIcon: Icons.expand_more_rounded,
                  endIcon: Icons.expand_less_rounded,
                  duration: const Duration(milliseconds: 300),
                  onStartIconPress: () {
                    _showJenisKelamin();
                    return false;
                  },
                  onEndIconPress: () {
                    Navigator.pop(context);
                    return false;
                  },
                  controller: _animateIconController,
                ),
                maxLines: 1,
                validator: (val) {
                  if (val!.isEmpty) {
                    return 'Input required';
                  }
                  return null;
                },
                readOnly: true,
                onTap: _showJenisKelamin,
                textInputAction: TextInputAction.next,
              ),
              const SizedBox(
                height: 32.0,
              ),
              Input(
                controller: _alamatCon,
                label: 'Alamat',
                hint: 'Alamat sesuai identitas',
                minLines: 4,
                maxLines: null,
                validator: (val) {
                  if (val!.isEmpty) {
                    return 'Input required';
                  }
                  return null;
                },
                textCap: TextCapitalization.words,
                keyType: TextInputType.multiline,
                textInputAction: TextInputAction.newline,
              ),
              const SizedBox(
                height: 32.0,
              ),
              const Text(
                'Nomor Handphone',
                style: TextStyle(fontWeight: FontWeight.w600),
              ),
              const SizedBox(
                height: 10.0,
              ),
              Container(
                padding:
                    const EdgeInsets.symmetric(vertical: 4.0, horizontal: 18.0),
                decoration: BoxDecoration(
                  color: Colors.blueGrey[50],
                  border: Border.all(width: 0.3, color: Colors.grey),
                  borderRadius: BorderRadius.circular(8.0),
                ),
                child: IntlPhoneField(
                  controller: _nomorHpCon,
                  decoration: InputDecoration(
                    contentPadding: const EdgeInsets.symmetric(vertical: 10.0),
                    border: const OutlineInputBorder(
                      borderSide: BorderSide.none,
                    ),
                    hintText: 'Ex: 081334334334,',
                    hintStyle: TextStyle(color: Colors.grey[400]),
                  ),
                  initialCountryCode: 'ID',
                  showDropdownIcon: false,
                  disableLengthCheck: true,
                  showCountryFlag: false,
                  validator: (value) {
                    if (value!.number.isEmpty) {
                      return 'Invalid phone Number';
                    }
                    return null;
                  },
                  onSaved: (phone) {
                    _noHp = phone!.number;
                  },
                ),
              ),
              const SizedBox(
                height: 52.0,
              ),
              ElevatedButton.icon(
                onPressed: _update,
                style: ElevatedButton.styleFrom(
                  backgroundColor: kPrimaryColor,
                  minimumSize: const Size(double.infinity, 45.0),
                ),
                icon: const Icon(Icons.edit_note_rounded),
                label: const Text('Update'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _streamUpdate(BuildContext context) {
    return StreamBuilder<ApiResponse<ResponsePasienModel>>(
      stream: _pasienBloc.pasienStream,
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
