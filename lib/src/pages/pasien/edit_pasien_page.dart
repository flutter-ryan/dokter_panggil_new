import 'package:dokter_panggil/src/blocs/mr_pasien_update_bloc.dart';
import 'package:dokter_panggil/src/models/master_status_nikah_model.dart';
import 'package:dokter_panggil/src/models/master_village_model.dart';
import 'package:dokter_panggil/src/models/pasien_show_model.dart';
import 'package:dokter_panggil/src/pages/components/error_dialog.dart';
import 'package:dokter_panggil/src/pages/components/input_form.dart';
import 'package:dokter_panggil/src/pages/components/input_kontak.dart';
import 'package:dokter_panggil/src/pages/components/list_jenis_kelamin.dart';
import 'package:dokter_panggil/src/pages/components/list_master_status_nikah.dart';
import 'package:dokter_panggil/src/pages/components/loading_kit.dart';
import 'package:dokter_panggil/src/pages/components/success_dialog.dart';
import 'package:dokter_panggil/src/pages/master/list_master_village_page.dart';
import 'package:dokter_panggil/src/pages/pasien/pilih_identitas_widget.dart';
import 'package:dokter_panggil/src/repositories/responseApi/api_response.dart';
import 'package:dokter_panggil/src/source/config.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:dokter_panggil/src/source/transition/animated_dialog.dart';
import 'package:intl/intl.dart';
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
  final _mrPasienUpdateBloc = MrPasienUpdateBloc();
  final _formKey = GlobalKey<FormState>();
  final _nikCon = TextEditingController();
  final _namaCon = TextEditingController();
  final _tempatLahirCon = TextEditingController();
  final _tanggalLahirCon = TextEditingController();
  final _alamatCon = TextEditingController();
  final _nomorHpCon = TextEditingController();
  final _jenisKelaminCon = TextEditingController();
  final _statusNikahCon = TextEditingController();
  final _kelurahanCon = TextEditingController();
  final _rtCon = TextEditingController();
  final _rwCon = TextEditingController();
  final _kodeposCon = TextEditingController();
  final _namaDarurat = TextEditingController();
  final _nomorHpDaruratCon = TextEditingController();
  DateTime _selectedDate = DateTime.parse('1990-01-01');
  final DateFormat _tanggal = DateFormat('yyyy-MM-dd');
  String? _noHp, _nomorHpDarurat;
  int? _jenisIdentitas, _selectedJk;

  @override
  void initState() {
    super.initState();
    _loadPasien();
  }

  void _loadPasien() {
    if (widget.data.identitas != null) {
      _jenisIdentitas = widget.data.identitas!.identitas!.id;
      _nikCon.text = '${widget.data.identitas?.nomorIdentitas}';
      _mrPasienUpdateBloc.jenisSink.add(widget.data.identitas!.identitas!.id!);
    }
    _namaCon.text = '${widget.data.namaPasien}';
    _tempatLahirCon.text = '${widget.data.tempatLahir}';
    _tanggalLahirCon.text = '${widget.data.tanggalLahir}';
    _jenisKelaminCon.text = '${widget.data.jenisKelamin}';
    _selectedJk = widget.data.jk!;
    _alamatCon.text = '${widget.data.alamat}';
    _nomorHpCon.text = '${widget.data.nomorTelepon}';
    if (widget.data.pasienStatusPerkawinan != null) {
      _statusNikahCon.text =
          '${widget.data.pasienStatusPerkawinan?.statusDeskripsi}';
      _mrPasienUpdateBloc.statusNikahSink
          .add(widget.data.pasienStatusPerkawinan!.statusId!);
    }

    if (widget.data.pasienKontakDarurat != null) {
      _namaDarurat.text = '${widget.data.pasienKontakDarurat!.nama}';
      _nomorHpDaruratCon.text =
          '${widget.data.pasienKontakDarurat!.nomorKontak}';
    }

    if (widget.data.pasienAdministrativeCode != null) {
      _kelurahanCon.text =
          '${widget.data.pasienAdministrativeCode!.village!.name}';
      _rwCon.text = '${widget.data.pasienAdministrativeCode!.rw}';
      _rtCon.text = '${widget.data.pasienAdministrativeCode!.rt}';
      _kodeposCon.text = '${widget.data.pasienAdministrativeCode!.kodePos}';
      _mrPasienUpdateBloc.villageSink
          .add(widget.data.pasienAdministrativeCode!.village!);
    }
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
    showMaterialModalBottomSheet(
      context: context,
      useRootNavigator: true,
      builder: (context) {
        return ListJenisKelamin();
      },
    ).then((value) {
      if (value != null) {
        var data = value as Map<String, dynamic>;
        _mrPasienUpdateBloc.jenisKelaminSink.add(data['id']);
        setState(() {
          _jenisKelaminCon.text = data['jenis'];
        });
      }
    });
  }

  void _update() {
    if (validateAndSave()) {
      SystemChannels.textInput.invokeMethod('TextInput.hide');
      _mrPasienUpdateBloc.nikSink.add(_nikCon.text);
      _mrPasienUpdateBloc.jenisSink.add(_jenisIdentitas!);
      _mrPasienUpdateBloc.idPasienSink.add(widget.data.id!);
      _mrPasienUpdateBloc.namaPasienSink.add(_namaCon.text);
      _mrPasienUpdateBloc.tempatLahirSink.add(_tempatLahirCon.text);
      _mrPasienUpdateBloc.tanggalLahirSink.add(_tanggalLahirCon.text);
      _mrPasienUpdateBloc.jenisKelaminSink.add('$_selectedJk');
      _mrPasienUpdateBloc.alamatSink.add(_alamatCon.text);
      _mrPasienUpdateBloc.nomorHpSink.add(_noHp!);
      _mrPasienUpdateBloc.rwSink.add(_rwCon.text);
      _mrPasienUpdateBloc.rtSink.add(_rtCon.text);
      _mrPasienUpdateBloc.kodePosSink.add(_kodeposCon.text);
      _mrPasienUpdateBloc.namaDaruratSink.add(_namaDarurat.text);
      _mrPasienUpdateBloc.nomorHpDaruratSink.add('$_nomorHpDarurat');
      _mrPasienUpdateBloc.updatePasien();
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
          if (!mounted) return;
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

  void _showVillage() {
    showMaterialModalBottomSheet(
      context: context,
      useRootNavigator: true,
      backgroundColor: Colors.transparent,
      builder: (context) => Padding(
        padding:
            EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
        child: SafeArea(
          bottom: false,
          child: ListMasterVillagePage(),
        ),
      ),
    ).then((value) {
      if (value != null) {
        var kelurahan = value as Village;
        _mrPasienUpdateBloc.villageSink.add(kelurahan);
        setState(() {
          _kelurahanCon.text = '${kelurahan.name}';
        });
      }
    });
  }

  void _showStatusNikah() {
    showMaterialModalBottomSheet(
      context: context,
      useRootNavigator: true,
      builder: (context) => ListMasterStatusNikah(),
    ).then((value) {
      if (value != null) {
        final status = value as MasterStatusNikah;
        _mrPasienUpdateBloc.statusNikahSink.add(status.id!);
        setState(() {
          _statusNikahCon.text = '${status.deskripsi}';
        });
      }
    });
  }

  @override
  void dispose() {
    _mrPasienUpdateBloc.dispose();
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
                suffixIcon: Icon(Icons.expand_more_rounded),
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
                controller: _statusNikahCon,
                label: 'Status',
                hint: 'Status perkawinan',
                suffixIcon: Icon(Icons.expand_more_rounded),
                maxLines: 1,
                validator: (val) {
                  if (val!.isEmpty) {
                    return 'Input required';
                  }
                  return null;
                },
                readOnly: true,
                onTap: _showStatusNikah,
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
              Input(
                  controller: _kelurahanCon,
                  label: 'Kelurahan',
                  hint: 'Pilih kelurahan sesuai alamat',
                  validator: (val) {
                    if (val!.isEmpty) {
                      return 'Input required';
                    }
                    return null;
                  },
                  onTap: _showVillage,
                  readOnly: true,
                  suffixIcon: Icon(Icons.keyboard_arrow_down_rounded)),
              const SizedBox(
                height: 32.0,
              ),
              Row(
                children: [
                  Expanded(
                    child: Input(
                      controller: _rwCon,
                      label: 'RW',
                      hint: 'RW sesuai alamat',
                      maxLines: 1,
                      validator: (val) {
                        if (val!.isEmpty) {
                          return 'Input required';
                        }
                        return null;
                      },
                      keyType: TextInputType.number,
                    ),
                  ),
                  SizedBox(
                    width: 22,
                  ),
                  Expanded(
                    child: Input(
                      controller: _rtCon,
                      label: 'RT',
                      hint: 'RT sesuai alamat',
                      maxLines: 1,
                      validator: (val) {
                        if (val!.isEmpty) {
                          return 'Input required';
                        }
                        return null;
                      },
                      keyType: TextInputType.number,
                    ),
                  )
                ],
              ),
              SizedBox(
                height: 32.0,
              ),
              Input(
                controller: _kodeposCon,
                label: 'Kode Pos',
                hint: 'Kode pos sesuai alamat',
                validator: (val) {
                  if (val!.isEmpty) {
                    return 'Input required';
                  }
                  return null;
                },
                keyType: TextInputType.number,
              ),
              const SizedBox(
                height: 32.0,
              ),
              FormField(
                initialValue: widget.data.nomorTelepon,
                validator: (val) {
                  if (val == null) {
                    return 'Input required';
                  }
                  return null;
                },
                builder: (state) => Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    InputKontak(
                      controller: _nomorHpCon,
                      label: 'Nomor Handphone',
                      onSaved: (value) {
                        setState(() {
                          _noHp = value!.number;
                        });
                      },
                      onChanged: (val) => state.didChange(val!.number),
                    ),
                    if (state.hasError)
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                          'Input required',
                          style:
                              TextStyle(fontSize: 13, color: Colors.red[800]),
                        ),
                      ),
                  ],
                ),
              ),
              SizedBox(
                height: 32,
              ),
              Text(
                'Kontak Darurat',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
              ),
              Divider(
                height: 22,
              ),
              Input(
                controller: _namaDarurat,
                label: 'Nama lengkap',
                hint: 'Nama lengkap suami/istri/saudara/orang tua',
                validator: (val) {
                  if (val!.isEmpty) {
                    return 'Input required';
                  }
                  return null;
                },
                textCap: TextCapitalization.words,
              ),
              SizedBox(
                height: 32,
              ),
              FormField(
                initialValue: widget.data.pasienKontakDarurat?.nomorKontak,
                validator: (val) {
                  if (val == null) {
                    return 'Input required';
                  }
                  return null;
                },
                builder: (state) => Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    InputKontak(
                      controller: _nomorHpDaruratCon,
                      label: 'Nomor Handphone',
                      onSaved: (val) {
                        setState(() {
                          _nomorHpDarurat = val!.number;
                        });
                      },
                      onChanged: (val) => state.didChange(val!.number),
                    ),
                    if (state.hasError)
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                          'Input required',
                          style:
                              TextStyle(fontSize: 13, color: Colors.red[800]),
                        ),
                      ),
                  ],
                ),
              ),
              const SizedBox(
                height: 52.0,
              ),
              Row(
                children: [
                  Expanded(
                    flex: 2,
                    child: ElevatedButton(
                      onPressed: () => Navigator.pop(context),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.grey[100],
                        foregroundColor: Colors.black,
                        minimumSize: const Size(double.infinity, 45.0),
                      ),
                      child: Text('Batal'),
                    ),
                  ),
                  SizedBox(
                    width: 12,
                  ),
                  Expanded(
                    flex: 3,
                    child: ElevatedButton.icon(
                      onPressed: _update,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: kPrimaryColor,
                        minimumSize: const Size(double.infinity, 45.0),
                      ),
                      icon: const Icon(Icons.edit_note_rounded),
                      label: const Text('Update'),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _streamUpdate(BuildContext context) {
    return StreamBuilder<ApiResponse<PasienShowModel>>(
      stream: _mrPasienUpdateBloc.pasienSaveStream,
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
                onTap: () =>
                    Navigator.pop(context, snapshot.data!.data!.pasien),
              );
          }
        }
        return const SizedBox();
      },
    );
  }
}
