import 'package:cart_stepper/cart_stepper.dart';
import 'package:admin_dokter_panggil/src/blocs/master_paket_bloc.dart';
import 'package:admin_dokter_panggil/src/models/master_paket_create_model.dart';
import 'package:admin_dokter_panggil/src/pages/components/card_paket_widget.dart';
import 'package:admin_dokter_panggil/src/pages/master/paket_item/show_farmasi.dart';
import 'package:admin_dokter_panggil/src/source/config.dart';
import 'package:admin_dokter_panggil/src/source/transition/slide_right_route.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class ItemResep extends StatefulWidget {
  const ItemResep({
    super.key,
    required this.bloc,
    this.total,
    this.data,
  });

  final MasterPaketBloc bloc;
  final Function(List<FarmasiSelected> data)? total;
  final List<PaketFarmasi>? data;

  @override
  State<ItemResep> createState() => _ItemResepState();
}

class _ItemResepState extends State<ItemResep> {
  List<FarmasiSelected> _farmasi = [];
  late MasterPaketBloc _masterPaketBloc;
  final _rupiah =
      NumberFormat.currency(locale: 'id', symbol: '', decimalDigits: 0);

  @override
  void initState() {
    super.initState();
    _masterPaketBloc = widget.bloc;
  }

  void _edit() {
    _farmasi = [];
    widget.data?.asMap().forEach((key, obat) {
      _farmasi.add(FarmasiSelected(
        id: obat.id,
        namaBarang: obat.namaBarang,
        jumlah: obat.qty!,
        hargaJual: obat.hargaJual,
      ));
    });
    _sinkListFarmasi();
  }

  void _showFarmasi() {
    Navigator.push(
      context,
      SlideRightRoute(page: const ShowFarmasi()),
    ).then((value) {
      if (value != null) {
        var data = value as List<FarmasiSelected>;
        data.asMap().forEach((key, farmasi) {
          _farmasi.add(farmasi);
        });
        setState(() {});
        _sinkListFarmasi();
      }
    });
  }

  void _delete(FarmasiSelected barang) {
    setState(() {
      _farmasi.removeWhere((e) => e.id == barang.id);
    });
    _sinkListFarmasi();
  }

  void _sinkListFarmasi() {
    List<int> farmasis = [];
    List<int> jumlah = [];
    List<String> aturan = [];
    List<String> catatan = [];
    _farmasi.asMap().forEach((key, farmasi) {
      farmasis.add(farmasi.id!);
      jumlah.add(farmasi.jumlah);
      aturan.add('${farmasi.aturanPakai}');
      if (farmasi.catatan == null) {
        catatan.add('');
      } else {
        catatan.add(farmasi.catatan!);
      }
    });
    _masterPaketBloc.farmasisSink.add(farmasis);
    _masterPaketBloc.jumlashFarmasisSink.add(jumlah);
    _masterPaketBloc.aturanFarmasiSink.add(aturan);
    _masterPaketBloc.catatanFarmasiSink.add(catatan);
    Future.delayed(const Duration(milliseconds: 500), () {
      widget.total!(_farmasi);
    });
  }

  @override
  void didUpdateWidget(covariant ItemResep oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.data != widget.data) {
      _edit();
    }
  }

  @override
  Widget build(BuildContext context) {
    return CardPaketWidget(
      title: 'RESEP',
      onTap: _showFarmasi,
      data: _farmasi.isEmpty
          ? null
          : Column(
              children: [
                Column(
                  mainAxisSize: MainAxisSize.min,
                  children: ListTile.divideTiles(
                    tiles: _farmasi
                        .map(
                          (barang) => Padding(
                            padding: const EdgeInsets.symmetric(vertical: 15.0),
                            child: ListTile(
                              contentPadding:
                                  const EdgeInsets.symmetric(horizontal: 15.0),
                              title: Row(
                                children: [
                                  Expanded(child: Text('${barang.namaBarang}')),
                                  const SizedBox(
                                    width: 12,
                                  ),
                                  Text(_rupiah.format(
                                      barang.jumlah * barang.hargaJual!))
                                ],
                              ),
                              subtitle: Padding(
                                padding: const EdgeInsets.only(top: 12.0),
                                child: Row(
                                  children: [
                                    Expanded(
                                      child: Row(
                                        children: [
                                          const Text('Qty: '),
                                          const SizedBox(
                                            width: 12.0,
                                          ),
                                          _buildCounter(context, barang),
                                        ],
                                      ),
                                    ),
                                    IconButton(
                                      onPressed: () => _delete(barang),
                                      color: Colors.red,
                                      icon: const Icon(
                                        Icons.delete_rounded,
                                      ),
                                    ),
                                  ],
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

  Widget _buildCounter(BuildContext context, FarmasiSelected data) {
    return CartStepperInt(
      value: data.jumlah,
      size: 32,
      style: CartStepperStyle(
        activeBackgroundColor: Colors.grey[50]!,
        elevation: 0,
        activeForegroundColor: Colors.black,
        border: Border.all(color: kPrimaryColor, width: 0.7),
        buttonAspectRatio: 1.3,
      ),
      numberSize: 3.0,
      didChangeCount: (count) {
        if (count > 0) {
          setState(() {
            data.jumlah = count;
          });
          _sinkListFarmasi();
        }
      },
    );
  }
}

class FarmasiSelected {
  FarmasiSelected({
    this.id,
    this.namaBarang,
    this.jumlah = 1,
    this.hargaJual,
    this.aturanPakai,
    this.catatan,
  });

  int? id;
  String? namaBarang;
  int jumlah;
  int? hargaJual;
  String? aturanPakai;
  String? catatan;
}
