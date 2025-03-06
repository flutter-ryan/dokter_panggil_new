import 'package:dokter_panggil/src/blocs/pegawai_profesi_bloc.dart';
import 'package:dokter_panggil/src/models/pegawai_dokter_model.dart';
import 'package:dokter_panggil/src/pages/components/error_response.dart';
import 'package:dokter_panggil/src/pages/components/loading_kit.dart';
import 'package:dokter_panggil/src/repositories/responseApi/api_response.dart';
import 'package:dokter_panggil/src/source/config.dart';
import 'package:flutter/material.dart';

class PilihPetugasPage extends StatefulWidget {
  const PilihPetugasPage({
    super.key,
    this.idGroup = 1,
  });

  final int idGroup;

  @override
  State<PilihPetugasPage> createState() => _PilihPetugasPageState();
}

class _PilihPetugasPageState extends State<PilihPetugasPage> {
  final _pegawaiProfesiBloc = PegawaiProfesiBloc();

  @override
  void initState() {
    super.initState();
    _pegawaiProfesiBloc.groupIdSink.add(widget.idGroup);
    _pegawaiProfesiBloc.pegawaiProfesi();
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<ApiResponse<PegawaiProfesiModel>>(
      stream: _pegawaiProfesiBloc.pegawaiProfesiStream,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          switch (snapshot.data!.status) {
            case Status.loading:
              return const SizedBox(
                height: 150,
                child: Center(
                  child: LoadingKit(
                    color: kPrimaryColor,
                  ),
                ),
              );
            case Status.error:
              return SizedBox(
                height: 250,
                child: Center(
                  child: ErrorResponse(
                    message: snapshot.data!.message,
                    onTap: () {
                      _pegawaiProfesiBloc.pegawaiProfesi();
                      setState(() {});
                    },
                  ),
                ),
              );
            case Status.completed:
              return Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(22.0),
                    child: Row(
                      children: [
                        Expanded(
                          child: Text(
                            'Pilih Petugas',
                            style: const TextStyle(
                              fontSize: 20.0,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                        CloseButton(
                          color: Colors.grey,
                        ),
                      ],
                    ),
                  ),
                  Flexible(
                    child: ListView.separated(
                      padding: const EdgeInsets.symmetric(horizontal: 22.0),
                      shrinkWrap: true,
                      itemBuilder: (context, i) {
                        var data = snapshot.data!.data!.profesi![i];
                        return ListTile(
                          onTap: () => Navigator.pop(context, data),
                          contentPadding: EdgeInsets.zero,
                          title: Text('${data.nama}'),
                        );
                      },
                      separatorBuilder: (context, i) => const Divider(
                        height: 0,
                      ),
                      itemCount: snapshot.data!.data!.profesi!.length,
                    ),
                  ),
                ],
              );
          }
        }
        return const SizedBox();
      },
    );
  }
}
