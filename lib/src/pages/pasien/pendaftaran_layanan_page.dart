import 'package:animate_icons/animate_icons.dart';
import 'package:dokter_panggil/src/blocs/mr_kunjungan_pasien_bloc.dart';
import 'package:dokter_panggil/src/blocs/pendaftaran_pembelian_langsung_bloc.dart';
import 'package:dokter_panggil/src/models/master_layanan_model.dart';
import 'package:dokter_panggil/src/models/master_tindakan_lab_all_model.dart';
import 'package:dokter_panggil/src/models/mr_kunjungan_pasien_model.dart';
import 'package:dokter_panggil/src/models/mr_master_skrining_model.dart';
import 'package:dokter_panggil/src/models/pasien_show_model.dart';
import 'package:dokter_panggil/src/models/pendaftaran_pembelian_langsug_save_model.dart';
import 'package:dokter_panggil/src/pages/components/button_rounded_widget.dart';
import 'package:dokter_panggil/src/pages/components/loading_kit.dart';
import 'package:dokter_panggil/src/pages/components/search_input_form.dart';
import 'package:dokter_panggil/src/pages/components/tambah_langsung_drugs_widget.dart';
import 'package:dokter_panggil/src/pages/master/master_layanan_widget.dart';
import 'package:dokter_panggil/src/pages/pasien/form_skrining_widget.dart';
import 'package:dokter_panggil/src/pages/pasien/list_paket_widget.dart';
import 'package:dokter_panggil/src/pages/pasien/pilih_petugas_page.dart';
import 'package:dokter_panggil/src/repositories/responseApi/api_response.dart';
import 'package:dokter_panggil/src/source/config.dart';
import 'package:dokter_panggil/src/source/size_config.dart';
import 'package:flutter/material.dart';
import 'package:dokter_panggil/src/pages/components/error_response.dart';
import 'package:dokter_panggil/src/blocs/hubungan_fetch_bloc.dart';
import 'package:dokter_panggil/src/blocs/master_tindakan_lab_all_bloc.dart';
import 'package:dokter_panggil/src/blocs/pendaftaran_kunjungan_nonkonsul_save_bloc.dart';
import 'package:dokter_panggil/src/blocs/tindakan_create_bloc.dart';
import 'package:dokter_panggil/src/models/hubungan_fetch_model.dart';
import 'package:dokter_panggil/src/models/pegawai_dokter_model.dart';
import 'package:dokter_panggil/src/models/pendaftaran_kunjungan_nonkonsul_save_model.dart';
import 'package:dokter_panggil/src/models/tindakan_create_model.dart';
import 'package:dokter_panggil/src/pages/components/error_dialog.dart';
import 'package:dokter_panggil/src/pages/components/input_form.dart';
import 'package:dokter_panggil/src/pages/components/success_dialog.dart';
import 'package:dokter_panggil/src/pages/components/tambah_langsung_consume_widget.dart';
import 'package:dokter_panggil/src/source/transition/slide_bottom_route.dart';
import 'package:flutter/services.dart';
import 'package:dokter_panggil/src/source/transition/animated_dialog.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';

class PendaftaranLayananPage extends StatefulWidget {
  const PendaftaranLayananPage({
    super.key,
    required this.pasien,
  });

  final Pasien pasien;

  @override
  State<PendaftaranLayananPage> createState() => _PendaftaranLayananPageState();
}

class _PendaftaranLayananPageState extends State<PendaftaranLayananPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Pendaftaran Layanan'),
        foregroundColor: Colors.black,
        backgroundColor: Colors.white,
      ),
      body: FormPendaftaranLayanan(
        pasien: widget.pasien,
      ),
    );
  }
}

class FormPendaftaranLayanan extends StatefulWidget {
  const FormPendaftaranLayanan({
    super.key,
    required this.pasien,
  });

  final Pasien pasien;

  @override
  State<FormPendaftaranLayanan> createState() => _FormPendaftaranLayananState();
}

class _FormPendaftaranLayananState extends State<FormPendaftaranLayanan> {
  final _mrKunjunganPasienBloc = MrKunjunganPasienBloc();
  final _pendaftaranKunjunganNonkonsulSaveBloc =
      PendaftaranKunjunganNonkonsulSaveBloc();
  final _pendaftaranPembelianLangsungBloc = PendaftaranPembelianLangsungBloc();
  final animateIconPerawatCon = AnimateIconController();
  final _animateIconDokterCon = AnimateIconController();
  final _animateIconTindakanCon = AnimateIconController();
  final _tindakanCreateBloc = TindakanCreateBloc();
  final _hubunganFetchBloc = HubunganFetchBloc();
  final _dateFormat = DateFormat('yyyy-MM-dd');
  final _formKey = GlobalKey<FormState>();
  final _tanggalCon = TextEditingController();
  final _jamCon = TextEditingController();
  final _keluhanCon = TextEditingController();
  final _dokterCon = TextEditingController();
  final _perawatCon = TextEditingController();
  final _layananCon = TextEditingController();
  final _namaWali = TextEditingController();
  final _hubungan = TextEditingController();
  final _nomorWali = TextEditingController();
  final _paketCon = TextEditingController();
  final _tanda = TextEditingController();
  final _perawatFocus = FocusNode();
  final _dokterFocus = FocusNode();
  List<SelectedConsume> _selectedBhp = [];
  List<SelectedObatInjeksi> _selectedObatInjeksi = [];
  List<MasterTindakanLabAll> _selectedLab = [];
  DateTime _selectedDate = DateTime.now();
  TimeOfDay _selectedTime = TimeOfDay.now();
  int bayar = 0;
  String _jenisPendaftaran = 'konsul';
  bool _errorUnselected = false;
  int? _perawatKonsul;
  int? _selectedIdPaket;
  final List<String> _tokens = [];
  List<int> groupTindakan = [];
  int _isPerawat = 1;
  int _isDokter = 1;

  void _showPegawai(int id, String title) {
    if (title == 'Dokter') {
      _animateIconDokterCon.animateToEnd();
    } else {
      animateIconPerawatCon.animateToEnd();
    }
    showBarModalBottomSheet(
      context: context,
      builder: (context) {
        return PilihPetugasPage(
          idGroup: id,
        );
      },
      duration: const Duration(milliseconds: 500),
    ).then((value) {
      if (value != null) {
        var data = value as PegawaiProfesi;
        if (_layananCon.text.isEmpty) {
          //
        }
        if (title == 'Dokter') {
          _dokterCon.text = data.nama!;
          _mrKunjunganPasienBloc.dokterSink.add('${data.id}');
        } else {
          _perawatCon.text = data.nama!;
          _mrKunjunganPasienBloc.perawatSink.add('${data.id}');
          _perawatKonsul = data.id;
        }
        if (data.user?.tokenFcm != null) {
          _tokens.add('${data.user!.tokenFcm}');
        }
        setState(() {});
      } else {
        if (title == 'Dokter') {
          _animateIconDokterCon.animateToStart();
        } else {
          animateIconPerawatCon.animateToStart();
        }
      }
    });
  }

  void _showTimePicker() {
    showAnimatedDialog(
      context: context,
      builder: (context) {
        return Theme(
          data: ThemeData.light().copyWith(
            colorScheme: const ColorScheme.light(
              primary: kPrimaryColor,
            ),
          ),
          child: TimePickerDialog(
            initialTime: _selectedTime,
            helpText: 'Pilih jam kunjungan',
            cancelText: 'Batal',
            confirmText: 'Pilih',
            initialEntryMode: TimePickerEntryMode.input,
          ),
        );
      },
      animationType: DialogTransitionType.slideFromLeft,
      duration: const Duration(milliseconds: 500),
    ).then(
      (value) {
        if (value != null) {
          var picked = value as TimeOfDay;
          if (!mounted) return;
          _jamCon.text = picked.format(context);
          setState(() {
            _selectedTime = picked;
          });
        }
      },
    );
  }

