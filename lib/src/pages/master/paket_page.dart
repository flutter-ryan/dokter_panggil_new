import 'package:dokter_panggil/src/blocs/master_paket_bloc.dart';
import 'package:dokter_panggil/src/models/master_paket_create_model.dart';
import 'package:dokter_panggil/src/models/master_paket_model.dart';
import 'package:dokter_panggil/src/models/master_tindakan_lab_model.dart';
import 'package:dokter_panggil/src/models/master_tindakan_rad_create_mode.dart';
import 'package:dokter_panggil/src/models/tindakan_paket_selected_model.dart';
import 'package:dokter_panggil/src/pages/components/card_paket_widget.dart';
import 'package:dokter_panggil/src/pages/components/close_button.dart';
import 'package:dokter_panggil/src/pages/components/confirm_dialog.dart';
import 'package:dokter_panggil/src/pages/components/error_dialog.dart';
import 'package:dokter_panggil/src/pages/components/header.dart';
import 'package:dokter_panggil/src/pages/components/input_form.dart';
import 'package:dokter_panggil/src/pages/components/loading_kit.dart';
import 'package:dokter_panggil/src/pages/components/search_input_form.dart';
import 'package:dokter_panggil/src/pages/components/success_dialog.dart';
import 'package:dokter_panggil/src/pages/master/list_master_tindakan_lab_paket.dart';
import 'package:dokter_panggil/src/pages/master/list_master_tindakan_rad_paket.dart';
import 'package:dokter_panggil/src/pages/master/paket_item/item_consumable.dart';
import 'package:dokter_panggil/src/pages/master/paket_item/item_drugs.dart';
import 'package:dokter_panggil/src/pages/master/paket_item/item_resep.dart';
import 'package:dokter_panggil/src/pages/master/paket_item/item_tindakan.dart';
import 'package:dokter_panggil/src/pages/master/paket_pencarian_page.dart';
import 'package:dokter_panggil/src/repositories/responseApi/api_response.dart';
import 'package:dokter_panggil/src/source/config.dart';
import 'package:dokter_panggil/src/source/size_config.dart';
import 'package:dokter_panggil/src/source/transition/slide_bottom_route.dart';
import 'package:dokter_panggil/src/source/transition/slide_left_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:dokter_panggil/src/source/transition/animated_dialog.dart';
import 'package:intl/intl.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';

class PaketPage extends StatefulWidget {
  const PaketPage({super.key});

  @override
  State<PaketPage> createState() => _PaketPageState();
}

class _PaketPageState extends State<PaketPage> {
  final _masterPaketBloc = MasterPaketBloc();
  final _formKey = GlobalKey<FormState>();
  final _namaPaket = TextEditingController();
  final _harga = TextEditingController();
  final _persen = TextEditingController();
  MasterPaket? masterPaket;
  List<PaketLabSelected> _tindakanLab = [];
  List<PaketRadSelected> _tindakanRad = [];
  String _groupJenisHarga = 'nominal';
  String form = 'create';
  int _total = 0;
  int _totalTindakan = 0;
  int _totalDrugs = 0;
  int _totalConsume = 0;
  int _totalResep = 0;
  int _totalLab = 0;
  int _totalRad = 0;
  final _rupiah =
      NumberFormat.currency(locale: 'id', symbol: 'Rp. ', decimalDigits: 0);

  bool validateAndSave() {
    var formData = _formKey.currentState;
    if (formData!.validate()) {
      return true;
    }
    return false;
  }

  @override
  void initState() {
    super.initState();
    _persen.addListener(_persenListen);
  }

  void _persenListen() {
    if (_persen.text.isNotEmpty) {
      _persenHitung();
    } else {
      _harga.clear();
    }
  }

