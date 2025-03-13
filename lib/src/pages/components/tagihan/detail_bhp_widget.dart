import 'package:animate_icons/animate_icons.dart';
import 'package:collection/collection.dart';
import 'package:dokter_panggil/src/blocs/bhp_kategori_bloc.dart';
import 'package:dokter_panggil/src/blocs/kunjungan_bhp_update_bloc.dart';
import 'package:dokter_panggil/src/blocs/master_bhp_by_category_bloc.dart';
import 'package:dokter_panggil/src/models/bhp_kategori_model.dart';
import 'package:dokter_panggil/src/models/kunjungan_bhp_update_model.dart';
import 'package:dokter_panggil/src/models/master_bhp_by_category_model.dart';
import 'package:dokter_panggil/src/models/master_bhp_model.dart';
import 'package:dokter_panggil/src/models/pasien_kunjungan_detail_model.dart';
import 'package:dokter_panggil/src/pages/components/card_tagihan.dart';
import 'package:dokter_panggil/src/pages/components/error_response.dart';
import 'package:dokter_panggil/src/pages/components/error_dialog.dart';
import 'package:dokter_panggil/src/pages/components/input_form.dart';
import 'package:dokter_panggil/src/pages/components/loading_kit.dart';
import 'package:dokter_panggil/src/pages/components/success_dialog.dart';
import 'package:dokter_panggil/src/pages/components/tagihan/tile_obat_widget.dart';
import 'package:dokter_panggil/src/repositories/responseApi/api_response.dart';
import 'package:dokter_panggil/src/source/config.dart';
import 'package:dokter_panggil/src/source/transition/slide_bottom_route.dart';
import 'package:flutter/material.dart';
import 'package:dokter_panggil/src/source/transition/animated_dialog.dart';
import 'package:intl/intl.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';

