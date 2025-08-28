import 'package:dokter_panggil/src/blocs/master_status_nikah_bloc.dart';
import 'package:dokter_panggil/src/models/master_status_nikah_model.dart';
import 'package:dokter_panggil/src/pages/components/close_button_widget.dart';
import 'package:dokter_panggil/src/pages/components/error_response.dart';
import 'package:dokter_panggil/src/pages/components/loading_kit.dart';
import 'package:dokter_panggil/src/repositories/responseApi/api_response.dart';
import 'package:dokter_panggil/src/source/config.dart';
import 'package:dokter_panggil/src/source/size_config.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class ListMasterStatusNikah extends StatefulWidget {
  const ListMasterStatusNikah({super.key});

  @override
  State<ListMasterStatusNikah> createState() => _ListMasterStatusNikahState();
}

class _ListMasterStatusNikahState extends State<ListMasterStatusNikah> {
  final _masterStatusNikahBloc = MasterStatusNikahBloc();

  @override
  void initState() {
    super.initState();
    _getMasterStatusNikah();
  }

  void _getMasterStatusNikah() {
    _masterStatusNikahBloc.getMasterStatusNikah();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      top: false,
      child: ConstrainedBox(
        constraints: BoxConstraints(
            minHeight: 200, maxHeight: SizeConfig.blockSizeVertical * 90),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Padding(
              padding: EdgeInsetsGeometry.all(22),
              child: Row(
                children: [
                  Expanded(
                    child: Text(
                      'Pilih Status Nikah',
                      style:
                          TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
                    ),
                  ),
                  CloseButtonWidget()
                ],
              ),
            ),
            _buildStreamMasterStatusNikah(context),
          ],
        ),
      ),
    );
  }

  Widget _buildStreamMasterStatusNikah(BuildContext context) {
    return StreamBuilder<ApiResponse<MasterStatusNikahModel>>(
      stream: _masterStatusNikahBloc.masterStatusNikahStream,
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
              return Column(
                  mainAxisSize: MainAxisSize.min,
                  children: ListTile.divideTiles(
                    context: context,
                    tiles: snapshot.data!.data!.data!.map((status) {
                      return ListTile(
                        onTap: () => Navigator.pop(context, status),
                        contentPadding: EdgeInsets.symmetric(horizontal: 22),
                        leading: SvgPicture.asset(
                          'images/status.svg',
                          height: 28,
                          colorFilter:
                              ColorFilter.mode(Colors.grey, BlendMode.srcATop),
                        ),
                        minLeadingWidth: 20,
                        title: Text('${status.deskripsi}'),
                        trailing: Icon(Icons.keyboard_arrow_right_rounded),
                      );
                    }).toList(),
                  ).toList());
          }
        }
        return const SizedBox();
      },
    );
  }
}
