import 'dart:io';

import 'package:dokter_panggil/src/models/master_bhp_model.dart';
import 'package:dokter_panggil/src/pages/components/list_master_bhp_category.dart';
import 'package:dokter_panggil/src/source/config.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';

class TambahLangsungConsume extends StatefulWidget {
  const TambahLangsungConsume({
    super.key,
    this.selectedData,
    this.category,
  });

  final List<SelectedConsume>? selectedData;
  final int? category;

  @override
  State<TambahLangsungConsume> createState() => _TambahLangsungConsumeState();
}

class _TambahLangsungConsumeState extends State<TambahLangsungConsume> {
  List<MasterBhp> _selected = [];
  final List<int> _selectedId = [];
  List<SelectedConsume> _selectedConsume = [];
  final List<TextEditingController> _jumlah = [];
  final _formKey = GlobalKey<FormState>();

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
    if (widget.selectedData != null) {
      widget.selectedData!.asMap().forEach((key, consume) {
        _selectedId.add(consume.id!);
        _selected.add(
          MasterBhp(
            id: consume.id,
            namaBarang: consume.barang,
          ),
        );
      });
      _selectedConsume = widget.selectedData!;
    }
  }

  void _showMasterBhp() {
    showBarModalBottomSheet(
      context: context,
      builder: (context) {
        return ListMasterBhpCategory(
          category: 4,
          selectedData: _selected,
        );
      },
      duration: const Duration(milliseconds: 500),
    ).then((value) {
      if (value != null) {
        var data = value as List<MasterBhp>;
        _selected = data;
        data.asMap().forEach((key, consume) {
          if (_selectedConsume.where((e) => e.id == consume.id).isEmpty) {
            _selectedConsume.add(
              SelectedConsume(
                id: consume.id!,
                barang: '${consume.namaBarang}',
                jumlah: 1,
                hargaModal: consume.hargaModal!,
                tarifAplikasi: consume.tarifAplikasi!,
              ),
            );
          } else {}
        });
        setState(() {});
      }
    });
  }

  void _deleteSelected(int id) {
    setState(() {
      _selectedConsume.removeWhere((e) => e.id == id);
      _selected.removeWhere((e) => e.id == id);
    });
  }

  void _simpanBarang() {
    if (validateAndSave()) {
      SystemChannels.textInput.invokeMethod('TextInput.hide');
      WidgetsBinding.instance.addPostFrameCallback(
        (timeStamp) => Navigator.pop(context, _selectedConsume),
      );
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
          onPressed: () => Navigator.pop(context, _selectedConsume),
          icon: Platform.isAndroid
              ? const Icon(Icons.arrow_back)
              : const Icon(Icons.arrow_back_ios),
        ),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 18.0, vertical: 8.0),
            child: Text(
              'Consumable Apotek Mentari',
              style: TextStyle(fontSize: 22.0, fontWeight: FontWeight.w600),
            ),
          ),
          Expanded(
            child: _selectedConsume.isNotEmpty
                ? _formInputConsumable(context)
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
                ElevatedButton(
                  onPressed: _showMasterBhp,
                  style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.grey[200],
                      foregroundColor: Colors.black,
                      minimumSize: const Size(52, 45)),
                  child: const Icon(Icons.add_rounded),
                ),
                const SizedBox(
                  width: 12.0,
                ),
                Expanded(
                    child: ElevatedButton(
                  onPressed: _selectedConsume.isEmpty ? null : _simpanBarang,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: kPrimaryColor,
                    minimumSize: const Size.fromHeight(45),
                  ),
                  child: const Text('Simpan Barang'),
                ))
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _formInputConsumable(BuildContext context) {
    return SingleChildScrollView(
      child: Form(
        key: _formKey,
        child: Column(
          children: ListTile.divideTiles(
            context: context,
            tiles: _selectedConsume.map((consume) {
              _jumlah.add(TextEditingController());
              _jumlah[_selectedConsume.indexOf(consume)].text =
                  '${consume.jumlah}';
              return Padding(
                padding: const EdgeInsets.symmetric(vertical: 8.0),
                child: Column(
                  children: [
                    ListTile(
                      title: Text('${consume.barang}'),
                      trailing: IconButton(
                        onPressed: () => _deleteSelected(consume.id!),
                        icon: const Icon(
                          Icons.delete,
                          color: Colors.red,
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 15.0, vertical: 8),
                      child: Row(
                        children: [
                          Expanded(
                            flex: 2,
                            child: TextFormField(
                              controller:
                                  _jumlah[_selectedConsume.indexOf(consume)],
                              decoration: InputDecoration(
                                hintText: 'Jumlah',
                                fillColor: Colors.grey[200],
                                filled: true,
                                border: InputBorder.none,
                                hintStyle: const TextStyle(color: Colors.grey),
                              ),
                              validator: (val) {
                                if (val!.isEmpty) {
                                  return 'Requierd';
                                }
                                return null;
                              },
                              keyboardType: TextInputType.number,
                              onSaved: (val) {
                                _selectedConsume[
                                        _selectedConsume.indexOf(consume)]
                                    .jumlah = int.parse(val!);
                              },
                            ),
                          ),
                          const SizedBox(
                            width: 12.0,
                          ),
                        ],
                      ),
                    ),
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

class SelectedConsume {
  SelectedConsume({
    this.id,
    this.barang,
    this.jumlah = 1,
    this.hargaModal,
    this.tarifAplikasi,
  });

  int? id;
  String? barang;
  int jumlah;
  int? hargaModal;
  int? tarifAplikasi;
}
