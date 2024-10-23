import 'package:dokter_panggil/src/blocs/master_bhp_paginate_bloc.dart';
import 'package:dokter_panggil/src/blocs/master_bhp_pencarian_bloc.dart';
import 'package:dokter_panggil/src/models/master_bhp_paginate_model.dart';
import 'package:dokter_panggil/src/pages/components/error_response.dart';
import 'package:dokter_panggil/src/pages/components/loading_kit.dart';
import 'package:dokter_panggil/src/pages/components/search_input_form.dart';
import 'package:dokter_panggil/src/repositories/responseApi/api_response.dart';
import 'package:dokter_panggil/src/source/config.dart';
import 'package:dokter_panggil/src/source/size_config.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class ListMasterBhpPaginate extends StatefulWidget {
  const ListMasterBhpPaginate({
    Key? key,
    this.selectedData,
  }) : super(key: key);

  final List<BarangHabisPakai>? selectedData;

  @override
  State<ListMasterBhpPaginate> createState() => _ListMasterBhpPaginateState();
}

class _ListMasterBhpPaginateState extends State<ListMasterBhpPaginate> {
  final _masterBhpBloc = MasterBhpPaginateBloc();
  final _masterBhpPencarianBloc = MasterBhpPencarianBloc();
  final _filter = TextEditingController();
  bool _isFilter = false;
  String? _prevFilter;

  @override
  void initState() {
    super.initState();
    _getMasterBhp();
    _filter.addListener(_filterListener);
  }

  void _getMasterBhp() {
    _masterBhpBloc.getMasterBhp();
  }

  void _filterListener() async {
    if (_filter.text.isNotEmpty) {
      if (_prevFilter != _filter.text) {
        await Future.delayed(const Duration(seconds: 1));
        _masterBhpPencarianBloc.namaBarangSink.add(_filter.text);
        _masterBhpPencarianBloc.getPencarianMasterBhp();
        _isFilter = true;
        _prevFilter = _filter.text;
      }
    } else {
      _getMasterBhp();
      _isFilter = false;
    }
    setState(() {});
  }

  @override
  void dispose() {
    _masterBhpBloc.dispose();
    _masterBhpPencarianBloc.dispose();
    _filter.removeListener(_filterListener);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: BoxConstraints(
        minHeight: SizeConfig.blockSizeVertical * 35,
        maxHeight: SizeConfig.blockSizeVertical * 90,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 18.0, vertical: 25.0),
            child: Text(
              'Apotek Mentari',
              style: TextStyle(fontSize: 22.0, fontWeight: FontWeight.w600),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 18.0, right: 18.0),
            child: SearchInputForm(
              controller: _filter,
              hint: "Pencarian nama barang/obat",
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
          if (_isFilter)
            Flexible(
              child: _streamPencarianBhp(context),
            )
          else
            Flexible(
              child: _streamBhp(context),
            )
        ],
      ),
    );
  }

  Widget _streamBhp(BuildContext context) {
    return StreamBuilder<ApiResponse<MasterBhpPaginateModel>>(
      stream: _masterBhpBloc.masterBhpStream,
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
                child: ErrorResponse(
                  message: snapshot.data!.message,
                  button: false,
                ),
              );
            case Status.completed:
              return ListBarangHabisPakai(
                data: snapshot.data!.data,
                bloc: _masterBhpBloc,
                selectedData: widget.selectedData,
              );
          }
        }
        return SizedBox(
          height: SizeConfig.blockSizeVertical * 35,
        );
      },
    );
  }

  Widget _streamPencarianBhp(BuildContext context) {
    return StreamBuilder<ApiResponse<MasterBhpPaginateModel>>(
      stream: _masterBhpPencarianBloc.pencarianMasterBhpStream,
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
                child: ErrorResponse(
                  message: snapshot.data!.message,
                  button: false,
                ),
              );
            case Status.completed:
              return ListBarangHabisPakai(
                data: snapshot.data!.data,
                blocSearch: _masterBhpPencarianBloc,
                selectedData: widget.selectedData,
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

class ListBarangHabisPakai extends StatefulWidget {
  const ListBarangHabisPakai({
    Key? key,
    this.data,
    this.bloc,
    this.blocSearch,
    this.selectedData,
  }) : super(key: key);

  final MasterBhpPaginateModel? data;
  final MasterBhpPaginateBloc? bloc;
  final MasterBhpPencarianBloc? blocSearch;
  final List<BarangHabisPakai>? selectedData;

  @override
  State<ListBarangHabisPakai> createState() => _ListBarangHabisPakaiState();
}

class _ListBarangHabisPakaiState extends State<ListBarangHabisPakai> {
  final _scrollController = ScrollController();
  List<BarangHabisPakai> _data = [];
  List<BarangHabisPakai> _selectedData = [];

  void _selectData(BarangHabisPakai data) {
    if (_selectedData.where((e) => e.id == data.id).isEmpty) {
      setState(() {
        _selectedData.add(data);
      });
    } else {
      setState(() {
        _selectedData.removeWhere((e) => e.id == data.id);
      });
    }
  }

  Future<void> _finalSelected() async {
    SystemChannels.textInput.invokeMethod('TextInput.hide');
    if (MediaQuery.of(context).viewInsets.bottom > 0.0) {
      await Future.delayed(
        const Duration(milliseconds: 700),
      );
    }
    if (!mounted) return;
    Navigator.pop(context, _selectedData);
  }

  @override
  void initState() {
    super.initState();
    _data = widget.data!.bhp!;
    if (widget.selectedData!.isNotEmpty) {
      _selectedData = widget.selectedData!;
    }
    _scrollController.addListener(_scrollListen);
  }

  void _scrollListen() {
    if (_scrollController.position.pixels ==
        _scrollController.position.maxScrollExtent) {
      if (widget.blocSearch != null) {
        widget.blocSearch!.getPencarianMasterBhpNextPage();
      } else {
        widget.bloc!.getBhpNextPage();
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Flexible(
          child: ListView.separated(
            padding: const EdgeInsets.symmetric(vertical: 22.0),
            controller: _scrollController,
            shrinkWrap: true,
            itemBuilder: (context, i) {
              if (i == _data.length) {
                return const SizedBox(
                  height: 50,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      CircleAvatar(
                        radius: 12,
                        backgroundColor: Colors.transparent,
                        child: CircularProgressIndicator(),
                      ),
                      SizedBox(
                        width: 12,
                      ),
                      Text('Memuat...'),
                    ],
                  ),
                );
              }
              var data = _data[i];
              return ListTile(
                onTap: () => _selectData(data),
                contentPadding: const EdgeInsets.symmetric(horizontal: 25.0),
                title: Text('${data.namaBarang}'),
                trailing: _selectedData.where((e) => e.id == data.id).isNotEmpty
                    ? const Icon(
                        Icons.check_circle_outline_rounded,
                        color: Colors.green,
                      )
                    : null,
              );
            },
            separatorBuilder: (context, i) => const Divider(
              height: 0,
            ),
            itemCount: widget.data!.totalPage != widget.data!.currentPage
                ? _data.length + 1
                : _data.length,
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
              onPressed: _selectedData.isEmpty ? null : _finalSelected,
              style: ElevatedButton.styleFrom(
                  minimumSize: const Size(double.infinity, 48.0)),
              child: _selectedData.isEmpty
                  ? const Text('PILIH BARANG')
                  : Text('PILIH BARANG (${_selectedData.length} barang)'),
            ),
          ),
        ),
      ],
    );
  }
}
