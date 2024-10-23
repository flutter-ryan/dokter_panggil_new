import 'package:animate_icons/animate_icons.dart';
import 'package:dokter_panggil/src/blocs/bhp_kategori_bloc.dart';
import 'package:dokter_panggil/src/blocs/master_bhp_bloc.dart';
import 'package:dokter_panggil/src/models/barang_fetch_model.dart';
import 'package:dokter_panggil/src/models/bhp_kategori_model.dart';
import 'package:dokter_panggil/src/models/master_bhp_model.dart';
import 'package:dokter_panggil/src/pages/components/error_response.dart';
import 'package:dokter_panggil/src/pages/components/error_dialog.dart';
import 'package:dokter_panggil/src/pages/components/input_form.dart';
import 'package:dokter_panggil/src/pages/components/loading_kit.dart';
import 'package:dokter_panggil/src/pages/components/success_dialog.dart';
import 'package:dokter_panggil/src/pages/components/title_bar_modal.dart';
import 'package:dokter_panggil/src/repositories/responseApi/api_response.dart';
import 'package:dokter_panggil/src/source/config.dart';
import 'package:dokter_panggil/src/source/size_config.dart';
import 'package:flutter/material.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';

class TambahBarangPage extends StatefulWidget {
  const TambahBarangPage({
    Key? key,
    required this.form,
    this.barang,
  }) : super(key: key);

  final String form;
  final Barang? barang;

  @override
  State<TambahBarangPage> createState() => _TambahBarangPageState();
}

class _TambahBarangPageState extends State<TambahBarangPage> {
  final MasterBhpBloc _masterBhpBloc = MasterBhpBloc();
  final _bhpKategoriBloc = BhpKategoriBloc();
  final _animateIconController = AnimateIconController();
  final _formKey = GlobalKey<FormState>();
  final _nama = TextEditingController();
  final _minStok = TextEditingController();
  final _harga = TextEditingController();
  final _jasa = TextEditingController();
  final _kategori = TextEditingController();
  int _selectedId = 0;

  @override
  void initState() {
    super.initState();
    _editForm();
  }

  void _editForm() {
    if (widget.form == 'edit') {
      _masterBhpBloc.idSink.add(widget.barang!.id!);
      _nama.text = '${widget.barang!.namaBarang}';
      _minStok.text = '${widget.barang!.minStok}';
      _harga.text = '${widget.barang!.hargaModal}';
      _jasa.text = '${widget.barang!.tarifAplikasi}';
      _kategori.text = '${widget.barang!.kategori!.kategori}';
      _selectedId = widget.barang!.kategori!.id!;
    }
  }

  bool validateAndSave() {
    var formState = _formKey.currentState;
    if (formState!.validate()) {
      formState.save();
      return true;
    }
    return false;
  }

  void _simpan() {
    if (validateAndSave()) {
      _masterBhpBloc.namaSink.add(_nama.text);
      _masterBhpBloc.minStokSink.add(_minStok.text);
      _masterBhpBloc.hargaSink.add(_harga.text);
      _masterBhpBloc.jasaSink.add(_jasa.text);
      _masterBhpBloc.kategoriSink.add(_selectedId);
      if (widget.form == 'add') {
        _masterBhpBloc.saveMasterBhp();
      } else if (widget.form == 'edit') {
        _masterBhpBloc.updateMasterBhp();
      }
      _showStreamBhpSave();
    }
  }

  void _showStreamBhpSave() {
    showDialog(
      context: context,
      builder: (context) {
        return _buidlStreamBhpSave();
      },
    ).then((value) {
      if (value != null) {
        Future.delayed(const Duration(milliseconds: 300), () {
          Navigator.pop(context, 'reload');
        });
      }
    });
  }

  void _showKategoriBhp() {
    _bhpKategoriBloc.getBhpKategori();
    showBarModalBottomSheet(
      context: context,
      builder: (context) {
        return _streamKategoriBhp(context);
      },
      duration: const Duration(milliseconds: 500),
    ).then((value) {
      if (value != null) {
        var data = value as BhpKategori;
        _selectKategori(data);
      }
    });
  }

  void _selectKategori(BhpKategori data) {
    _kategori.text = '${data.kategori}';
    _selectedId = data.id!;
    setState(() {});
  }

