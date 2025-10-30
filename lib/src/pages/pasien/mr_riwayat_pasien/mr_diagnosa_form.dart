import 'package:admin_dokter_panggil/src/models/mr_pengkajian_dokter_model.dart';
import 'package:admin_dokter_panggil/src/pages/components/dashboard_sub_form_widget.dart';
import 'package:admin_dokter_panggil/src/source/color_style.dart';
import 'package:flutter/material.dart';

class MrDiagnosaForm extends StatefulWidget {
  const MrDiagnosaForm({
    super.key,
    this.idKunjungan,
    this.mrDiagnosaDokter,
    this.mrDiagnosaIcdDokter,
  });

  final int? idKunjungan;
  final MrDiagnosaDokter? mrDiagnosaDokter;
  final MrDiagnosaIcdDokter? mrDiagnosaIcdDokter;

  @override
  State<MrDiagnosaForm> createState() => _MrDiagnosaFormState();
}

class _MrDiagnosaFormState extends State<MrDiagnosaForm> {
  MrDiagnosaIcdDokter? _mrDiagnosaIcdDokter;
  MrDiagnosaDokter? _mrDiagnosaDokter;

  @override
  void initState() {
    super.initState();
    if (widget.mrDiagnosaIcdDokter != null) {
      _mrDiagnosaIcdDokter = widget.mrDiagnosaIcdDokter;
    }
    if (widget.mrDiagnosaDokter != null) {
      _mrDiagnosaDokter = widget.mrDiagnosaDokter;
    }
  }

  @override
  Widget build(BuildContext context) {
    return DashboardSubFormWidget(
      title: 'Diagnosa ICD 10',
      errorMessage: 'Data diagnosa tidak tersedia',
      isAdd: _mrDiagnosaIcdDokter == null && _mrDiagnosaDokter == null,
      onAdd: null,
      dataCard: _mrDiagnosaIcdDokter == null && _mrDiagnosaDokter == null
          ? null
          : Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Column(
                  children: [
                    if (_mrDiagnosaDokter!.diagnosas!.isNotEmpty)
                      ..._mrDiagnosaDokter!.diagnosas!
                          .map((diagnosa) => DiagnosaCard(
                                title: Text(
                                    '${diagnosa.kodeIcd10} - ${diagnosa.namaDiagnosa}'),
                                subtitle: Text(
                                  '${diagnosa.type}',
                                  style: TextStyle(
                                    color: diagnosa.type == 'Primary'
                                        ? kGreenColor
                                        : Colors.orange,
                                    fontSize: 12,
                                  ),
                                ),
                              )),
                    if (_mrDiagnosaIcdDokter!.diagnosas!.isNotEmpty)
                      ..._mrDiagnosaIcdDokter!.diagnosas!.map(
                        (diagnosa) => DiagnosaCard(
                          title: Text('${diagnosa.code} - ${diagnosa.display}'),
                          subtitle: Text(
                            '${diagnosa.type}',
                            style: TextStyle(
                              color: diagnosa.type == 'Primary'
                                  ? kGreenColor
                                  : Colors.orange,
                              fontSize: 12,
                            ),
                          ),
                        ),
                      )
                  ],
                ),
                if (_mrDiagnosaIcdDokter!.catatan != null)
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
                        '${_mrDiagnosaIcdDokter!.catatan}',
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

class DiagnosaCard extends StatelessWidget {
  const DiagnosaCard({
    super.key,
    this.title,
    this.subtitle,
  });

  final Widget? title;
  final Widget? subtitle;

  @override
  Widget build(BuildContext context) {
    return ListTile(
        contentPadding: const EdgeInsets.symmetric(vertical: 0),
        leading: const Icon(
          Icons.arrow_right_rounded,
        ),
        horizontalTitleGap: 8,
        minLeadingWidth: 0,
        title: title,
        subtitle: subtitle);
  }
}
