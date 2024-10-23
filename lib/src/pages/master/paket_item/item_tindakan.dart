import 'package:cart_stepper/cart_stepper.dart';
import 'package:dokter_panggil/src/blocs/master_paket_bloc.dart';
import 'package:dokter_panggil/src/models/master_paket_create_model.dart';
import 'package:dokter_panggil/src/models/tindakan_paket_selected_model.dart';
import 'package:dokter_panggil/src/pages/components/card_paket_widget.dart';
import 'package:dokter_panggil/src/pages/components/confirm_dialog.dart';
import 'package:dokter_panggil/src/pages/master/list_master_tindakan_paket.dart';
import 'package:dokter_panggil/src/source/config.dart';
import 'package:dokter_panggil/src/source/size_config.dart';
import 'package:flutter/material.dart';
import 'package:dokter_panggil/src/source/transition/animated_dialog.dart';
import 'package:intl/intl.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';

class ItemTindakan extends StatefulWidget {
  const ItemTindakan({
    super.key,
    required this.bloc,
    this.data,
    this.total,
  });

  final MasterPaketBloc bloc;
  final List<PaketTindakan>? data;
  final Function(List<TindakanPaketSelected> data)? total;

  @override
  State<ItemTindakan> createState() => _ItemTindakanState();
}

class _ItemTindakanState extends State<ItemTindakan> {
  List<TindakanPaketSelected> _tindakan = [];
  late MasterPaketBloc _masterPaketBloc;
  final _rupiah =
      NumberFormat.currency(locale: 'id', symbol: '', decimalDigits: 0);

  @override
  void initState() {
    super.initState();
    _masterPaketBloc = widget.bloc;
  }

  void _edit() {
    _tindakan = [];
    widget.data?.asMap().forEach((key, tindakan) {
      _tindakan.add(
        TindakanPaketSelected(
          id: tindakan.id,
          namaTindakan: tindakan.namaTindakan,
          jumlah: tindakan.qty!,
          tarif: tindakan.tarif!,
          total: tindakan.qty! * tindakan.tarif!,
          isDokter: tindakan.isDokter == 1 ? true : false,
        ),
      );
    });
    _sinkListTindakan();
  }

  void _showMasterTindakan(String jenis) {
    showMaterialModalBottomSheet(
      context: context,
      builder: (context) => Padding(
        padding:
            EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
        child: _streamListTindakan(context, jenis),
      ),
      duration: const Duration(milliseconds: 500),
    ).then((value) {
      if (value != null) {
        var data = value as List<TindakanPaketSelected>;
        setState(() {
          _tindakan.addAll(data);
        });
        _sinkListTindakan();
      }
    });
  }

  void _deleteTindakan(TindakanPaketSelected? tindakan) {
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
            _tindakan.removeWhere((e) => e.id == tindakan!.id);
          });
          _sinkListTindakan();
        });
      }
    });
  }

  void _sinkListTindakan() {
    List<int> quantity = [];
    List<int> tindakan = [];
    List<bool> isDokter = [];
    _tindakan.asMap().forEach((key, selected) {
      quantity.add(selected.jumlah);
      tindakan.add(selected.id!);
      isDokter.add(selected.isDokter);
    });
    _masterPaketBloc.tindakanSink.add(tindakan);
    _masterPaketBloc.jumlahTindakanSink.add(quantity);
    _masterPaketBloc.isDokterSink.add(isDokter);
    Future.delayed(const Duration(milliseconds: 500), () {
      widget.total!(_tindakan);
    });
  }

  @override
  void didUpdateWidget(covariant ItemTindakan oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.data != widget.data) {
      _edit();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        _tindakanDokterWidget(context),
        const SizedBox(
          height: 12.0,
        ),
        _tindakanPerawatWidget(context),
      ],
    );
  }

  Widget _tindakanDokterWidget(BuildContext context) {
    return CardPaketWidget(
      title: 'TINDAKAN DOKTER',
      onTap: () => _showMasterTindakan('dokter'),
      data: _tindakan.where((e) => e.isDokter).isEmpty
          ? null
          : Column(
              children: [
                Column(
                  children: ListTile.divideTiles(
                    context: context,
                    tiles: _tindakan
                        .where((e) => e.isDokter == true)
                        .map(
                          (tindakan) => Padding(
                            padding: const EdgeInsets.symmetric(vertical: 15.0),
                            child: ListTile(
                              contentPadding:
                                  const EdgeInsets.symmetric(horizontal: 15.0),
                              title: Row(
                                children: [
                                  Expanded(
                                    child: Text('${tindakan.namaTindakan}'),
                                  ),
                                  const SizedBox(
                                    width: 12.0,
                                  ),
                                  Text(_rupiah.format(tindakan.total))
                                ],
                              ),
                              subtitle: Padding(
                                padding: const EdgeInsets.only(top: 10.0),
                                child: Row(
                                  children: [
                                    Expanded(
                                      child: Row(
                                        children: [
                                          const Text('Qty: '),
                                          const SizedBox(
                                            width: 12.0,
                                          ),
                                          _buildCounter(context, tindakan),
                                        ],
                                      ),
                                    ),
                                    IconButton(
                                      onPressed: () =>
                                          _deleteTindakan(tindakan),
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

  Widget _tindakanPerawatWidget(BuildContext context) {
    return CardPaketWidget(
      title: 'TINDAKAN PERAWAT',
      onTap: () => _showMasterTindakan('perawat'),
      data: _tindakan.where((e) => !e.isDokter).isEmpty
          ? null
          : Column(
              children: [
                Column(
                  children: ListTile.divideTiles(
                    context: context,
                    tiles: _tindakan
                        .where((e) => !e.isDokter)
                        .map(
                          (tindakan) => Padding(
                            padding: const EdgeInsets.symmetric(vertical: 15.0),
                            child: ListTile(
                              contentPadding:
                                  const EdgeInsets.symmetric(horizontal: 15.0),
                              title: Row(
                                children: [
                                  Expanded(
                                    child: Text('${tindakan.namaTindakan}'),
                                  ),
                                  const SizedBox(
                                    width: 12.0,
                                  ),
                                  Text(_rupiah.format(tindakan.total))
                                ],
                              ),
                              subtitle: Padding(
                                padding: const EdgeInsets.only(top: 10.0),
                                child: Row(
                                  children: [
                                    Expanded(
                                      child: Row(
                                        children: [
                                          const Text('Qty: '),
                                          const SizedBox(
                                            width: 12.0,
                                          ),
                                          _buildCounter(context, tindakan),
                                        ],
                                      ),
                                    ),
                                    IconButton(
                                      onPressed: () =>
                                          _deleteTindakan(tindakan),
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

  Widget _streamListTindakan(BuildContext context, String jenis) {
    return Container(
      constraints: BoxConstraints(
        minHeight: SizeConfig.blockSizeVertical * 35,
        maxHeight: SizeConfig.blockSizeVertical * 80,
      ),
      child: ListMasterTindakanPaket(
        selectedData: _tindakan,
        jenis: jenis,
      ),
    );
  }

  Widget _buildCounter(BuildContext context, TindakanPaketSelected data) {
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
            data.total = count * data.tarif;
          });
          _sinkListTindakan();
        }
      },
    );
  }
}
