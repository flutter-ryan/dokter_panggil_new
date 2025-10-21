import 'package:admin_dokter_panggil/src/blocs/file_eresep_racikan_bloc.dart';
import 'package:admin_dokter_panggil/src/blocs/tagihan_resep_racikan_save_bloc.dart';
import 'package:admin_dokter_panggil/src/models/file_eresep_racikan_model.dart';
import 'package:admin_dokter_panggil/src/models/master_bhp_paginate_model.dart';
import 'package:admin_dokter_panggil/src/models/mr_pencarian_barang_farmasi_model.dart';
import 'package:admin_dokter_panggil/src/models/pasien_kunjungan_detail_model.dart';
import 'package:admin_dokter_panggil/src/models/tagihan_resep_racikan_save_model.dart';
import 'package:admin_dokter_panggil/src/pages/components/error_dialog.dart';
import 'package:admin_dokter_panggil/src/pages/components/list_master_bhp_paginate.dart';
import 'package:admin_dokter_panggil/src/pages/components/loading_kit.dart';
import 'package:admin_dokter_panggil/src/pages/components/mr_pencarian_barang_farmasi.dart';
import 'package:admin_dokter_panggil/src/pages/components/success_dialog.dart';
import 'package:admin_dokter_panggil/src/repositories/responseApi/api_response.dart';
import 'package:admin_dokter_panggil/src/source/config.dart';
import 'package:admin_dokter_panggil/src/source/size_config.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:admin_dokter_panggil/src/source/transition/animated_dialog.dart';
import 'package:intl/intl.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:share_plus/share_plus.dart';

class TransaksiResepRacikanMr extends StatefulWidget {
  const TransaksiResepRacikanMr({
    super.key,
    required this.idKunjungan,
    required this.dataResepRacikan,
  });

  final int idKunjungan;
  final ResepRacikan dataResepRacikan;

  @override
  State<TransaksiResepRacikanMr> createState() =>
      _TransaksiResepRacikanMrState();
}

