import 'package:admin_dokter_panggil/src/blocs/master_bhp_by_category_bloc.dart';
import 'package:admin_dokter_panggil/src/models/master_bhp_by_category_model.dart';
import 'package:admin_dokter_panggil/src/models/master_bhp_model.dart';
import 'package:admin_dokter_panggil/src/pages/components/button_rounded_widget.dart';
import 'package:admin_dokter_panggil/src/pages/components/error_response.dart';
import 'package:admin_dokter_panggil/src/pages/components/loading_kit.dart';
import 'package:admin_dokter_panggil/src/pages/components/search_input_form.dart';
import 'package:admin_dokter_panggil/src/repositories/responseApi/api_response.dart';
import 'package:admin_dokter_panggil/src/source/config.dart';
import 'package:admin_dokter_panggil/src/source/size_config.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class ListMasterBhpCategory extends StatefulWidget {
  const ListMasterBhpCategory({
    super.key,
    this.selectedData,
    this.category,
  });

  final List<MasterBhp>? selectedData;
  final int? category;

  @override
  State<ListMasterBhpCategory> createState() => _ListMasterBhpCategoryState();
}

class _ListMasterBhpCategoryState extends State<ListMasterBhpCategory> {
  final _masterBhpCategoryBloc = MasterBhpByCategoryBloc();
  final _filter = TextEditingController();

  @override
  void initState() {
    super.initState();
    _getMasterBhp();
  }

  void _getMasterBhp() {
    _masterBhpCategoryBloc.categoryIdSink.add(widget.category!);
    _masterBhpCategoryBloc.bhpByCategory();
  }

  @override
  void dispose() {
    _masterBhpCategoryBloc.dispose();
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
              'Apotek Mentari Drugs',
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
            child: _streamBhp(context),
          )
        ],
      ),
    );
  }

  Widget _streamBhp(BuildContext context) {
    return StreamBuilder<ApiResponse<MasterBhpByCategoryModel>>(
      stream: _masterBhpCategoryBloc.bhpCategoryStream,
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
              return ListBhpCategoryWidget(
                data: snapshot.data!.data!.data,
                selectedData: widget.selectedData,
                filter: _filter,
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

class ListBhpCategoryWidget extends StatefulWidget {
  const ListBhpCategoryWidget({
    super.key,
    this.data,
    this.selectedData,
    this.filter,
  });

  final List<MasterBhp>? data;
  final List<MasterBhp>? selectedData;
  final TextEditingController? filter;

  @override
  State<ListBhpCategoryWidget> createState() => _ListBhpCategoryWidgetState();
}

class _ListBhpCategoryWidgetState extends State<ListBhpCategoryWidget> {
  List<MasterBhp> _data = [];
  List<MasterBhp> _selectedData = [];

  @override
  void initState() {
    super.initState();
    _data = widget.data!;
    if (widget.selectedData!.isNotEmpty) {
      _selectedData = widget.selectedData!;
    }
    widget.filter!.addListener(_filterListener);
  }

  void _selectData(MasterBhp data) {
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
        const Duration(milliseconds: 500),
      );
    }
    if (!mounted) return;
    Navigator.pop(context, _selectedData);
  }

  void _filterListener() async {
    if (widget.filter!.text.isNotEmpty) {
      _data = widget.data!
          .where((e) => e.namaBarang!
              .toLowerCase()
              .contains(widget.filter!.text.toLowerCase()))
          .toList();
    } else {
      _data = widget.data!;
    }
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Flexible(
          child: ListView.separated(
            padding: const EdgeInsets.symmetric(vertical: 22.0),
            shrinkWrap: true,
            itemBuilder: (context, i) {
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
            itemCount: _data.length,
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
                offset: Offset(0.0, -2.0),
              )
            ],
          ),
          child: ButtonRoundedWidget(
            onPressed: _selectedData.isEmpty ? null : _finalSelected,
            backgroundColor: kPrimaryColor,
            foregroundColor: Colors.white,
            label: _selectedData.isEmpty
                ? 'PILIH BARANG'
                : 'PILIH BARANG (${_selectedData.length} barang)',
          ),
        ),
      ],
    );
  }
}
