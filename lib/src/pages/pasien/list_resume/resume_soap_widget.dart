import 'package:admin_dokter_panggil/src/blocs/resume_soap_bloc.dart';
import 'package:admin_dokter_panggil/src/models/resume_soap_model.dart';
import 'package:admin_dokter_panggil/src/pages/components/loading_kit.dart';
import 'package:admin_dokter_panggil/src/repositories/responseApi/api_response.dart';
import 'package:admin_dokter_panggil/src/source/config.dart';
import 'package:admin_dokter_panggil/src/pages/components/error_response.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class ResumeSoapWidget extends StatefulWidget {
  const ResumeSoapWidget({
    super.key,
    this.idKunjungan,
    this.idPetugas,
  });

  final int? idKunjungan;
  final int? idPetugas;

  @override
  State<ResumeSoapWidget> createState() => _ResumeSoapWidgetState();
}

class _ResumeSoapWidgetState extends State<ResumeSoapWidget> {
  final _resumeSoapBloc = ResumeSoapBloc();

  @override
  void initState() {
    super.initState();
    _resumeSoapBloc.idKunjuganSink.add(widget.idKunjungan!);
    _resumeSoapBloc.idPetugasSink.add(widget.idPetugas!);
    _resumeSoapBloc.getResumeSoap();
  }

  @override
  void dispose() {
    _resumeSoapBloc.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<ApiResponse<ResponseResumeSoapModel>>(
        stream: _resumeSoapBloc.resumeSoapStream,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            switch (snapshot.data!.status) {
              case Status.loading:
                return const Center(
                  child: LoadingKit(color: kPrimaryColor),
                );
              case Status.error:
                return ErrorResponse(
                  message: snapshot.data!.message,
                  onTap: () {
                    _resumeSoapBloc.getResumeSoap();
                    setState(() {});
                  },
                );
              case Status.completed:
                return ListView.separated(
                  padding: const EdgeInsets.symmetric(
                      vertical: 32.0, horizontal: 22),
                  itemBuilder: (context, i) {
                    var data = snapshot.data!.data!.data![i];
                    return Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(12),
                        boxShadow: const [
                          BoxShadow(
                            color: Colors.black12,
                            blurRadius: 12,
                            offset: Offset(2.0, 2.0),
                          )
                        ],
                      ),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(18.0),
                            child: Row(
                              children: [
                                const Icon(FontAwesomeIcons.calendarPlus),
                                const SizedBox(
                                  width: 12.0,
                                ),
                                Text('${data.tanggal}'),
                              ],
                            ),
                          ),
                          const Divider(
                            height: 0,
                          ),
                          ListTile(
                            title: const Text('Objektif'),
                            subtitle: Text('${data.objective}'),
                          ),
                          ListTile(
                            title: const Text('Subjektif'),
                            subtitle: Text('${data.subjective}'),
                          ),
                          ListTile(
                            title: const Text('Assesment'),
                            subtitle: Text('${data.assesment}'),
                          ),
                          ListTile(
                            title: const Text('Planning'),
                            subtitle: Text('${data.planning}'),
                          ),
                          ListTile(
                            title: const Text('Instruksi'),
                            subtitle: Text('${data.instruksi}'),
                          ),
                        ],
                      ),
                    );
                  },
                  separatorBuilder: (context, i) => const SizedBox(
                    height: 18.0,
                  ),
                  itemCount: snapshot.data!.data!.data!.length,
                );
            }
          }
          return const SizedBox();
        });
  }
}
