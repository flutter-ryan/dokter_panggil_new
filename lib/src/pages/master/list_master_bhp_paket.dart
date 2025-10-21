import 'package:admin_dokter_panggil/src/blocs/master_bhp_kategori_bloc.dart';
import 'package:admin_dokter_panggil/src/models/master_bhp_kategori_model.dart';
import 'package:admin_dokter_panggil/src/models/master_bhp_model.dart';
import 'package:admin_dokter_panggil/src/pages/components/loading_kit.dart';
import 'package:admin_dokter_panggil/src/pages/components/search_input_form.dart';
import 'package:admin_dokter_panggil/src/pages/master/paket_item/item_drugs.dart';
import 'package:admin_dokter_panggil/src/repositories/responseApi/api_response.dart';
import 'package:admin_dokter_panggil/src/source/config.dart';
import 'package:admin_dokter_panggil/src/source/size_config.dart';
import 'package:flutter/material.dart';
import 'package:admin_dokter_panggil/src/pages/components/error_response.dart';

class ListMasterBhpPaket extends StatefulWidget {
  const ListMasterBhpPaket({
    super.key,
    this.idKategori,
    this.title,
    this.selectedData,
  });
  final List<BhpSelected>? selectedData;
  final int? idKategori;
  final String? title;

  @override
  State<ListMasterBhpPaket> createState() => _ListMasterBhpPaketState();
}

class _ListMasterBhpPaketState extends State<ListMasterBhpPaket> {
  final _masterBhpKategoriBloc = MasterBhpKategoriBloc();
  final _filter = TextEditingController();

  @override
  void initState() {
    super.initState();
    _masterBhpKategoriBloc.idKategoriSink.add(widget.idKategori!);
    _masterBhpKategoriBloc.getBhpKategori();
  }

  @override
  void dispose() {
    _masterBhpKategoriBloc.dispose();
    _filter.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 18.0, vertical: 25.0),
          child: Text(
            '${widget.title}',
            style: const TextStyle(fontSize: 22.0, fontWeight: FontWeight.w600),
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(left: 18.0, right: 18.0),
          child: SearchInputForm(
            controller: _filter,
            hint: "Pencarian nama bhp",
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
          child: _streamBhpDrugs(context),
        )
      ],
    );
  }

  Widget _streamBhpDrugs(BuildContext context) {
    return StreamBuilder<ApiResponse<MasterBhpKategoriModel>>(
      stream: _masterBhpKategoriBloc.bhpKategoriStream,
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
              var drugs = snapshot.data!.data!.data!;
              return ListBhpDrugs(
                data: drugs,
                filter: _filter,
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

class ListBhpDrugs extends StatefulWidget {
  const ListBhpDrugs({
    super.key,
    required this.data,
    this.filter,
    this.selectedData,
  });

  final List<MasterBhp>? data;
  final TextEditingController? filter;
  final List<BhpSelected>? selectedData;

  @override
  State<ListBhpDrugs> createState() => _ListBhpDrugsState();
}

class _ListBhpDrugsState extends State<ListBhpDrugs> {
  List<MasterBhp> _data = [];
  List<BhpSelected> _selectedData = [];

  @override
  void initState() {
    super.initState();
    _data = widget.data!;
    widget.filter!.addListener(_filterListen);
    if (widget.selectedData != null) _selectedData = widget.selectedData!;
  }

  void _filterListen() {
    if (widget.filter!.text.isEmpty) {
      _data = widget.data!;
    } else {
      _data = widget.data!
          .where((e) => e.namaBarang!
              .toLowerCase()
              .contains(widget.filter!.text.toLowerCase()))
          .toList();
    }
    setState(() {});
  }

  void _selectData(MasterBhp data) {
    if (_selectedData.where((e) => e.id == data.id).isEmpty) {
      setState(() {
        _selectedData.insert(
            0,
            BhpSelected(
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

  void _finalSelected() {
    Navigator.pop(context, _selectedData);
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
                  padding: const EdgeInsets.symmetric(vertical: 18),
                  itemBuilder: (context, i) {
                    var data = _data[i];
                    return ListTile(
                      onTap: () => _selectData(data),
                      contentPadding:
                          const EdgeInsets.symmetric(horizontal: 18.0),
                      title: Text('${data.namaBarang}'),
                      trailing:
                          _selectedData.where((e) => e.id == data.id).isNotEmpty
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
                  itemCount: _data.length)),
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
                  ? const Text('PILIH DRUGS')
                  : Text('PILIH (${_selectedData.length} drugs)'),
            ),
          ),
        ),
      ],
    );
  }
}
