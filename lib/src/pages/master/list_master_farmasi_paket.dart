import 'package:admin_dokter_panggil/src/blocs/barang_farmasi_filter_bloc.dart';
import 'package:admin_dokter_panggil/src/models/barang_farmasi_filter_model.dart';
import 'package:admin_dokter_panggil/src/models/master_farmasi_paginate_model.dart';
import 'package:admin_dokter_panggil/src/pages/components/loading_kit.dart';
import 'package:admin_dokter_panggil/src/pages/components/search_input_form.dart';
import 'package:admin_dokter_panggil/src/pages/master/paket_item/item_resep.dart';
import 'package:admin_dokter_panggil/src/repositories/responseApi/api_response.dart';
import 'package:admin_dokter_panggil/src/source/config.dart';
import 'package:admin_dokter_panggil/src/source/size_config.dart';
import 'package:flutter/material.dart';
import 'package:admin_dokter_panggil/src/pages/components/error_response.dart';

class ListMasterFarmasiPaket extends StatefulWidget {
  const ListMasterFarmasiPaket({
    super.key,
    this.selectedData,
  });

  final List<FarmasiSelected>? selectedData;

  @override
  State<ListMasterFarmasiPaket> createState() => _ListMasterFarmasiPaketState();
}

class _ListMasterFarmasiPaketState extends State<ListMasterFarmasiPaket> {
  final _barangFarmasiFilterBloc = BarangFarmasiFilterBloc();
  final _filter = TextEditingController();

  @override
  void initState() {
    super.initState();
    _barangFarmasiFilterBloc.filterBarangFarmasi();
  }

  @override
  void dispose() {
    _barangFarmasiFilterBloc.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        const Padding(
          padding: EdgeInsets.symmetric(horizontal: 18.0, vertical: 25.0),
          child: Text(
            'FARMASI',
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
        Flexible(
          child: _listFarmasi(context),
        ),
      ],
    );
  }

  Widget _listFarmasi(BuildContext context) {
    return StreamBuilder<ApiResponse<ResponseBarangFarmasiFilterModel>>(
      stream: _barangFarmasiFilterBloc.barangFarmasiStream,
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
              var barang = snapshot.data!.data!.barang!;
              return ListBarangFarmasi(data: barang, filter: _filter);
          }
        }
        return SizedBox(
          height: SizeConfig.blockSizeVertical * 35,
        );
      },
    );
  }
}

class ListBarangFarmasi extends StatefulWidget {
  const ListBarangFarmasi({
    super.key,
    required this.data,
    this.filter,
    this.selectedData,
  });

  final List<BarangFarmasi> data;
  final TextEditingController? filter;
  final List<FarmasiSelected>? selectedData;

  @override
  State<ListBarangFarmasi> createState() => _ListBarangFarmasiState();
}

class _ListBarangFarmasiState extends State<ListBarangFarmasi> {
  List<FarmasiSelected> _selectedData = [];
  List<BarangFarmasi> _data = [];

  @override
  void initState() {
    super.initState();
    _data = widget.data;
    widget.filter!.addListener(_filterListen);
    if (widget.selectedData != null) _selectedData = widget.selectedData!;
  }

  void _filterListen() {
    if (widget.filter!.text.isEmpty) {
      _data = widget.data;
    } else {
      _data = widget.data
          .where((e) => e.namaBarang!
              .toLowerCase()
              .contains(widget.filter!.text.toLowerCase()))
          .toList();
    }
    setState(() {});
  }

  void _finalSelected() {
    Navigator.pop(context, _selectedData);
  }

  void _selectData(BarangFarmasi data) {
    if (_selectedData.where((e) => e.id == data.id).isEmpty) {
      setState(() {
        _selectedData.insert(
            0,
            FarmasiSelected(
              id: data.id,
              namaBarang: data.namaBarang,
              hargaJual: data.hargaJual,
            ));
      });
    } else {
      setState(() {
        _selectedData.removeWhere((e) => e.id == data.id);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        if (_data.isEmpty)
          const SizedBox(
            width: double.infinity,
            child: Center(
              child: ErrorResponse(
                message: 'Data tidak tersedia',
                button: false,
              ),
            ),
          )
        else
          Flexible(
            child: ListView.separated(
              shrinkWrap: true,
              padding:
                  const EdgeInsets.symmetric(horizontal: 8.0, vertical: 18),
              itemBuilder: (context, i) {
                var data = _data[i];
                return ListTile(
                  onTap: () => _selectData(data),
                  contentPadding: const EdgeInsets.symmetric(horizontal: 18.0),
                  title: Text('${data.namaBarang}'),
                  subtitle: Text('${data.mitraFarmasi!.namaMitra}'),
                  trailing:
                      _selectedData.where((e) => e.id == data.id).isNotEmpty
                          ? const Icon(
                              Icons.check_circle_outline_rounded,
                              color: Colors.green,
                            )
                          : null,
                );
              },
              itemCount: _data.length,
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
              onPressed: _selectedData.isEmpty ? null : _finalSelected,
              style: ElevatedButton.styleFrom(
                  minimumSize: const Size(double.infinity, 48.0),
                  backgroundColor: kPrimaryColor),
              child: _selectedData.isEmpty
                  ? const Text('PILIH BARANG')
                  : Text('PILIH (${_selectedData.length} barang)'),
            ),
          ),
        ),
      ],
    );
  }
}
