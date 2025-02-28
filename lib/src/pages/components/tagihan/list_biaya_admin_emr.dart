import 'package:dokter_panggil/src/models/master_biaya_admin_emr_model.dart';
import 'package:dokter_panggil/src/pages/components/loading_kit.dart';
import 'package:dokter_panggil/src/source/config.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class ListBiayaAdminEmr extends StatefulWidget {
  const ListBiayaAdminEmr({
    super.key,
    this.listBiaya,
    this.onSelected,
    this.subtotal,
  });

  final Function(List<MasterBiayaAdminEmr>? biayaAdmin)? onSelected;
  final List<MasterBiayaAdminEmr>? listBiaya;
  final int? subtotal;

  @override
  State<ListBiayaAdminEmr> createState() => _ListBiayaAdminEmrState();
}

class _ListBiayaAdminEmrState extends State<ListBiayaAdminEmr> {
  List<MasterBiayaAdminEmr> _listBiaya = [];
  final _noRupiah =
      NumberFormat.currency(symbol: '', locale: 'id', decimalDigits: 0);
  bool _isNilai = false;
  @override
  void initState() {
    super.initState();
    _getBiayaAdmin();
  }

  void _getBiayaAdmin() {
    Future.delayed(const Duration(milliseconds: 500), () {
      _listBiaya = widget.listBiaya!;
      widget.onSelected!(_listBiaya);
      setState(() {
        _isNilai = true;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    if (!_isNilai) {
      return SizedBox(
        height: 62,
        child: Center(
          child: LoadingKit(
            size: 32,
            color: kPrimaryColor,
          ),
        ),
      );
    }
    return Column(
      children: _listBiaya.map(
        (biaya) {
          int nilaiBiaya = biaya.nilai!;
          if (biaya.persen == 1) {
            nilaiBiaya = ((biaya.nilai! * widget.subtotal!) / 100).round();
          }
          return ListTile(
            title: Text('${biaya.deskripsi}'),
            contentPadding: EdgeInsets.zero,
            visualDensity: VisualDensity.compact,
            dense: true,
            trailing: SizedBox(
              width: 100,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Rp. ',
                    style: TextStyle(fontSize: 13.0),
                  ),
                  Text(
                    _noRupiah.format(nilaiBiaya),
                    style: TextStyle(fontSize: 13.0),
                  ),
                ],
              ),
            ),
          );
        },
      ).toList(),
    );
  }
}
