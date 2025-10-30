import 'package:admin_dokter_panggil/src/models/mr_pengkajian_dokter_model.dart';
import 'package:admin_dokter_panggil/src/pages/components/dashboard_sub_form_widget.dart';
import 'package:admin_dokter_panggil/src/source/color_style.dart';
import 'package:flutter/material.dart';

class MrProsedurForm extends StatefulWidget {
  const MrProsedurForm({
    super.key,
    this.idKunjungan,
    this.mrProsedur,
  });

  final int? idKunjungan;
  final MrProsedur? mrProsedur;

  @override
  State<MrProsedurForm> createState() => _MrProsedurFormState();
}

class _MrProsedurFormState extends State<MrProsedurForm> {
  MrProsedur? _prosedur;

  @override
  void initState() {
    super.initState();
    if (widget.mrProsedur != null) {
      _prosedur = widget.mrProsedur;
    }
  }

  @override
  Widget build(BuildContext context) {
    return DashboardSubFormWidget(
      title: 'Diagnosa ICD 9',
      isAdd: _prosedur == null,
      errorMessage: 'Data Diagnosa tidak tersedia',
      onAdd: null,
      dataCard: _prosedur == null
          ? null
          : Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Column(
                  children: _prosedur!.prosedur!
                      .map(
                        (prosedur) => ListTile(
                          contentPadding:
                              const EdgeInsets.symmetric(vertical: 0),
                          leading: const Icon(
                            Icons.keyboard_arrow_right_rounded,
                            size: 18.0,
                          ),
                          horizontalTitleGap: 8,
                          minLeadingWidth: 0,
                          title: Text('${prosedur.prosedur}'),
                          subtitle: Text(
                            '${prosedur.type}',
                            style: TextStyle(
                              color: prosedur.type == 'Primary'
                                  ? kGreenColor
                                  : Colors.orange,
                            ),
                          ),
                        ),
                      )
                      .toList(),
                ),
                if (_prosedur!.catatan != null)
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Padding(
                        padding: EdgeInsets.symmetric(vertical: 4.0),
                        child: Text(
                          'Catatan',
                          style: TextStyle(fontSize: 13, color: Colors.grey),
                        ),
                      ),
                      Text(
                        '${_prosedur!.catatan}',
                      ),
                      const SizedBox(
                        height: 12.0,
                      ),
                    ],
                  ),
              ],
            ),
    );
  }
}