class DetailBhpWidget extends StatefulWidget {
  const DetailBhpWidget({
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
  State<DetailBhpWidget> createState() => _DetailBhpWidgetState();
}

class _DetailBhpWidgetState extends State<DetailBhpWidget> {
  final _animateIconController = AnimateIconController();
  final _kunjunganBhpUpdateBloc = KunjunganBhpUpdateBloc();
  final _scrollCon = ScrollController();
  final _rupiah =
      NumberFormat.currency(locale: 'id', symbol: 'Rp. ', decimalDigits: 0);
  final _rupiahNo =
      NumberFormat.currency(locale: 'id', symbol: '', decimalDigits: 0);
  final _namaBarang = TextEditingController();
  final _jumlah = TextEditingController();
  final _alasan = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  List<Bhp> _data = [];
  List<BhpMr> _dataMr = [];
  int? _selectedId;
  int _hargaModal = 0;
  int _tarifAplikasi = 0;
  List<BarangLab> _bhpLab = [];

  @override
  void initState() {
    super.initState();
    _data = widget.data.bhp!;
    _dataMr = widget.data.bhpMr!;
    if (widget.data.bhpLabMr!.isNotEmpty) {
      groupBy(widget.data.bhpLabMr!, (bhpLab) => bhpLab.createdAt).forEach(
        (tanggal, list) => _bhpLab.add(
          BarangLab(tanggal: tanggal, data: list),
        ),
      );
    }
  }

  bool validateAndSave() {
    var formData = _formKey.currentState;
    if (formData!.validate()) {
      return true;
    }
    return false;
  }

  void _edit(BuildContext context, Bhp bhp) {
    _kunjunganBhpUpdateBloc.idSink.add(bhp.id!);
    _selectedId = bhp.barang!.id;
    _namaBarang.text = '${bhp.barang!.namaBarang}';
    _jumlah.text = '${bhp.jumlah}';
    _tarifAplikasi = bhp.tarifAplikasi!;
    _hargaModal = bhp.hargaModal!;
    showBarModalBottomSheet(
      context: context,
      isDismissible: false,
      builder: (context) {
        return Padding(
          padding:
              EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
          child: _editFormBhp(bhp),
        );
      },
      duration: const Duration(milliseconds: 500),
    ).then((value) {
      if (value != null) {
        _kunjunganBhpUpdateBloc.barangSink.add(_selectedId!);
        _kunjunganBhpUpdateBloc.jumlahSink.add(int.parse(_jumlah.text));
        _kunjunganBhpUpdateBloc.hargaModalSink.add(_hargaModal);
        _kunjunganBhpUpdateBloc.tarifAplikasiSink.add(_tarifAplikasi);
        _kunjunganBhpUpdateBloc.alasanSink.add(_alasan.text);
        _kunjunganBhpUpdateBloc.updateKunjunganBhp();
        _showStreamKunjunganBhp();
      }
    });
  }

  void _updateBhpKunjungan() {
    if (validateAndSave()) {
      Navigator.pop(context, 'update');
    }
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

  void _showStreamKunjunganBhp() {
    showAnimatedDialog(
      context: context,
      builder: (context) {
        return _streamKunjunganBhp(context);
      },
      duration: const Duration(milliseconds: 500),
      animationType: DialogTransitionType.slideFromBottomFade,
    ).then((value) {
      var data = value as DetailKunjungan;
      _alasan.clear();
      widget.reload!(data);
    });
  }

  @override
  void didUpdateWidget(covariant DetailBhpWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.data != widget.data) {
      _data = widget.data.bhp!;
      setState(() {});
    }
  }

  @override
  void dispose() {
    _kunjunganBhpUpdateBloc.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (widget.data.isEmr == 0) {
      return _oldBhpWidget(context);
    }
    return Cardtagihan(
      title: 'Barang Habis Pakai',
      subTotal: Text(
        _rupiah.format(widget.data.totalBhp),
        style: const TextStyle(fontWeight: FontWeight.w600),
      ),
      tiles: [
        ...ListTile.divideTiles(
          context: context,
          tiles: _dataMr
              .map((bhp) => Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.fromLTRB(0.0, 12.0, 8.0, 8.0),
                        child: Text(
                          '${bhp.tanggalShort}\n${bhp.jamShort}',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              fontSize: 12, fontWeight: FontWeight.w600),
                        ),
                      ),
                      Expanded(
                        child: Padding(
                          padding:
                              const EdgeInsets.fromLTRB(8.0, 12.0, 0.0, 8.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                '${bhp.namaPegawai}',
                                style: TextStyle(
                                    fontSize: 12,
                                    color: Colors.black,
                                    fontWeight: FontWeight.w600),
                              ),
                              ...bhp.kunjunganBhp!
                                  .map((barang) => TileObatWidget(
                                        title: '${barang.barang!.namaBarang}',
                                        subtitle:
                                            '${barang.jumlah} x ${_rupiahNo.format(barang.hargaModal! + barang.tarifAplikasi!)}',
                                        trailing: _rupiah.format(barang.tarif),
                                      ))
                            ],
                          ),
                        ),
                      ),
                    ],
                  ))
              .toList(),
        ),
        Divider(
          height: 0,
        ),
        ...ListTile.divideTiles(
          context: context,
          tiles: _bhpLab
              .map(
                (bhpLab) => Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.fromLTRB(0.0, 12.0, 8.0, 8.0),
                      child: Text(
                        '${bhpLab.tanggal}',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            fontSize: 12, fontWeight: FontWeight.w600),
                      ),
                    ),
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.fromLTRB(8.0, 12.0, 0.0, 8.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Barang Tindakan Lab',
                              style: TextStyle(
                                  fontSize: 12,
                                  color: Colors.black,
                                  fontWeight: FontWeight.w600),
                            ),
                            ...bhpLab.data!.map((data) => TileObatWidget(
                                  title: '${data.namaBarang}',
                                  subtitle: '${data.jumlah} Buah',
                                  trailing: _rupiah.format(data.harga),
                                ))
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              )
              .toList(),
        ),
      ],
    );
  }

  Widget _oldBhpWidget(BuildContext context) {
    return Cardtagihan(
      title: 'Barang Habis Pakai',
      subTotal: Text(
        _rupiah.format(widget.data.totalBhp),
        style: const TextStyle(fontWeight: FontWeight.w600),
      ),
      tiles: ListTile.divideTiles(
        context: context,
        tiles: _data
            .map(
              (bhp) => ListTile(
                onTap: () => widget.type != 'view' && widget.role == 99
                    ? _edit(context, bhp)
                    : null,
                dense: true,
                contentPadding:
                    const EdgeInsets.symmetric(vertical: 4.0, horizontal: 0),
                horizontalTitleGap: 0,
                title: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Flexible(child: Text('${bhp.barang!.namaBarang}')),
                    if (widget.role == 99 && widget.type != 'view')
                      const SizedBox(
                        width: 12.0,
                      ),
                    if (widget.role == 99 && widget.type != 'view')
                      const Icon(
                        Icons.edit_note_rounded,
                        size: 22.0,
                        color: Colors.blue,
                      )
                  ],
                ),
                subtitle: Text(
                    '${bhp.jumlah} x ${_rupiahNo.format(bhp.hargaModal! + bhp.tarifAplikasi!)}'),
                trailing: Text(
                  _rupiah.format(bhp.tarif),
                ),
              ),
            )
            .toList(),
      ).toList(),
    );
  }

  Widget _editFormBhp(Bhp bhp) {
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
                  onPressed: _updateBhpKunjungan,
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

  Widget _streamKunjunganBhp(BuildContext context) {
    return StreamBuilder<ApiResponse<ResponseKunjunganBhpUpdateModel>>(
      stream: _kunjunganBhpUpdateBloc.kunjunganBhpUpdateStream,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          switch (snapshot.data!.status) {
            case Status.loading:
              return const LoadingKit(
                color: kPrimaryColor,
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
}

class ListMasterBhp extends StatefulWidget {
  const ListMasterBhp({
    super.key,
    this.selectedId,
  });

  final int? selectedId;

  @override
  State<ListMasterBhp> createState() => _ListMasterBhpState();
}

class _ListMasterBhpState extends State<ListMasterBhp> {
  final _bhpKategoriBloc = BhpKategoriBloc();

  @override
  void initState() {
    super.initState();
    _bhpKategoriBloc.getBhpKategori();
  }

  @override
  void dispose() {
    _bhpKategoriBloc.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        title: const Text('Apotek Mentari'),
        elevation: 0.0,
      ),
      body: _streamBhpKategori(context),
    );
  }

  Widget _streamBhpKategori(BuildContext context) {
    return StreamBuilder<ApiResponse<BhpKategoriModel>>(
      stream: _bhpKategoriBloc.bhpKategoriStream,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          switch (snapshot.data!.status) {
            case Status.loading:
              return const LoadingKit(
                color: kPrimaryColor,
              );
            case Status.error:
              return ErrorResponse(
                message: snapshot.data!.message,
                onTap: () {
                  _bhpKategoriBloc.getBhpKategori();
                  setState(() {});
                },
              );
            case Status.completed:
              return TabKategori(
                data: snapshot.data!.data!.data,
                selectedId: widget.selectedId,
              );
          }
        }
        return const SizedBox();
      },
    );
  }
}

