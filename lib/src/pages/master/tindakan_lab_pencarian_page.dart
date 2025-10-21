import 'dart:io';

import 'package:admin_dokter_panggil/src/blocs/master_tindakan_lab_all_bloc.dart';
import 'package:admin_dokter_panggil/src/models/master_tindakan_lab_all_model.dart';
import 'package:admin_dokter_panggil/src/pages/components/error_response.dart';
import 'package:admin_dokter_panggil/src/pages/components/loading_kit.dart';
import 'package:admin_dokter_panggil/src/pages/components/search_input_form.dart';
import 'package:admin_dokter_panggil/src/repositories/responseApi/api_response.dart';
import 'package:admin_dokter_panggil/src/source/config.dart';
import 'package:flutter/material.dart';

class TindakanLabPencarianPage extends StatefulWidget {
  const TindakanLabPencarianPage({super.key});

  @override
  State<TindakanLabPencarianPage> createState() =>
      _TindakanLabPencarianPageState();
}

class _TindakanLabPencarianPageState extends State<TindakanLabPencarianPage> {
  final _masterTindakanLabAllBloc = MasterTindakanLabAllBloc();

  @override
  void initState() {
    super.initState();
    _masterTindakanLabAllBloc.getTindakanLabAll();
  }

  @override
  void dispose() {
    _masterTindakanLabAllBloc.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _streamBarangFarmasi(context),
    );
  }

  Widget _streamBarangFarmasi(BuildContext context) {
    return StreamBuilder<ApiResponse<MasterTindakanLabAllModel>>(
      stream: _masterTindakanLabAllBloc.tindakanLabAllStream,
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
                  onTap: () => setState(() {
                    _masterTindakanLabAllBloc.getTindakanLabAll();
                    setState(() {});
                  }),
                ),
              );
            case Status.completed:
              return ListMasterTindakanLabWidget(
                  data: snapshot.data!.data!.data);
          }
        }
        return const SizedBox();
      },
    );
  }
}

class ListMasterTindakanLabWidget extends StatefulWidget {
  const ListMasterTindakanLabWidget({
    super.key,
    this.data,
  });

  final List<MasterTindakanLabAll>? data;

  @override
  State<ListMasterTindakanLabWidget> createState() =>
      _ListMasterTindakanLabWidgetState();
}

class _ListMasterTindakanLabWidgetState
    extends State<ListMasterTindakanLabWidget> {
  List<MasterTindakanLabAll> _data = [];
  final _filter = TextEditingController();

  @override
  void initState() {
    super.initState();
    _data = widget.data!;
    _filter.addListener(_filterListen);
  }

  void _filterListen() {
    if (_filter.text.isNotEmpty) {
      _data = widget.data!
          .where((e) => e.namaTindakanLab!
              .toLowerCase()
              .contains(_filter.text.toLowerCase()))
          .toList();
    } else {
      _data = widget.data!;
    }
    setState(() {});
  }

  @override
  void dispose() {
    _filter.removeListener(_filterListen);
    _filter.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
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
                  hint: 'Pencarian nama tindakan',
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
          child: ListView.separated(
            padding: const EdgeInsets.symmetric(vertical: 18.0),
            itemBuilder: (context, i) {
              var data = _data[i];
              return ListTile(
                onTap: () => Navigator.pop(context, data),
                contentPadding:
                    const EdgeInsets.symmetric(vertical: 8.0, horizontal: 22.0),
                dense: true,
                title: data.mitra == null
                    ? Text('${data.namaTindakanLab}')
                    : Text(
                        '${data.namaTindakanLab} - ${data.mitra!.namaMitra}',
                      ),
              );
            },
            separatorBuilder: (context, i) => const Divider(
              height: 0,
            ),
            itemCount: _data.length,
          ),
        ),
      ],
    );
  }
}
