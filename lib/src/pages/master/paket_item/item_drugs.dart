import 'package:cart_stepper/cart_stepper.dart';
import 'package:admin_dokter_panggil/src/blocs/master_paket_bloc.dart';
import 'package:admin_dokter_panggil/src/models/master_paket_create_model.dart';
import 'package:admin_dokter_panggil/src/pages/components/card_paket_widget.dart';
import 'package:admin_dokter_panggil/src/pages/components/confirm_dialog.dart';
import 'package:admin_dokter_panggil/src/pages/master/paket_item/show_bhp_drugs.dart';
import 'package:admin_dokter_panggil/src/source/config.dart';
import 'package:admin_dokter_panggil/src/source/transition/slide_right_route.dart';
import 'package:flutter/material.dart';
import 'package:admin_dokter_panggil/src/source/transition/animated_dialog.dart';
import 'package:intl/intl.dart';

class ItemDrugs extends StatefulWidget {
  const ItemDrugs({
    super.key,
    required this.bloc,
    this.total,
    this.data,
  });

  final MasterPaketBloc bloc;
  final Function(List<BhpSelected> data)? total;
  final List<PaketDrugs>? data;
  @override
  State<ItemDrugs> createState() => _ItemDrugsState();
}

class _ItemDrugsState extends State<ItemDrugs> {
  List<BhpSelected> _drugs = [];
  late MasterPaketBloc _masterPaketBloc;
  final _rupiah =
      NumberFormat.currency(locale: 'id', symbol: '', decimalDigits: 0);

  @override
  void initState() {
    super.initState();
    _masterPaketBloc = widget.bloc;
  }

  void _edit() {
    _drugs = [];
    widget.data?.asMap().forEach((key, drug) {
      _drugs.add(BhpSelected(
        id: drug.id,
        namaBarang: drug.namaBarang,
        jumlah: drug.qty!,
        hargaJual: drug.hargaJual,
        aturanPakai: drug.aturanPakai,
        catatan: drug.catatan,
      ));
    });
    _sinkListDrugs();
  }

  void _selectBhpDrugs() {
    Navigator.push(
      context,
      SlideRightRoute(
        page: const ShowBhpDrugs(),
      ),
    ).then((value) {
      if (value != null) {
        var data = value as List<BhpSelected>;
        data.asMap().forEach((key, bhp) {
          _drugs.add(bhp);
        });
        setState(() {});
      }
      _sinkListDrugs();
    });
  }

  void _sinkListDrugs() {
    List<int> drugs = [];
    List<int> jumlah = [];
    List<String> aturan = [];
    List<String> catatan = [];
    _drugs.asMap().forEach((key, drug) {
      drugs.add(drug.id!);
      jumlah.add(drug.jumlah);
      aturan.add(drug.aturanPakai!);
      if (drug.catatan == null) {
        catatan.add('');
      } else {
        catatan.add(drug.catatan!);
      }
    });
    _masterPaketBloc.drugsSink.add(drugs);
    _masterPaketBloc.jumlahDrugsSink.add(jumlah);
    _masterPaketBloc.aturanDrugsSink.add(aturan);
    _masterPaketBloc.catatanDrugSink.add(catatan);
    Future.delayed(const Duration(milliseconds: 500), () {
      widget.total!(_drugs);
    });
  }

  void _deleteDrug(BhpSelected? drug) {
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
        Future.delayed(const Duration(milliseconds: 500), () {
          setState(() {
            _drugs.removeWhere((e) => e.id == drug!.id);
          });
          _sinkListDrugs();
        });
      }
    });
  }

  @override
  void didUpdateWidget(covariant ItemDrugs oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.data != widget.data) {
      _edit();
    }
  }

  @override
  Widget build(BuildContext context) {
    return CardPaketWidget(
      title: 'DRUGS',
      onTap: _selectBhpDrugs,
      data: _drugs.isEmpty
          ? null
          : Column(
              children: [
                Column(
                  mainAxisSize: MainAxisSize.min,
                  children: ListTile.divideTiles(
                          tiles: _drugs
                              .map(
                                (drug) => Padding(
                                  padding: const EdgeInsets.symmetric(
                                      vertical: 15.0),
                                  child: ListTile(
                                    contentPadding: const EdgeInsets.symmetric(
                                        horizontal: 18.0),
                                    title: Row(
                                      children: [
                                        Expanded(
                                          child: Text('${drug.namaBarang}'),
                                        ),
                                        const SizedBox(
                                          width: 12.0,
                                        ),
                                        Text(_rupiah.format(
                                            drug.jumlah * drug.hargaJual!))
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
                                                _buildCounter(context, drug),
                                              ],
                                            ),
                                          ),
                                          IconButton(
                                            onPressed: () => _deleteDrug(drug),
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
                          context: context)
                      .toList(),
                ),
              ],
            ),
    );
  }

  Widget _buildCounter(BuildContext context, BhpSelected data) {
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
          _sinkListDrugs();
        }
      },
    );
  }
}

class BhpSelected {
  BhpSelected({
    this.id,
    this.namaBarang,
    this.jumlah = 1,
    this.hargaJual,
    this.aturanPakai,
    this.catatan = '',
  });

  int? id;
  String? namaBarang;
  int jumlah;
  int? hargaJual;
  String? aturanPakai;
  String? catatan;
}