  void _simpan() {
    if (validateAndSave()) {
      List<int> tindakanLab = [];
      List<int> tindakanRad = [];
      _tindakanLab.asMap().forEach((key, lab) {
        tindakanLab.add(lab.id!);
      });
      _tindakanRad.asMap().forEach((key, rad) {
        tindakanRad.add(rad.id!);
      });
      _masterPaketBloc.namaPaketSink.add(_namaPaket.text);
      _masterPaketBloc.hargaSink.add(int.parse(_harga.text));
      if (_groupJenisHarga == 'persen') {
        _masterPaketBloc.diskonSink.add(int.parse(_persen.text));
      }
      _masterPaketBloc.jenisHarga.add(_groupJenisHarga);
      _masterPaketBloc.labSink.add(tindakanLab);
      _masterPaketBloc.radSink.add(tindakanRad);
      _masterPaketBloc.totalSink.add(_total);
      _masterPaketBloc.saveMasterPaket();
      _showStreamSavePaket();
    }
  }

  void _showStreamSavePaket() {
    showAnimatedDialog(
      context: context,
      builder: (context) {
        return _streamSavePaket(context);
      },
      animationType: DialogTransitionType.slideFromBottomFade,
      duration: const Duration(milliseconds: 500),
    ).then((value) {
      if (value != null) {
        if (!mounted) return;
        Navigator.pushReplacement(
          context,
          SlideBottomRoute(page: super.widget),
        );
      }
    });
  }

  void _showStreamUpdatePaket() {
    showAnimatedDialog(
      context: context,
      builder: (context) {
        return _streamUpdatePaket(context);
      },
      animationType: DialogTransitionType.slideFromBottomFade,
      duration: const Duration(milliseconds: 500),
    ).then((value) {
      if (value != null) {
        var data = value as MasterPaket;
        _edit(data);
      }
    });
  }

  void _showMasterTindakanLab() {
    showMaterialModalBottomSheet(
      context: context,
      builder: (context) {
        return Padding(
          padding:
              EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
          child: _streamListTindakanLab(context),
        );
      },
      duration: const Duration(milliseconds: 500),
    ).then((value) {
      if (value != null) {
        var data = value as List<MasterTindakanLab>;
        List<PaketLabSelected> dataLab = [];
        data.asMap().forEach((key, lab) {
          _totalLab += lab.hargaJual!;
          dataLab.add(
            PaketLabSelected(
              id: lab.id,
              namaTindakanLab: lab.namaTindakanLab,
              hargaJual: lab.hargaJual,
              hargaModal: lab.hargaModal,
              tarifAplikasi: lab.tarifAplikasi,
            ),
          );
        });
        setState(() {
          _tindakanLab = dataLab;
        });
        _hitungTotal();
      }
    });
  }

  void _showMasterTindakanRad() {
    showMaterialModalBottomSheet(
      context: context,
      builder: (context) {
        return Padding(
          padding:
              EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
          child: _streamListTindakanRad(context),
        );
      },
      duration: const Duration(milliseconds: 500),
    ).then((value) {
      if (value != null) {
        var data = value as List<MasterTindakanRad>;
        List<PaketRadSelected> dataRad = [];
        data.asMap().forEach((key, rad) {
          _totalRad += rad.hargaJual!;
          dataRad.add(
            PaketRadSelected(
              id: rad.id,
              namaTindakanRad: rad.namaTindakan,
              hargaJual: rad.hargaJual,
              hargaModal: rad.hargaModal,
              tarifAplikasi: rad.tarifAplikasi,
            ),
          );
        });
        setState(() {
          _tindakanRad = dataRad;
        });
        _hitungTotal();
      }
    });
  }

  void _deleteTindakanLab(PaketLabSelected? lab) {
    setState(() {
      _totalLab = _totalLab - lab!.hargaJual!;
      _tindakanLab.removeWhere((e) => e.id == lab.id);
    });
    _hitungTotal();
  }

  void _deleteTindakanRad(PaketRadSelected? rad) {
    setState(() {
      _totalRad = _totalRad - rad!.hargaJual!;
      _tindakanRad.removeWhere((e) => e.id == rad.id);
    });
    _hitungTotal();
  }

  void _hitungTotal() {
    setState(() {
      _total = _totalTindakan +
          _totalDrugs +
          _totalConsume +
          _totalResep +
          _totalLab +
          _totalRad;
    });
    _persenHitung();
  }

  void _persenHitung() {
    if (_groupJenisHarga == 'persen') {
      double diskon = (int.parse(_persen.text) / 100) * _total;
      setState(() {
        _harga.text = '${_total - diskon.round()}';
      });
    }
  }

