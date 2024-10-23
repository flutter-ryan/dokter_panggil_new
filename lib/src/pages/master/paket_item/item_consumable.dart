import 'package:cart_stepper/cart_stepper.dart';
import 'package:dokter_panggil/src/blocs/master_paket_bloc.dart';
import 'package:dokter_panggil/src/models/master_paket_create_model.dart';
import 'package:dokter_panggil/src/pages/components/card_paket_widget.dart';
import 'package:dokter_panggil/src/pages/components/confirm_dialog.dart';
import 'package:dokter_panggil/src/pages/master/list_master_bhp_paket.dart';
import 'package:dokter_panggil/src/pages/master/paket_item/item_drugs.dart';
import 'package:dokter_panggil/src/source/config.dart';
import 'package:dokter_panggil/src/source/size_config.dart';
import 'package:flutter/material.dart';
import 'package:dokter_panggil/src/source/transition/animated_dialog.dart';
import 'package:intl/intl.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';

class ItemConsumable extends StatefulWidget {
  const ItemConsumable({
    super.key,
    this.data,
    required this.bloc,
    this.total,
  });

  final MasterPaketBloc bloc;
  final Function(List<BhpSelected> data)? total;
  final List<PaketConsumes>? data;

  @override
  State<ItemConsumable> createState() => _ItemConsumableState();
}

class _ItemConsumableState extends State<ItemConsumable> {
  List<BhpSelected> _consumable = [];
  late MasterPaketBloc _masterPaketBloc;
  final _rupiah =
      NumberFormat.currency(locale: 'id', symbol: '', decimalDigits: 0);

  @override
  void initState() {
    super.initState();
    _masterPaketBloc = widget.bloc;
  }

  void _edit() {
    _consumable = [];
    widget.data?.asMap().forEach((key, drug) {
      _consumable.add(BhpSelected(
        id: drug.id,
        namaBarang: drug.namaBarang,
        jumlah: drug.qty!,
        hargaJual: drug.hargaJual,
      ));
    });
    _sinkListConsumable();
  }

  void _showBhpConsumable() {
    showMaterialModalBottomSheet(
      context: context,
      builder: (context) {
        return Padding(
          padding:
              EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
          child: _streamListConsumableBhp(context),
        );
      },
      duration: const Duration(milliseconds: 500),
    ).then((value) {
      if (value != null) {
        var data = value as List<BhpSelected>;
        setState(() {
          _consumable = data;
        });
        _sinkListConsumable();
      }
    });
  }

  void _deleteConsumble(BhpSelected? consum) {
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
            _consumable.removeWhere((e) => e.id == consum!.id);
          });
          _sinkListConsumable();
        });
      }
    });
  }

  void _sinkListConsumable() {
    List<int> consumes = [];
    List<int> jumlah = [];
    _consumable.asMap().forEach((key, consume) {
      consumes.add(consume.id!);
      jumlah.add(consume.jumlah);
    });
    _masterPaketBloc.consumesSink.add(consumes);
    _masterPaketBloc.jumlahConsumesSink.add(jumlah);
    Future.delayed(const Duration(milliseconds: 500), () {
      widget.total!(_consumable);
    });
  }

  @override
  void didUpdateWidget(covariant ItemConsumable oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.data != widget.data) {
      _edit();
    }
  }

  @override
  Widget build(BuildContext context) {
    return CardPaketWidget(
      title: 'CONSUMABLE',
      onTap: _showBhpConsumable,
      data: _consumable.isEmpty
          ? null
          : Column(
              children: [
                Column(
                  mainAxisSize: MainAxisSize.min,
                  children: ListTile.divideTiles(
                    context: context,
                    tiles: _consumable
                        .map(
                          (consum) => Padding(
                            padding: const EdgeInsets.symmetric(vertical: 15.0),
                            child: ListTile(
                              contentPadding:
                                  const EdgeInsets.symmetric(horizontal: 15.0),
                              title: Row(
                                children: [
                                  Expanded(child: Text('${consum.namaBarang}')),
                                  const SizedBox(
                                    width: 12.0,
                                  ),
                                  Text(
                                    _rupiah.format(
                                        consum.jumlah * consum.hargaJual!),
                                  )
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
                                          _buildCounter(context, consum),
                                        ],
                                      ),
                                    ),
                                    IconButton(
                                      onPressed: () => _deleteConsumble(consum),
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
                  ).toList(),
                ),
              ],
            ),
    );
  }

  Widget _streamListConsumableBhp(BuildContext context) {
    return Container(
      constraints: BoxConstraints(
        minHeight: SizeConfig.blockSizeVertical * 35,
        maxHeight: SizeConfig.blockSizeVertical * 90,
      ),
      child: ListMasterBhpPaket(
        selectedData: _consumable,
        idKategori: 4,
        title: 'CONSUMABLE',
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
          _sinkListConsumable();
        }
      },
    );
  }
}