  void _showDatePicker() {
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
            firstDate: DateTime.now().subtract(const Duration(days: 365)),
            lastDate: DateTime.now().add(
              const Duration(days: 365),
            ),
            helpText: 'Pilih tanggal pendaftaran',
            cancelText: 'Batal',
            confirmText: 'Pilih',
            fieldLabelText: 'Tanggal',
            fieldHintText: 'Tanggal/Bulan/Tahun',
          ),
        );
      },
      animationType: DialogTransitionType.slideFromLeft,
      duration: const Duration(milliseconds: 500),
    ).then((value) {
      if (value != null) {
        var date = value as DateTime;
        _tanggalCon.text = _dateFormat.format(date);
        setState(() {
          _selectedDate = date;
        });
      }
    });
  }

  void _showLayanan() {
    _animateIconTindakanCon.animateToEnd();
    _tindakanCreateBloc.tindakanCreate();
    showBarModalBottomSheet(
      context: context,
      builder: (context) {
        return Padding(
          padding: EdgeInsets.only(
              top: 28.0, bottom: MediaQuery.of(context).viewInsets.bottom + 28),
          child: const MasterLayananWidget(),
        );
      },
    ).then((value) {
      _animateIconTindakanCon.animateToStart();
      if (value != null) {
        var data = value as MasterLayanan;
        _dokterCon.clear();
        _formKey.currentState!.reset();
        _layananCon.text = data.namaLayanan!;
        List<TindakanRequest> tindakan = [
          TindakanRequest(
            idTindakan: data.tindakanLayanan!.id!,
            jasaDokter: data.tindakanLayanan!.jasaDokter!,
            jasaDrp: data.tindakanLayanan!.jasaDokterPanggil!,
            total: data.tindakanLayanan!.tarif!,
          ),
        ];
        _mrKunjunganPasienBloc.tindakanSink.add(tindakan);
        setState(() {
          bayar = data.isBayarLangsung!;
          _isDokter = data.isDokter!;
          _isPerawat = data.isPerawat!;
        });

        _mrKunjunganPasienBloc.layananSink.add(data.id!);
      }
    });
  }

  void _hubunganPasien() {
    _hubunganFetchBloc.fetchHubungan();
    showBarModalBottomSheet(
      context: context,
      builder: (context) {
        return Padding(
          padding: const EdgeInsets.symmetric(vertical: 28.0),
          child: _buildStreamHubunganPasien(),
        );
      },
    ).then((value) {
      if (value != null) {
        var data = value as Hubungan;
        _hubungan.text = data.hubungan!;
        _mrKunjunganPasienBloc.hubunganSink.add(data.id.toString());
      }
    });
  }

  bool validateAndSave() {
    var formState = _formKey.currentState;
    if (formState!.validate()) {
      formState.save();
      return true;
    }
    return false;
  }

  void _saveKunjungan() {
    if (validateAndSave()) {
      _mrKunjunganPasienBloc.normSink.add(widget.pasien.norm!);
      _mrKunjunganPasienBloc.tanggalSink.add(_tanggalCon.text);
      _mrKunjunganPasienBloc.jamSink.add(_jamCon.text);
      _mrKunjunganPasienBloc.keluhanSink.add(_keluhanCon.text);
      _mrKunjunganPasienBloc.namaWaliSink.add(_namaWali.text);
      _mrKunjunganPasienBloc.nomorWaliSink.add(_nomorWali.text);
      _mrKunjunganPasienBloc.tokensSink.add(_tokens);
      if (bayar == 1) {
        _mrKunjunganPasienBloc.statusSink.add(4);
      }
      _mrKunjunganPasienBloc.simpanKunjungan();
      _showStreamSave();
    }
  }

  void _saveKunjunganNonKonsul() {
    if (_selectedLab.isNotEmpty) {
      setState(() {
        _errorUnselected = false;
      });
    } else {
      setState(() {
        _errorUnselected = true;
      });
      return;
    }
    if (validateAndSave()) {
      SystemChannels.textInput.invokeMethod('TextInput.hide');
      FocusScope.of(context).unfocus();
      List<int> tindakanLab = [];
      List<int> hargaModal = [];
      List<int> tarifAplikasi = [];
      _selectedLab.asMap().forEach((key, value) {
        tindakanLab.add(value.id!);
        hargaModal.add(value.hargaModal!);
        tarifAplikasi.add(value.tarifAplikasi!);
      });
      _pendaftaranKunjunganNonkonsulSaveBloc.normSink.add(widget.pasien.norm!);
      _pendaftaranKunjunganNonkonsulSaveBloc.tanggalSink.add(_tanggalCon.text);
      _pendaftaranKunjunganNonkonsulSaveBloc.jamSink.add(_jamCon.text);
      _pendaftaranKunjunganNonkonsulSaveBloc.tindakanLabSink.add(tindakanLab);
      _pendaftaranKunjunganNonkonsulSaveBloc.hargaModalSink.add(hargaModal);
      _pendaftaranKunjunganNonkonsulSaveBloc.tarifAplikasiSink
          .add(tarifAplikasi);
      _pendaftaranKunjunganNonkonsulSaveBloc.perawatSink.add(_perawatKonsul!);
      _pendaftaranKunjunganNonkonsulSaveBloc.statusSink.add(2);
      _pendaftaranKunjunganNonkonsulSaveBloc.tokensSink.add(_tokens);
      _pendaftaranKunjunganNonkonsulSaveBloc.saveKunjunganNonkonsul();
      _showStreamNonKonsulSave();
    }
  }

  void _savePembelianLangsung() {
    if (_selectedBhp.isNotEmpty || _selectedObatInjeksi.isNotEmpty) {
      List<int> drugs = [];
      List<int> consumes = [];
      List<int> jumlahDrugs = [];
      List<int> jumlahConsumes = [];
      List<int> hargaModaldrugs = [];
      List<int> hargaModalConsumes = [];
      List<int> tarifAplikasidrugs = [];
      List<int> tarifAplikasiConsumes = [];
      List<String> aturan = [];
      List<String> catatan = [];
      _selectedObatInjeksi.asMap().forEach((key, drug) {
        drugs.add(drug.id!);
        jumlahDrugs.add(drug.jumlah);
        hargaModaldrugs.add(drug.hargaModal!);
        tarifAplikasidrugs.add(drug.tarifAplikasi!);
        aturan.add(drug.aturan);
        catatan.add(drug.catatan);
      });
      _selectedBhp.asMap().forEach((key, consume) {
        consumes.add(consume.id!);
        jumlahConsumes.add(consume.jumlah);
        hargaModalConsumes.add(consume.hargaModal!);
        tarifAplikasiConsumes.add(consume.tarifAplikasi!);
      });
      _pendaftaranPembelianLangsungBloc.normSink.add(widget.pasien.norm!);
      _pendaftaranPembelianLangsungBloc.tanggalSink.add(_tanggalCon.text);
      _pendaftaranPembelianLangsungBloc.jamSink.add(_jamCon.text);
      _pendaftaranPembelianLangsungBloc.drugsSink.add(drugs);
      _pendaftaranPembelianLangsungBloc.consumesSink.add(consumes);
      _pendaftaranPembelianLangsungBloc.jumlahDrugsSink.add(jumlahDrugs);
      _pendaftaranPembelianLangsungBloc.jumlahConsumesSink.add(jumlahConsumes);
      _pendaftaranPembelianLangsungBloc.hargaModalDrugsSink
          .add(hargaModaldrugs);
      _pendaftaranPembelianLangsungBloc.hargaModalConsumesSink
          .add(hargaModalConsumes);
      _pendaftaranPembelianLangsungBloc.tarifAplikasiDrugsSink
          .add(tarifAplikasidrugs);
      _pendaftaranPembelianLangsungBloc.tarifAplikasiConsumesSink
          .add(tarifAplikasiConsumes);
      _pendaftaranPembelianLangsungBloc.catatanSink.add(catatan);
      _pendaftaranPembelianLangsungBloc.aturanSink.add(aturan);
      _pendaftaranPembelianLangsungBloc.savePembelianLangsung();
      _showStreamPembelianLangsungSave();
      return;
    }
    Fluttertoast.showToast(
      msg: 'Silahkan milih barang terlebih dahulu',
      toastLength: Toast.LENGTH_LONG,
      backgroundColor: Colors.red,
      textColor: Colors.white,
    );
  }

  void _savePaket() {
    if (_paketCon.text.isNotEmpty) {
      _mrKunjunganPasienBloc.normSink.add(widget.pasien.norm!);
      _mrKunjunganPasienBloc.tanggalSink.add(_tanggalCon.text);
      _mrKunjunganPasienBloc.jamSink.add(_jamCon.text);
      _mrKunjunganPasienBloc.idPaketSink.add(_selectedIdPaket!);
      _mrKunjunganPasienBloc.tokensSink.add(_tokens);
      _mrKunjunganPasienBloc.keluhanSink.add(_keluhanCon.text);
      _mrKunjunganPasienBloc.simpanKunjunganPaket();
      _showStreamSave();
    } else {
      Fluttertoast.showToast(
          msg: 'Anda belum memilih paket pemeriksaan',
          toastLength: Toast.LENGTH_LONG,
          backgroundColor: Colors.red);
    }
  }

  void _showStreamSave() {
    showAnimatedDialog(
      context: context,
      builder: (context) {
        return _buildStreamSaveKunjungan();
      },
      animationType: DialogTransitionType.slideFromBottomFade,
      duration: const Duration(milliseconds: 500),
    ).then(
      (value) {
        if (value != null) {
          if (!mounted) return;
          Navigator.pop(context, 'reload');
        }
      },
    );
  }

  void _showStreamPembelianLangsungSave() {
    showAnimatedDialog(
      context: context,
      builder: (context) {
        return _buildStreamSavePembelianLangsung();
      },
      animationType: DialogTransitionType.slideFromBottomFade,
      duration: const Duration(milliseconds: 500),
    ).then(
      (value) {
        if (value != null) {
          if (!mounted) return;
          Navigator.pop(context, 'reload');
        }
      },
    );
  }

  void _showStreamNonKonsulSave() {
    showAnimatedDialog(
      context: (context),
      builder: (context) {
        return _streamNonKonsulSave(context);
      },
      duration: const Duration(milliseconds: 500),
      animationType: DialogTransitionType.slideFromBottomFade,
    ).then((value) {
      if (value != null) {
        if (!mounted) return;
        Navigator.pop(context, 'reload');
      }
    });
  }

  void _selectBhp(int category) {
    if (category == 2) {
      Navigator.push(
        context,
        SlideBottomRoute(
          page: TambahLangsungDrugsWidget(
            selectedData: _selectedObatInjeksi,
          ),
        ),
      ).then((value) {
        var data = value as List<SelectedObatInjeksi>;
        setState(() {
          _selectedObatInjeksi = data;
        });
      });
    } else if (category == 4) {
      Navigator.push(
        context,
        SlideBottomRoute(
          page: TambahLangsungConsume(
            selectedData: _selectedBhp,
          ),
        ),
      ).then((value) {
        var data = value as List<SelectedConsume>;
        setState(() {
          _selectedBhp = data;
        });
      });
    } else {
      Fluttertoast.showToast(msg: 'Kategori pilihan tidak tersedia');
    }
  }

  void _selectTindakanLab() {
    showBarModalBottomSheet(
      context: context,
      builder: (context) {
        return Padding(
          padding:
              EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
          child: Container(
            constraints: BoxConstraints(
              minHeight: SizeConfig.blockSizeVertical * 30,
              maxHeight: SizeConfig.blockSizeVertical * 80,
            ),
            child: ListTindakanLabNonkonsulWidget(
              selectedData: _selectedLab,
            ),
          ),
        );
      },
      duration: const Duration(milliseconds: 500),
    ).then((value) {
      if (value != null) {
        var data = value as List<MasterTindakanLabAll>;
        _selectedLab = data;
      }
      setState(() {
        _errorUnselected = false;
      });
    });
  }

  void _deleteSelected(int id) {
    setState(() {
      _selectedLab.removeWhere((e) => e.id == id);
    });
  }

  void _selectJenisPendaftaran() {
    showMaterialModalBottomSheet(
      context: context,
      builder: (context) {
        return SafeArea(top: false, child: _jenisPendaftaranWidget(context));
      },
      duration: const Duration(milliseconds: 500),
    ).then((value) {
      if (value != null) {
        var jenis = value as String;
        _tokens.clear();
        setState(() {
          _jenisPendaftaran = jenis;
        });
      }
    });
  }

  void _showPaket() {
    showBarModalBottomSheet(
      context: context,
      builder: (context) {
        return ListPaketWidget(
          selectedId: _selectedIdPaket,
        );
      },
      duration: const Duration(milliseconds: 500),
    ).then((value) {
      if (value != null) {
        var data = value as SelectedPaketModel;
        setState(() {
          _selectedIdPaket = data.id;
          _paketCon.text = data.namaPaket!;
        });
      }
    });
  }

  @override
  void dispose() {
    _tanggalCon.dispose();
    _jamCon.dispose();
    _keluhanCon.dispose();
    _dokterCon.dispose();
    _perawatCon.dispose();
    _layananCon.dispose();
    _namaWali.dispose();
    _hubungan.dispose();
    _nomorWali.dispose();
    _mrKunjunganPasienBloc.dispose();
    _tindakanCreateBloc.dispose();
    _hubunganFetchBloc.dispose();
    _paketCon.dispose();
    _pendaftaranKunjunganNonkonsulSaveBloc.dispose();
    _pendaftaranPembelianLangsungBloc.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return Form(
      key: _formKey,
      child: Column(
        children: [
          Expanded(
            child: ListView(
              padding:
                  const EdgeInsets.symmetric(horizontal: 22.0, vertical: 32.0),
              children: [
                const Text(
                  'Pendaftaran Pasien',
                  style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.w600),
                ),
                const SizedBox(
                  height: 8.0,
                ),
                const Divider(),
                const SizedBox(
                  height: 15.0,
                ),
                Row(
                  children: [
                    Expanded(
                      flex: 3,
                      child: Input(
                        controller: _tanggalCon
                          ..text = _dateFormat.format(_selectedDate),
                        label: 'Tanggal',
                        hint: 'Tanggal pendaftaran layanan pasien',
                        maxLines: 1,
                        readOnly: true,
                        validator: (val) {
                          if (val!.isEmpty) {
                            return 'Input required';
                          }
                          return null;
                        },
                        onTap: _showDatePicker,
                      ),
                    ),
                    const SizedBox(
                      width: 12.0,
                    ),
                    Expanded(
                      flex: 2,
                      child: Input(
                        controller: _jamCon
                          ..text = _selectedTime.format(context),
                        label: 'Jam',
                        hint: 'Jam pendaftaran',
                        maxLines: 1,
                        readOnly: true,
                        validator: (val) {
                          if (val!.isEmpty) {
                            return 'Input required';
                          }
                          return null;
                        },
                        onTap: _showTimePicker,
                      ),
                    )
                  ],
                ),
                const SizedBox(
                  height: 22.0,
                ),
                const Text(
                  'Jenis pendaftaran',
                  style: TextStyle(fontWeight: FontWeight.w600),
                ),
                const SizedBox(
                  height: 12.0,
                ),
                Container(
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey, width: 0.5),
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                  child: ListTile(
                    onTap: _selectJenisPendaftaran,
                    title: Text(_jenisPendaftaran.toUpperCase()),
                    trailing: const Icon(Icons.keyboard_arrow_right),
                  ),
                ),
                const SizedBox(
                  height: 22.0,
                ),
                if (_jenisPendaftaran == 'konsul')
                  _formInputKonsulWidget(context)
                else if (_jenisPendaftaran == 'pembelian-langsung')
                  _formInputPembelianLangsung(context)
                else if (_jenisPendaftaran == 'paket')
                  _formInputPaket(context)
                else if (_jenisPendaftaran == 'non-konsul')
                  _formInputNonKonsulWidget(context)
                else
                  const SizedBox(),
              ],
            ),
          ),
          _buttonDaftarLayanan(context)
        ],
      ),
    );
  }

  Widget _formInputPaket(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Input(
          controller: _layananCon,
          label: 'Layanan',
          hint: 'Pilih layanan',
          maxLines: 1,
          readOnly: true,
          validator: (val) {
            if (val!.isEmpty) {
              return 'Input required';
            }
            return null;
          },
          onTap: _showLayanan,
          suffixIcon: _layananCon.text.isNotEmpty
              ? IconButton(
                  onPressed: () {
                    _layananCon.clear();
                    setState(() {
                      bayar = 0;
                    });
                  },
                  color: Colors.red[300],
                  icon: const Icon(Icons.cancel),
                )
              : AnimateIcons(
                  startIcon: Icons.add_circle_outline,
                  endIcon: Icons.add_circle_outline,
                  endIconColor: Colors.grey,
                  startIconColor: Colors.grey,
                  onStartIconPress: () {
                    return true;
                  },
                  onEndIconPress: () {
                    return true;
                  },
                  controller: _animateIconTindakanCon,
                ),
        ),
        if (bayar == 1)
          const Padding(
            padding: EdgeInsets.only(top: 4.0),
            child: Text(
              'Layanan ini membutuhkan pembayaran diawal',
              style: TextStyle(color: Colors.red, fontSize: 13.0),
            ),
          ),
        if (_isDokter == 1)
          Padding(
            padding: const EdgeInsets.only(bottom: 22, top: 22),
            child: Input(
              controller: _dokterCon,
              label: 'Dokter',
              hint: 'Pilih dokter',
              maxLines: 1,
              readOnly: true,
              onTap: () => _showPegawai(1, 'Dokter'),
              suffixIcon: _dokterCon.text.isNotEmpty
                  ? IconButton(
                      onPressed: () {
                        _dokterCon.clear();
                        _mrKunjunganPasienBloc.dokterSink.add('');
                        setState(() {});
                      },
                      color: Colors.red[300],
                      icon: const Icon(Icons.cancel_outlined),
                    )
                  : AnimateIcons(
                      startIcon: Icons.add_circle_outline,
                      endIcon: Icons.add_circle_outline,
                      endIconColor: Colors.grey,
                      startIconColor: Colors.grey,
                      onStartIconPress: () {
                        return true;
                      },
                      onEndIconPress: () {
                        return true;
                      },
                      controller: _animateIconDokterCon,
                    ),
            ),
          ),
        if (_isPerawat == 1)
          Padding(
            padding: const EdgeInsets.only(bottom: 22.0),
            child: Input(
              controller: _perawatCon,
              label: 'Perawat',
              hint: 'Pilih perawat',
              maxLines: 1,
              readOnly: true,
              onTap: () => _showPegawai(2, 'Perawat'),
              suffixIcon: _perawatCon.text.isNotEmpty
                  ? IconButton(
                      onPressed: () {
                        _perawatCon.clear();
                        _mrKunjunganPasienBloc.perawatSink.add('');
                        setState(() {});
                      },
                      color: Colors.red[300],
                      icon: const Icon(Icons.cancel_outlined),
                    )
                  : AnimateIcons(
                      startIcon: Icons.add_circle_outline,
                      endIcon: Icons.add_circle_outline,
                      endIconColor: Colors.grey,
                      startIconColor: Colors.grey,
                      onStartIconPress: () {
                        return true;
                      },
                      onEndIconPress: () {
                        return true;
                      },
                      controller: animateIconPerawatCon,
                    ),
            ),
          ),
        Input(
          controller: _paketCon,
          label: 'Paket',
          hint: 'Pilih paket',
          maxLines: 1,
          readOnly: true,
          onTap: _showPaket,
          validator: (value) {
            if (value!.isEmpty) {
              return 'Input required';
            }
            return null;
          },
          suffixIcon: _paketCon.text.isNotEmpty
              ? IconButton(
                  onPressed: () {
                    _paketCon.clear();
                    _mrKunjunganPasienBloc.perawatSink.add('');
                    _selectedIdPaket = null;
                    setState(() {});
                  },
                  color: Colors.red[300],
                  icon: const Icon(Icons.cancel_outlined),
                )
              : const Icon(
                  Icons.add_circle_outline,
                  color: Colors.grey,
                ),
        ),
        const SizedBox(
          height: 22,
        ),
        const Divider(),
        const ListTile(
          contentPadding: EdgeInsets.zero,
          title: Text(
            'Skrining Pasien',
            style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.w600),
          ),
        ),
        const Divider(),
        const SizedBox(
          height: 12,
        ),
        Input(
          controller: _keluhanCon,
          label: 'Keluhan',
          hint: 'Keluhan masuk pasien',
          maxLines: 1,
          textCap: TextCapitalization.words,
          textInputAction: TextInputAction.next,
          validator: (value) {
            if (value!.isEmpty) {
              return 'Input required';
            }
            return null;
          },
        ),
        const SizedBox(
          height: 22.0,
        ),
        Input(
          controller: _tanda,
          label: 'Tanda & Gejala',
          hint: 'Pilih tanda dan gejala masuk pasien',
          maxLines: 1,
          readOnly: true,
          onTap: () {
            showBarModalBottomSheet(
              context: context,
              builder: (context) => const FormSkriningWidget(),
            ).then((value) {
              if (value != null) {
                var data = value as MasterSkrining;
                _mrKunjunganPasienBloc.skriningSink.add(data.id!);
                setState(() {
                  _tanda.text = '${data.skrining}';
                });
              }
            });
          },
          suffixIcon: AnimateIcons(
            startIcon: Icons.add_circle_outline,
            endIcon: Icons.add_circle_outline,
            endIconColor: Colors.grey,
            startIconColor: Colors.grey,
            onStartIconPress: () {
              return true;
            },
            onEndIconPress: () {
              return true;
            },
            controller: _animateIconTindakanCon,
          ),
        ),
        const SizedBox(
          height: 22,
        ),
        const Text(
          'Resiko Jatuh',
          style: TextStyle(fontWeight: FontWeight.w600),
        ),
        FormField(
          onSaved: (val) {
            if (val != null) {
              _mrKunjunganPasienBloc.resikoJatuh.add('$val');
              _mrKunjunganPasienBloc.keputusanResikoJatuhSink
                  .add('Kursi Roda/Antrian Khusus');
            }
          },
          builder: (state) => Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              RadioListTile(
                value: 'Tidak beresiko',
                groupValue: state.value,
                title: const Text('Tidak Beresiko'),
                contentPadding: EdgeInsets.zero,
                onChanged: (newValue) {
                  state.didChange(newValue);
                  _mrKunjunganPasienBloc.resikoJatuh.add('');
                  _mrKunjunganPasienBloc.keputusanResikoJatuhSink.add('');
                },
              ),
              RadioListTile(
                value: 'Menggunakan Alat Bantu',
                groupValue: state.value,
                title: const Text('Menggunakan Alat Bantu'),
                contentPadding: EdgeInsets.zero,
                onChanged: (newValue) {
                  state.didChange(newValue);
                },
              ),
              RadioListTile(
                value: 'Gangguan Saat Jalan',
                groupValue: state.value,
                title: const Text('Gangguan Saat Jalan'),
                contentPadding: EdgeInsets.zero,
                onChanged: (newValue) {
                  state.didChange(newValue);
                },
              ),
              RadioListTile(
                value: 'Menggunakan Penutup Mata (Salah Satu/Keduanya)',
                groupValue: state.value,
                title: const Text(
                    'Menggunakan Penutup Mata (Salah Satu/Keduanya)'),
                contentPadding: EdgeInsets.zero,
                onChanged: (newValue) {
                  state.didChange(newValue);
                },
              )
            ],
          ),
        ),
      ],
    );
  }

  Widget _formInputKonsulWidget(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Input(
          controller: _layananCon,
          label: 'Layanan',
          hint: 'Pilih layanan',
          maxLines: 1,
          readOnly: true,
          validator: (val) {
            if (val!.isEmpty) {
              return 'Input required';
            }
            return null;
          },
          onTap: _showLayanan,
          suffixIcon: _layananCon.text.isNotEmpty
              ? IconButton(
                  onPressed: () {
                    _layananCon.clear();
                    setState(() {
                      bayar = 0;
                    });
                  },
                  color: Colors.red[300],
                  icon: const Icon(Icons.cancel),
                )
              : AnimateIcons(
                  startIcon: Icons.add_circle_outline,
                  endIcon: Icons.add_circle_outline,
                  endIconColor: Colors.grey,
                  startIconColor: Colors.grey,
                  onStartIconPress: () {
                    return true;
                  },
                  onEndIconPress: () {
                    return true;
                  },
                  controller: _animateIconTindakanCon,
                ),
        ),
        if (bayar == 1)
          const Padding(
            padding: EdgeInsets.only(top: 4.0),
            child: Text(
              'Layanan ini membutuhkan pembayaran diawal',
              style: TextStyle(color: Colors.red, fontSize: 13.0),
            ),
          ),
        const SizedBox(
          height: 22.0,
        ),
        if (_isDokter == 1)
          Input(
            focusNode: _dokterFocus,
            controller: _dokterCon,
            label: 'Dokter',
            hint: 'Pilih dokter',
            maxLines: 1,
            readOnly: true,
            onTap: () => _showPegawai(1, 'Dokter'),
            validator: (value) {
              if (value!.isEmpty && groupTindakan.contains(1)) {
                return 'Input required';
              }
              return null;
            },
            suffixIcon: _dokterCon.text.isNotEmpty
                ? IconButton(
                    onPressed: () {
                      _dokterCon.clear();
                      _mrKunjunganPasienBloc.dokterSink.add('');
                      setState(() {});
                    },
                    color: Colors.red[300],
                    icon: const Icon(Icons.cancel),
                  )
                : AnimateIcons(
                    startIcon: Icons.add_circle_outline,
                    endIcon: Icons.add_circle_outline,
                    endIconColor: Colors.grey,
                    startIconColor: Colors.grey,
                    onStartIconPress: () {
                      return true;
                    },
                    onEndIconPress: () {
                      return true;
                    },
                    controller: _animateIconDokterCon,
                  ),
          ),
        if (_isDokter == 1)
          const SizedBox(
            height: 22.0,
          ),
        if (_isPerawat == 1)
          Input(
            focusNode: _perawatFocus,
            controller: _perawatCon,
            label: 'Perawat',
            hint: 'Pilih perawat',
            maxLines: 1,
            readOnly: true,
            onTap: () => _showPegawai(2, 'Perawat'),
            validator: (value) {
              if (value!.isEmpty && groupTindakan.contains(2)) {
                return 'Input required';
              }
              return null;
            },
            suffixIcon: _perawatCon.text.isNotEmpty
                ? IconButton(
                    onPressed: () {
                      _perawatCon.clear();
                      _mrKunjunganPasienBloc.perawatSink.add('');
                      setState(() {});
                    },
                    color: Colors.red[300],
                    icon: const Icon(Icons.cancel_outlined),
                  )
                : AnimateIcons(
                    startIcon: Icons.add_circle_outline,
                    endIcon: Icons.add_circle_outline,
                    endIconColor: Colors.grey,
                    startIconColor: Colors.grey,
                    onStartIconPress: () {
                      return true;
                    },
                    onEndIconPress: () {
                      return true;
                    },
                    controller: animateIconPerawatCon,
                  ),
          ),
        if (_isPerawat == 1)
          const SizedBox(
            height: 22,
          ),
        const Divider(),
        const ListTile(
          contentPadding: EdgeInsets.zero,
          title: Text(
            'Skrining Pasien',
            style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.w600),
          ),
        ),
        const Divider(),
        const SizedBox(
          height: 12,
        ),
        Input(
          controller: _keluhanCon,
          label: 'Keluhan',
          hint: 'Keluhan masuk pasien',
          maxLines: 1,
          textCap: TextCapitalization.words,
          textInputAction: TextInputAction.next,
          validator: (value) {
            if (value!.isEmpty) {
              return 'Input required';
            }
            return null;
          },
        ),
        const SizedBox(
          height: 22.0,
        ),
        Input(
          controller: _tanda,
          label: 'Tanda & Gejala',
          hint: 'Pilih tanda dan gejala masuk pasien',
          maxLines: 1,
          readOnly: true,
          onTap: () {
            showBarModalBottomSheet(
              context: context,
              builder: (context) => const FormSkriningWidget(),
            ).then((value) {
              if (value != null) {
                var data = value as MasterSkrining;
                _mrKunjunganPasienBloc.skriningSink.add(data.id!);
                setState(() {
                  _tanda.text = '${data.skrining}';
                });
              }
            });
          },
          suffixIcon: AnimateIcons(
            startIcon: Icons.add_circle_outline,
            endIcon: Icons.add_circle_outline,
            endIconColor: Colors.grey,
            startIconColor: Colors.grey,
            onStartIconPress: () {
              return true;
            },
            onEndIconPress: () {
              return true;
            },
            controller: _animateIconTindakanCon,
          ),
        ),
        const SizedBox(
          height: 22,
        ),
        const Text(
          'Resiko Jatuh',
          style: TextStyle(fontWeight: FontWeight.w600),
        ),
        FormField(
          onSaved: (val) {
            if (val != null) {
              _mrKunjunganPasienBloc.resikoJatuh.add('$val');
              _mrKunjunganPasienBloc.keputusanResikoJatuhSink
                  .add('Kursi Roda/Antrian Khusus');
            }
          },
          builder: (state) => Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              RadioListTile(
                value: 'Tidak beresiko',
                groupValue: state.value,
                title: const Text('Tidak Beresiko'),
                contentPadding: EdgeInsets.zero,
                onChanged: (newValue) {
                  state.didChange(newValue);
                  _mrKunjunganPasienBloc.resikoJatuh.add('');
                  _mrKunjunganPasienBloc.keputusanResikoJatuhSink.add('');
                },
              ),
              RadioListTile(
                value: 'Menggunakan Alat Bantu',
                groupValue: state.value,
                title: const Text('Menggunakan Alat Bantu'),
                contentPadding: EdgeInsets.zero,
                onChanged: (newValue) {
                  state.didChange(newValue);
                },
              ),
              RadioListTile(
                value: 'Gangguan Saat Jalan',
                groupValue: state.value,
                title: const Text('Gangguan Saat Jalan'),
                contentPadding: EdgeInsets.zero,
                onChanged: (newValue) {
                  state.didChange(newValue);
                },
              ),
              RadioListTile(
                value: 'Menggunakan Penutup Mata (Salah Satu/Keduanya)',
                groupValue: state.value,
                title: const Text(
                    'Menggunakan Penutup Mata (Salah Satu/Keduanya)'),
                contentPadding: EdgeInsets.zero,
                onChanged: (newValue) {
                  state.didChange(newValue);
                },
              )
            ],
          ),
        ),
        const SizedBox(
          height: 22.0,
        ),
        const Divider(),
        const ListTile(
          contentPadding: EdgeInsets.zero,
          title: Text(
            'Identitas Wali Pasien',
            style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.w600),
          ),
          subtitle: Text('*)Diisi apabila ada'),
        ),
        const Divider(
          height: 0,
        ),
        const SizedBox(
          height: 22.0,
        ),
        Input(
          controller: _namaWali,
          label: 'Nama',
          hint: 'Nama wali pasien',
          maxLines: 1,
          textCap: TextCapitalization.words,
          textInputAction: TextInputAction.next,
        ),
        const SizedBox(
          height: 22.0,
        ),
        Input(
          controller: _hubungan,
          label: 'Hubungan',
          hint: 'Hubungan wali dengan pasien',
          maxLines: 1,
          readOnly: true,
          onTap: _hubunganPasien,
        ),
        const SizedBox(
          height: 22.0,
        ),
        Input(
          controller: _nomorWali,
          label: 'Nomor Hp',
          hint: 'Nomor hp wali pasien',
          maxLines: 1,
          keyType: TextInputType.number,
          textInputAction: TextInputAction.done,
        ),
      ],
    );
  }

  Widget _buildStreamHubunganPasien() {
    return StreamBuilder<ApiResponse<HubunganFetchModel>>(
      stream: _hubunganFetchBloc.hubunganFetchStream,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          switch (snapshot.data!.status) {
            case Status.loading:
              return const SizedBox(
                height: 150,
                child: Center(
                  child: LoadingKit(
                    color: kPrimaryColor,
                  ),
                ),
              );
            case Status.error:
              return SizedBox(
                height: 150,
                child: Center(
                  child: ErrorResponse(
                    message: snapshot.data!.message,
                    onTap: () {
                      _tindakanCreateBloc.tindakanCreate();
                      setState(() {});
                    },
                  ),
                ),
              );
            case Status.completed:
              return Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 22.0),
                    child: Text(
                      'Pilih Hubungan Wali',
                      style: TextStyle(
                          fontSize: 18.0, fontWeight: FontWeight.w600),
                    ),
                  ),
                  const SizedBox(
                    height: 22.0,
                  ),
                  Container(
                    constraints: BoxConstraints(
                      maxHeight: SizeConfig.blockSizeVertical * 50,
                    ),
                    child: ListView.separated(
                      padding: const EdgeInsets.symmetric(horizontal: 22.0),
                      shrinkWrap: true,
                      itemBuilder: (context, i) {
                        var data = snapshot.data!.data!.hubungan![i];
                        return ListTile(
                          onTap: () => Navigator.pop(context, data),
                          contentPadding: EdgeInsets.zero,
                          title: Text('${data.hubungan}'),
                        );
                      },
                      separatorBuilder: (context, i) => const Divider(
                        height: 0,
                      ),
                      itemCount: snapshot.data!.data!.hubungan!.length,
                    ),
                  ),
                ],
              );
          }
        }

        return const SizedBox();
      },
    );
  }

  Widget _buildStreamSaveKunjungan() {
    return StreamBuilder<ApiResponse<MrKunjunganPasienModel>>(
      stream: _mrKunjunganPasienBloc.kunjunganPasienStream,
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

  Widget _buildStreamSavePembelianLangsung() {
    return StreamBuilder<
        ApiResponse<ResponsePendaftaranPembelianLangsungSaveModel>>(
      stream: _pendaftaranPembelianLangsungBloc.pembelianLansungStream,
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

  Widget _streamNonKonsulSave(BuildContext context) {
    return StreamBuilder<
        ApiResponse<ResponsePendaftaranKunjunganNonkonsulSaveModel>>(
      stream: _pendaftaranKunjunganNonkonsulSaveBloc.kunjunganNonkonsulStream,
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

  Widget _formInputNonKonsulWidget(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(
          height: 12.0,
        ),
        Input(
          controller: _perawatCon,
          label: 'Perawat',
          hint: 'Pilih perawat',
          maxLines: 1,
          readOnly: true,
          onTap: () => _showPegawai(2, 'Perawat'),
          suffixIcon: AnimateIcons(
            startIcon: Icons.add_circle_outline,
            endIcon: Icons.cancel_outlined,
            endIconColor: Colors.grey,
            startIconColor: Colors.grey,
            onStartIconPress: () {
              _showPegawai(2, 'Perawat');
              return true;
            },
            onEndIconPress: () {
              _perawatCon.clear();
              _mrKunjunganPasienBloc.perawatSink.add('');
              setState(() {});
              return true;
            },
            controller: animateIconPerawatCon,
          ),
          validator: (value) {
            if (value!.isEmpty) {
              return 'Input required';
            }
            return null;
          },
        ),
        const SizedBox(
          height: 12.0,
        ),
        _nonKonsulLabWidget(context),
      ],
    );
  }

  Widget _formInputPembelianLangsung(BuildContext context) {
    return Column(
      children: [
        NonKonsulWigdet(
          title: 'Obat Injeksi',
          buttonTitle: 'Tambah Barang',
          onTap: () => _selectBhp(2),
          listSelectedNonKonsul: _selectedObatInjeksi.isEmpty
              ? const Padding(
                  padding: EdgeInsets.all(18),
                  child: Center(
                    child: Text(
                      'Data tidak tersedia',
                      style: TextStyle(
                          fontStyle: FontStyle.italic, color: Colors.grey),
                    ),
                  ),
                )
              : Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12.0),
                    border: Border.all(color: Colors.grey, width: 0.5),
                  ),
                  child: Column(
                    children: ListTile.divideTiles(
                      context: context,
                      tiles: _selectedObatInjeksi
                          .map(
                            (drug) => ListTile(
                              dense: true,
                              minLeadingWidth: 0.0,
                              contentPadding: const EdgeInsets.symmetric(
                                  horizontal: 18.0, vertical: 4.0),
                              leading: Text(
                                  '${_selectedObatInjeksi.indexOf(drug) + 1}.'),
                              title: Text('${drug.barang}'),
                              subtitle: Text('Aturan: ${drug.aturan}'),
                              trailing: Text('${drug.jumlah} buah'),
                            ),
                          )
                          .toList(),
                    ).toList(),
                  ),
                ),
        ),
        NonKonsulWigdet(
          title: 'Consumable',
          buttonTitle: 'Tambah Barang',
          onTap: () => _selectBhp(4),
          listSelectedNonKonsul: _selectedBhp.isEmpty
              ? const Padding(
                  padding: EdgeInsets.all(18),
                  child: Center(
                      child: Text(
                    'Data tidak tersedia',
                    style: TextStyle(
                        fontStyle: FontStyle.italic, color: Colors.grey),
                  )),
                )
              : Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12.0),
                    border: Border.all(color: Colors.grey, width: 0.5),
                  ),
                  child: Column(
                    children: ListTile.divideTiles(
                      context: context,
                      tiles: _selectedBhp
                          .map(
                            (bhp) => ListTile(
                              dense: true,
                              minLeadingWidth: 0.0,
                              contentPadding: const EdgeInsets.symmetric(
                                  horizontal: 18.0, vertical: 4.0),
                              leading:
                                  Text('${_selectedBhp.indexOf(bhp) + 1}.'),
                              title: Text(bhp.barang!),
                              trailing: Text('${bhp.jumlah} buah'),
                            ),
                          )
                          .toList(),
                    ).toList(),
                  ),
                ),
        ),
      ],
    );
  }

  Widget _nonKonsulLabWidget(BuildContext context) {
    return NonKonsulWigdet(
      title: 'Tindakan Laboratorium',
      buttonTitle: 'Tambah Tindakan Laboratorium',
      onTap: _selectTindakanLab,
      error: _errorUnselected
          ? const Padding(
              padding: EdgeInsets.all(8.0),
              child: Text(
                'Pilih tindakan laboratorium',
                style: TextStyle(fontSize: 13.0, color: kPrimaryColor),
              ),
            )
          : null,
      listSelectedNonKonsul: Column(
        children: _selectedLab
            .map(
              (tindakanLab) => ListTile(
                dense: true,
                minLeadingWidth: 0.0,
                leading: Text('${_selectedLab.indexOf(tindakanLab) + 1}.'),
                title: Text('${tindakanLab.namaTindakanLab}'),
                trailing: CircleAvatar(
                  radius: 15.0,
                  backgroundColor: Colors.transparent,
                  child: IconButton(
                      onPressed: () => _deleteSelected(tindakanLab.id!),
                      padding: EdgeInsets.zero,
                      icon: const Icon(
                        Icons.delete,
                        color: Colors.red,
                      )),
                ),
              ),
            )
            .toList(),
      ),
    );
  }

  Widget _jenisPendaftaranWidget(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Padding(
          padding: EdgeInsets.all(22.0),
          child: Text(
            'Jenis Pendaftaran',
            style: TextStyle(fontWeight: FontWeight.w600, fontSize: 18.0),
          ),
        ),
        ListTile(
          onTap: () => Navigator.pop(context, 'konsul'),
          title: const Text('Konsul'),
          titleTextStyle: const TextStyle(
              fontWeight: FontWeight.normal,
              color: Colors.black,
              fontSize: 16.0),
          contentPadding: const EdgeInsets.symmetric(horizontal: 18.0),
          trailing: _jenisPendaftaran == 'konsul'
              ? const Icon(
                  Icons.check_box,
                  color: Colors.green,
                )
              : null,
        ),
        const Divider(
          height: 0,
        ),
        ListTile(
          onTap: () => Navigator.pop(context, 'non-konsul'),
          title: const Text('Non Konsul'),
          titleTextStyle: const TextStyle(
              fontWeight: FontWeight.normal,
              color: Colors.black,
              fontSize: 16.0),
          contentPadding: const EdgeInsets.symmetric(horizontal: 18.0),
          trailing: _jenisPendaftaran == 'non-konsul'
              ? const Icon(
                  Icons.check_box,
                  color: Colors.green,
                )
              : null,
        ),
        const Divider(
          height: 0,
        ),
        ListTile(
          onTap: () => Navigator.pop(context, 'pembelian-langsung'),
          title: const Text('Pembelian langsung'),
          titleTextStyle: const TextStyle(
              fontWeight: FontWeight.normal,
              color: Colors.black,
              fontSize: 16.0),
          contentPadding: const EdgeInsets.symmetric(horizontal: 18.0),
          trailing: _jenisPendaftaran == 'pembelian-langsung'
              ? const Icon(
                  Icons.check_box,
                  color: Colors.green,
                )
              : null,
        ),
        const Divider(
          height: 0,
        ),
        ListTile(
          onTap: () => Navigator.pop(context, 'paket'),
          title: const Text('Paket'),
          titleTextStyle: const TextStyle(
              fontWeight: FontWeight.normal,
              color: Colors.black,
              fontSize: 16.0),
          contentPadding: const EdgeInsets.symmetric(horizontal: 18.0),
          trailing: _jenisPendaftaran == 'paket'
              ? const Icon(
                  Icons.check_box,
                  color: Colors.green,
                )
              : null,
        )
      ],
    );
  }

  Widget _buttonDaftarLayanan(BuildContext context) {
    if (_jenisPendaftaran == 'konsul') {
      return Container(
        padding: EdgeInsets.all(22),
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.black12,
              blurRadius: 6.0,
              offset: Offset(-2.0, 1.0),
            )
          ],
        ),
        child: ButtonRoundedWidget(
          onPressed: _saveKunjungan,
          label: 'Daftar Layanan',
          backgroundColor: kPrimaryColor,
          foregroundColor: Colors.white,
        ),
      );
    } else if (_jenisPendaftaran == 'non-konsul') {
      return Container(
        padding: EdgeInsets.all(22),
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.black12,
              blurRadius: 6.0,
              offset: Offset(-2.0, 1.0),
            )
          ],
        ),
        child: ButtonRoundedWidget(
          onPressed: _saveKunjunganNonKonsul,
          label: 'Daftar Layanan',
          backgroundColor: kPrimaryColor,
          foregroundColor: Colors.white,
        ),
      );
    } else if (_jenisPendaftaran == 'pembelian-langsung') {
      return Container(
        padding: EdgeInsets.all(22),
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.black12,
              blurRadius: 6.0,
              offset: Offset(-2.0, 1.0),
            )
          ],
        ),
        child: ButtonRoundedWidget(
          onPressed: _savePembelianLangsung,
          label: 'Daftar Layanan',
          backgroundColor: kPrimaryColor,
          foregroundColor: Colors.white,
        ),
      );
    } else if (_jenisPendaftaran == 'paket') {
      return Container(
        padding: EdgeInsets.all(22),
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.black12,
              blurRadius: 6.0,
              offset: Offset(-2.0, 1.0),
            )
          ],
        ),
        child: ButtonRoundedWidget(
          onPressed: _savePaket,
          label: 'Daftar Layanan',
          backgroundColor: kPrimaryColor,
          foregroundColor: Colors.white,
        ),
      );
    }
    return Container();
  }
}

