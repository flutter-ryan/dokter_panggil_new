import 'package:dokter_panggil/src/pages/components/confirm_dialog.dart';
import 'package:dokter_panggil/src/pages/components/input_no_label.dart';
import 'package:dokter_panggil/src/pages/master/list_master_farmasi_paket.dart';
import 'package:dokter_panggil/src/pages/master/paket_item/item_resep.dart';
import 'package:dokter_panggil/src/source/config.dart';
import 'package:dokter_panggil/src/source/size_config.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:dokter_panggil/src/source/transition/animated_dialog.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:dokter_panggil/src/pages/components/error_response.dart';

class ShowFarmasi extends StatefulWidget {
  const ShowFarmasi({super.key});

  @override
  State<ShowFarmasi> createState() => _ShowFarmasiState();
}

class _ShowFarmasiState extends State<ShowFarmasi> {
  final _formKey = GlobalKey<FormState>();
  List<FarmasiSelected> _farmasi = [];
  final List<TextEditingController> _listJumlah = [];
  final List<TextEditingController> _listAturan = [];
  final List<TextEditingController> _listCatatan = [];

  bool validateAndSave() {
    var formState = _formKey.currentState;
    if (formState!.validate()) {
      return true;
    }
    return false;
  }

  void _showBarangFarmasi() {
    showMaterialModalBottomSheet(
      context: context,
      builder: (context) {
        return Padding(
          padding:
              EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
          child: _streamListFarmasi(context),
        );
      },
      duration: const Duration(milliseconds: 500),
    ).then((value) {
      if (value != null) {
        var data = value as List<FarmasiSelected>;
        setState(() {
          _farmasi = data;
        });
      }
    });
  }

  void _pilihBarangFarmasi() {
    SystemChannels.textInput.invokeMethod('TextInput.hide');
    FocusScope.of(context).requestFocus(FocusNode());
    if (validateAndSave()) {
      Future.delayed(const Duration(milliseconds: 500), () {
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
              Navigator.pop(context, _farmasi);
            });
          }
        });
      });
    }
  }

  @override
  Widget build(BuildContext context) {
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
            child: _buildFormFarmasi(context),
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
                  onPressed: _showBarangFarmasi,
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
                    onPressed: _farmasi.isEmpty ? null : _pilihBarangFarmasi,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: kPrimaryColor,
                      minimumSize: const Size.fromHeight(45),
                    ),
                    child: _farmasi.isEmpty
                        ? const Text('Pilih obat')
                        : Text('Pilih ${_farmasi.length} barang farmasi'),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _streamListFarmasi(BuildContext context) {
    return Container(
      constraints: BoxConstraints(
        minHeight: SizeConfig.blockSizeVertical * 35,
        maxHeight: SizeConfig.blockSizeVertical * 90,
      ),
      child: ListMasterFarmasiPaket(
        selectedData: _farmasi,
      ),
    );
  }

  Widget _buildFormFarmasi(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(vertical: 12),
      child: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 22.0),
              child: Text(
                'Input Barang Farmasi',
                style: TextStyle(fontSize: 22, fontWeight: FontWeight.w600),
              ),
            ),
            const SizedBox(
              height: 12.0,
            ),
            if (_farmasi.isEmpty)
              _noDataWidget(context)
            else
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: ListTile.divideTiles(
                  tiles: _farmasi.map((obat) {
                    _listJumlah.add(TextEditingController());
                    _listAturan.add(TextEditingController());
                    _listCatatan.add(TextEditingController());
                    return Padding(
                      padding: const EdgeInsets.all(22.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          ListTile(
                            title: Row(
                              children: [
                                Expanded(child: Text('${obat.namaBarang}')),
                                const SizedBox(
                                  width: 12.0,
                                ),
                                CircleAvatar(
                                  backgroundColor: Colors.transparent,
                                  foregroundColor: Colors.red,
                                  child: IconButton(
                                      onPressed: () {
                                        _farmasi.removeWhere(
                                            (e) => e.id == obat.id);
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
                                      controller:
                                          _listJumlah[_farmasi.indexOf(obat)],
                                      hint: 'Jumlah',
                                      onChanged: (val) =>
                                          obat.jumlah = int.parse(val!),
                                      keyboardType: TextInputType.number,
                                      textInputAction: TextInputAction.next,
                                    ),
                                  ),
                                  const SizedBox(
                                    width: 12.0,
                                  ),
                                  Expanded(
                                    flex: 4,
                                    child: InputNoLabel(
                                      hint: 'Aturan pakai',
                                      controller:
                                          _listAturan[_farmasi.indexOf(obat)],
                                      onChanged: (val) =>
                                          obat.aturanPakai = val,
                                      textInputAction: TextInputAction.next,
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
                            controller: _listCatatan[_farmasi.indexOf(obat)],
                            onChanged: (val) => obat.catatan = val,
                            validate: false,
                          )
                        ],
                      ),
                    );
                  }).toList(),
                  context: context,
                ).toList(),
              )
          ],
        ),
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
