import 'package:admin_dokter_panggil/src/models/mr_pengkajian_dokter_model.dart';
import 'package:admin_dokter_panggil/src/pages/components/dashboard_sub_form_widget.dart';
import 'package:admin_dokter_panggil/src/pages/components/list_tile_data_widget.dart';
import 'package:flutter/material.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';

class MrTindakanForm extends StatefulWidget {
  const MrTindakanForm({
    super.key,
    this.idKunjungan,
    this.tindakan,
  });

  final int? idKunjungan;
  final List<MrKunjunganTindakan>? tindakan;

  @override
  State<MrTindakanForm> createState() => _MrTindakanFormState();
}

class _MrTindakanFormState extends State<MrTindakanForm> {
  final List<MrKunjunganTindakan> _tindakan = [];

  @override
  void initState() {
    super.initState();
    if (widget.tindakan != null) {
      _tindakan.addAll(widget.tindakan!);
    }
  }

  @override
  Widget build(BuildContext context) {
    return DashboardSubFormWidget(
      title: 'Tindakan',
      errorMessage: 'Data tindakan tidak tersedia',
      onAdd: null,
      dataCard: _tindakan.isEmpty
          ? null
          : Column(
              children: _tindakan
                  .map(
                    (tindakan) => ListTileDataWidget(
                      title: Text('${tindakan.namaTindakan}'),
                      subtitle: tindakan.foc == 1
                          ? Align(
                              alignment: Alignment.centerLeft,
                              child: Container(
                                width: 100,
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 4, vertical: 2),
                                decoration: BoxDecoration(
                                  color: Colors.green,
                                  borderRadius: BorderRadius.circular(22),
                                ),
                                child: const Center(
                                  child: Text(
                                    'Free of Charge',
                                    style: TextStyle(
                                        color: Colors.white, fontSize: 12),
                                  ),
                                ),
                              ),
                            )
                          : null,
                    ),
                  )
                  .toList(),
            ),
    );
  }
}