class ListTindakanWidget extends StatefulWidget {
  const ListTindakanWidget({
    super.key,
    required this.data,
  });

  final List<TindakanCreate> data;

  @override
  State<ListTindakanWidget> createState() => _ListTindakanWidgetState();
}

class _ListTindakanWidgetState extends State<ListTindakanWidget> {
  final _filter = TextEditingController();
  List<TindakanCreate> _data = [];
  @override
  void initState() {
    super.initState();
    _data = widget.data;
    _filter.addListener(_filterListen);
  }

  void _filterListen() {
    if (_filter.text.isEmpty) {
      _data = widget.data;
    } else {
      _data = widget.data
          .where((e) => e.namaTindakan!
              .toLowerCase()
              .contains(_filter.text.toLowerCase()))
          .toList();
    }
    setState(() {});
  }

  @override
  void dispose() {
    _filter.dispose();
    _filter.removeListener(_filterListen);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: BoxConstraints(maxHeight: SizeConfig.blockSizeVertical * 80),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 22.0),
            child: Text(
              'Pilih Layanan',
              style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.w600),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(22.0),
            child: SearchInputForm(
              hint: 'Pencarian nama tindakan',
              controller: _filter,
            ),
          ),
          Flexible(
            child: ListView.separated(
              padding:
                  const EdgeInsets.symmetric(horizontal: 22.0, vertical: 12.0),
              itemBuilder: (context, i) {
                var data = _data[i];
                return ListTile(
                  onTap: () => Navigator.pop(context, data),
                  contentPadding: EdgeInsets.zero,
                  title: Text('${data.namaTindakan}'),
                );
              },
              separatorBuilder: (context, i) => const Divider(
                height: 0,
              ),
              itemCount: _data.length,
            ),
          ),
        ],
      ),
    );
  }
}

