import 'package:admin_dokter_panggil/src/blocs/new_resume_medis_pasien_bloc.dart';
import 'package:admin_dokter_panggil/src/models/new_resume_medis_pasien_model.dart';
import 'package:admin_dokter_panggil/src/pages/components/error_response.dart';
import 'package:admin_dokter_panggil/src/pages/components/loading_kit.dart';
import 'package:admin_dokter_panggil/src/pages/pasien/resume_medis_page.dart';
import 'package:admin_dokter_panggil/src/repositories/responseApi/api_response.dart';
import 'package:admin_dokter_panggil/src/source/color_style.dart';
import 'package:flutter/material.dart';

class ResumeNonmrPage extends StatefulWidget {
  const ResumeNonmrPage({
    super.key,
    this.idKunjungan,
  });

  final int? idKunjungan;

  @override
  State<ResumeNonmrPage> createState() => _ResumeNonmrPageState();
}

class _ResumeNonmrPageState extends State<ResumeNonmrPage> {
  final _newResumeMedisPasienBloc = NewResumeMedisPasienBloc();

  @override
  void initState() {
    super.initState();
    _getRiwayatKunjungan();
  }

  void _getRiwayatKunjungan() {
    _newResumeMedisPasienBloc.idKunjunganSink.add(widget.idKunjungan!);
    _newResumeMedisPasienBloc.getResumePasien();
  }

  @override
  void dispose() {
    super.dispose();
    _newResumeMedisPasienBloc.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _streamResumeNonmrWidget(context),
    );
  }

  Widget _streamResumeNonmrWidget(BuildContext context) {
    return StreamBuilder<ApiResponse<NewResumeMedisPasienModel>>(
      stream: _newResumeMedisPasienBloc.newResumePaienStream,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          switch (snapshot.data!.status) {
            case Status.loading:
              return Center(
                child: LoadingKit(
                  color: kPrimaryColor,
                ),
              );
            case Status.error:
              return ErrorResponse(
                message: snapshot.data!.message,
                onTap: () {
                  _getRiwayatKunjungan();
                  setState(() {});
                },
              );
            case Status.completed:
              return ResumeMedisPage(
                data: snapshot.data!.data!.data,
              );
          }
        }
        return const SizedBox();
      },
    );
  }
}
