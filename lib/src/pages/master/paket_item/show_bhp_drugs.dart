import 'package:dokter_panggil/src/pages/components/confirm_dialog.dart';
import 'package:dokter_panggil/src/pages/components/input_no_label.dart';
import 'package:dokter_panggil/src/pages/master/list_master_bhp_paket.dart';
import 'package:dokter_panggil/src/pages/master/paket_item/item_drugs.dart';
import 'package:dokter_panggil/src/source/config.dart';
import 'package:dokter_panggil/src/source/size_config.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:dokter_panggil/src/source/transition/animated_dialog.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:dokter_panggil/src/pages/components/error_response.dart';

class ShowBhpDrugs extends StatefulWidget {
  const ShowBhpDrugs({super.key});

  @override
  State<ShowBhpDrugs> createState() => _ShowBhpDrugsState();
}

class _ShowBhpDrugsState extends State<ShowBhpDrugs> {
  List<BhpSelected> _selected = [];
  final List<TextEditingController> _listJumlah = [];
  final List<TextEditingController> _listAturan = [];
  final List<TextEditingController> _listCatatan = [];
  final _formKey = GlobalKey<FormState>();

  bool validateAndSave() {
    var formState = _formKey.currentState;
    if (formState!.validate()) {
      return true;
    }
    return false;
  }

  void _showBhpDrugs() {
    showMaterialModalBottomSheet(
      context: context,
      builder: (context) {
        return Padding(
          padding:
              EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
          child: _streamListDrugsBhp(context),
        );
      },
      duration: const Duration(milliseconds: 500),
    ).then((value) {
      if (value != null) {
        var data = value as List<BhpSelected>;
        _formKey.currentState!.validate();
        setState(() {
          _selected = data;
        });
      }
    });
  }

  void _pilihDrugs() {
    SystemChannels.textInput.invokeMethod('TextInput.hide');
    FocusScope.of(context).requestFocus(FocusNode());
    if (validateAndSave()) {
      Future.delayed(const Duration(milliseconds: 400), () {
        if (!mounted) return;
        showAnimatedDialog(
          context: context,
          builder: (context) {
            return ConfirmDialogWidget(
              message: 'Anda yakin telah selasai memilih obat?',
              onConfirm: () => Navigator.pop(context, 'confirm'),
              labelConfirm: 'Ya, Selesai',
            );
          },
          animationType: DialogTransitionType.slideFromBottomFade,
          duration: const Duration(milliseconds: 500),
        ).then((value) {
          if (value != null) {
            Future.delayed(const Duration(milliseconds: 500), () {
              if (!mounted) return;
              Navigator.pop(context, _selected);
            });
          }
        });
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return Scaffold(
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            height: MediaQuery.of(context).padding.top,
          ),
          IconButton(
            onPressed: () => Navigator.pop(context),
            icon: const Icon(Icons.arrow_back_rounded),
          ),
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(vertical: 12),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Padding(
                      padding: EdgeInsets.symmetric(horizontal: 22.0),
                      child: Text(
                        'Input Bhp Drugs',
                        style: TextStyle(
                            fontSize: 22, fontWeight: FontWeight.w600),
                      ),
                    ),
                    const SizedBox(
                      height: 12.0,
                    ),
                    if (_selected.isEmpty)
                      _noDataWidget(context)
                    else
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisSize: MainAxisSize.min,
                        children: ListTile.divideTiles(
                          context: context,
                          tiles: _selected.map((drug) {
                            _listJumlah.add(TextEditingController());
                            _listAturan.add(TextEditingController());
                            _listCatatan.add(TextEditingController());
                            return Padding(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 18.0, vertical: 15.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  ListTile(
                                    title: Row(
                                      children: [
                                        Expanded(
                                          child: Text('${drug.namaBarang}'),
                                        ),
                                        const SizedBox(
                                          width: 12.0,
                                        ),
                                        CircleAvatar(
                                          backgroundColor: Colors.transparent,
                                          foregroundColor: Colors.red,
                                          child: IconButton(
                                              onPressed: () {
                                                _selected.removeWhere(
                                                    (e) => e.id == drug.id);
                                                setState(() {});
                                              },
                                              padding: EdgeInsets.zero,
                                              icon: const Icon(
                                                Icons.delete_rounded,
                                                color: Colors.red,
                                              )),
                                        )
                                      ],
                                    ),
                                    contentPadding: EdgeInsets.zero,
                                    subtitle: Padding(
                                      padding: const EdgeInsets.only(top: 12.0),
                                      child: Row(
                                        children: [
                                          Expanded(
                                            flex: 3,
                                            child: InputNoLabel(
                                              controller: _listJumlah[
                                                  _selected.indexOf(drug)],
                                              hint: 'Jumlah',
                                              onChanged: (val) =>
                                                  drug.jumlah = int.parse(val!),
                                              keyboardType:
                                                  TextInputType.number,
                                              textInputAction:
                                                  TextInputAction.next,
                                            ),
                                          ),
                                          const SizedBox(
                                            width: 12.0,
                                          ),
                                          Expanded(
                                            flex: 4,
                                            child: InputNoLabel(
                                              hint: 'Aturan pakai',
                                              controller: _listAturan[
                                                  _selected.indexOf(drug)],
                                              onChanged: (val) =>
                                                  drug.aturanPakai = val,
                                              textInputAction:
                                                  TextInputAction.next,
                                            ),
                                          )
                                        ],
                                      ),
                                    ),
                                  ),
                                  const SizedBox(
                                    height: 12.0,
                                  ),
                                  InputNoLabel(
                                    hint: 'Catatan',
                                    validate: false,
                                    controller:
                                        _listCatatan[_selected.indexOf(drug)],
                                    onChanged: (val) => drug.catatan = val,
                                  )
                                ],
                              ),
                            );
                          }).toList(),
                        ).toList(),
                      ),
                  ],
                ),
              ),
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 22, vertical: 18.0),
            decoration: const BoxDecoration(color: Colors.white, boxShadow: [
              BoxShadow(
                color: Colors.black12,
                blurRadius: 4,
                offset: Offset(0.0, 0.0),
              ),
            ]),
            child: Row(
              children: [
                ElevatedButton(
                  onPressed: _showBhpDrugs,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.grey[100],
                    foregroundColor: Colors.black,
                    minimumSize: const Size(50, 45),
                  ),
                  child: const Icon(Icons.add_rounded),
                ),
                const SizedBox(
                  width: 12,
                ),
                Expanded(
                  child: ElevatedButton(
                    onPressed: _selected.isEmpty ? null : _pilihDrugs,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: kPrimaryColor,
                      minimumSize: const Size.fromHeight(45),
                    ),
                    child: _selected.isEmpty
                        ? const Text('Pilih obat')
                        : Text('Pilih ${_selected.length} Obat'),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _streamListDrugsBhp(BuildContext context) {
    return Container(
      constraints: BoxConstraints(
        minHeight: SizeConfig.blockSizeVertical * 35,
        maxHeight: SizeConfig.blockSizeVertical * 90,
      ),
      child: ListMasterBhpPaket(
        selectedData: _selected,
        idKategori: 2,
        title: 'DRUGS',
      ),
    );
  }

  Widget _noDataWidget(BuildContext context) {
    return SizedBox(
      height: SizeConfig.blockSizeVertical * 70,
      child: const Padding(
        padding: EdgeInsets.symmetric(horizontal: 22.0),
        child: ErrorResponse(
          message:
              'Data obat terpilih tidak tersedia.\nTap tombol untuk menambahkan obat',
          button: false,
        ),
      ),
    );
  }
}
