import 'package:dokter_panggil/src/blocs/master_tindakan_lab_create_bloc.dart';
import 'package:dokter_panggil/src/models/master_tindakan_lab_create_model.dart';
import 'package:dokter_panggil/src/models/master_tindakan_lab_model.dart';
import 'package:dokter_panggil/src/pages/components/loading_kit.dart';
import 'package:dokter_panggil/src/pages/components/search_input_form.dart';
import 'package:dokter_panggil/src/pages/master/paket_page.dart';
import 'package:dokter_panggil/src/repositories/responseApi/api_response.dart';
import 'package:dokter_panggil/src/source/config.dart';
import 'package:dokter_panggil/src/source/size_config.dart';
import 'package:flutter/material.dart';
import 'package:dokter_panggil/src/pages/components/error_response.dart';

class ListMasterTindakanLabPaket extends StatefulWidget {
  const ListMasterTindakanLabPaket({
    super.key,
    this.selectedData,
  });

  final List<PaketLabSelected>? selectedData;

  @override
  State<ListMasterTindakanLabPaket> createState() =>
      _ListMasterTindakanLabPaketState();
}

class _ListMasterTindakanLabPaketState
    extends State<ListMasterTindakanLabPaket> {
  final _masterTindakanLabCreateBloc = MasterTindakanLabCreateBloc();

  @override
  void initState() {
    super.initState();
    _masterTindakanLabCreateBloc.getMasterTindakanLab();
  }

  @override
  void dispose() {
    _masterTindakanLabCreateBloc.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<ApiResponse<MasterTindakanLabCreateModel>>(
      stream: _masterTindakanLabCreateBloc.masterTindakanLabCreateStream,
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
              var tindakanLab = snapshot.data!.data!.data!;
              return ListTindakanLab(
                selectedData: widget.selectedData,
                data: tindakanLab,
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

class ListTindakanLab extends StatefulWidget {
  const ListTindakanLab({
    super.key,
    required this.data,
    this.selectedData,
  });

  final List<MasterTindakanLab> data;
  final List<PaketLabSelected>? selectedData;

  @override
  State<ListTindakanLab> createState() => _ListTindakanLabState();
}

class _ListTindakanLabState extends State<ListTindakanLab> {
  List<MasterTindakanLab> _data = [];
  final List<MasterTindakanLab> _selectedData = [];
  final _filter = TextEditingController();

  @override
  void initState() {
    super.initState();
    _data = widget.data;
    _filter.addListener(_filterListen);
    if (widget.selectedData != null) {
      widget.selectedData!.asMap().forEach((key, lab) {
        _selectedData.add(
          MasterTindakanLab(
            id: lab.id,
            namaTindakanLab: lab.namaTindakanLab,
            hargaJual: lab.hargaJual,
            hargaModal: lab.hargaModal,
            tarifAplikasi: lab.tarifAplikasi,
          ),
        );
      });
    }
  }

  void _filterListen() {
    if (_filter.text.isEmpty) {
      setState(() {
        _data = widget.data;
      });
    } else {
      setState(() {
        _data = widget.data
            .where((e) => e.namaTindakanLab!
                .toLowerCase()
                .contains(_filter.text.toLowerCase()))
            .toList();
      });
    }
  }

  void _finalSelected() {
    Navigator.pop(context, _selectedData);
  }

  void _selectData(MasterTindakanLab data) {
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
            'Tindakan Laboratorium',
            style: TextStyle(fontSize: 22.0, fontWeight: FontWeight.w600),
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(left: 18.0, right: 18.0),
          child: SearchInputForm(
            controller: _filter,
            hint: "Pencarian nama tindakan lab",
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
                  title: Text('${data.namaTindakanLab}'),
                  subtitle: Text('${data.mitra!.namaMitra}'),
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
                  ? const Text('PILIH TINDAKAN LAB')
                  : Text('PILIH (${_selectedData.length} Tindakan Lab)'),
            ),
          ),
        ),
      ],
    );
  }
}