class NonKonsulWigdet extends StatefulWidget {
  const NonKonsulWigdet({
    super.key,
    this.title,
    this.onTap,
    this.buttonTitle,
    this.listSelectedNonKonsul,
    this.error,
  });

  final String? title;
  final String? buttonTitle;
  final VoidCallback? onTap;
  final Widget? listSelectedNonKonsul;
  final Widget? error;

  @override
  State<NonKonsulWigdet> createState() => _NonKonsulWigdetState();
}

class _NonKonsulWigdetState extends State<NonKonsulWigdet> {
  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Divider(
          height: 22.0,
        ),
        const SizedBox(
          height: 12.0,
        ),
        Text(
          '${widget.title}',
          style: const TextStyle(fontWeight: FontWeight.w600),
        ),
        const SizedBox(
          height: 12.0,
        ),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 10),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8.0),
            border: Border.all(color: Colors.grey, width: 0.5),
          ),
          child: InkWell(
            onTap: widget.onTap,
            child: Row(
              children: [
                const Icon(
                  Icons.add_rounded,
                  size: 25.0,
                  color: kPrimaryColor,
                ),
                const SizedBox(
                  width: 12.0,
                ),
                Expanded(
                  child: Text(
                    '${widget.buttonTitle}',
                    style: const TextStyle(color: kPrimaryColor),
                  ),
                ),
                const Icon(
                  Icons.keyboard_arrow_right_rounded,
                  size: 25,
                  color: Colors.grey,
                ),
              ],
            ),
          ),
        ),
        widget.error ?? const SizedBox(),
        const SizedBox(
          height: 12.0,
        ),
        widget.listSelectedNonKonsul ?? const SizedBox(),
        const SizedBox(
          height: 12,
        ),
      ],
    );
  }
}

