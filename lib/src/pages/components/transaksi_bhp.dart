import 'package:dokter_panggil/src/blocs/transaksi_bhp_bloc.dart';
import 'package:dokter_panggil/src/models/master_bhp_paginate_model.dart';
import 'package:dokter_panggil/src/models/pasien_kunjungan_detail_model.dart';
import 'package:dokter_panggil/src/models/transaksi_bhp_model.dart';
import 'package:dokter_panggil/src/pages/components/error_dialog.dart';
import 'package:dokter_panggil/src/pages/components/list_master_bhp_paginate.dart';
import 'package:dokter_panggil/src/pages/components/loading_kit.dart';
import 'package:dokter_panggil/src/pages/components/success_dialog.dart';
import 'package:dokter_panggil/src/repositories/responseApi/api_response.dart';
import 'package:dokter_panggil/src/source/config.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:dokter_panggil/src/source/transition/animated_dialog.dart';
import 'package:intl/intl.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';

class TransaksiBhp extends StatefulWidget {
  const TransaksiBhp({
    super.key,
    required this.idKunjungan,
    required this.dataBhp,
  });

  final int idKunjungan;
  final List<Bhp> dataBhp;

  @override
  State<TransaksiBhp> createState() => _TransaksiBhpState();
}

class _TransaksiBhpState extends State<TransaksiBhp> {
  final _transaksiBhpBloc = TransaksiBhpBloc();
  final _rupiah =
      NumberFormat.currency(locale: 'id', symbol: 'Rp. ', decimalDigits: 0);
  List<BarangHabisPakai> _selectedBhp = [];
  final List<int> _jumlahBhp = [];
  final List<int> _barang = [];
  final _formKey = GlobalKey<FormState>();

  bool validateAndSave() {
    var formState = _formKey.currentState;
    if (formState!.validate()) {
      formState.save();
      return true;
    }
    return false;
  }

  void _detail() {
    showBarModalBottomSheet(
      context: context,
      builder: (context) {
        return _detailTindakanLab(context);
      },
      duration: const Duration(milliseconds: 500),
    );
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
        setState(() {
          _selectedBhp = value as List<BarangHabisPakai>;
        });
      }
    });
  }

  void _removeList(int? id) {
    setState(() {
      _selectedBhp.removeWhere((e) => e.id == id);
    });
  }

  void _simpan() {
    _jumlahBhp.clear();
    if (validateAndSave()) {
      SystemChannels.textInput.invokeMethod('TextInput.hide');
      _barang.clear();
      if (_selectedBhp.isNotEmpty) {
        for (var bhp in _selectedBhp) {
          _barang.add(bhp.id!);
        }
      }
      _transaksiBhpBloc.idKunjunganSink.add(widget.idKunjungan);
      _transaksiBhpBloc.barangSink.add(_barang);
      _transaksiBhpBloc.jumlahSink.add(_jumlahBhp);
      _transaksiBhpBloc.saveTransaksiBhp();
      _showStreamSimpanTransaksi();
    }
  }

  void _showStreamSimpanTransaksi() {
    showAnimatedDialog(
      context: context,
      builder: (context) {
        return _streamSimpanTransaksi(context);
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

  @override
  void dispose() {
    _transaksiBhpBloc.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text('Transaksi BHP'),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        actions: [
          IconButton(
            onPressed: _detail,
            icon: const Icon(
              Icons.info_outline_rounded,
              color: kPrimaryColor,
            ),
          )
        ],
      ),
      body: _formTransaksiBhp(context),
    );
  }

  Widget _formTransaksiBhp(BuildContext context) {
    return Column(
      children: [
        if (_selectedBhp.isNotEmpty)
          Expanded(
            child: _formApotekMentari(context),
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
                color: Colors.black12, blurRadius: 6, offset: Offset(0.0, -2.0))
          ]),
          child: Row(
            children: [
              ElevatedButton(
                onPressed: _listBhp,
                style: ElevatedButton.styleFrom(
                  minimumSize: const Size(0.0, 48.0),
                  backgroundColor: Colors.grey[200],
                  foregroundColor: Colors.black,
                ),
                child: const Icon(Icons.add_rounded),
              ),
              const SizedBox(
                width: 15.0,
              ),
              Expanded(
                child: ElevatedButton(
                  onPressed: _selectedBhp.isEmpty ? null : _simpan,
                  style: ElevatedButton.styleFrom(
                    minimumSize: const Size(0.0, 48.0),
                    backgroundColor: kPrimaryColor,
                  ),
                  child: const Text('SIMPAN TRANSAKSI'),
                ),
              ),
            ],
          ),
        )
      ],
    );
  }

  Widget _formApotekMentari(BuildContext context) {
    return Form(
      key: _formKey,
      child: ListView.separated(
        padding: const EdgeInsets.symmetric(vertical: 32.0, horizontal: 22.0),
        physics: const NeverScrollableScrollPhysics(),
        shrinkWrap: true,
        itemBuilder: (context, i) {
          var data = _selectedBhp[i];
          return Padding(
            padding: const EdgeInsets.symmetric(vertical: 8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(child: Text('${data.namaBarang}')),
                    Text(_rupiah.format(data.hargaJual))
                  ],
                ),
                const SizedBox(
                  height: 12.0,
                ),
                Row(
                  children: [
                    Expanded(
                      child: TextFormField(
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
                        onSaved: (val) => _jumlahBhp.add(int.parse(val!)),
                        keyboardType: TextInputType.number,
                      ),
                    ),
                    const SizedBox(
                      width: 32.0,
                    ),
                    IconButton(
                      onPressed: () => _removeList(data.id),
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
      ),
    );
  }

  Widget _detailTindakanLab(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 18.0, vertical: 22.0),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'List Tindakan Laboratorium',
            style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.w600),
          ),
          const SizedBox(
            height: 18.0,
          ),
          Column(
            mainAxisSize: MainAxisSize.min,
            children: ListTile.divideTiles(
              context: context,
              tiles: widget.dataBhp
                  .map(
                    (bhp) => ListTile(
                      contentPadding: EdgeInsets.zero,
                      horizontalTitleGap: 0,
                      title: Text('${bhp.barang}'),
                      trailing: Text('${bhp.jumlah} buah'),
                      leading: const Icon(Icons.keyboard_arrow_right),
                    ),
                  )
                  .toList(),
            ).toList(),
          ),
          const SizedBox(
            height: 22.0,
          ),
        ],
      ),
    );
  }

  Widget _streamSimpanTransaksi(BuildContext context) {
    return StreamBuilder<ApiResponse<ResponseTransaksiBhpModel>>(
      stream: _transaksiBhpBloc.transaksiBhpStream,
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
