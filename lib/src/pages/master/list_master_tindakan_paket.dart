import 'dart:async';

import 'package:dokter_panggil/src/blocs/tindakan_filter_bloc.dart';
import 'package:dokter_panggil/src/models/tindakan_filter_model.dart';
import 'package:dokter_panggil/src/models/tindakan_paket_selected_model.dart';
import 'package:dokter_panggil/src/pages/components/loading_kit.dart';
import 'package:dokter_panggil/src/pages/components/search_input_form.dart';
import 'package:dokter_panggil/src/repositories/responseApi/api_response.dart';
import 'package:dokter_panggil/src/source/config.dart';
import 'package:dokter_panggil/src/source/size_config.dart';
import 'package:flutter/material.dart';
import 'package:dokter_panggil/src/pages/components/error_response.dart';

class ListMasterTindakanPaket extends StatefulWidget {
  const ListMasterTindakanPaket({
    super.key,
    this.selectedData,
    this.jenis,
  });

  final List<TindakanPaketSelected>? selectedData;
  final String? jenis;

  @override
  State<ListMasterTindakanPaket> createState() =>
      _ListMasterTindakanPaketState();
}

class _ListMasterTindakanPaketState extends State<ListMasterTindakanPaket> {
  final _tindakanFilterBloc = TindakanFilterBloc();
  final _filter = TextEditingController();
  final List<TindakanPaketSelected> _selectedData = [];
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    if (widget.jenis == 'dokter') {
      _tindakanFilterBloc.idGroupSink.add(1);
    } else {
      _tindakanFilterBloc.idGroupSink.add(2);
    }
    _tindakanFilterBloc.filterTindakanGroup();
    _filter.addListener(_filterListener);
  }

  void _filterListener() {
    _timer?.cancel();
    if (_filter.text.isNotEmpty) {
      _timer = Timer.periodic(const Duration(milliseconds: 500), (timer) {
        _timer?.cancel();
        _tindakanFilterBloc.filterSink.add(_filter.text);
        _tindakanFilterBloc.filterTindakanGroup();
        setState(() {});
      });
    } else {
      _timer?.cancel();
      _tindakanFilterBloc.filterSink.add('');
      _tindakanFilterBloc.filterTindakanGroup();
      setState(() {});
    }
  }

  void _finalSelected() {
    Navigator.pop(context, _selectedData);
  }

  void _selectData(TindakanFilter data) {
    if (_selectedData.where((e) => e.id == data.id).isEmpty) {
      setState(() {
        _selectedData.add(TindakanPaketSelected(
          id: data.id,
          namaTindakan: data.namaTindakan,
          tarif: data.tarif!,
          total: data.tarif! * 1,
          isDokter: widget.jenis == 'dokter' ? true : false,
        ));
      });
    } else {
      setState(() {
        _selectedData.removeWhere((e) => e.id == data.id);
      });
    }
  }

  @override
  void dispose() {
    _tindakanFilterBloc.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Padding(
          padding: EdgeInsets.symmetric(horizontal: 18.0, vertical: 25.0),
          child: Text(
            'Tindakan',
            style: TextStyle(fontSize: 22.0, fontWeight: FontWeight.w600),
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(left: 18.0, right: 18.0),
          child: SearchInputForm(
            controller: _filter,
            hint: "Pencarian nama tindakan",
            suffixIcon: _filter.text.isNotEmpty
                ? InkWell(
                    onTap: () {
                      _filter.clear();
                    },
                    child: const Icon(
                      Icons.close_rounded,
                      color: Colors.grey,
                    ),
                  )
                : null,
          ),
        ),
        Flexible(
          child: _listTindakanAll(context),
        ),
      ],
    );
  }

  Widget _listTindakanAll(BuildContext context) {
    return StreamBuilder<ApiResponse<ResponseTindakanFilterModel>>(
      stream: _tindakanFilterBloc.tindakanFilterStream,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          switch (snapshot.data!.status) {
            case Status.loading:
              return const LoadingKit(
                color: kPrimaryColor,
              );
            case Status.error:
              return SizedBox(
                width: double.infinity,
                child: Center(
                  child: ErrorResponse(
                    message: snapshot.data!.message,
                    button: false,
                  ),
                ),
              );
            case Status.completed:
              var tindakan = snapshot.data!.data!.tindakan;
              return Column(
                children: [
                  Expanded(
                    child: ListView.separated(
                      shrinkWrap: true,
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8.0,
                        vertical: 18,
                      ),
                      itemBuilder: (context, i) {
                        var data = tindakan[i];
                        if (widget.jenis == 'dokter') {
                          return ListTile(
                            onTap: () => _selectData(data),
                            contentPadding:
                                const EdgeInsets.symmetric(horizontal: 18.0),
                            title: Text('${data.namaTindakan}'),
                            trailing: _selectedData
                                    .where((e) => e.id == data.id && e.isDokter)
                                    .isNotEmpty
                                ? const Icon(
                                    Icons.check_circle_outline_rounded,
                                    color: Colors.green,
                                  )
                                : null,
                          );
                        } else if (widget.jenis == 'perawat') {
                          return ListTile(
                            onTap: () => _selectData(data),
                            contentPadding:
                                const EdgeInsets.symmetric(horizontal: 18.0),
                            title: Text('${data.namaTindakan}'),
                            trailing: _selectedData
                                    .where(
                                        (e) => e.id == data.id && !e.isDokter)
                                    .isNotEmpty
                                ? const Icon(
                                    Icons.check_circle_outline_rounded,
                                    color: Colors.green,
                                  )
                                : null,
                          );
                        }
                        return const SizedBox();
                      },
                      itemCount: tindakan!.length,
                      separatorBuilder: (context, i) => const Divider(
                        height: 0,
                      ),
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.all(18.0),
                    decoration: const BoxDecoration(
                      color: Colors.white,
                      boxShadow: [
                        BoxShadow(
                            color: Colors.black12,
                            blurRadius: 6,
                            offset: Offset(0.0, -2.0))
                      ],
                    ),
                    child: Center(
                      child: ElevatedButton(
                        onPressed:
                            _selectedData.isEmpty ? null : _finalSelected,
                        style: ElevatedButton.styleFrom(
                            minimumSize: const Size(double.infinity, 48.0),
                            backgroundColor: kPrimaryColor),
                        child: _selectedData.isEmpty
                            ? const Text('PILIH TINDAKAN')
                            : widget.jenis == 'dokter'
                                ? Text(
                                    'PILIH (${_selectedData.where((e) => e.isDokter).length} tindakan)')
                                : Text(
                                    'PILIH (${_selectedData.where((e) => !e.isDokter).length} tindakan)'),
                      ),
                    ),
                  ),
                ],
              );
          }
        }
        return SizedBox(
          height: SizeConfig.blockSizeVertical * 35,
        );
      },
    );
  }
}