  @override
  void dispose() {
    _masterBhpBloc.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return Scaffold(
      appBar: AppBar(
        title: widget.form == 'add'
            ? const Text('Tambah Barang')
            : const Text('Edit Barang'),
        foregroundColor: Colors.black,
        backgroundColor: Colors.white,
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.symmetric(vertical: 32.0, horizontal: 22.0),
          children: [
            Input(
              controller: _nama,
              label: 'Nama',
              hint: 'Nama barang/obat',
              maxLines: 1,
              validator: (val) {
                if (val!.isEmpty) {
                  return 'Input required';
                }
                return null;
              },
              textCap: TextCapitalization.words,
              textInputAction: TextInputAction.next,
            ),
            const SizedBox(
              height: 22.0,
            ),
            Input(
              controller: _kategori,
              label: 'Kategori',
              hint: 'Pilih kategori barang',
              maxLines: 1,
              suffixIcon: AnimateIcons(
                startIconColor: Colors.grey,
                endIconColor: Colors.grey,
                startIcon: Icons.expand_more_rounded,
                endIcon: Icons.expand_less_rounded,
                duration: const Duration(milliseconds: 300),
                onStartIconPress: () {
                  _showKategoriBhp();
                  return false;
                },
                onEndIconPress: () {
                  Navigator.pop(context);
                  return false;
                },
                controller: _animateIconController,
              ),
              validator: (val) {
                if (val!.isEmpty) {
                  return 'Input required';
                }
                return null;
              },
              readOnly: true,
              onTap: _showKategoriBhp,
            ),
            const SizedBox(
              height: 22.0,
            ),
            Input(
              controller: _minStok,
              label: 'Minimal',
              hint: 'Minimal stokk barang/obat',
              maxLines: 1,
              validator: (val) {
                if (val!.isEmpty) {
                  return 'Input required';
                }
                return null;
              },
              keyType: TextInputType.number,
              textInputAction: TextInputAction.next,
            ),
            const SizedBox(
              height: 22.0,
            ),
            Input(
              controller: _harga,
              label: 'Harga',
              hint: 'Harga modal barang/obat',
              maxLines: 1,
              validator: (val) {
                if (val!.isEmpty) {
                  return 'Input required';
                }
                return null;
              },
              keyType: TextInputType.number,
              textInputAction: TextInputAction.next,
            ),
            const SizedBox(
              height: 22.0,
            ),
            Input(
              controller: _jasa,
              label: 'Jasa aplikasi',
              hint: 'Tarif jasa aplikasi',
              maxLines: 1,
              validator: (val) {
                if (val!.isEmpty) {
                  return 'Input required';
                }
                return null;
              },
              keyType: TextInputType.number,
              textInputAction: TextInputAction.next,
            ),
            const SizedBox(
              height: 22.0,
            ),
            const SizedBox(
              height: 42.0,
            ),
            if (widget.form == 'edit')
              SizedBox(
                width: double.infinity,
                height: 48,
                child: ElevatedButton(
                  onPressed: _simpan,
                  child: const Text('Update'),
                ),
              )
            else
              SizedBox(
                width: double.infinity,
                height: 48,
                child: ElevatedButton(
                  onPressed: _simpan,
                  style:
                      ElevatedButton.styleFrom(backgroundColor: kPrimaryColor),
                  child: const Text('Simpan'),
                ),
              )
          ],
        ),
      ),
    );
  }

  Widget _buidlStreamBhpSave() {
    return StreamBuilder<ApiResponse<ResponseMasterBhpModel>>(
      stream: _masterBhpBloc.masterBhpStream,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          switch (snapshot.data!.status) {
            case Status.loading:
              return const LoadingKit(
                color: Colors.white,
              );
            case Status.error:
              return ErrorDialog(message: snapshot.data!.message);
            case Status.completed:
              return SuccessDialog(
                message: snapshot.data!.data!.message,
                onTap: () => Navigator.pop(context, 'success'),
              );
          }
        }
        return const SizedBox();
      },
    );
  }

  Widget _streamKategoriBhp(BuildContext context) {
    return StreamBuilder<ApiResponse<BhpKategoriModel>>(
      stream: _bhpKategoriBloc.bhpKategoriStream,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          switch (snapshot.data!.status) {
            case Status.loading:
              return const SizedBox(
                height: 180,
                child: LoadingKit(
                  color: kPrimaryColor,
                ),
              );
            case Status.error:
              return SizedBox(
                width: double.infinity,
                height: 300,
                child: ErrorResponse(
                  message: snapshot.data!.message,
                  onTap: () => Navigator.pop(context),
                ),
              );
            case Status.completed:
              return ListBhpKategori(
                data: snapshot.data!.data!.data,
                selectedId: _selectedId,
              );
          }
        }
        return const SizedBox(
          height: 200,
        );
      },
    );
  }
}

class ListBhpKategori extends StatefulWidget {
  const ListBhpKategori({
    super.key,
    this.data,
    this.selectedId = 0,
  });

  final List<BhpKategori>? data;
  final int selectedId;

  @override
  State<ListBhpKategori> createState() => _ListBhpKategoriState();
}

class _ListBhpKategoriState extends State<ListBhpKategori> {
  List<BhpKategori> _data = [];

  @override
  void initState() {
    super.initState();
    _data = widget.data!;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: BoxConstraints(
        maxHeight: SizeConfig.blockSizeVertical * 50,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const TitleBarModal(title: 'Daftar Kategori BHP'),
          const SizedBox(
            height: 18.0,
          ),
          Flexible(
            child: ListView.separated(
              shrinkWrap: true,
              itemBuilder: (context, i) {
                var data = _data[i];
                return ListTile(
                  contentPadding:
                      const EdgeInsets.symmetric(horizontal: 22.0, vertical: 4),
                  onTap: () => Navigator.pop(context, data),
                  title: Text('${data.kategori}'),
                  trailing: widget.selectedId == data.id
                      ? const Icon(
                          Icons.check_circle_outline,
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
          const SizedBox(
            height: 22.0,
          )
        ],
      ),
    );
  }
}
