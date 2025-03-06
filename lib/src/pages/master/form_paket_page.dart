import 'package:dokter_panggil/src/models/master_bhp_paginate_model.dart';
import 'package:dokter_panggil/src/models/master_tindakan_model.dart';
import 'package:dokter_panggil/src/pages/components/card_paket_widget.dart';
import 'package:dokter_panggil/src/pages/components/input_form.dart';
import 'package:dokter_panggil/src/pages/components/list_master_bhp_paginate.dart';
import 'package:dokter_panggil/src/pages/components/list_master_tindakan.dart';
import 'package:dokter_panggil/src/source/config.dart';
import 'package:dokter_panggil/src/source/size_config.dart';
import 'package:flutter/material.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';

class FormPaketPage extends StatefulWidget {
  const FormPaketPage({super.key});

  @override
  State<FormPaketPage> createState() => _FormPaketPageState();
}

class _FormPaketPageState extends State<FormPaketPage> {
  final _formKey = GlobalKey<FormState>();
  final List<BarangHabisPakai> _bhp = [];
  List<MasterTindakan> _tindakan = [];

  bool validateAndSave() {
    var formState = _formKey.currentState;
    if (formState!.validate()) {
      return true;
    }
    return false;
  }

  void _simpan() {
    if (validateAndSave()) {
      //
    }
  }

  void _showMasterTindakan() {
    showBarModalBottomSheet(
      context: context,
      builder: (context) => _streamListTindakan(context),
      duration: const Duration(milliseconds: 500),
    ).then((value) {
      if (value != null) {
        var data = value as List<MasterTindakan>;
        setState(() {
          _tindakan = data;
        });
      }
    });
  }

  void _showMasterBhp() {
    showMaterialModalBottomSheet(
      context: context,
      builder: (context) {
        return _streamListBhp(context);
      },
      duration: const Duration(milliseconds: 500),
    );
  }

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return Scaffold(
      appBar: AppBar(
        backgroundColor: kPrimaryColor,
        title: const Text('Tambah Paket/promo'),
      ),
      body: Column(
        children: [
          Expanded(
            child: Form(
              key: _formKey,
              child: ListView(
                padding: const EdgeInsets.symmetric(vertical: 12.0),
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(vertical: 22.0),
                    decoration:
                        const BoxDecoration(color: Colors.white, boxShadow: [
                      BoxShadow(
                        color: Colors.black12,
                        blurRadius: 6.0,
                        offset: Offset(2.0, 2.0),
                      )
                    ]),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Padding(
                          padding: EdgeInsets.symmetric(horizontal: 22.0),
                          child: Text(
                            'Deskripsi Paket',
                            style: TextStyle(
                                fontSize: 16.0, fontWeight: FontWeight.w600),
                          ),
                        ),
                        const Divider(
                          height: 32.0,
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 22.0),
                          child: Input(
                            label: 'Nama',
                            hint: 'Ketikkan nama paket/promo',
                            textInputAction: TextInputAction.next,
                            validator: (val) {
                              if (val!.isEmpty) {
                                return 'Input required';
                              }
                              return null;
                            },
                          ),
                        ),
                        const SizedBox(
                          height: 18.0,
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 22.0),
                          child: Input(
                            label: 'Harga',
                            hint: 'Ketikkan harga paket/promo',
                            keyType: TextInputType.number,
                            validator: (val) {
                              if (val!.isEmpty) {
                                return 'Input required';
                              }
                              return null;
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(
                    height: 12.0,
                  ),
                  CardPaketWidget(
                    title: 'Barang Habis Pakai',
                    onTap: _showMasterBhp,
                  ),
                  const SizedBox(
                    height: 12.0,
                  ),
                  CardPaketWidget(
                    title: 'Tindakan',
                    onTap: _showMasterTindakan,
                  ),
                  const SizedBox(
                    height: 12.0,
                  ),
                  CardPaketWidget(
                    title: 'Resep',
                    onTap: () {},
                  ),
                  const SizedBox(
                    height: 12.0,
                  ),
                  CardPaketWidget(
                    title: 'Tindakan Laboratorium',
                    onTap: () {},
                  ),
                ],
              ),
            ),
          ),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(22.0),
            decoration: const BoxDecoration(
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                    color: Colors.black12,
                    blurRadius: 6,
                    offset: Offset(0.0, -2.0))
              ],
            ),
            child: ElevatedButton(
              onPressed: _simpan,
              style: ElevatedButton.styleFrom(
                backgroundColor: kPrimaryColor,
                minimumSize: const Size(0.0, 46.0),
              ),
              child: const Text('Simpan'),
            ),
          ),
        ],
      ),
    );
  }

  Widget _streamListBhp(BuildContext context) {
    return SizedBox(
      height: SizeConfig.blockSizeVertical * 80,
      child: ListMasterBhpPaginate(),
    );
  }

  Widget _streamListTindakan(BuildContext context) {
    return SizedBox(
      height: SizeConfig.blockSizeVertical * 80,
      child: ListMasterTindakan(
        selectedData: _tindakan,
      ),
    );
  }
}
