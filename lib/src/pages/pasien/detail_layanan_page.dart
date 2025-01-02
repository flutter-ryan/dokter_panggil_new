import 'package:dokter_panggil/src/blocs/pasien_kunjungan_detail_bloc.dart';
import 'package:dokter_panggil/src/models/pasien_kunjungan_detail_model.dart';
import 'package:dokter_panggil/src/pages/components/detail_layanan_widget.dart';
import 'package:dokter_panggil/src/pages/components/error_response.dart';
import 'package:dokter_panggil/src/pages/components/loading_kit.dart';
import 'package:dokter_panggil/src/repositories/responseApi/api_response.dart';
import 'package:dokter_panggil/src/source/config.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class DetailLayananPage extends StatefulWidget {
  const DetailLayananPage({
    super.key,
    required this.id,
    this.type = 'create',
    this.role,
  });

  final int id;
  final String type;
  final int? role;

  @override
  State<DetailLayananPage> createState() => _DetailLayananPageState();
}

class _DetailLayananPageState extends State<DetailLayananPage> {
  final _pasienKunjunganDetailBloc = PasienKunjunganDetailBloc();

  @override
  void initState() {
    super.initState();
    print('role: ${widget.role}');
    _pasienKunjunganDetailBloc.idKunjunganSink.add(widget.id);
    _pasienKunjunganDetailBloc.kunjunganDetail();
  }

  void _reload() {
    _pasienKunjunganDetailBloc.idKunjunganSink.add(widget.id);
    _pasienKunjunganDetailBloc.kunjunganDetail();
    setState(() {});
  }

  @override
  void dispose() {
    _pasienKunjunganDetailBloc.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blueGrey[50],
      appBar: AppBar(
        elevation: 0.0,
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        title: const Text('Detail kunjungan'),
        systemOverlayStyle: const SystemUiOverlayStyle(
          statusBarColor: Colors.transparent,
          statusBarBrightness: Brightness.light,
          statusBarIconBrightness: Brightness.dark,
          systemNavigationBarColor: Colors.white,
        ),
      ),
      body: _streamKunjunganDetail(),
    );
  }

  Widget _streamKunjunganDetail() {
    return StreamBuilder<ApiResponse<PasienKunjunganDetailModel>>(
      stream: _pasienKunjunganDetailBloc.kunjunganDetailStream,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          switch (snapshot.data!.status) {
            case Status.loading:
              return const Center(
                child: LoadingKit(
                  color: kPrimaryColor,
                ),
              );
            case Status.error:
              return Center(
                child: ErrorResponse(
                  message: snapshot.data!.message,
                  onTap: () {
                    _pasienKunjunganDetailBloc.kunjunganDetail();
                    setState(() {});
                  },
                ),
              );
            case Status.completed:
              var data = snapshot.data!.data!.detail!;
              return DetailLayananWidget(
                data: data,
                id: widget.id,
                type: widget.type,
                onReload: _reload,
                role: widget.role,
              );
          }
        }
        return const SizedBox();
      },
    );
  }
}
