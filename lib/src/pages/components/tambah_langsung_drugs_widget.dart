import 'dart:io';

import 'package:dokter_panggil/src/models/master_bhp_model.dart';
import 'package:dokter_panggil/src/pages/components/button_circle_widget.dart';
import 'package:dokter_panggil/src/pages/components/button_rounded_widget.dart';
import 'package:dokter_panggil/src/pages/components/list_master_bhp_category.dart';
import 'package:dokter_panggil/src/source/config.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';

class TambahLangsungDrugsWidget extends StatefulWidget {
  const TambahLangsungDrugsWidget({
    super.key,
    this.selectedData,
  });

  final List<SelectedObatInjeksi>? selectedData;

  @override
  State<TambahLangsungDrugsWidget> createState() =>
      _TambahLangsungDrugsWidgetState();
}

class _TambahLangsungDrugsWidgetState extends State<TambahLangsungDrugsWidget> {
  final _formKey = GlobalKey<FormState>();
  List<MasterBhp> _selected = [];
  List<SelectedObatInjeksi> _selectedObatInjeksi = [];
  final List<TextEditingController> _jumlah = [];
  final List<TextEditingController> _aturan = [];
  final List<TextEditingController> _catatan = [];

  bool validateAndSave() {
    var formData = _formKey.currentState;
    if (formData!.validate()) {
      formData.save();
      return true;
    }
    return false;
  }

  @override
  void initState() {
    super.initState();
    if (widget.selectedData!.isNotEmpty) {
      _selectedObatInjeksi = widget.selectedData!;
    }
  }

  void _showMasterBhp() {
    showBarModalBottomSheet(
      context: context,
      builder: (context) {
        return Padding(
          padding:
              EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
          child: ListMasterBhpCategory(
            category: 2,
            selectedData: _selected,
          ),
        );
      },
      duration: const Duration(milliseconds: 500),
    ).then((value) {
      if (value != null) {
        var data = value as List<MasterBhp>;
        _selected = data;
        data.asMap().forEach((key, drug) {
          _selectedObatInjeksi.add(SelectedObatInjeksi(
            id: drug.id,
            barang: drug.namaBarang,
            hargaModal: drug.hargaModal,
            tarifAplikasi: drug.tarifAplikasi,
          ));
        });
        setState(() {});
      }
    });
  }

  void _deleteSelected(SelectedObatInjeksi data) {
    _jumlah[_selectedObatInjeksi.indexOf(data)].clear();
    _aturan[_selectedObatInjeksi.indexOf(data)].clear();
    _catatan[_selectedObatInjeksi.indexOf(data)].clear();
    _selectedObatInjeksi.removeWhere((e) => e.id == data.id);
    _selected.removeWhere((e) => e.id == data.id);
    setState(() {});
  }