  void _edit(MasterPaket data) {
    _namaPaket.text = '${data.namaPaket}';
    _persen.text = '${data.persen}';
    _groupJenisHarga = '${data.jenisHarga}';
    _harga.text = '${data.harga}';
    _tindakanLab = [];
    _tindakanRad = [];
    data.lab?.asMap().forEach((key, tindakanLab) {
      _tindakanLab.add(
        PaketLabSelected(
          id: tindakanLab.id,
          namaTindakanLab: tindakanLab.namaTindakanLab,
          hargaModal: tindakanLab.hargaModal,
          hargaJual: tindakanLab.hargaJual,
          tarifAplikasi: tindakanLab.tarifAplikasi,
        ),
      );
    });
    data.rad?.asMap().forEach((key, tindakanRad) {
      _tindakanRad.add(
        PaketRadSelected(
          id: tindakanRad.id,
          namaTindakanRad: tindakanRad.namaTindakanRad,
          hargaJual: tindakanRad.hargaJual,
          hargaModal: tindakanRad.hargaModal,
          tarifAplikasi: tindakanRad.tarifAplikasi,
        ),
      );
    });
    setState(() {
      masterPaket = data;
      form = 'edit';
    });
  }

  void _updatePaket() {
    if (validateAndSave()) {
      SystemChannels.textInput.invokeMethod('TextInput.hide');
      FocusScope.of(context).requestFocus(FocusNode());
      showAnimatedDialog(
        context: context,
        builder: (context) {
          return ConfirmDialogWidget(
            onConfirm: () => Navigator.pop(context, 'update'),
            message: 'Anda yakin mengubah data ini?',
            labelConfirm: 'Ya, Ubah',
          );
        },
        animationType: DialogTransitionType.slideFromBottomFade,
        duration: const Duration(milliseconds: 500),
      ).then((value) {
        if (value != null) {
          List<int> tindakanLab = [];
          List<int> tindakanRad = [];
          _tindakanLab.asMap().forEach((key, lab) {
            tindakanLab.add(lab.id!);
          });
          _tindakanRad.asMap().forEach((key, rad) {
            tindakanRad.add(rad.id!);
          });
          _masterPaketBloc.namaPaketSink.add(_namaPaket.text);
          _masterPaketBloc.hargaSink.add(int.parse(_harga.text));
          if (_groupJenisHarga == 'persen') {
            _masterPaketBloc.diskonSink.add(int.parse(_persen.text));
          }
          _masterPaketBloc.idPaketSink.add(masterPaket!.id!);
          _masterPaketBloc.jenisHarga.add(_groupJenisHarga);
          _masterPaketBloc.labSink.add(tindakanLab);
          _masterPaketBloc.radSink.add(tindakanRad);
          _masterPaketBloc.totalSink.add(_total);
          _masterPaketBloc.updateMasterPaket();
          _showStreamUpdatePaket();
        }
      });
    }
  }

  void _deletePaket() {
    SystemChannels.textInput.invokeMethod('TextInput.hide');
    FocusScope.of(context).requestFocus(FocusNode());
    showAnimatedDialog(
      context: context,
      builder: (context) {
        return ConfirmDialogWidget(
          onConfirm: () => Navigator.pop(context, 'confirm'),
        );
      },
      duration: const Duration(milliseconds: 500),
      animationType: DialogTransitionType.slideFromBottomFade,
    ).then((value) {
      if (value != null) {
        _masterPaketBloc.idPaketSink.add(masterPaket!.id!);
        _masterPaketBloc.deleteMasterPaket();
        _showStreamSavePaket();
      }
    });
  }

  void _batal() {
    Navigator.pushReplacement(
        context,
        SlideBottomRoute(
          page: const PaketPage(),
        ));
  }

