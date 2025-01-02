import 'package:animate_icons/animate_icons.dart';
import 'package:dokter_panggil/src/blocs/pasien_bloc.dart';
import 'package:dokter_panggil/src/models/pasien_model.dart';
import 'package:dokter_panggil/src/models/pasien_show_model.dart';
import 'package:dokter_panggil/src/pages/components/button_edit_master.dart';
import 'package:dokter_panggil/src/pages/components/confirm_dialog.dart';
import 'package:dokter_panggil/src/pages/components/error_dialog.dart';
import 'package:dokter_panggil/src/pages/components/header.dart';
import 'package:dokter_panggil/src/pages/components/input_form.dart';
import 'package:dokter_panggil/src/pages/components/loading_kit.dart';
import 'package:dokter_panggil/src/pages/components/search_input_form.dart';
import 'package:dokter_panggil/src/pages/components/success_dialog.dart';
import 'package:dokter_panggil/src/pages/pasien/pencarian_pasien_page.dart';
import 'package:dokter_panggil/src/pages/pasien/pilih_identitas_widget.dart';
import 'package:dokter_panggil/src/repositories/responseApi/api_response.dart';
import 'package:dokter_panggil/src/source/config.dart';
import 'package:dokter_panggil/src/source/size_config.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:dokter_panggil/src/source/transition/animated_dialog.dart';
import 'package:intl/intl.dart';
import 'package:intl_phone_field/intl_phone_field.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:persistent_bottom_nav_bar_v2/persistent_bottom_nav_bar_v2.dart';

class Tambahpasienpage extends StatefulWidget {
  const Tambahpasienpage({super.key});

  @override
  State<Tambahpasienpage> createState() => _TambahpasienpageState();
}

class _TambahpasienpageState extends State<Tambahpasienpage> {
  final _scrollCon = ScrollController();
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
  bool _editForm = false;
  String? _nomorHp;

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
      }
    });
  }

  void _simpan() {
    if (validateAndSave()) {
      _pasienBloc.nikSink.add(_nikCon.text);
      _pasienBloc.namaSink.add(_namaCon.text);
      _pasienBloc.tempatLahirSink.add(_tempatLahirCon.text);
      _pasienBloc.tanggalLahirSink.add(_tanggalLahirCon.text);
      _pasienBloc.alamatSink.add(_alamatCon.text);
      _pasienBloc.nomorHpSink.add(_nomorHp!);
      _pasienBloc.savePasien();
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
    _pasienBloc.idSink.add(pasien.id!);
    setState(() {
      _editForm = true;
    });
  }

  void _update() {
    if (validateAndSave()) {
      _pasienBloc.nikSink.add(_nikCon.text);
      _pasienBloc.namaSink.add(_namaCon.text);
      _pasienBloc.tempatLahirSink.add(_tempatLahirCon.text);
      _pasienBloc.tanggalLahirSink.add(_tanggalLahirCon.text);
      _pasienBloc.jenisKelaminSink.add(_jenisKelaminCon.text);
      _pasienBloc.alamatSink.add(_alamatCon.text);
      _pasienBloc.nomorHpSink.add(_nomorHpCon.text);
      _pasienBloc.updatePasien();
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
          _pasienBloc.deletePasien();
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
        _pasienBloc.jenisSink.add('${identitas.id}');
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
                child: ListView(
                  controller: _scrollCon,
                  padding: const EdgeInsets.all(32.0),
                  children: [
                    Input(
                      controller: _nikCon,
                      readOnly: true,
                      label: 'Nomor identitas',
                      hint: 'Nomor identitas',
                      maxLines: 1,
                      keyType: TextInputType.number,
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
                      padding: const EdgeInsets.symmetric(
                          vertical: 4.0, horizontal: 18.0),
                      decoration: BoxDecoration(
                        color: Colors.blueGrey[50],
                        border: Border.all(width: 0.3, color: Colors.grey),
                        borderRadius: BorderRadius.circular(8.0),
                      ),
                      child: IntlPhoneField(
                        controller: _nomorHpCon,
                        decoration: InputDecoration(
                          contentPadding:
                              const EdgeInsets.symmetric(vertical: 10.0),
                          border: const OutlineInputBorder(
                            borderSide: BorderSide.none,
                          ),
                          hintText: 'Ex: 081334334334',
                          hintStyle: TextStyle(color: Colors.grey[400]),
                        ),
                        initialCountryCode: 'ID',
                        disableLengthCheck: true,
                        showDropdownIcon: false,
                        showCountryFlag: false,
                        validator: (value) {
                          if (value!.number.isEmpty) {
                            return 'Invalid phone Number';
                          }
                          return null;
                        },
                        onSaved: (value) {
                          setState(() {
                            _nomorHp = value!.number;
                          });
                        },
                      ),
                    ),
                    const SizedBox(
                      height: 32.0,
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
            ],
          ),
        ),
      ),
    );
  }

  Widget _streamSave() {
    return StreamBuilder<ApiResponse<ResponsePasienModel>>(
      stream: _pasienBloc.pasienStream,
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
