import 'package:admin_dokter_panggil/src/pages/components/dashboard_sub_form_widget.dart';
import 'package:flutter/material.dart';

class MrTindakanLanjutanForm extends StatefulWidget {
  const MrTindakanLanjutanForm({
    super.key,
    this.idKunjungan,
    this.layananLanjutan,
  });

  final int? idKunjungan;
  final List<String>? layananLanjutan;

  @override
  State<MrTindakanLanjutanForm> createState() => _MrTindakanLanjutanFormState();
}

class _MrTindakanLanjutanFormState extends State<MrTindakanLanjutanForm> {
  List<String> _layananLanjutan = [];

  @override
  void initState() {
    super.initState();
    if (widget.layananLanjutan != null) {
      _layananLanjutan = widget.layananLanjutan!;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        if (widget.layananLanjutan != null)
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 12.0),
            child: DashboardSubFormWidget(
              title: 'Tindakan Lanjutan',
              dataCard: _layananLanjutan.isEmpty
                  ? const ListTile(
                      contentPadding: EdgeInsets.symmetric(vertical: 4),
                      leading: Icon(
                        Icons.arrow_right_rounded,
                      ),
                      horizontalTitleGap: 8,
                      minLeadingWidth: 0,
                      title: Text('Selesai layanan'),
                    )
                  : Column(
                      children: widget.layananLanjutan!
                          .map(
                            (lanjutan) => ListTile(
                              contentPadding:
                                  const EdgeInsets.symmetric(vertical: 4),
                              leading: const Icon(
                                Icons.arrow_right_rounded,
                              ),
                              horizontalTitleGap: 8,
                              minLeadingWidth: 0,
                              title: Text(lanjutan),
                            ),
                          )
                          .toList(),
                    ),
            ),
          ),
      ],
    );
  }
}
