import 'package:admin_dokter_panggil/src/blocs/master_tindakan_lab_create_bloc.dart';
import 'package:admin_dokter_panggil/src/models/master_tindakan_lab_create_model.dart';
import 'package:admin_dokter_panggil/src/models/master_tindakan_lab_model.dart';
import 'package:admin_dokter_panggil/src/pages/components/error_response.dart';
import 'package:admin_dokter_panggil/src/pages/components/loading_kit.dart';
import 'package:admin_dokter_panggil/src/pages/components/search_input_form.dart';
import 'package:admin_dokter_panggil/src/repositories/responseApi/api_response.dart';
import 'package:admin_dokter_panggil/src/source/config.dart';
import 'package:admin_dokter_panggil/src/source/size_config.dart';
import 'package:flutter/material.dart';

class ListMasterTindakanLab extends StatefulWidget {
  const ListMasterTindakanLab({
    super.key,
    this.selectedData,
  });

  final List<MasterTindakanLab>? selectedData;

  @override
  State<ListMasterTindakanLab> createState() => _ListMasterTindakanLabState();
}

class _ListMasterTindakanLabState extends State<ListMasterTindakanLab> {
  final _masterTindakanLabCreateBloc = MasterTindakanLabCreateBloc();

  @override
  void initState() {
    super.initState();
    _masterTindakanLabCreateBloc.getJenisTindakanLab();
  }

  @override
  void dispose() {
    _masterTindakanLabCreateBloc.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(
          height: 20.0,
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 22.0, vertical: 12.0),
          child: Row(
            children: [
              const Expanded(
                child: Text(
                  'Tindakan Laboratorium',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
                ),
              ),
              CircleAvatar(
                radius: 18.0,
                backgroundColor: Colors.transparent,
                foregroundColor: Colors.grey,
                child: IconButton(
                  onPressed: () => Navigator.pop(context),
                  padding: EdgeInsets.zero,
                  icon: const Icon(Icons.close),
                ),
              )
            ],
          ),
        ),
        _streamMasterTindakanLab(context),
      ],
    );
  }

  Widget _streamMasterTindakanLab(BuildContext context) {
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
              return ErrorResponse(
                message: snapshot.data!.message,
                onTap: () => Navigator.pop(context),
              );
            case Status.completed:
              return ListTindakanLabCreate(
                data: snapshot.data!.data!.data,
                selectedData: widget.selectedData,
              );
          }
        }
        return const SizedBox();
      },
    );
  }
}

class ListTindakanLabCreate extends StatefulWidget {
  const ListTindakanLabCreate({
    super.key,
    this.selectedData,
    this.data,
  });

  final List<MasterTindakanLab>? data;
  final List<MasterTindakanLab>? selectedData;

  @override
  State<ListTindakanLabCreate> createState() => _ListTindakanLabCreateState();
}

class _ListTindakanLabCreateState extends State<ListTindakanLabCreate> {
  final _filter = TextEditingController();
  List<MasterTindakanLab> _data = [];
  List<MasterTindakanLab> _selectedData = [];
  final _scrollCon = ScrollController();

  @override
  void initState() {
    super.initState();
    _data = widget.data!;
    _selectedData = widget.selectedData!;
    _filter.addListener(_filterListen);
  }

  void _filterListen() {
    if (_filter.text.isEmpty) {
      _data = widget.data!;
    } else {
      _data = widget.data!
          .where((e) => e.namaTindakanLab!
              .toLowerCase()
              .contains(_filter.text.toLowerCase()))
          .toList();
    }
    setState(() {});
  }

  void _selectedTindakanLab(MasterTindakanLab data) {
    if (_selectedData.where((e) => e.id == data.id).isNotEmpty) {
      _selectedData.removeWhere((e) => e.id == data.id);
    } else {
      _selectedData.add(data);
    }
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Flexible(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (_data.length > 5)
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
            Container(
              constraints: BoxConstraints(
                minHeight: SizeConfig.blockSizeVertical * 30,
              ),
              child: const Center(
                child: ErrorResponse(
                  message: 'Data tidak tersedia',
                  button: false,
                ),
              ),
            )
          else
            Flexible(
              child: SingleChildScrollView(
                controller: _scrollCon,
                padding: const EdgeInsets.symmetric(
                    horizontal: 12.0, vertical: 18.0),
                child: Column(
                    children: ListTile.divideTiles(
                  context: context,
                  tiles: _data
                      .map(
                        (data) => ListTile(
                          onTap: () => _selectedTindakanLab(data),
                          title: Text('${data.namaTindakanLab}'),
                          subtitle: data.mitra == null
                              ? const Text('-')
                              : Text('${data.mitra!.namaMitra}'),
                          trailing: _selectedData
                                  .where((e) => e.id == data.id)
                                  .isNotEmpty
                              ? const Icon(
                                  Icons.check_circle_outline_rounded,
                                  color: Colors.green,
                                )
                              : null,
                        ),
                      )
                      .toList(),
                ).toList()),
              ),
            ),
          Container(
            padding: const EdgeInsets.all(18.0),
            child: ElevatedButton(
              onPressed: _selectedData.isEmpty
                  ? null
                  : () => Navigator.pop(context, _selectedData),
              style: ElevatedButton.styleFrom(
                minimumSize: const Size(double.infinity, 45.0),
                backgroundColor: kPrimaryColor,
              ),
              child: _selectedData.isEmpty
                  ? const Text('Pilih Tindakan Lab')
                  : Text('Pilih ${_selectedData.length} Tindakan Lab'),
            ),
          ),
        ],
      ),
    );
  }
}