class ListTindakanLabNonkonsulWidget extends StatefulWidget {
  const ListTindakanLabNonkonsulWidget({
    super.key,
    this.selectedData,
  });

  final List<MasterTindakanLabAll>? selectedData;

  @override
  State<ListTindakanLabNonkonsulWidget> createState() =>
      _ListTindakanLabNonkonsulWidgetState();
}

class _ListTindakanLabNonkonsulWidgetState
    extends State<ListTindakanLabNonkonsulWidget> {
  final _masterTindakanLabAllBloc = MasterTindakanLabAllBloc();

  @override
  void initState() {
    super.initState();
    _masterTindakanLabAllBloc.getTindakanLabNonKonsul();
  }

  @override
  void dispose() {
    _masterTindakanLabAllBloc.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(
          height: 20.0,
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 22.0, vertical: 12.0),
          child: Row(
            children: [
              const Expanded(
                child: Text(
                  'Tindakan Laboratorium',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
                ),
              ),
              CircleAvatar(
                radius: 18.0,
                backgroundColor: Colors.transparent,
                foregroundColor: Colors.grey,
                child: IconButton(
                  onPressed: () => Navigator.pop(context),
                  padding: EdgeInsets.zero,
                  icon: const Icon(Icons.close),
                ),
              )
            ],
          ),
        ),
        _streamMasterTindakanLab(context),
      ],
    );
  }

  Widget _streamMasterTindakanLab(BuildContext context) {
    return StreamBuilder<ApiResponse<MasterTindakanLabAllModel>>(
      stream: _masterTindakanLabAllBloc.tindakanLabAllStream,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          switch (snapshot.data!.status) {
            case Status.loading:
              return SizedBox(
                height: SizeConfig.blockSizeVertical * 30,
                child: const LoadingKit(
                  color: kPrimaryColor,
                ),
              );
            case Status.error:
              return Center(
                child: ErrorResponse(
                  message: snapshot.data!.message,
                  onTap: () => Navigator.pop(context),
                ),
              );
            case Status.completed:
              return ListTindakanLabNonKonsul(
                data: snapshot.data!.data!.data,
                selectedData: widget.selectedData,
              );
          }
        }
        return const SizedBox();
      },
    );
  }
}