class TabKategori extends StatefulWidget {
  const TabKategori({
    super.key,
    this.data,
    this.selectedId,
  });

  final List<BhpKategori>? data;
  final int? selectedId;

  @override
  State<TabKategori> createState() => _TabKategoriState();
}

class _TabKategoriState extends State<TabKategori>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: widget.data!.length, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        TabBar(
          controller: _tabController,
          isScrollable: true,
          indicatorColor: kPrimaryColor,
          labelColor: Colors.black,
          unselectedLabelColor: Colors.grey[400],
          indicatorWeight: 3.0,
          tabs: widget.data!
              .map(
                (kategori) => Tab(
                  text: kategori.kategori,
                ),
              )
              .toList(),
        ),
        const Divider(
          height: 0,
          color: Colors.grey,
        ),
        Expanded(
          child: TabBarView(
            controller: _tabController,
            children: widget.data!
                .map(
                  (data) => DaftarBhp(
                    id: data.id,
                    selectedId: widget.selectedId,
                  ),
                )
                .toList(),
          ),
        )
      ],
    );
  }
}

class DaftarBhp extends StatefulWidget {
  const DaftarBhp({
    super.key,
    this.id,
    this.selectedId,
  });

  final int? id;
  final int? selectedId;

  @override
  State<DaftarBhp> createState() => _DaftarBhpState();
}

class _DaftarBhpState extends State<DaftarBhp> {
  final _bhpByCategoryBloc = MasterBhpByCategoryBloc();

  @override
  void initState() {
    super.initState();
    _loadBhpByCategory();
  }

  void _loadBhpByCategory() {
    _bhpByCategoryBloc.categoryIdSink.add(widget.id!);
    _bhpByCategoryBloc.bhpByCategory();
  }

  @override
  void didUpdateWidget(covariant DaftarBhp oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.id != widget.id) {
      _loadBhpByCategory();
      setState(() {});
    }
  }

  @override
  void dispose() {
    _bhpByCategoryBloc.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<ApiResponse<MasterBhpByCategoryModel>>(
      stream: _bhpByCategoryBloc.bhpCategoryStream,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          switch (snapshot.data!.status) {
            case Status.loading:
              return const LoadingKit(
                color: kPrimaryColor,
              );
            case Status.error:
              return ErrorResponse(
                message: snapshot.data!.message,
                onTap: () {
                  _bhpByCategoryBloc.bhpByCategory();
                  setState(() {});
                },
              );
            case Status.completed:
              return _listBhpByCategory(context, snapshot.data!.data!.data!);
          }
        }
        return const SizedBox();
      },
    );
  }

  Widget _listBhpByCategory(BuildContext context, List<MasterBhp> bhp) {
    return ListView.separated(
      padding: const EdgeInsets.symmetric(vertical: 22.0),
      itemBuilder: (context, i) {
        var data = bhp[i];
        return ListTile(
          onTap: () => Navigator.pop(context, data),
          title: Text('${data.namaBarang}'),
          trailing: widget.selectedId == data.id
              ? const Icon(
                  Icons.check_circle_outline_outlined,
                  color: Colors.green,
                )
              : null,
        );
      },
      separatorBuilder: (context, i) {
        return const Divider(
          height: 0,
        );
      },
      itemCount: bhp.length,
    );
  }
}

class BarangLab {
  String? tanggal;
  List<BhpLabMr>? data;

  BarangLab({
    this.tanggal,
    this.data,
  });
}
