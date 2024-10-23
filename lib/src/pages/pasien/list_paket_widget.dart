import 'package:dokter_panggil/src/blocs/master_paket_create_bloc.dart';
import 'package:dokter_panggil/src/models/master_paket_create_model.dart';
import 'package:dokter_panggil/src/pages/components/loading_kit.dart';
import 'package:dokter_panggil/src/repositories/responseApi/api_response.dart';
import 'package:dokter_panggil/src/source/config.dart';
import 'package:dokter_panggil/src/pages/components/error_response.dart';
import 'package:flutter/material.dart';

class ListPaketWidget extends StatefulWidget {
  const ListPaketWidget({
    super.key,
    this.selectedId,
  });

  final int? selectedId;

  @override
  State<ListPaketWidget> createState() => _ListPaketWidgetState();
}

class _ListPaketWidgetState extends State<ListPaketWidget> {
  final _masterPaketCreateBloc = MasterPaketCreateBloc();

  @override
  void initState() {
    super.initState();
    _masterPaketCreateBloc.getMasterPaket();
  }

  @override
  void dispose() {
    _masterPaketCreateBloc.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<ApiResponse<ResponseMasterPaketCreateModel>>(
      stream: _masterPaketCreateBloc.masterPaketCreateStream,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          switch (snapshot.data!.status) {
            case Status.loading:
              return const SizedBox(
                height: 200,
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
                      _masterPaketCreateBloc.getMasterPaket();
                      setState(() {});
                    },
                  ),
                ),
              );
            case Status.completed:
              return SafeArea(
                top: false,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Padding(
                      padding: EdgeInsets.all(22.0),
                      child: Text(
                        'Daftar paket',
                        style: TextStyle(
                            fontSize: 20, fontWeight: FontWeight.bold),
                      ),
                    ),
                    Flexible(
                      child: ListView.separated(
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        shrinkWrap: true,
                        itemBuilder: (context, i) {
                          var data = snapshot.data!.data!.data![i];
                          return ListTile(
                            onTap: () => Navigator.pop(
                              context,
                              SelectedPaketModel(
                                id: data.id,
                                namaPaket: data.namaPaket,
                              ),
                            ),
                            contentPadding:
                                const EdgeInsets.symmetric(horizontal: 32),
                            title: Text('${data.namaPaket}'),
                            titleTextStyle: const TextStyle(
                                color: Colors.black,
                                fontWeight: FontWeight.normal,
                                fontSize: 14.0),
                            trailing: widget.selectedId == data.id
                                ? const Icon(
                                    Icons.check_circle_outline_rounded,
                                    color: Colors.green,
                                  )
                                : const SizedBox(
                                    width: 22.0,
                                  ),
                          );
                        },
                        separatorBuilder: (context, i) => const Divider(
                          height: 0,
                        ),
                        itemCount: snapshot.data!.data!.data!.length,
                      ),
                    ),
                  ],
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

class SelectedPaketModel {
  SelectedPaketModel({
    this.id,
    this.namaPaket,
  });

  int? id;
  String? namaPaket;
}
