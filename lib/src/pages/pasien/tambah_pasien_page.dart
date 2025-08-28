import 'package:dokter_panggil/src/blocs/mr_pasien_save_bloc.dart';
import 'package:dokter_panggil/src/models/master_status_nikah_model.dart';
import 'package:dokter_panggil/src/models/master_village_model.dart';
import 'package:dokter_panggil/src/models/mr_pasien_save_model.dart';
import 'package:dokter_panggil/src/models/pasien_show_model.dart';
import 'package:dokter_panggil/src/pages/components/button_edit_master.dart';
import 'package:dokter_panggil/src/pages/components/confirm_dialog.dart';
import 'package:dokter_panggil/src/pages/components/error_dialog.dart';
import 'package:dokter_panggil/src/pages/components/header.dart';
import 'package:dokter_panggil/src/pages/components/input_form.dart';
import 'package:dokter_panggil/src/pages/components/input_kontak.dart';
import 'package:dokter_panggil/src/pages/components/list_jenis_kelamin.dart';
import 'package:dokter_panggil/src/pages/components/list_master_status_nikah.dart';
import 'package:dokter_panggil/src/pages/components/loading_kit.dart';
import 'package:dokter_panggil/src/pages/components/search_input_form.dart';
import 'package:dokter_panggil/src/pages/components/success_dialog.dart';
import 'package:dokter_panggil/src/pages/master/list_master_village_page.dart';
import 'package:dokter_panggil/src/pages/pasien/pencarian_pasien_page.dart';
import 'package:dokter_panggil/src/pages/pasien/pilih_identitas_widget.dart';
import 'package:dokter_panggil/src/repositories/responseApi/api_response.dart';
import 'package:dokter_panggil/src/source/config.dart';
import 'package:dokter_panggil/src/source/size_config.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:dokter_panggil/src/source/transition/animated_dialog.dart';
import 'package:intl/intl.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:persistent_bottom_nav_bar_v2/persistent_bottom_nav_bar_v2.dart';

class Tambahpasienpage extends StatefulWidget {
  const Tambahpasienpage({super.key});

  @override
  State<Tambahpasienpage> createState() => _TambahpasienpageState();
}

class _TambahpasienpageState extends State<Tambahpasienpage> {
  final _scrollCon = ScrollController();
  final _mrPasienSaveBloc = MrPasienSaveBloc();
  final _formKey = GlobalKey<FormState>();
  final _nikCon = TextEditingController();
  final _namaCon = TextEditingController();
  final _tempatLahirCon = TextEditingController();
  final _tanggalLahirCon = TextEditingController();
  final _alamatCon = TextEditingController();
  final _nomorHpCon = TextEditingController();
  final _jenisKelaminCon = TextEditingController();
  final _kelurahanCon = TextEditingController();
  final _kodeposCon = TextEditingController();
  final _namaDarurat = TextEditingController();
  final _nomorHpDaruratCon = TextEditingController();
  final _rwCon = TextEditingController();
  final _rtCon = TextEditingController();
  final _statusNikahCon = TextEditingController();

