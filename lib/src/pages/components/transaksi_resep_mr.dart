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
  final List<ListTextEditingController> _jumlah = [];
  final List<ListTextEditingController> _jumlahHabisPakai = [];
  final List<BarangFarmasi> _selectedMitra = [];
  final List<BarangHabisPakai> _selectedMentari = [];

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
          child: StreamBarangFarmasi(),
        );
      },
      duration: const Duration(milliseconds: 500),
    ).then((value) {
      if (value != null) {
        final barangs = value as List<BarangFarmasi>;
        for (final barang in barangs) {
          _jumlah.add(ListTextEditingController(
            id: barang.id,
            controller: TextEditingController(),
          ));
          if (_selectedMitra
              .where((selected) => selected.id == barang.id)
              .isEmpty) {
            _selectedMitra.add(barang);
          }
        }
        setState(() {});
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
          child: ListMasterBhpPaginate(),
        );
      },
      duration: const Duration(milliseconds: 500),
    ).then((value) {
      if (value != null) {
        final barangs = value as List<BarangHabisPakai>;
        for (final barang in barangs) {
          _jumlahHabisPakai.add(
            ListTextEditingController(
              id: barang.id,
              controller: TextEditingController(),
            ),
          );
          if (_selectedMentari
              .where((selected) => selected.id == barang.id)
              .isEmpty) {
            _selectedMentari.add(barang);
          }
        }
        setState(() {});
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
      final List<BarangRequest> barangMitra = [];
      final List<BarangRequest> barangMentari = [];
      _selectedMitra.asMap().forEach((i, selected) {
        barangMitra.add(
          BarangRequest(
            id: selected.id!,
            namaBarang: '${selected.namaBarang}',
            jumlah: int.parse(
              _jumlah[_jumlah
                      .indexWhere((controller) => controller.id == selected.id)]
                  .controller!
                  .text,
            ),
          ),
        );
      });
      _selectedMentari.asMap().forEach((i, selected) {
        barangMentari.add(
          BarangRequest(
            id: selected.id!,
            namaBarang: '${selected.namaBarang}',
            jumlah: int.parse(_jumlahHabisPakai[_jumlahHabisPakai
                    .indexWhere((controller) => controller.id == selected.id)]
                .controller!
                .text),
          ),
        );
      });
      _tagihanResepOralSaveBloc.idResepOralSink.add(widget.idResep!);
      _tagihanResepOralSaveBloc.barangMentariSink.add(barangMentari);
      _tagihanResepOralSaveBloc.barangMitraSink.add(barangMitra);
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
      setState(() {
        _selectedMitra.removeWhere((e) => e.id == id);
      });
    } else {
      setState(() {
        _selectedMentari.removeWhere((e) => e.id == id);
      });
    }
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
        final data = value as BarangFarmasi;
        setState(() {
          _selectedMitra[_selectedMitra.indexWhere((e) => e.id == data.id)] =
              data;
        });
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
        centerTitle: false,
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
          if (_selectedMitra.isNotEmpty || _selectedMentari.isNotEmpty)
            Expanded(
              child: ListView(
                padding: const EdgeInsets.symmetric(
                    vertical: 12.0, horizontal: 22.0),
                children: [
                  const SizedBox(
                    height: 12.0,
                  ),
                  if (_selectedMitra.isNotEmpty)
                    const Text(
                      'Apotek Mitra',
                      style:
                          TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                    ),
                  if (_selectedMitra.isNotEmpty)
                    const Divider(
                      thickness: 1.5,
                    ),
                  if (_selectedMitra.isNotEmpty) _formApotekMitra(context),
                  const SizedBox(
                    height: 18.0,
                  ),
                  if (_selectedMentari.isNotEmpty && _selectedMitra.isNotEmpty)
                    const SizedBox(
                      height: 22.0,
                    ),
                  if (_selectedMentari.isNotEmpty)
                    const Text(
                      'Apotek Mentari',
                      style:
                          TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                    ),
                  if (_selectedMentari.isNotEmpty)
                    const Divider(
                      thickness: 1.5,
                    ),
                  if (_selectedMentari.isNotEmpty) _formApotekMentari(context),
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
                      onPressed: (_selectedMitra.isNotEmpty ||
                              _selectedMentari.isNotEmpty)
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
        final selected = _selectedMitra[i];
        return Padding(
          padding: const EdgeInsets.symmetric(vertical: 8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ListTile(
                onTap: () => _editBarangMitra(selected),
                contentPadding: EdgeInsets.zero,
                title: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Flexible(child: Text('${selected.namaBarang}')),
                    const SizedBox(
                      width: 12.0,
                    ),
                    const Icon(
                      Icons.edit_note_rounded,
                      color: Colors.blue,
                    )
                  ],
                ),
                trailing: Text(_rupiah.format(selected.hargaJual)),
              ),
              Row(
                children: [
                  Expanded(
                    child: TextFormField(
                      controller: _jumlah[_jumlah.indexWhere(
                              (controller) => controller.id == selected.id)]
                          .controller,
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
                      keyboardType: TextInputType.number,
                    ),
                  ),
                  const SizedBox(
                    width: 12.0,
                  ),
                  CircleAvatar(
                    backgroundColor: Colors.transparent,
                    child: IconButton(
                      onPressed: () => _removeList(selected.id, 'mitra'),
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
      itemCount: _selectedMitra.length,
    );
  }

  Widget _formApotekMentari(BuildContext context) {
    return ListView.separated(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      physics: const NeverScrollableScrollPhysics(),
      shrinkWrap: true,
      itemBuilder: (context, i) {
        var selected = _selectedMentari[i];
        return Padding(
          padding: const EdgeInsets.symmetric(vertical: 8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ListTile(
                contentPadding: EdgeInsets.zero,
                title: Text('${selected.namaBarang}'),
                trailing: Text(_rupiah.format(selected.hargaJual)),
              ),
              Row(
                children: [
                  Expanded(
                    child: TextFormField(
                      controller: _jumlahHabisPakai[
                              _jumlahHabisPakai.indexWhere(
                                  (controller) => controller.id == selected.id)]
                          .controller,
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
                      keyboardType: TextInputType.number,
                    ),
                  ),
                  const SizedBox(
                    width: 12.0,
                  ),
                  CircleAvatar(
                    backgroundColor: Colors.transparent,
                    child: IconButton(
                      onPressed: () => _removeList(selected.id, 'mentari'),
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
      itemCount: _selectedMentari.length,
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

class ListTextEditingController {
  ListTextEditingController({
    this.id,
    this.controller,
  });

  int? id;
  TextEditingController? controller;
}
