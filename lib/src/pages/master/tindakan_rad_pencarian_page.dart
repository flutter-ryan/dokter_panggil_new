import 'dart:io';

import 'package:dokter_panggil/src/blocs/master_tindakan_rad_cari_bloc.dart';
import 'package:dokter_panggil/src/models/master_tindakan_rad_cari_modal.dart';
import 'package:dokter_panggil/src/models/master_tindakan_rad_create_mode.dart';
import 'package:dokter_panggil/src/pages/components/error_response.dart';
import 'package:dokter_panggil/src/pages/components/loading_kit.dart';
import 'package:dokter_panggil/src/pages/components/search_input_form.dart';
import 'package:dokter_panggil/src/repositories/responseApi/api_response.dart';
import 'package:dokter_panggil/src/source/config.dart';
import 'package:flutter/material.dart';

class TindakanRadPencarianPage extends StatefulWidget {
  const TindakanRadPencarianPage({super.key});

  @override
  State<TindakanRadPencarianPage> createState() =>
      _TindakanRadPencarianPageState();
}

class _TindakanRadPencarianPageState extends State<TindakanRadPencarianPage> {
  final _masterTindakanRadCariBloc = MasterTindakanRadCariBloc();
  final _filter = TextEditingController();

  @override
  void initState() {
    super.initState();
    _masterTindakanRadCariBloc.cariTindakanRad();
    _filter.addListener(_listenFilter);
  }

  void _listenFilter() {
    if (_filter.text.isNotEmpty) {
      _masterTindakanRadCariBloc.filterSink.add(_filter.text);
      _masterTindakanRadCariBloc.cariTindakanRad();
    } else {
      _masterTindakanRadCariBloc.cariTindakanRad();
    }
  }

  @override
  void dispose() {
    _masterTindakanRadCariBloc.dispose();
    _filter.removeListener(_listenFilter);
    _filter.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Padding(
            padding: EdgeInsets.only(
              left: 2.0,
              right: 32.0,
              top: MediaQuery.of(context).padding.top + 18,
            ),
            child: Row(
              children: [
                if (Platform.isAndroid)
                  IconButton(
                    onPressed: () => Navigator.pop(context),
                    icon: Icon(
                      Icons.arrow_back,
                      color: Colors.grey[600],
                    ),
                  )
                else
                  IconButton(
                    onPressed: () => Navigator.pop(context),
                    icon: Icon(
                      Icons.arrow_back_ios,
                      color: Colors.grey[600],
                    ),
                  ),
                const SizedBox(
                  width: 4.0,
                ),
                Expanded(
                  child: SearchInputForm(
                    controller: _filter,
                    hint: 'Cari nama tindakan radiologi',
                    autofocus: true,
                    suffixIcon: _filter.text.isNotEmpty
                        ? CircleAvatar(
                            radius: 15,
                            backgroundColor: Colors.transparent,
                            foregroundColor: Colors.grey,
                            child: IconButton(
                              onPressed: () {
                                _filter.clear();
                              },
                              padding: EdgeInsets.zero,
                              iconSize: 20,
                              icon: const Icon(Icons.close_rounded),
                            ),
                          )
                        : null,
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: _streamMasterTindakanRadCariWidget(context),
          ),
        ],
      ),
    );
  }

  Widget _streamMasterTindakanRadCariWidget(BuildContext context) {
    return StreamBuilder<ApiResponse<ResponseMasterTindakanRadCariModel>>(
        stream: _masterTindakanRadCariBloc.masterTindakanRadCariStream,
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
                  onTap: () => Navigator.pop(context),
                );
              case Status.completed:
                return ListTindakanRadWidget(
                  data: snapshot.data!.data!.data!,
                );
            }
          }
          return const SizedBox();
        });
  }
}

class ListTindakanRadWidget extends StatelessWidget {
  const ListTindakanRadWidget({
    super.key,
    this.data,
  });

  final List<MasterTindakanRad>? data;

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      padding: const EdgeInsets.symmetric(vertical: 18.0),
      itemBuilder: (context, i) {
        final tindakan = data![i];
        return ListTile(
          onTap: () => Navigator.pop(context, tindakan),
          contentPadding:
              const EdgeInsets.symmetric(vertical: 8.0, horizontal: 22.0),
          title: Text('${tindakan.namaTindakan}'),
        );
      },
      separatorBuilder: (context, i) => const Divider(
        height: 0,
      ),
      itemCount: data!.length,
    );
  }
}
