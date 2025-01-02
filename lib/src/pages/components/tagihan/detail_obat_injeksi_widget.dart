import 'package:animate_icons/animate_icons.dart';
import 'package:dokter_panggil/src/blocs/kunjungan_obat_injeksi_update_bloc.dart';
import 'package:dokter_panggil/src/models/kunjungan_obat_injeksi_update_model.dart';
import 'package:dokter_panggil/src/models/master_bhp_model.dart';
import 'package:dokter_panggil/src/models/pasien_kunjungan_detail_model.dart';
import 'package:dokter_panggil/src/pages/components/card_tagihan.dart';
import 'package:dokter_panggil/src/pages/components/error_dialog.dart';
import 'package:dokter_panggil/src/pages/components/input_form.dart';
import 'package:dokter_panggil/src/pages/components/loading_kit.dart';
import 'package:dokter_panggil/src/pages/components/success_dialog.dart';
import 'package:dokter_panggil/src/pages/components/tagihan/detail_bhp_widget.dart';
import 'package:dokter_panggil/src/pages/components/tagihan/resep_injeksi_widget.dart';
import 'package:dokter_panggil/src/pages/components/tagihan/tile_obat_widget.dart';
import 'package:dokter_panggil/src/repositories/responseApi/api_response.dart';
import 'package:dokter_panggil/src/source/config.dart';
import 'package:dokter_panggil/src/source/transition/slide_bottom_route.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:dokter_panggil/src/source/transition/animated_dialog.dart';
import 'package:intl/intl.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';

class DetailObatInjeksiWidget extends StatefulWidget {
  const DetailObatInjeksiWidget({
    super.key,
    required this.data,
    this.type,
    this.reload,
    this.role,
  });

  final DetailKunjungan data;
  final String? type;
  final Function(DetailKunjungan kunjungan)? reload;
  final int? role;

  @override
  State<DetailObatInjeksiWidget> createState() =>
      _DetailObatInjeksiWidgetState();
}

class _DetailObatInjeksiWidgetState extends State<DetailObatInjeksiWidget> {
  final _kunjunganObatInjeksiUpdateBloc = KunjunganObatInjeksiUpdateBloc();
  final _animateIconController = AnimateIconController();
  final _scrollCon = ScrollController();
  final _rupiah =
      NumberFormat.currency(locale: 'id', symbol: 'Rp. ', decimalDigits: 0);
  final _rupiahNo =
      NumberFormat.currency(locale: 'id', symbol: '', decimalDigits: 0);
  final _namaBarang = TextEditingController();
  final _jumlah = TextEditingController();
  final _alasan = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  List<ResepObatInjeksi> _data = [];
  int? _selectedId;
  int _hargaModal = 0;
  int _tarifAplikasi = 0;

  @override
  void initState() {
    super.initState();
    if (widget.data.resepObatInjeksi != null) {
      _data = widget.data.resepObatInjeksi!;
    }
  }

  bool validateAndSave() {
    var formData = _formKey.currentState;
    if (formData!.validate()) {
      formData.save();
      return true;
    }
    return false;
  }

  void _edit(BuildContext context, ResepObatInjeksi resep) {
    _kunjunganObatInjeksiUpdateBloc.idSink.add(resep.id!);
    // _selectedId = obat.barang!.id;
    // _namaBarang.text = '${obat.barang!.namaBarang}';
    // _jumlah.text = '${obat.jumlah}';
    // _tarifAplikasi = obat.tarifAplikasi!;
    // _hargaModal = obat.hargaModal!;
    showBarModalBottomSheet(
      context: context,
      builder: (context) {
        return Padding(
          padding:
              EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
          child: _editFormObatInjeksi(resep),
        );
      },
      duration: const Duration(milliseconds: 500),
    );
  }

