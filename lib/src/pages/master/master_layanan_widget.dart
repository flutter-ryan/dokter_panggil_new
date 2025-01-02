import 'package:dokter_panggil/src/blocs/master_layanan_bloc.dart';
import 'package:dokter_panggil/src/models/master_layanan_model.dart';
import 'package:dokter_panggil/src/pages/components/error_response.dart';
import 'package:dokter_panggil/src/pages/components/loading_kit.dart';
import 'package:dokter_panggil/src/repositories/responseApi/api_response.dart';
import 'package:dokter_panggil/src/source/config.dart';
import 'package:flutter/material.dart';

class MasterLayananWidget extends StatefulWidget {
  const MasterLayananWidget({super.key});

  @override
  State<MasterLayananWidget> createState() => _MasterLayananWidgetState();
}

class _MasterLayananWidgetState extends State<MasterLayananWidget> {
  final _masterLayananBloc = MasterLayananBloc();

  @override
  void initState() {
    super.initState();
    _masterLayananBloc.getLayanan();
  }

  @override
  void dispose() {
    super.dispose();
    _masterLayananBloc.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<ApiResponse<MasterLayananModel>>(
      stream: _masterLayananBloc.masterLayananStream,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          switch (snapshot.data!.status) {
            case Status.loading:
              return const SizedBox(
                height: 200,
                child: LoadingKit(
                  color: kPrimaryColor,
                ),
              );
            case Status.error:
              return ErrorResponse(
                message: snapshot.data!.message,
                onTap: () {
                  _masterLayananBloc.getLayanan();
                  setState(() {});
                },
              );
            case Status.completed:
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Padding(
                    padding: EdgeInsets.fromLTRB(22, 12, 22, 18),
                    child: Text(
                      'Pilih Layanan',
                      style:
                          TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
                    ),
                  ),
                  Flexible(
                    child: ListView.separated(
                      shrinkWrap: true,
                      itemBuilder: (context, i) {
                        var layanan = snapshot.data!.data!.data[i];
                        return ListTile(
                          onTap: () => Navigator.pop(context, layanan),
                          contentPadding: const EdgeInsets.symmetric(
                              horizontal: 28, vertical: 4),
                          title: Text(
                            '${layanan.namaLayanan}',
                          ),
                        );
                      },
                      separatorBuilder: (context, i) => const Divider(
                        height: 0,
                      ),
                      itemCount: snapshot.data!.data!.data.length,
                    ),
                  ),
                ],
              );
          }
        }
        return const SizedBox(
          height: 200,
        );
      },
    );
  }
}
