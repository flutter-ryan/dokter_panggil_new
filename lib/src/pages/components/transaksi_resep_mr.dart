import 'package:dokter_panggil/src/blocs/tagihan_resep_oral_save_bloc.dart';
import 'package:dokter_panggil/src/models/master_bhp_paginate_model.dart';
import 'package:dokter_panggil/src/models/master_farmasi_paginate_model.dart';
import 'package:dokter_panggil/src/models/pasien_kunjungan_detail_model.dart';
import 'package:dokter_panggil/src/models/tagihan_resep_oral_save_model.dart';
import 'package:dokter_panggil/src/pages/components/error_dialog.dart';
import 'package:dokter_panggil/src/pages/components/form_barang_mitra.dart';
import 'package:dokter_panggil/src/pages/components/list_master_bhp_paginate.dart';
import 'package:dokter_panggil/src/pages/components/loading_kit.dart';
import 'package:dokter_panggil/src/pages/components/stream_barang_farmasi.dart';
import 'package:dokter_panggil/src/pages/components/success_dialog.dart';
import 'package:dokter_panggil/src/pages/components/tagihan/e_resep_widget.dart';
import 'package:dokter_panggil/src/repositories/responseApi/api_response.dart';
import 'package:dokter_panggil/src/source/config.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:dokter_panggil/src/source/transition/animated_dialog.dart';
import 'package:intl/intl.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';

class TransaksiResepMr extends StatefulWidget {
  const TransaksiResepMr({
    super.key,
    this.idKunjungan,
    this.dataResep,
    this.idResep,
  });

  final int? idKunjungan;
  final List<Resep>? dataResep;
  final int? idResep;

  @override
  State<TransaksiResepMr> createState() => _TransaksiResepMrState();
}

class _TransaksiResepMrState extends State<TransaksiResepMr> {
  final _tagihanResepOralSaveBloc = TagihanResepOralSaveBloc();
  final _formKey = GlobalKey<FormState>();
  final _rupiah =
      NumberFormat.currency(locale: 'id', symbol: 'Rp. ', decimalDigits: 0);
  final List<TextEditingController> _jumlah = [];
  final List<TextEditingController> _jumlahHabisPakai = [];
  List<BarangFarmasi> _selectedData = [];
  List<BarangHabisPakai> _selectedBhp = [];
  final List<BarangRequest> _barangMitra = [];
  final List<BarangRequest> _barangMentari = [];

  void _pilihApotek() {
    showMaterialModalBottomSheet(
      context: context,
      builder: (context) {
        return _pilihApotekWidget(context);
      },
      duration: const Duration(milliseconds: 500),
    ).then((value) {
      if (value != null) {
        var jenis = value as String;
        Future.delayed(const Duration(milliseconds: 500), () {
          if (jenis == 'mitra') {
            _listObat();
          } else {
            _listBhp();
          }
        });
      }
    });
  }

  void _listObat() {
    showBarModalBottomSheet(
      context: context,
      builder: (context) {
        return Padding(
          padding:
              EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
          child: StreamBarangFarmasi(
            selectedData: _selectedData,
          ),
        );
      },
      duration: const Duration(milliseconds: 500),
    ).then((value) {
      if (value != null) {
        final barangs = value as List<BarangFarmasi>;
        for (final barang in barangs) {
          _barangMitra.add(
            BarangRequest(
              id: barang.id!,
              namaBarang: barang.namaBarang!,
              jumlah: 1,
              tarif: barang.hargaJual,
            ),
          );
        }
        setState(() {
          _selectedData = barangs;
        });
      }
    });
  }

