import 'package:admin_dokter_panggil/src/blocs/mr_kunjungan_cppt_bloc.dart';
import 'package:admin_dokter_panggil/src/models/mr_kunjungan_cppt_model.dart';
import 'package:admin_dokter_panggil/src/models/mr_riwayat_detail_model.dart';
import 'package:admin_dokter_panggil/src/pages/components/error_response.dart';
import 'package:admin_dokter_panggil/src/pages/components/loading_kit.dart';
import 'package:admin_dokter_panggil/src/repositories/responseApi/api_response.dart';
import 'package:admin_dokter_panggil/src/source/color_style.dart';
import 'package:flutter/material.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';

class MrCppt extends StatefulWidget {
  const MrCppt({
    super.key,
    this.data,
  });

  final MrRiwayatDetail? data;

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
    _mrKunjunganCpptBloc.idKunjunganSink.add(widget.data!.id!);
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
                dataDashboard: widget.data,
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
  final MrRiwayatDetail? dataDashboard;

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
                  controller: _controller,
                ),
              ),
            ],
          ),
        ),
        if (widget.dataDashboard!.isPerawat! || widget.dataDashboard!.isDokter!)
          StreamBuilder<ScrollButtonState>(
            stream: _scrollBloc.state,
            initialData: ScrollButtonState(isVisible: true),
            builder: (context, snapshot) => Positioned(
              bottom: 18,
              right: 18,
              child: AnimatedSlide(
                duration: const Duration(milliseconds: 300),
                offset:
                    snapshot.data!.isVisible ? Offset.zero : const Offset(0, 2),
                child: AnimatedOpacity(
                  opacity: snapshot.data!.isVisible ? 1 : 0,
                  duration: const Duration(milliseconds: 300),
                  child: FloatingActionButton(
                    onPressed: _pilihanCppt,
                    backgroundColor: kSecondaryColor,
                    child: const Icon(
                      Icons.add_rounded,
                      size: 28,
                    ),
                  ),
                ),
              ),
            ),
          )
      ],
    );
  }

  Widget _pilihanCpptWidget(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Padding(
          padding: EdgeInsets.all(22.0),
          child: Text(
            'Pilih Salah Satu',
            style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),
          ),
        ),
        ListTile(
          title: const Text('SOAP'),
          onTap: () => Navigator.pop(context, 'soap'),
          contentPadding:
              const EdgeInsets.symmetric(horizontal: 32.0, vertical: 8.0),
          trailing: const Icon(Icons.keyboard_arrow_right_rounded),
        ),
        const Divider(
          height: 0,
        ),
        ListTile(
          title: const Text('TBAK SBAR'),
          onTap: () => Navigator.pop(context, 'tbak'),
          contentPadding:
              const EdgeInsets.symmetric(horizontal: 32.0, vertical: 8.0),
          trailing: const Icon(Icons.keyboard_arrow_right_rounded),
        ),
        SizedBox(
          height: MediaQuery.of(context).padding.bottom,
        )
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
