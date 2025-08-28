import 'dart:async';

import 'package:dokter_panggil/src/blocs/master_ruangan_bloc.dart';
import 'package:dokter_panggil/src/models/master_ruangan_model.dart';
import 'package:dokter_panggil/src/pages/components/close_button_widget.dart';
import 'package:dokter_panggil/src/pages/components/error_response.dart';
import 'package:dokter_panggil/src/pages/components/loading_kit.dart';
import 'package:dokter_panggil/src/repositories/responseApi/api_response.dart';
import 'package:dokter_panggil/src/source/config.dart';
import 'package:dokter_panggil/src/source/size_config.dart';
import 'package:flutter/material.dart';

class ListMasterRuanganPage extends StatefulWidget {
  const ListMasterRuanganPage({super.key});

  @override
  State<ListMasterRuanganPage> createState() => _ListMasterRuanganPageState();
}

class _ListMasterRuanganPageState extends State<ListMasterRuanganPage> {
  final _filter = TextEditingController();
  final _masterRuanganBloc = MasterRuanganBloc();
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _masterRuanganBloc.getMasterRuangan();
    _filter.addListener(_filterListen);
  }

  void _filterListen() {
    _timer?.cancel();
    if (_filter.text.length > 2) {
      //
    }
  }

  @override
  void dispose() {
    super.dispose();
    _filter.removeListener(_filterListen);
    _filter.dispose();
    _masterRuanganBloc.dispose();
  }

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return StreamBuilder<ApiResponse<MasterRuanganModel>>(
      stream: _masterRuanganBloc.masterRuanganStream,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          switch (snapshot.data!.status) {
            case Status.loading:
              return SizedBox(
                height: 200,
                child: Center(
                  child: LoadingKit(
                    color: kPrimaryColor,
                  ),
                ),
              );
            case Status.error:
              return ErrorResponse(
                message: snapshot.data!.message,
                onTap: () => Navigator.pop(context),
              );
            case Status.completed:
              return SafeArea(
                top: false,
                child: Container(
                  constraints: BoxConstraints(
                      minHeight: 300,
                      maxHeight: SizeConfig.blockSizeVertical * 80),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: EdgeInsetsGeometry.fromLTRB(22, 22, 22, 0),
                        child: Row(
                          children: [
                            Expanded(
                              child: Text(
                                'Pilih Ruangan',
                                style: TextStyle(
                                    fontSize: 20, fontWeight: FontWeight.w600),
                              ),
                            ),
                            CloseButtonWidget()
                          ],
                        ),
                      ),
                      ListView.separated(
                        shrinkWrap: true,
                        padding: EdgeInsets.all(22),
                        itemBuilder: (context, i) {
                          var ruangan = snapshot.data!.data!.data![i];
                          return ListTile(
                            onTap: () => Navigator.pop(context, ruangan),
                            title: Text('${ruangan.namaRuangan}'),
                            trailing: Icon(
                              Icons.keyboard_arrow_right_rounded,
                            ),
                          );
                        },
                        separatorBuilder: (context, i) => SizedBox(
                          height: 18,
                        ),
                        itemCount: snapshot.data!.data!.data!.length,
                      ),
                    ],
                  ),
                ),
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