  void _listBhp() {
    showBarModalBottomSheet(
      context: context,
      builder: (context) {
        return Padding(
          padding:
              EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
          child: ListMasterBhpPaginate(
            selectedData: _selectedBhp,
          ),
        );
      },
      duration: const Duration(milliseconds: 500),
    ).then((value) {
      if (value != null) {
        final barangs = value as List<BarangHabisPakai>;
        for (final barang in barangs) {
          _barangMentari.add(
            BarangRequest(
              id: barang.id!,
              namaBarang: barang.namaBarang!,
              jumlah: 1,
              tarif: barang.hargaJual,
            ),
          );
        }
        setState(() {
          _selectedBhp = barangs;
        });
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

  void _simpan() {
    if (validateAndSave()) {
      SystemChannels.textInput.invokeMethod('TextInput.hide');
      FocusScope.of(context).requestFocus(FocusNode());
      _tagihanResepOralSaveBloc.idResepOralSink.add(widget.idResep!);
      _tagihanResepOralSaveBloc.barangMentariSink.add(_barangMentari);
      _tagihanResepOralSaveBloc.barangMitraSink.add(_barangMitra);
      _tagihanResepOralSaveBloc.saveTagihanResepOral();
      _showStreamTransaksiResep();
    }
  }

  void _showStreamTransaksiResep() {
    showAnimatedDialog(
      context: context,
      builder: (context) => _streamTransaksiResep(context),
      duration: const Duration(milliseconds: 500),
      animationType: DialogTransitionType.slideFromBottomFade,
    ).then((value) {
      if (value != null) {
        var data = value as DetailKunjungan;
        Future.delayed(const Duration(milliseconds: 500), () {
          if (!mounted) return;
          Navigator.pop(context, data);
        });
      }
    });
  }

  void _eresep() {
    showBarModalBottomSheet(
      context: context,
      builder: (context) {
        return EresepWidget(
          data: widget.dataResep!,
          idKunjungan: widget.idKunjungan!,
        );
      },
      duration: const Duration(milliseconds: 500),
    );
  }

  void _removeList(int? id, String list) {
    if (list == 'mitra') {
      _selectedData.removeWhere((e) => e.id == id);
      _barangMitra.removeWhere((e) => e.id == id);
    } else {
      _selectedBhp.removeWhere((e) => e.id == id);
      _barangMentari.removeWhere((e) => e.id == id);
    }
    setState(() {});
  }

  void _editBarangMitra(BarangFarmasi data) {
    showBarModalBottomSheet(
      context: context,
      builder: (context) {
        return Padding(
          padding:
              EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
          child: FormBarangMitra(data: data),
        );
      },
      duration: const Duration(milliseconds: 500),
    ).then((value) {
      if (value != null) {
        var data = value as BarangFarmasi;
        _selectedData[_selectedData.indexWhere((e) => e.id == data.id)] = data;
        setState(() {});
      }
    });
  }

  @override
  void dispose() {
    _tagihanResepOralSaveBloc.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text('Transaksi resep'),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 0,
        actions: [
          IconButton(
            onPressed: _eresep,
            icon: const Icon(
              Icons.receipt,
              color: kPrimaryColor,
            ),
          ),
        ],
      ),
      body: _formTransaksiResep(context),
    );
  }

  Widget _formTransaksiResep(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        children: [
          if (_selectedData.isNotEmpty || _selectedBhp.isNotEmpty)
            Expanded(
              child: ListView(
                padding: const EdgeInsets.symmetric(
                    vertical: 12.0, horizontal: 22.0),
                children: [
                  const SizedBox(
                    height: 12.0,
                  ),
                  if (_selectedData.isNotEmpty)
                    const Text(
                      'Apotek Mitra',
                      style:
                          TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                    ),
                  if (_selectedData.isNotEmpty)
                    const Divider(
                      thickness: 1.5,
                    ),
                  if (_selectedData.isNotEmpty) _formApotekMitra(context),
                  const SizedBox(
                    height: 18.0,
                  ),
                  if (_selectedBhp.isNotEmpty && _selectedData.isNotEmpty)
                    const SizedBox(
                      height: 22.0,
                    ),
                  if (_selectedBhp.isNotEmpty)
                    const Text(
                      'Apotek Mentari',
                      style:
                          TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                    ),
                  if (_selectedBhp.isNotEmpty)
                    const Divider(
                      thickness: 1.5,
                    ),
                  if (_selectedBhp.isNotEmpty) _formApotekMentari(context),
                ],
              ),
            )
          else
            const Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.warning_amber_rounded,
                    color: Colors.red,
                    size: 52.0,
                  ),
                  SizedBox(
                    height: 12.0,
                  ),
                  Text(
                    'Data barang/obat tidak tersedia',
                    style: TextStyle(fontSize: 16.0, color: Colors.grey),
                  ),
                ],
              ),
            ),
          Container(
            padding: const EdgeInsets.all(18.0),
            width: double.infinity,
            decoration: const BoxDecoration(color: Colors.white, boxShadow: [
              BoxShadow(
                color: Colors.black12,
                blurRadius: 6,
                offset: Offset(0.0, -2.0),
              )
            ]),
            child: Padding(
              padding: EdgeInsets.only(
                  bottom: MediaQuery.of(context).padding.bottom),
              child: Row(
                children: [
                  CircleAvatar(
                    backgroundColor: Colors.grey[100],
                    foregroundColor: Colors.blueAccent,
                    child: IconButton(
                      onPressed: _pilihApotek,
                      style: ElevatedButton.styleFrom(
                          minimumSize: const Size(0.0, 48.0),
                          backgroundColor: Colors.grey[200],
                          foregroundColor: Colors.black,
                          elevation: 0),
                      icon: const Icon(Icons.add_rounded),
                    ),
                  ),
                  const SizedBox(
                    width: 15.0,
                  ),
                  Expanded(
                    child: ElevatedButton(
                      onPressed:
                          (_selectedData.isNotEmpty || _selectedBhp.isNotEmpty)
                              ? _simpan
                              : null,
                      style: ElevatedButton.styleFrom(
                          minimumSize: const Size(0.0, 42.0),
                          disabledBackgroundColor: Colors.grey[200],
                          disabledForegroundColor: Colors.grey[400],
                          backgroundColor: kPrimaryColor,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(32))),
                      child: const Text('SIMPAN TRANSAKSI'),
                    ),
                  ),
                ],
              ),
            ),
          )
        ],
      ),
    );
  }

  Widget _pilihApotekWidget(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 22),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(22.0, 0, 22.0, 22.0),
            child: Text(
              'Pilih Salah Satu',
              style: TextStyle(fontSize: 18),
            ),
          ),
          ListTile(
            onTap: () => Navigator.pop(context, 'mitra'),
            contentPadding:
                const EdgeInsets.symmetric(vertical: 8.0, horizontal: 22.0),
            title: const Text('Apotek Mitra'),
          ),
          Divider(
            height: 0,
            color: Colors.grey[400],
          ),
          ListTile(
            onTap: () => Navigator.pop(context, 'mentari'),
            contentPadding:
                const EdgeInsets.symmetric(vertical: 8.0, horizontal: 22.0),
            title: const Text('Apotek Mentari'),
          ),
        ],
      ),
    );
  }

  Widget _formApotekMitra(BuildContext context) {
    return ListView.separated(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      physics: const NeverScrollableScrollPhysics(),
      shrinkWrap: true,
      itemBuilder: (context, i) {
        var data = _barangMitra[i];
        var barangMitra = _selectedData[i];
        _jumlah.add(TextEditingController());
        return Padding(
          padding: const EdgeInsets.symmetric(vertical: 8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ListTile(
                onTap: () => _editBarangMitra(barangMitra),
                contentPadding: EdgeInsets.zero,
                title: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Flexible(child: Text(data.namaBarang)),
                    const SizedBox(
                      width: 12.0,
                    ),
                    const Icon(
                      Icons.edit_note_rounded,
                      color: Colors.blue,
                    )
                  ],
                ),
                trailing: Text(_rupiah.format(data.tarif)),
              ),
              Row(
                children: [
                  Expanded(
                    child: TextFormField(
                      controller: _jumlah[i],
                      decoration: const InputDecoration(
                        contentPadding: EdgeInsets.symmetric(
                            vertical: 0.0, horizontal: 12.0),
                        hintText: 'Jumlah',
                        hintStyle: TextStyle(color: Colors.grey),
                        border: OutlineInputBorder(),
                      ),
                      validator: (value) {
                        if (value!.isEmpty) {
                          return 'Input required';
                        }
                        return null;
                      },
                      onSaved: (val) => data.jumlah = int.parse('$val'),
                      keyboardType: TextInputType.number,
                    ),
                  ),
                  const SizedBox(
                    width: 12.0,
                  ),
                  CircleAvatar(
                    backgroundColor: Colors.transparent,
                    child: IconButton(
                      onPressed: () => _removeList(data.id, 'mitra'),
                      color: Colors.red,
                      icon: const Icon(
                        Icons.delete_outline_rounded,
                      ),
                    ),
                  )
                ],
              ),
            ],
          ),
        );
      },
      separatorBuilder: (context, i) => const SizedBox(
        height: 12.0,
      ),
      itemCount: _selectedData.length,
    );
  }

  Widget _formApotekMentari(BuildContext context) {
    return ListView.separated(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      physics: const NeverScrollableScrollPhysics(),
      shrinkWrap: true,
      itemBuilder: (context, i) {
        var data = _selectedBhp[i];
        _jumlahHabisPakai.add(TextEditingController());
        return Padding(
          padding: const EdgeInsets.symmetric(vertical: 8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ListTile(
                contentPadding: EdgeInsets.zero,
                title: Text('${data.namaBarang}'),
                trailing: Text(_rupiah.format(data.hargaJual)),
              ),
              Row(
                children: [
                  Expanded(
                    child: TextFormField(
                      controller: _jumlahHabisPakai[i],
                      decoration: const InputDecoration(
                        contentPadding: EdgeInsets.symmetric(
                            vertical: 0.0, horizontal: 12.0),
                        hintText: 'Jumlah',
                        hintStyle: TextStyle(color: Colors.grey),
                        border: OutlineInputBorder(),
                      ),
                      validator: (value) {
                        if (value!.isEmpty) {
                          return 'Input required';
                        }
                        return null;
                      },
                      onSaved: (val) {},
                      keyboardType: TextInputType.number,
                    ),
                  ),
                  const SizedBox(
                    width: 12.0,
                  ),
                  CircleAvatar(
                    backgroundColor: Colors.transparent,
                    child: IconButton(
                      onPressed: () => _removeList(data.id, 'mentari'),
                      color: Colors.red,
                      icon: const Icon(Icons.delete_outline_rounded),
                    ),
                  )
                ],
              ),
            ],
          ),
        );
      },
      separatorBuilder: (context, i) => const Divider(),
      itemCount: _selectedBhp.length,
    );
  }

  Widget _streamTransaksiResep(BuildContext context) {
    return StreamBuilder<ApiResponse<TagihanResepOralSaveModel>>(
      stream: _tagihanResepOralSaveBloc.tagihanResepOralStream,
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