  void _updateKunjunganObatInjeksi() {
    if (validateAndSave()) {
      SystemChannels.textInput.invokeListMethod('TextInput.hide');
      _kunjunganObatInjeksiUpdateBloc.barangSink.add(_selectedId!);
      _kunjunganObatInjeksiUpdateBloc.jumlahSink.add(int.parse(_jumlah.text));
      _kunjunganObatInjeksiUpdateBloc.hargaModalSink.add(_hargaModal);
      _kunjunganObatInjeksiUpdateBloc.tarifAplikasiSink.add(_tarifAplikasi);
      _kunjunganObatInjeksiUpdateBloc.alasanSink.add(_alasan.text);
      _kunjunganObatInjeksiUpdateBloc.updateObatInjeksi();
      _showStreamUpdateObat();
    }
  }

  void _showStreamUpdateObat() {
    showAnimatedDialog(
      context: context,
      builder: (context) {
        return _streamUpdateObat(context);
      },
      duration: const Duration(milliseconds: 500),
      animationType: DialogTransitionType.slideFromBottomFade,
    ).then((value) {
      if (value != null) {
        var data = value as ResepObatInjeksi;
        _namaBarang.clear();
        _jumlah.clear();
        _alasan.clear();
        Future.delayed(const Duration(milliseconds: 500), () {
          if (!mounted) return;
          Navigator.pop(context);
          _data![_data!.indexWhere((e) => e.id == data.id)] = data;
          setState(() {});
        });
      }
    });
  }

  void _showMasterBhp() {
    Navigator.push(
      context,
      SlideBottomRoute(
        page: ListMasterBhp(
          selectedId: _selectedId,
        ),
      ),
    ).then((value) {
      if (value != null) {
        var data = value as MasterBhp;
        setState(() {
          _selectedId = data.id;
          _namaBarang.text = data.namaBarang!;
          _tarifAplikasi = data.tarifAplikasi!;
          _hargaModal = data.hargaModal!;
        });
      }
    });
  }

  void _eresepInjeksi() {
    showBarModalBottomSheet(
      context: context,
      builder: (context) => _buildEresepInjeksiWidget(context),
    );
  }

