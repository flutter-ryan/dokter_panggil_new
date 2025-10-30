import 'package:admin_dokter_panggil/src/models/mr_pengkajian_telemedicine_model.dart';
import 'package:admin_dokter_panggil/src/repositories/responseApi/api_response.dart';
import 'package:flutter/material.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';

class MrLayananLanjutanTelemedicineForm extends StatefulWidget {
  const MrLayananLanjutanTelemedicineForm({
    super.key,
    this.idKunjungan,
    this.layananLanjutan,
  });

  final int? idKunjungan;
  final List<LayananLanjutan>? layananLanjutan;

  @override
  State<MrLayananLanjutanTelemedicineForm> createState() =>
      _MrLayananLanjutanTelemedicineFormState();
}

class _MrLayananLanjutanTelemedicineFormState
    extends State<MrLayananLanjutanTelemedicineForm> {
  @override
  Widget build(BuildContext context) {
    return Container();
  }
}
