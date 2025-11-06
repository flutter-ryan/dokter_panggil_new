import 'package:admin_dokter_panggil/src/blocs/mr_kunjungan_cppt_bloc.dart';
import 'package:admin_dokter_panggil/src/models/mr_kunjungan_cppt_model.dart';
import 'package:admin_dokter_panggil/src/models/mr_riwayat_kunjungan_model.dart';
import 'package:admin_dokter_panggil/src/pages/components/error_response.dart';
import 'package:admin_dokter_panggil/src/pages/components/loading_kit.dart';
import 'package:admin_dokter_panggil/src/pages/pasien/mr_riwayat_pasien/mr_cppt_list_widget.dart';
import 'package:admin_dokter_panggil/src/repositories/responseApi/api_response.dart';
import 'package:admin_dokter_panggil/src/source/color_style.dart';
import 'package:flutter/material.dart';

class MrCppt extends StatefulWidget {
  const MrCppt({
    super.key,
    this.riwayatKunjungan,
  });

  final MrRiwayatKunjungan? riwayatKunjungan;

  @override
  State<MrCppt> createState() => _MrCpptState();
}

class _MrCpptState extends State<MrCppt> {
  final _mrKunjunganCpptBloc = MrKunjunganCpptBloc();

  @override
  void initState() {
    super.initState();
    _getMrCppt();
  }

  void _getMrCppt() {
    _mrKunjunganCpptBloc.idKunjunganSink
        .add(widget.riwayatKunjungan!.idKunjungan!);
    _mrKunjunganCpptBloc.getCppt();
  }

  @override
  void dispose() {
    super.dispose();
    _mrKunjunganCpptBloc.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<ApiResponse<MrKunjunganCpptModel>>(
      stream: _mrKunjunganCpptBloc.cpptStream,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          switch (snapshot.data!.status) {
            case Status.loading:
              return const LoadingKit(
                color: kPrimaryColor,
              );
            case Status.error:
              return ErrorResponse(
                message: snapshot.data!.message,
                onTap: () {
                  _getMrCppt();
                  setState(() {});
                },
              );
            case Status.completed:
              return MrCpptWidget(
                dataDashboard: widget.riwayatKunjungan,
                data: snapshot.data!.data!.data,
              );
          }
        }
        return const SizedBox();
      },
    );
  }
}

class MrCpptWidget extends StatefulWidget {
  const MrCpptWidget({
    super.key,
    this.data,
    this.dataDashboard,
  });

  final List<DataCppt>? data;
  final MrRiwayatKunjungan? dataDashboard;

  @override
  State<MrCpptWidget> createState() => _MrCpptWidgetState();
}

class _MrCpptWidgetState extends State<MrCpptWidget> {
  List<DataCppt> _dataCppt = [];

  @override
  void initState() {
    super.initState();
    _dataCppt = widget.data!;
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 22.0),
          child: Column(
            children: [
              IntrinsicHeight(
                child: Container(
                  color: kBgRedLightColor,
                  child: const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 4.0),
                    child: Row(
                      children: [
                        Expanded(
                          flex: 3,
                          child: Padding(
                            padding: EdgeInsets.symmetric(
                                horizontal: 8.0, vertical: 12),
                            child: Text(
                              'Tgl/Jam',
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                          ),
                        ),
                        VerticalDivider(
                          width: 0,
                          color: Colors.grey,
                        ),
                        Expanded(
                          flex: 10,
                          child: Padding(
                            padding: EdgeInsets.symmetric(
                              horizontal: 8.0,
                              vertical: 12,
                            ),
                            child: Text(
                              'SOAP/SBAR',
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              Expanded(
                child: MrCpptListWidget(
                  dataCppt: _dataCppt,
                  dataDashboard: widget.dataDashboard,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class RowTtvCpptWidget extends StatelessWidget {
  const RowTtvCpptWidget({
    super.key,
    this.title,
    this.body,
    this.colorBody,
    this.colorText,
  });

  final String? title;
  final String? body;
  final Color? colorBody;
  final Color? colorText;

  @override
  Widget build(BuildContext context) {
    return IntrinsicHeight(
      child: Row(
        children: [
          Expanded(
            flex: 2,
            child: Container(
              color: Colors.grey[100],
              padding: EdgeInsets.symmetric(vertical: 4, horizontal: 8),
              child: Align(
                alignment: Alignment.topLeft,
                child: Text(
                  '$title',
                  style: TextStyle(
                    fontSize: 12,
                  ),
                ),
              ),
            ),
          ),
          VerticalDivider(
            color: Colors.black,
            width: 0,
          ),
          Expanded(
            flex: 3,
            child: Container(
              color: colorBody ?? Colors.grey[100],
              padding: EdgeInsets.symmetric(vertical: 4, horizontal: 8),
              child: Align(
                alignment: Alignment.topLeft,
                child: Text(
                  '$body',
                  style: TextStyle(
                      fontSize: 12,
                      color: colorText ?? Colors.black,
                      fontWeight: FontWeight.w600),
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}