  Future<void> _finalSelected() async {
    if (validateAndSave()) {
      SystemChannels.textInput.invokeMethod('TextInput.hide');
      FocusScope.of(context).requestFocus(FocusNode());
      if (MediaQuery.of(context).viewInsets.bottom > 0.0) {
        await Future.delayed(
          const Duration(milliseconds: 500),
        );
      }
      if (!mounted) return;
      Navigator.pop(context, _selectedObatInjeksi);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        foregroundColor: Colors.black,
        leading: IconButton(
          onPressed: () => Navigator.pop(context, _selectedObatInjeksi),
          icon: Platform.isAndroid
              ? const Icon(Icons.arrow_back)
              : const Icon(Icons.arrow_back_ios),
        ),
        systemOverlayStyle: SystemUiOverlayStyle(
          statusBarBrightness: Brightness.light,
          statusBarIconBrightness: Brightness.dark,
          systemNavigationBarColor: Colors.white,
          systemNavigationBarIconBrightness: Brightness.dark,
        ),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 18.0, vertical: 8.0),
            child: Text(
              'Obat Injeksi Apotek Mentari',
              style: TextStyle(fontSize: 22.0, fontWeight: FontWeight.w600),
            ),
          ),
          Expanded(
            child: _selectedObatInjeksi.isNotEmpty
                ? _formInputDrug(context)
                : const Center(
                    child: Text(
                      'Data obat tidak tersedia',
                      style: TextStyle(fontSize: 16.0, color: Colors.grey),
                    ),
                  ),
          ),
          Container(
            padding: const EdgeInsets.all(22.0),
            decoration: const BoxDecoration(
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                  color: Colors.black12,
                  offset: Offset(-2.0, -2.0),
                  blurRadius: 12,
                ),
              ],
            ),
            child: Row(
              children: [
                ButtonCircleWidget(
                  onPressed: _showMasterBhp,
                ),
                const SizedBox(
                  width: 12.0,
                ),
                Expanded(
                  child: ButtonRoundedWidget(
                    onPressed:
                        _selectedObatInjeksi.isEmpty ? null : _finalSelected,
                    backgroundColor: kPrimaryColor,
                    foregroundColor: Colors.white,
                    label: 'Simpan Barang',
                  ),
                )
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _formInputDrug(BuildContext context) {
    return SingleChildScrollView(
      child: Form(
        key: _formKey,
        child: Column(
          children: ListTile.divideTiles(
            context: context,
            tiles: _selectedObatInjeksi.map((drug) {
              _jumlah.add(TextEditingController());
              _aturan.add(TextEditingController());
              _catatan.add(TextEditingController());
              if (_selectedObatInjeksi.isNotEmpty) {
                _jumlah[_selectedObatInjeksi.indexOf(drug)].text =
                    drug.jumlah.toString();
                _aturan[_selectedObatInjeksi.indexOf(drug)].text = drug.aturan;
                _catatan[_selectedObatInjeksi.indexOf(drug)].text =
                    drug.catatan;
              }
              return Padding(
                padding: const EdgeInsets.all(18.0),
                child: Column(
                  children: [
                    ListTile(
                      contentPadding: EdgeInsets.zero,
                      title: Text('${drug.barang}'),
                      trailing: IconButton(
                        onPressed: () => _deleteSelected(drug),
                        icon: const Icon(
                          Icons.delete,
                          color: Colors.red,
                        ),
                      ),
                    ),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          flex: 2,
                          child: InputFormNoBorder(
                            hint: 'Jumlah',
                            controller:
                                _jumlah[_selectedObatInjeksi.indexOf(drug)],
                            keyboardType: TextInputType.number,
                            textInputAction: TextInputAction.next,
                            onSaved: (val) {
                              drug.jumlah = int.parse(val!);
                            },
                          ),
                        ),
                        const SizedBox(
                          width: 12.0,
                        ),
                        Expanded(
                          flex: 3,
                          child: InputFormNoBorder(
                            hint: 'Aturan pakai',
                            controller:
                                _aturan[_selectedObatInjeksi.indexOf(drug)],
                            keyboardType: TextInputType.multiline,
                            textInputAction: TextInputAction.newline,
                            onSaved: (val) {
                              drug.aturan = val!;
                            },
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(
                      height: 12.0,
                    ),
                    InputFormNoBorder(
                      hint: 'Catatan',
                      validate: false,
                      minLines: 2,
                      controller: _catatan[_selectedObatInjeksi.indexOf(drug)],
                      keyboardType: TextInputType.multiline,
                      textInputAction: TextInputAction.newline,
                      onSaved: (val) {
                        drug.catatan = val!;
                      },
                    )
                  ],
                ),
              );
            }).toList(),
          ).toList(),
        ),
      ),
    );
  }
}

class InputFormNoBorder extends StatelessWidget {
  const InputFormNoBorder({
    super.key,
    this.controller,
    this.hint,
    this.onSaved,
    this.validate = true,
    this.minLines = 1,
    this.keyboardType = TextInputType.text,
    this.textInputAction = TextInputAction.done,
  });

  final TextEditingController? controller;
  final String? hint;
  final Function(String? val)? onSaved;
  final bool validate;
  final int minLines;
  final TextInputType keyboardType;
  final TextInputAction textInputAction;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      decoration: InputDecoration(
        contentPadding:
            const EdgeInsets.symmetric(vertical: 18.0, horizontal: 12.0),
        hintText: '$hint',
        fillColor: Colors.grey[200],
        filled: true,
        border: InputBorder.none,
        hintStyle: TextStyle(color: Colors.grey[600]),
      ),
      minLines: minLines,
      maxLines: null,
      validator: (val) {
        if (val!.isEmpty && validate) {
          return 'Requierd';
        }
        return null;
      },
      keyboardType: keyboardType,
      textInputAction: textInputAction,
      onSaved: onSaved,
    );
  }
}

class SelectedObatInjeksi {
  SelectedObatInjeksi({
    this.id,
    this.barang,
    this.jumlah = 1,
    this.hargaModal,
    this.tarifAplikasi,
    this.aturan = '',
    this.catatan = '',
  });

  int? id;
  String? barang;
  int jumlah;
  int? hargaModal;
  int? tarifAplikasi;
  String aturan;
  String catatan;
}
