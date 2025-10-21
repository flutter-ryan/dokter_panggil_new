import 'package:admin_dokter_panggil/src/blocs/mr_master_skrining_bloc.dart';
import 'package:admin_dokter_panggil/src/models/mr_master_skrining_model.dart';
import 'package:admin_dokter_panggil/src/pages/components/error_response.dart';
import 'package:admin_dokter_panggil/src/pages/components/loading_kit.dart';
import 'package:admin_dokter_panggil/src/repositories/responseApi/api_response.dart';
import 'package:admin_dokter_panggil/src/source/config.dart';
import 'package:flutter/material.dart';

class FormSkriningWidget extends StatefulWidget {
  const FormSkriningWidget({super.key});

  @override
  State<FormSkriningWidget> createState() => _FormSkriningWidgetState();
}

class _FormSkriningWidgetState extends State<FormSkriningWidget> {
  final _mrMasterSkriningBloc = MrMasterSkriningBloc();

  @override
  void initState() {
    super.initState();
    _mrMasterSkriningBloc.getMasterSkrining();
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<ApiResponse<MrMasterSkriningModel>>(
      stream: _mrMasterSkriningBloc.masterSkriningStream,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          switch (snapshot.data!.status) {
            case Status.loading:
              return const SizedBox(
                height: 200,
                child: LoadingKit(
                  color: kPrimaryColor,
                  size: 42,
                ),
              );
            case Status.error:
              return ErrorResponse(
                message: snapshot.data!.message,
                onTap: () {
                  _mrMasterSkriningBloc.getMasterSkrining();
                  setState(() {});
                },
              );
            case Status.completed:
              return Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(
                    height: 12.0,
                  ),
                  const Padding(
                    padding: EdgeInsets.all(22.0),
                    child: Text(
                      'Pilih Skrining',
                      style:
                          TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
                    ),
                  ),
                  Flexible(
                    child: ListView.separated(
                      padding: const EdgeInsets.fromLTRB(18.0, 0.0, 18.0, 22.0),
                      shrinkWrap: true,
                      itemBuilder: (context, i) {
                        var skrining = snapshot.data!.data!.data![i];
                        return ListTile(
                          onTap: () => Navigator.pop(context, skrining),
                          leading: const Icon(Icons.arrow_right_rounded),
                          contentPadding: EdgeInsets.zero,
                          minLeadingWidth: 12,
                          horizontalTitleGap: 12,
                          title: Text('${skrining.skrining}'),
                        );
                      },
                      separatorBuilder: (context, i) => const Divider(),
                      itemCount: snapshot.data!.data!.data!.length,
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