  DateTime _selectedDate = DateTime.parse('1990-01-01');
  final DateFormat _tanggal = DateFormat('yyyy-MM-dd');
  bool _editForm = false;
  String? _nomorHp, _nomorHpDarurat;

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
        _jenisKelaminCon.text = data['jenis'];
        _mrPasienSaveBloc.jenisKelaminSink.add(data['id']);
      }
    });
  }

  void _simpan() {
    if (validateAndSave()) {
      _mrPasienSaveBloc.nikSink.add(_nikCon.text);
      _mrPasienSaveBloc.namaPasienSink.add(_namaCon.text);
      _mrPasienSaveBloc.tempatLahirSink.add(_tempatLahirCon.text);
      _mrPasienSaveBloc.tanggalLahirSink.add(_tanggalLahirCon.text);
      _mrPasienSaveBloc.alamatSink.add(_alamatCon.text);
      _mrPasienSaveBloc.nomorHpSink.add(_nomorHp!);
      _mrPasienSaveBloc.rwSink.add(_rwCon.text);
      _mrPasienSaveBloc.rtSink.add(_rtCon.text);
      _mrPasienSaveBloc.kodePosSink.add(_kodeposCon.text);
      _mrPasienSaveBloc.namaDaruratSink.add(_namaDarurat.text);
      _mrPasienSaveBloc.nomorHpDaruratSink.add('$_nomorHpDarurat');
      _mrPasienSaveBloc.simpanPasien();
      _showStream();
    }
  }

  void _batal() {
    _nikCon.clear();
    _namaCon.clear();
    _tempatLahirCon.clear();
    _tanggalLahirCon.clear();
    _alamatCon.clear();
    _nomorHpCon.clear();
    _jenisKelaminCon.clear();
    _kelurahanCon.clear();
    _kodeposCon.clear();
    _namaDarurat.clear();
    _kelurahanCon.clear();
    _statusNikahCon.clear();
    _rtCon.clear();
    _rwCon.clear();
    _nomorHpDaruratCon.clear();
    FocusScope.of(context).requestFocus(FocusNode());
    _scrollCon.animateTo(0,
        duration: const Duration(milliseconds: 300),
        curve: Curves.fastOutSlowIn);
    setState(() {
      _editForm = false;
    });
  }

  void _showStream() {
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

  void _edit(Pasien pasien) {
    _nikCon.text = pasien.nik!;
    _namaCon.text = pasien.namaPasien!;
    _tempatLahirCon.text = pasien.tempatLahir!;
    _tanggalLahirCon.text = pasien.tanggalLahir!;
    _jenisKelaminCon.text = pasien.jenisKelamin!;
    _alamatCon.text = pasien.alamat!;
    _nomorHpCon.text = pasien.nomorTelepon!;
    _mrPasienSaveBloc.idPasienSink.add(pasien.id!);
    setState(() {
      _editForm = true;
    });
  }

  void _update() {
    if (validateAndSave()) {
      _mrPasienSaveBloc.nikSink.add(_nikCon.text);
      _mrPasienSaveBloc.namaPasienSink.add(_namaCon.text);
      _mrPasienSaveBloc.tempatLahirSink.add(_tempatLahirCon.text);
      _mrPasienSaveBloc.tanggalLahirSink.add(_tanggalLahirCon.text);
      _mrPasienSaveBloc.jenisKelaminSink.add(_jenisKelaminCon.text);
      _mrPasienSaveBloc.alamatSink.add(_alamatCon.text);
      _mrPasienSaveBloc.nomorHpSink.add(_nomorHpCon.text);
      // _mrPasienSaveBloc.updatePasien();
      _showStream();
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
          _mrPasienSaveBloc.deletePasien();
          _showStream();
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
          child: const PilihIdentitasWidget(),
        );
      },
    ).then((value) {
      if (value != null) {
        var identitas = value as PilihIdentitasModel;
        _nikCon.text = identitas.nomor;
        _mrPasienSaveBloc.jenisSink.add(identitas.id);
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
        _mrPasienSaveBloc.villageSink.add(kelurahan);
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
        _mrPasienSaveBloc.statusNikahSink.add(status.id!);
        setState(() {
          _statusNikahCon.text = '${status.deskripsi}';
        });
      }
    });
  }

  @override
  void dispose() {
    _mrPasienSaveBloc.dispose();
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
    SizeConfig().init(context);
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: const SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarBrightness: Brightness.dark,
        statusBarIconBrightness: Brightness.light,
      ),
      child: Scaffold(
        backgroundColor: Colors.white,
        body: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Header(
                title: 'Tambah Pasien',
                subtitle: SearchInputForm(
                  isReadOnly: true,
                  hint: 'Pencarian pasien',
                  onTap: () => pushScreen(
                    context,
                    screen: const PencarianPasianpage(),
                    pageTransitionAnimation: PageTransitionAnimation.slideUp,
                    withNavBar: false,
                  ).then((value) {
                    if (value != null) {
                      var data = value as Pasien;
                      _edit(data);
                    }
                  }),
                ),
              ),
              Expanded(
                child: SingleChildScrollView(
                  controller: _scrollCon,
                  padding: const EdgeInsets.all(32.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Infromasi Pribadi',
                        style: TextStyle(
                            fontSize: 20, fontWeight: FontWeight.w600),
                      ),
                      Divider(
                        height: 22,
                      ),
                      Input(
                        controller: _nikCon,
                        readOnly: true,
                        label: 'Nomor identitas',
                        hint: 'Nomor identitas',
                        maxLines: 1,
                        keyType: TextInputType.number,
                        onTap: _pilihIdentitas,
                        validator: (val) {
                          if (val!.isEmpty) {
                            return 'Input required';
                          }
                          return null;
                        },
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
                      SizedBox(
                        height: 32,
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
                      SizedBox(
                        height: 32,
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
                        builder: (state) => Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            InputKontak(
                              controller: _nomorHpCon,
                              label: 'Nomor Handphone',
                              onSaved: (value) {
                                setState(() {
                                  _nomorHp = value!.number;
                                });
                              },
                              onChanged: (val) => state.didChange(val),
                            ),
                            if (state.hasError)
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Text(
                                  'Input required',
                                  style: TextStyle(
                                      fontSize: 13, color: Colors.red[800]),
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
                        style: TextStyle(
                            fontSize: 20, fontWeight: FontWeight.w600),
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
                              onChanged: (val) => state.didChange(val),
                            ),
                            if (state.hasError)
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Text(
                                  'Input required',
                                  style: TextStyle(
                                      fontSize: 13, color: Colors.red[800]),
                                ),
                              ),
                          ],
                        ),
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
                        Row(
                          children: [
                            Expanded(
                              child: SizedBox(
                                width: double.infinity,
                                height: 45.0,
                                child: ElevatedButton(
                                  onPressed: _batal,
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.grey[200],
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(6.0),
                                    ),
                                  ),
                                  child: const Text(
                                    'BATAL',
                                    style: TextStyle(color: Colors.black),
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(
                              width: 15.0,
                            ),
                            Expanded(
                              child: SizedBox(
                                width: double.infinity,
                                height: 45.0,
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
                              ),
                            ),
                          ],
                        )
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _streamSave() {
    return StreamBuilder<ApiResponse<MrPasienSaveModel>>(
      stream: _mrPasienSaveBloc.pasienSaveStream,
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