class ListTindakanLabNonKonsul extends StatefulWidget {
  const ListTindakanLabNonKonsul({
    super.key,
    this.selectedData,
    this.data,
  });

  final List<MasterTindakanLabAll>? data;
  final List<MasterTindakanLabAll>? selectedData;

  @override
  State<ListTindakanLabNonKonsul> createState() =>
      _ListTindakanLabNonKonsulState();
}

class _ListTindakanLabNonKonsulState extends State<ListTindakanLabNonKonsul> {
  final _filter = TextEditingController();
  List<MasterTindakanLabAll> _data = [];
  List<MasterTindakanLabAll> _selectedData = [];
  final _scrollCon = ScrollController();

  @override
  void initState() {
    super.initState();
    _data = widget.data!;
    _selectedData = widget.selectedData!;
    _filter.addListener(_filterListen);
  }

  void _filterListen() {
    if (_filter.text.isEmpty) {
      _data = widget.data!;
    } else {
      _data = widget.data!
          .where((e) => e.namaTindakanLab!
              .toLowerCase()
              .contains(_filter.text.toLowerCase()))
          .toList();
    }
    setState(() {});
  }

  void _selectedTindakanLab(MasterTindakanLabAll data) {
    if (_selectedData.where((e) => e.id == data.id).isNotEmpty) {
      _selectedData.removeWhere((e) => e.id == data.id);
    } else {
      _selectedData.add(data);
    }
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Flexible(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (_data.length > 5)
            Padding(
              padding: const EdgeInsets.only(left: 18.0, right: 18.0),
              child: SearchInputForm(
                controller: _filter,
                hint: "Pencarian nama tindakan lab",
                suffixIcon: _filter.text.isNotEmpty
                    ? InkWell(
                        onTap: () {
                          _filter.clear();
                        },
                        child: const Icon(
                          Icons.close_rounded,
                          color: Colors.grey,
                        ),
                      )
                    : null,
              ),
            ),
          if (_data.isEmpty)
            Container(
              constraints: BoxConstraints(
                minHeight: SizeConfig.blockSizeVertical * 30,
              ),
              child: const Center(
                child: ErrorResponse(
                  message: 'Data tidak tersedia',
                  button: false,
                ),
              ),
            )
          else
            Flexible(
              child: SingleChildScrollView(
                controller: _scrollCon,
                padding: const EdgeInsets.symmetric(
                    horizontal: 12.0, vertical: 18.0),
                child: Column(
                    children: ListTile.divideTiles(
                  context: context,
                  tiles: _data
                      .map(
                        (data) => ListTile(
                          onTap: () => _selectedTindakanLab(data),
                          title: Text('${data.namaTindakanLab}'),
                          subtitle: data.mitra == null
                              ? const Text('-')
                              : Text('${data.mitra!.namaMitra}'),
                          trailing: _selectedData
                                  .where((e) => e.id == data.id)
                                  .isNotEmpty
                              ? const Icon(
                                  Icons.check_circle_outline_rounded,
                                  color: Colors.green,
                                )
                              : null,
                        ),
                      )
                      .toList(),
                ).toList()),
              ),
            ),
          Container(
            padding: const EdgeInsets.all(18.0),
            child: ElevatedButton(
              onPressed: _selectedData.isEmpty
                  ? null
                  : () => Navigator.pop(context, _selectedData),
              style: ElevatedButton.styleFrom(
                minimumSize: const Size(double.infinity, 45.0),
                backgroundColor: kPrimaryColor,
              ),
              child: _selectedData.isEmpty
                  ? const Text('Pilih Tindakan Lab')
                  : Text('Pilih ${_selectedData.length} Tindakan Lab'),
            ),
          ),
        ],
      ),
    );
  }
}

class ResikoJatuhClass {
  String? resiko;
  String? keputusan;

  ResikoJatuhClass({
    this.resiko,
    this.keputusan,
  });
}
