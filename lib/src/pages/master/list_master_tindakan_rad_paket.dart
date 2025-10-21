import 'package:admin_dokter_panggil/src/blocs/master_tindakan_rad_create_bloc.dart';
import 'package:admin_dokter_panggil/src/models/master_tindakan_rad_create_mode.dart';
import 'package:admin_dokter_panggil/src/pages/components/loading_kit.dart';
import 'package:admin_dokter_panggil/src/pages/components/search_input_form.dart';
import 'package:admin_dokter_panggil/src/pages/master/paket_page.dart';
import 'package:admin_dokter_panggil/src/repositories/responseApi/api_response.dart';
import 'package:admin_dokter_panggil/src/source/config.dart';
import 'package:admin_dokter_panggil/src/source/size_config.dart';
import 'package:flutter/material.dart';
import 'package:admin_dokter_panggil/src/pages/components/error_response.dart';

class ListMasterTindakanRadPaket extends StatefulWidget {
  const ListMasterTindakanRadPaket({
    super.key,
    this.selectedData,
  });

  final List<PaketRadSelected>? selectedData;

  @override
  State<ListMasterTindakanRadPaket> createState() =>
      _ListMasterTindakanRadPaketState();
}

class _ListMasterTindakanRadPaketState
    extends State<ListMasterTindakanRadPaket> {
  final _masterTindakanRadCreateBloc = MasterTindakanRadCreateBloc();

  @override
  void initState() {
    super.initState();
    _masterTindakanRadCreateBloc.getTindakanRad();
  }

  @override
  void dispose() {
    _masterTindakanRadCreateBloc.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<ApiResponse<MasterTindakanRadCreateModel>>(
      stream: _masterTindakanRadCreateBloc.tindakanRadStream,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          switch (snapshot.data!.status) {
            case Status.loading:
              return SizedBox(
                height: SizeConfig.blockSizeVertical * 30,
                child: const LoadingKit(
                  color: kPrimaryColor,
                ),
              );
            case Status.error:
              return SizedBox(
                width: double.infinity,
                height: SizeConfig.blockSizeVertical * 30,
                child: Center(
                  child: ErrorResponse(
                    message: snapshot.data!.message,
                    button: false,
                  ),
                ),
              );
            case Status.completed:
              var tindakanRad = snapshot.data!.data!.data!;
              return ListTindakanRad(
                data: tindakanRad,
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

class ListTindakanRad extends StatefulWidget {
  const ListTindakanRad({
    super.key,
    required this.data,
    this.selectedData,
  });

  final List<MasterTindakanRad> data;
  final List<PaketRadSelected>? selectedData;

  @override
  State<ListTindakanRad> createState() => _ListTindakanRadState();
}

class _ListTindakanRadState extends State<ListTindakanRad> {
  List<MasterTindakanRad> _data = [];
  final List<MasterTindakanRad> _selectedData = [];
  final _filter = TextEditingController();

  @override
  void initState() {
    super.initState();
    _data = widget.data;
    _filter.addListener(_filterListen);
    if (widget.selectedData != null) {
      widget.selectedData!.asMap().forEach((key, rad) {
        _selectedData.add(
          MasterTindakanRad(
            id: rad.id,
            namaTindakan: rad.namaTindakanRad,
            hargaJual: rad.hargaJual,
            tarifAplikasi: rad.tarifAplikasi,
            hargaModal: rad.hargaModal,
          ),
        );
      });
    }
  }

  void _filterListen() {
    if (_filter.text.isEmpty) {
      _data = widget.data;
    } else {
      _data = _data
          .where((e) => e.namaTindakan!
              .toLowerCase()
              .contains(_filter.text.toLowerCase()))
          .toList();
    }
    setState(() {});
  }

  void _finalSelected() {
    Navigator.pop(context, _selectedData);
  }

  void _selectData(MasterTindakanRad data) {
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

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        const Padding(
          padding: EdgeInsets.symmetric(horizontal: 18.0, vertical: 25.0),
          child: Text(
            'Tindakan Radiologi',
            style: TextStyle(fontSize: 22.0, fontWeight: FontWeight.w600),
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(left: 18.0, right: 18.0),
          child: SearchInputForm(
            controller: _filter,
            hint: "Pencarian nama tindakan rad",
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
                  title: Text('${data.namaTindakan}'),
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
                backgroundColor: kPrimaryColor,
              ),
              child: _selectedData.isEmpty
                  ? const Text('PILIH TINDAKAN RAD')
                  : Text('PILIH (${_selectedData.length} Tindakan Rad)'),
            ),
          ),
        ),
      ],
    );
  }
}

class TindakanLabSelected {
  TindakanLabSelected(
      {this.id, this.namaTindakanLab, this.jumlah = 1, this.tarif});

  int? id;
  String? namaTindakanLab;
  int jumlah;
  int? tarif;
}