  @override
  void dispose() {
    _kunjunganObatInjeksiUpdateBloc.dispose();
    _namaBarang.dispose();
    _jumlah.dispose();
    _alasan.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Cardtagihan(
      title: 'Obat Injeksi',
      subTotal: Text(
        _rupiah.format(widget.data.totalObatInjeksi),
        style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 12),
      ),
      tiles: ListTile.divideTiles(
        context: context,
        tiles: _data
            .map((resep) => Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.fromLTRB(0.0, 12.0, 8.0, 8.0),
                      child: Text(
                        '${resep.tanggalShort}\n${resep.jamShort}',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            fontSize: 12, fontWeight: FontWeight.w600),
                      ),
                    ),
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.fromLTRB(8.0, 14.0, 0.0, 8.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            RichText(
                              text: TextSpan(
                                  text: '${resep.dokter} |',
                                  style: TextStyle(
                                      fontSize: 12,
                                      color: Colors.black,
                                      fontWeight: FontWeight.w600),
                                  children: [
                                    TextSpan(
                                        text: ' E-Resep',
                                        style:
                                            TextStyle(color: Colors.blueAccent),
                                        recognizer: TapGestureRecognizer()
                                          ..onTap = () {}),
                                  ]),
                            ),
                            ...resep.obatInjeksi!.map((obat) => TileObatWidget(
                                  title: '${obat.barang!.namaBarang}',
                                  subtitle:
                                      '${obat.jumlah} x ${_rupiahNo.format(obat.hargaModal! + obat.tarifAplikasi!)}',
                                  trailing: _rupiah.format(obat.tarif),
                                ))
                          ],
                        ),
                      ),
                    ),
                  ],
                ))
            .toList(),
      ).toList(),
    );
  }

  Widget _editFormObatInjeksi(ResepObatInjeksi obat) {
    return Form(
      key: _formKey,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 18.0),
            child: Row(
              children: [
                const SizedBox(
                  width: 22.0,
                ),
                const Expanded(
                  child: Text(
                    'Edit Barang Habis Pakai',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
                  ),
                ),
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  style: TextButton.styleFrom(foregroundColor: Colors.grey),
                  child: const Icon(Icons.close_rounded),
                ),
              ],
            ),
          ),
          Flexible(
            child: ListView(
              controller: _scrollCon,
              padding:
                  const EdgeInsets.symmetric(horizontal: 22.0, vertical: 18.0),
              shrinkWrap: true,
              children: [
                Input(
                  controller: _namaBarang,
                  label: 'Nama Barang',
                  hint: 'Inputkan nama barang',
                  validator: (value) {
                    if (value!.isEmpty) return 'Input required';
                    return null;
                  },
                  readOnly: true,
                  suffixIcon: AnimateIcons(
                    startIconColor: Colors.grey,
                    endIconColor: Colors.grey,
                    startIcon: Icons.expand_more_rounded,
                    endIcon: Icons.expand_less_rounded,
                    duration: const Duration(milliseconds: 300),
                    onStartIconPress: () {
                      _showMasterBhp();
                      return false;
                    },
                    onEndIconPress: () {
                      Navigator.pop(context);
                      return false;
                    },
                    controller: _animateIconController,
                  ),
                  onTap: _showMasterBhp,
                ),
                const SizedBox(
                  height: 28.0,
                ),
                Input(
                  controller: _jumlah,
                  label: 'Jumlah',
                  hint: 'Inputkan jumlah barang',
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'Input required';
                    }
                    return null;
                  },
                ),
                const SizedBox(
                  height: 28.0,
                ),
                Input(
                  controller: _alasan,
                  label: 'Alasan Perubahan',
                  hint: 'Inputkan alasan perubahan barang',
                  minLines: 3,
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'Input required';
                    }
                    return null;
                  },
                  textCap: TextCapitalization.sentences,
                ),
                const SizedBox(
                  height: 42.0,
                ),
                ElevatedButton(
                  onPressed: _updateKunjunganObatInjeksi,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: kPrimaryColor,
                    minimumSize: const Size(double.infinity, 45),
                  ),
                  child: const Text('Update BHP'),
                ),
                const SizedBox(
                  height: 22.0,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _streamUpdateObat(BuildContext context) {
    return StreamBuilder<ApiResponse<ResponseKunjunganObatInkjeksiUpdateModel>>(
      stream: _kunjunganObatInjeksiUpdateBloc.obatInjeksiUpdateStream,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          switch (snapshot.data!.status) {
            case Status.loading:
              return const LoadingKit(
                color: Colors.white,
              );
            case Status.error:
              return ErrorDialog(
                message: snapshot.data!.message,
                onTap: () => Navigator.pop(context),
              );
            case Status.completed:
              return SuccessDialog(
                message: snapshot.data!.data!.message,
                onTap: () => Navigator.pop(context, snapshot.data!.data!.data),
              );
          }
        }
        return const SizedBox();
      },
    );
  }

  Widget _buildEresepInjeksiWidget(BuildContext context) {
    return SizedBox(
      child: DefaultTabController(
        length: widget.data.dokter!.length,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.all(22.0),
              child: Row(
                children: [
                  Expanded(
                    child: Text(
                      'E-Resep Obat Injeksi',
                      style:
                          TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
                    ),
                  ),
                  CircleAvatar(
                    backgroundColor: Colors.grey[100],
                    foregroundColor: Colors.grey[400],
                    child: CloseButton(
                      color: Colors.grey[400],
                    ),
                  ),
                ],
              ),
            ),
            TabBar(
              labelColor: Colors.black,
              isScrollable: true,
              unselectedLabelColor: Colors.grey[400],
              indicatorColor: kPrimaryColor,
              tabs: widget.data.dokter!
                  .map(
                    (dokter) => Tab(
                      child: RichText(
                        text: TextSpan(
                          text: '${dokter.dokter}',
                          style: const TextStyle(color: Colors.black),
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  )
                  .toList(),
            ),
            Expanded(
                child: TabBarView(
                    children: widget.data.dokter!
                        .map(
                          (dokter) => ResepInjeksiWidget(
                            dokter: dokter,
                            idKunjungan: widget.data.id,
                          ),
                        )
                        .toList()))
          ],
        ),
      ),
    );
  }
}