  @override
  void dispose() {
    _masterPaketBloc.dispose();
    _namaPaket.dispose();
    _persen.dispose();
    _harga.dispose();
    _persen.removeListener(_persenListen);
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
              title: 'Master Paket/Promo',
              subtitle: SearchInputForm(
                isReadOnly: true,
                hint: 'Pencarian paket/promo',
                onTap: () => Navigator.push(
                  context,
                  SlideLeftRoute(
                    page: const PaketPencarianPage(),
                  ),
                ).then((value) {
                  if (value != null) {
                    var data = value as MasterPaket;
                    _edit(data);
                  }
                }),
              ),
              closeButton: const ClosedButton(),
            ),
            _listItemPaket(context),
            Container(
              decoration: const BoxDecoration(color: Colors.white, boxShadow: [
                BoxShadow(
                    color: Colors.black12, blurRadius: 8, offset: Offset(0, -2))
              ]),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  ListTile(
                    title: const Text(
                      'Total Item',
                      style: TextStyle(fontSize: 14.0, color: Colors.grey),
                    ),
                    subtitle: Text(
                      _rupiah.format(_total),
                      style: const TextStyle(
                          fontWeight: FontWeight.w600, fontSize: 16.0),
                    ),
                    trailing: form == 'create'
                        ? ElevatedButton(
                            onPressed: _simpan,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: kPrimaryColor,
                              minimumSize: const Size(120, 45),
                            ),
                            child: const Text('SIMPAN'),
                          )
                        : _buttonEdit(context),
                  ),
                  if (form != 'create')
                    Padding(
                      padding: const EdgeInsets.only(
                          left: 18.0, right: 18.0, bottom: 12.0),
                      child: ElevatedButton(
                        onPressed: _batal,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.grey[100],
                          foregroundColor: Colors.black,
                          minimumSize: const Size(double.infinity, 42),
                        ),
                        child: const Text('Batal Update'),
                      ),
                    )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buttonEdit(BuildContext context) {
    return SizedBox(
      width: 120,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Expanded(
            flex: 1,
            child: ElevatedButton(
              onPressed: _deletePaket,
              style: ElevatedButton.styleFrom(
                backgroundColor: kPrimaryColor,
                minimumSize: const Size.fromHeight(42),
              ),
              child: const Icon(Icons.delete),
            ),
          ),
          const SizedBox(
            width: 8.0,
          ),
          Expanded(
            flex: 1,
            child: ElevatedButton(
              onPressed: _updatePaket,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue,
                minimumSize: const Size.fromHeight(42),
              ),
              child: const Icon(Icons.edit),
            ),
          ),
        ],
      ),
    );
  }

  Widget _listItemPaket(BuildContext context) {
    return Expanded(
      child: Form(
        key: _formKey,
        child: SingleChildScrollView(
          child: Column(
            children: [
              Container(
                padding: const EdgeInsets.symmetric(vertical: 22.0),
                decoration:
                    const BoxDecoration(color: Colors.white, boxShadow: [
                  BoxShadow(
                    color: Colors.black12,
                    blurRadius: 6.0,
                    offset: Offset(2.0, 2.0),
                  )
                ]),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Padding(
                      padding: EdgeInsets.symmetric(horizontal: 22.0),
                      child: Text(
                        'DESKRIPSI',
                        style: TextStyle(
                            fontSize: 16.0, fontWeight: FontWeight.w600),
                      ),
                    ),
                    const Divider(
                      height: 32.0,
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 22.0),
                      child: Input(
                        controller: _namaPaket,
                        label: 'Nama',
                        hint: 'Ketikkan nama paket/promo',
                        textInputAction: TextInputAction.next,
                        textCap: TextCapitalization.words,
                        validator: (val) {
                          if (val!.isEmpty) {
                            return 'Input required';
                          }
                          return null;
                        },
                      ),
                    ),
                    const SizedBox(
                      height: 18.0,
                    ),
                    _selectJenisHarga(context),
                  ],
                ),
              ),
              const SizedBox(
                height: 12.0,
              ),
              ItemTindakan(
                bloc: _masterPaketBloc,
                data: masterPaket?.tindakan,
                total: (List<TindakanPaketSelected> data) {
                  var total = 0;
                  data.asMap().forEach((key, tindakan) {
                    total += tindakan.jumlah * tindakan.tarif;
                  });
                  setState(() {
                    _totalTindakan = total;
                  });
                  _hitungTotal();
                },
              ),
              const SizedBox(
                height: 12.0,
              ),
              ItemDrugs(
                bloc: _masterPaketBloc,
                data: masterPaket?.drugs,
                total: (List<BhpSelected> data) {
                  var total = 0;
                  data.asMap().forEach((key, drug) {
                    total += drug.jumlah * drug.hargaJual!;
                  });
                  setState(() {
                    _totalDrugs = total;
                  });
                  _hitungTotal();
                },
              ),
              const SizedBox(
                height: 12.0,
              ),
              ItemConsumable(
                bloc: _masterPaketBloc,
                data: masterPaket?.consumes,
                total: (List<BhpSelected> data) {
                  var total = 0;
                  data.asMap().forEach((key, drug) {
                    total += drug.jumlah * drug.hargaJual!;
                  });
                  setState(() {
                    _totalConsume = total;
                  });
                  _hitungTotal();
                },
              ),
              const SizedBox(
                height: 12.0,
              ),
              ItemResep(
                bloc: _masterPaketBloc,
                data: masterPaket?.farmasi,
                total: (List<FarmasiSelected> data) {
                  var total = 0;
                  data.asMap().forEach((key, barang) {
                    total += barang.jumlah * barang.hargaJual!;
                  });
                  setState(() {
                    _totalResep = total;
                  });
                  _hitungTotal();
                },
              ),
              const SizedBox(
                height: 12.0,
              ),
              _tindakanLabSelected(context),
              const SizedBox(
                height: 12.0,
              ),
              _tindakanRadSelected(context),
              const SizedBox(
                height: 12.0,
              ),
              CardPaketWidget(
                title: 'HARGA PAKET',
                isButton: false,
                data: Column(
                  children: [
                    if (_groupJenisHarga == 'persen')
                      Padding(
                        padding: const EdgeInsets.only(
                          left: 22.0,
                          right: 22.0,
                          top: 18.0,
                        ),
                        child: Input(
                          controller: _persen,
                          label: 'Diskon',
                          hint: 'Ketikkan persen diskon paket/promo',
                          keyType: const TextInputType.numberWithOptions(
                              decimal: true),
                          validator: (val) {
                            if (val!.isEmpty) {
                              return 'Input required';
                            } else if (int.parse(val) > 100) {
                              return 'Maksimal angka 100';
                            }
                            return null;
                          },
                        ),
                      ),
                    Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 22.0,
                        vertical: 18,
                      ),
                      child: Input(
                        controller: _harga,
                        label: 'Harga',
                        readOnly: _groupJenisHarga == 'nominal' ? false : true,
                        hint: _groupJenisHarga == 'nominal'
                            ? 'Ketikkan harga paket/promo'
                            : 'Harga paket/promo',
                        keyType: TextInputType.number,
                        validator: (val) {
                          if (val!.isEmpty) {
                            return 'Input required';
                          }
                          return null;
                        },
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(
                height: 12.0,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _selectJenisHarga(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 22.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Jenis Harga',
            style: TextStyle(fontWeight: FontWeight.w600),
          ),
          const SizedBox(
            height: 12.0,
          ),
          Row(
            children: [
              Expanded(
                child: Container(
                  decoration: BoxDecoration(
                    border: Border.all(width: 0.3, color: Colors.grey),
                    borderRadius: BorderRadius.circular(8.0),
                    color: Colors.grey[200],
                  ),
                  child: Center(
                    child: RadioListTile(
                      value: 'nominal',
                      activeColor: kPrimaryColor,
                      groupValue: _groupJenisHarga,
                      onChanged: (newval) {
                        setState(() {
                          _groupJenisHarga = '$newval';
                          _harga.clear();
                          _persen.clear();
                        });
                      },
                      title: const Text('Nominal'),
                    ),
                  ),
                ),
              ),
              const SizedBox(
                width: 12.0,
              ),
              Expanded(
                child: Container(
                  decoration: BoxDecoration(
                    border: Border.all(width: 0.3, color: Colors.grey),
                    borderRadius: BorderRadius.circular(8.0),
                    color: Colors.grey[200],
                  ),
                  child: Center(
                    child: RadioListTile(
                      value: 'persen',
                      groupValue: _groupJenisHarga,
                      activeColor: kPrimaryColor,
                      onChanged: (newval) {
                        setState(() {
                          _groupJenisHarga = '$newval';
                          _harga.text = "0";
                        });
                      },
                      title: const Text('Persen'),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _tindakanLabSelected(BuildContext context) {
    return CardPaketWidget(
      title: 'LABORATORIUM',
      onTap: _showMasterTindakanLab,
      data: _tindakanLab.isEmpty
          ? null
          : Column(
              children: [
                Column(
                  children: ListTile.divideTiles(
                    tiles: _tindakanLab
                        .map(
                          (tindakanLab) => Padding(
                            padding: const EdgeInsets.symmetric(vertical: 8.0),
                            child: ListTile(
                              contentPadding:
                                  const EdgeInsets.symmetric(horizontal: 15.0),
                              title: Text('${tindakanLab.namaTindakanLab}'),
                              trailing: IconButton(
                                onPressed: () =>
                                    _deleteTindakanLab(tindakanLab),
                                icon: const Icon(
                                  Icons.delete_rounded,
                                  color: Colors.red,
                                ),
                              ),
                            ),
                          ),
                        )
                        .toList(),
                    context: context,
                  ).toList(),
                ),
              ],
            ),
    );
  }

  Widget _tindakanRadSelected(BuildContext context) {
    return CardPaketWidget(
      title: 'RADIALOGI',
      onTap: _showMasterTindakanRad,
      data: _tindakanRad.isEmpty
          ? null
          : Column(
              children: [
                Column(
                  children: ListTile.divideTiles(
                          tiles: _tindakanRad
                              .map(
                                (tindakanRad) => Padding(
                                  padding:
                                      const EdgeInsets.symmetric(vertical: 8.0),
                                  child: ListTile(
                                    contentPadding: const EdgeInsets.symmetric(
                                        horizontal: 22.0),
                                    title:
                                        Text('${tindakanRad.namaTindakanRad}'),
                                    trailing: IconButton(
                                      onPressed: () =>
                                          _deleteTindakanRad(tindakanRad),
                                      icon: const Icon(
                                        Icons.delete_rounded,
                                        color: Colors.red,
                                      ),
                                    ),
                                  ),
                                ),
                              )
                              .toList(),
                          context: context)
                      .toList(),
                ),
              ],
            ),
    );
  }

  Widget _streamListTindakanLab(BuildContext context) {
    return Container(
      constraints: BoxConstraints(
        minHeight: SizeConfig.blockSizeVertical * 35,
        maxHeight: SizeConfig.blockSizeVertical * 90,
      ),
      child: ListMasterTindakanLabPaket(
        selectedData: _tindakanLab,
      ),
    );
  }

  Widget _streamListTindakanRad(BuildContext context) {
    return Container(
      constraints: BoxConstraints(
        minHeight: SizeConfig.blockSizeVertical * 35,
        maxHeight: SizeConfig.blockSizeVertical * 90,
      ),
      child: ListMasterTindakanRadPaket(
        selectedData: _tindakanRad,
      ),
    );
  }

  Widget _streamSavePaket(BuildContext context) {
    return StreamBuilder<ApiResponse<ResponseMasterPaketModel>>(
      stream: _masterPaketBloc.masterPaketSaveStream,
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

  Widget _streamUpdatePaket(BuildContext context) {
    return StreamBuilder<ApiResponse<ResponseMasterPaketModel>>(
      stream: _masterPaketBloc.masterPaketSaveStream,
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

class PaketLabSelected {
  PaketLabSelected({
    this.id,
    this.namaTindakanLab,
    this.hargaJual,
    this.hargaModal,
    this.tarifAplikasi,
  });

  int? id;
  String? namaTindakanLab;
  int? hargaJual;
  int? hargaModal;
  int? tarifAplikasi;
}

class PaketRadSelected {
  PaketRadSelected({
    this.id,
    this.namaTindakanRad,
    this.hargaJual,
    this.hargaModal,
    this.tarifAplikasi,
  });

  int? id;
  String? namaTindakanRad;
  int? hargaJual;
  int? hargaModal;
  int? tarifAplikasi;
}