class _TransaksiResepRacikanMrState extends State<TransaksiResepRacikanMr> {
  final _tagihanResepRacikanSaveBloc = TagihanResepRacikanSaveBloc();
  final _fileEresepRacikanBloc = FileEresepRacikanBloc();
  final _formKey = GlobalKey<FormState>();
  final _rupiah =
      NumberFormat.currency(locale: 'id', symbol: 'Rp. ', decimalDigits: 0);
  final List<ListTextEditingControllerRacikan> _jumlah = [];
  final List<ListTextEditingControllerRacikan> _jumlahHabisPakai = [];
  final List<MrBarangFarmasi> _selectedData = [];
  final List<BarangHabisPakai> _selectedBhp = [];

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
        if (jenis == 'mitra') {
          _listObat();
        } else {
          _listBhp();
        }
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
          child: MrPencarianBarangFarmasi(),
        );
      },
      duration: const Duration(milliseconds: 500),
    ).then((value) {
      if (value != null) {
        final data = value as List<MrBarangFarmasi>;
        for (final barang in data) {
          _jumlah.add(ListTextEditingControllerRacikan(
            id: barang.id,
            controller: TextEditingController(),
          ));
          _selectedData.add(barang);
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
        final selecteds = value as List<BarangHabisPakai>;
        for (final selected in selecteds) {
          _jumlahHabisPakai.add(ListTextEditingControllerRacikan(
            id: selected.id,
            controller: TextEditingController(),
          ));
          _selectedBhp.add(selected);
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
      final List<BarangRacikanRequest> barangMitra = [];
      final List<BarangRacikanRequest> barangMentari = [];
      for (final selected in _selectedData) {
        barangMitra.add(
          BarangRacikanRequest(
              id: selected.id!,
              jumlah: int.parse(_jumlah[_jumlah
                      .indexWhere((controller) => controller.id == selected.id)]
                  .controller!
                  .text)),
        );
      }
      for (final selected in _selectedBhp) {
        barangMentari.add(
          BarangRacikanRequest(
              id: selected.id!,
              jumlah: int.parse(_jumlahHabisPakai[_jumlahHabisPakai
                      .indexWhere((controller) => controller.id == selected.id)]
                  .controller!
                  .text)),
        );
      }
      _tagihanResepRacikanSaveBloc.idResepRacikan
          .add(widget.dataResepRacikan.id!);
      _tagihanResepRacikanSaveBloc.barangMitraSink.add(barangMitra);
      _tagihanResepRacikanSaveBloc.barangMentariSink.add(barangMentari);
      _tagihanResepRacikanSaveBloc.saveTagihanRacikan();
      _showStreamTransaksiResep();
    }
  }

  void _showStreamTransaksiResep() {
    showAnimatedDialog(
      context: context,
      builder: (context) {
        return _streamTransaksiResep(context);
      },
      duration: const Duration(milliseconds: 200),
      animationType: DialogTransitionType.slideFromBottomFade,
    ).then((value) {
      if (value != null) {
        var data = value as DetailKunjungan;
        Future.delayed(const Duration(milliseconds: 300), () {
          if (!mounted) return;
          Navigator.pop(context, data);
        });
      }
    });
  }

  void _eresepMrRacikan() {
    showMaterialModalBottomSheet(
      context: context,
      builder: (context) {
        return _eresepRacikanWidget(context, widget.dataResepRacikan);
      },
      duration: const Duration(milliseconds: 500),
    ).then((value) {
      if (value != null) {
        final data = value as ResepRacikan;
        Future.delayed(const Duration(milliseconds: 500), () {
          _fileEresepRacikanBloc.idResepSink.add(data.id!);
          _fileEresepRacikanBloc.eresepRacikan();
          _showStreamEresepRacikan();
        });
      }
    });
  }

  void _showStreamEresepRacikan() {
    showAnimatedDialog(
      context: context,
      builder: (context) => _streamEresepRacikn(context),
      animationType: DialogTransitionType.slideFromBottomFade,
    ).then((value) {
      if (value != null) {
        final resep = value as FileEresepRacikan;
        Future.delayed(const Duration(milliseconds: 500), () async {
          SharePlus.instance.share(
            ShareParams(
              title: 'E-Resep Racikan ${resep.pasien}',
              text:
                  'ERESEP dokter panggil\n\nPasien ${resep.pasien}\n${Uri.parse(resep.url!).toString()}',
              subject: 'E-Resep ${resep.pasien}',
            ),
          );
        });
      }
    });
  }

  void _removeList(int? id, String list) {
    if (list == 'mitra') {
      _selectedData.removeWhere((e) => e.id == id);
    } else {
      _selectedBhp.removeWhere((e) => e.id == id);
    }
    setState(() {});
  }

  @override
  void dispose() {
    _tagihanResepRacikanSaveBloc.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text('Transaksi resep racikan'),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        centerTitle: false,
        actions: [
          IconButton(
            onPressed: _eresepMrRacikan,
            icon: const Icon(
              Icons.receipt,
              color: kPrimaryColor,
            ),
          )
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
                    size: 52,
                  ),
                  SizedBox(
                    height: 12.0,
                  ),
                  Text(
                    'Data barang/obat tidak tersedia',
                    style: TextStyle(color: Colors.grey, fontSize: 16.0),
                  )
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
                  offset: Offset(0.0, -2.0))
            ]),
            child: SafeArea(
              top: false,
              child: Row(
                children: [
                  CircleAvatar(
                    backgroundColor: Colors.grey[200],
                    foregroundColor: Colors.blueAccent,
                    radius: 22,
                    child: IconButton(
                      onPressed: _pilihApotek,
                      style: ElevatedButton.styleFrom(
                        minimumSize: const Size(0.0, 48.0),
                        elevation: 0,
                      ),
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
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(32)),
                        backgroundColor: Colors.green,
                      ),
                      child: const Text('SIMPAN TRANSAKSI'),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _pilihApotekWidget(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 0.0),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(22.0),
            child: Text(
              'Pilih Apotek',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
            ),
          ),
          Divider(
            height: 0,
          ),
          ListTile(
            onTap: () {
              Navigator.pop(context, 'mitra');
            },
            contentPadding:
                const EdgeInsets.symmetric(vertical: 8.0, horizontal: 22.0),
            title: const Text('Apotek Mitra'),
          ),
          Divider(
            height: 0,
            color: Colors.grey[400],
          ),
          ListTile(
            onTap: () {
              Navigator.pop(context, 'mentari');
            },
            contentPadding:
                const EdgeInsets.symmetric(vertical: 8.0, horizontal: 22.0),
            title: const Text('Apotek Mentari'),
          ),
          SizedBox(
            height: MediaQuery.of(context).padding.bottom + 18,
          )
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
        var selected = _selectedData[i];
        return Padding(
          padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 12.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ListTile(
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
                trailing: Text(
                  _rupiah.format(selected.hargaJual),
                ),
              ),
              const SizedBox(
                height: 12.0,
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
      separatorBuilder: (context, i) => const Divider(),
      itemCount: _selectedData.length,
    );
  }

  Widget _formApotekMentari(BuildContext context) {
    return ListView.separated(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      physics: const NeverScrollableScrollPhysics(),
      shrinkWrap: true,
      itemBuilder: (context, i) {
        var selected = _selectedBhp[i];
        return Padding(
          padding: const EdgeInsets.symmetric(vertical: 8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Expanded(child: Text('${selected.namaBarang}')),
                  Text(_rupiah.format(selected.hargaJual))
                ],
              ),
              const SizedBox(
                height: 12.0,
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
                    width: 32.0,
                  ),
                  IconButton(
                    onPressed: () => _removeList(selected.id, 'mentari'),
                    color: Colors.red,
                    icon: const Icon(Icons.delete_outline_rounded),
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
    return StreamBuilder<ApiResponse<TagihanResepRacikanSaveModel>>(
      stream: _tagihanResepRacikanSaveBloc.tagihanRacikanStream,
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

  Widget _eresepRacikanWidget(BuildContext context, ResepRacikan racikan) {
    return Container(
      constraints: BoxConstraints(
        maxHeight: SizeConfig.blockSizeVertical * 92,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 22.0, vertical: 12.0),
            child: Row(
              children: [
                Expanded(
                  child: Text(
                    'Resep Racikan',
                    style:
                        TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),
                  ),
                ),
                CloseButton(
                  color: Colors.grey[400],
                  onPressed: () => Navigator.pop(context),
                )
              ],
            ),
          ),
          const Divider(
            height: 0,
          ),
          Flexible(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ListTile(
                    title: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Nama Racikan',
                          style: TextStyle(fontSize: 12, color: Colors.grey),
                        ),
                        Text(
                          '${racikan.namaRacikan}',
                        ),
                      ],
                    ),
                    subtitle: Text('${racikan.aturanPakai}'),
                  ),
                  ...racikan.barang!.map(
                    (barang) => ListTile(
                      visualDensity: VisualDensity.compact,
                      leading: Icon(Icons.keyboard_arrow_right_rounded),
                      horizontalTitleGap: 0,
                      dense: true,
                      title: Text('${barang.barang}'),
                    ),
                  ),
                  ListTile(
                    title: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Petunjuk Racikan',
                          style: TextStyle(fontSize: 12, color: Colors.grey),
                        ),
                        Text(
                          '${racikan.petunjuk}',
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(22),
            child: ElevatedButton(
              onPressed: () => Navigator.pop(context, 'kirim'),
              style: ElevatedButton.styleFrom(
                backgroundColor: kPrimaryColor,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(32)),
                minimumSize: const Size(double.infinity, 45),
              ),
              child: const Text('Kirim E-Resep'),
            ),
          ),
        ],
      ),
    );
  }

  Widget _streamEresepRacikn(BuildContext context) {
    return StreamBuilder<ApiResponse<FileEresepRacikanModel>>(
      stream: _fileEresepRacikanBloc.fileEresepRacikanStream,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          switch (snapshot.data!.status) {
            case Status.loading:
              return LoadingKit();
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

class ListTextEditingControllerRacikan {
  ListTextEditingControllerRacikan({
    this.id,
    this.controller,
  });

  int? id;
  TextEditingController? controller;
}
