import 'package:admin_dokter_panggil/src/models/mr_pengkajian_dokter_model.dart';
import 'package:flutter/material.dart';

class MrRencanaTerapiForm extends StatefulWidget {
  const MrRencanaTerapiForm({
    super.key,
    this.idKunjungan,
    this.mrKunjunganRencanaTerapi,
  });

  final int? idKunjungan;
  final RencanaTerapi? mrKunjunganRencanaTerapi;

  @override
  State<MrRencanaTerapiForm> createState() => _MrRencanaTerapiFormState();
}

class _MrRencanaTerapiFormState extends State<MrRencanaTerapiForm> {
  RencanaTerapi? _rencanaTerapi;

  @override
  void initState() {
    super.initState();
    if (widget.mrKunjunganRencanaTerapi != null) {
      _rencanaTerapi = widget.mrKunjunganRencanaTerapi;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(22.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Rencana Terapi',
            style: TextStyle(fontSize: 13, color: Colors.grey),
          ),
          const SizedBox(
            height: 8,
          ),
          if (_rencanaTerapi == null)
            Text(
              '-',
              style: const TextStyle(fontSize: 15),
            )
          else
            Text(
              '${_rencanaTerapi?.rencanaTerapi}',
              style: const TextStyle(fontSize: 15),
            ),
        ],
      ),
    );
  }
}
