import 'package:dokter_panggil/src/blocs/delete_tagihan_tindakan_lab_bloc.dart';
import 'package:dokter_panggil/src/blocs/dokumen_pengantar_lab_bloc.dart';
import 'package:dokter_panggil/src/blocs/kunjungan_tindakan_lab_save_bloc.dart';
import 'package:dokter_panggil/src/blocs/master_tindakan_lab_create_bloc.dart';
import 'package:dokter_panggil/src/blocs/transportasi_kunjungan_tindakan_lab_bloc.dart';
import 'package:dokter_panggil/src/models/dokumen_pengantar_lab_model.dart';
import 'package:dokter_panggil/src/models/kunjungan_tindakan_lab_save_model.dart';
import 'package:dokter_panggil/src/models/master_tindakan_lab_create_model.dart';
import 'package:dokter_panggil/src/models/master_tindakan_lab_model.dart';
import 'package:dokter_panggil/src/models/pasien_kunjungan_detail_model.dart';
import 'package:dokter_panggil/src/models/transportasi_kunjungan_tindakan_lab_model.dart';
import 'package:dokter_panggil/src/pages/components/card_tagihan_lab.dart';
import 'package:dokter_panggil/src/pages/components/confirm_dialog.dart';
import 'package:dokter_panggil/src/pages/components/error_response.dart';
import 'package:dokter_panggil/src/pages/components/error_dialog.dart';
import 'package:dokter_panggil/src/pages/components/input_form.dart';
import 'package:dokter_panggil/src/pages/components/loading_kit.dart';
import 'package:dokter_panggil/src/pages/components/search_input_form.dart';
import 'package:dokter_panggil/src/pages/components/success_dialog.dart';
import 'package:dokter_panggil/src/repositories/responseApi/api_response.dart';
import 'package:dokter_panggil/src/source/config.dart';
import 'package:dokter_panggil/src/source/size_config.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:dokter_panggil/src/source/transition/animated_dialog.dart';
import 'package:intl/intl.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:whatsapp_share2/whatsapp_share2.dart';

class DetailTagihanLabWidget extends StatefulWidget {
  const DetailTagihanLabWidget({
    super.key,
    required this.data,
    this.type = 'create',
    this.reload,
  });

  final DetailKunjungan data;
  final Function(DetailKunjungan data)? reload;
  final String type;

  @override
  State<DetailTagihanLabWidget> createState() => _DetailTagihanLabWidgetState();
}

class _DetailTagihanLabWidgetState extends State<DetailTagihanLabWidget> {
  final _dokumenPengantarLabBloc = DokumenPengantarLabBloc();
  final _transportasiKunjunganTindakanLabBloc =
      TransportasiKunjunganTindakanLabBloc();
  final _kunjunganTindakanLabSaveBloc = KunjunganTindakanLabSaveBloc();
  final _masterTindakanLabCreateBloc = MasterTindakanLabCreateBloc();
  final _deleteTagihanTindakanLabBloc = DeleteTagihanTindakanLabBloc();
  final _transport = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  final _rupiah =
      NumberFormat.currency(locale: 'id', symbol: 'Rp. ', decimalDigits: 0);
  late DetailKunjungan _data;

  bool validateAndSave() {
    var formData = _formKey.currentState;
    if (formData!.validate()) {
      return true;
    }
    return false;
  }

  @override
  void initState() {
    super.initState();
    _loadListTindakanLab();
  }

  void _loadListTindakanLab() {
    _data = widget.data;
  }

  void _edit(BuildContext context, TindakanLab data) {
    _masterTindakanLabCreateBloc.getMasterTindakanLab();
    showBarModalBottomSheet(
      context: context,
      builder: (context) {
        return Padding(
          padding:
              EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
          child: Container(
            constraints: BoxConstraints(
              maxHeight: SizeConfig.blockSizeVertical * 80,
              minHeight: SizeConfig.blockSizeVertical * 30,
            ),
            child: _streamTindakanLab(context, data),
          ),
        );
      },
      duration: const Duration(milliseconds: 500),
    ).then((value) {
      if (value != null) {
        var data = value as EditTindakanLabModel;
        _kunjunganTindakanLabSaveBloc.idSink.add(data.id!);
        _kunjunganTindakanLabSaveBloc.hargaModalSink
            .add(data.tindakanLab!.hargaModal!);
        _kunjunganTindakanLabSaveBloc.tarifAplikasiSink
            .add(data.tindakanLab!.tarifAplikasi!);
        _kunjunganTindakanLabSaveBloc.tindakanLabSink
            .add(data.tindakanLab!.id!);
        _kunjunganTindakanLabSaveBloc.updateKunjunganTindakanLab();
        _showStreamTindakanLabSave();
      }
    });
  }

  void _showStreamTindakanLabSave() {
    showAnimatedDialog(
      context: context,
      builder: (context) {
        return _streamTindakanLabSave(context);
      },
      duration: const Duration(milliseconds: 500),
      animationType: DialogTransitionType.slideFromBottomFade,
    ).then((value) {
      if (value != null) {
        var data = value as DetailKunjungan;
        widget.reload!(data);
      }
    });
  }

  void _simpan(TindakanLab data) {
    if (validateAndSave()) {
      SystemChannels.textInput.invokeMethod('TextInput.hide');
      FocusScope.of(context).unfocus();
      _transportasiKunjunganTindakanLabBloc.idSink.add(data.id!);
      _transportasiKunjunganTindakanLabBloc.transportasiSink
          .add(int.parse(_transport.text));
      _transportasiKunjunganTindakanLabBloc.saveTransportasiTindakanLab();
      _showStreamTransportTindakanLab();
    }
  }

  void _showStreamTransportTindakanLab() {
    showAnimatedDialog(
      context: context,
      builder: (context) {
        return _streamTransportTindakanLab(context);
      },
      duration: const Duration(milliseconds: 500),
      animationType: DialogTransitionType.slideFromBottomFade,
    ).then((value) {
      if (value != null) {
        var data = value as DetailKunjungan;
        Future.delayed(const Duration(milliseconds: 600), () {
          Navigator.pop(context, data);
        });
      }
    });
  }

  void _epengantar() {
    showMaterialModalBottomSheet(
      context: context,
      builder: (context) {
        return _modalPilihPegawai(context);
      },
      duration: const Duration(milliseconds: 500),
    ).then((value) {
      if (value != null) {
        var data = value as int;
        _dokumenPengantarLabBloc.idPegawaiSink.add(data.toString());
        _dialogEpengantar();
      }
    });
  }

  void _dialogEpengantar() {
    showAnimatedDialog(
      context: context,
      builder: (context) {
        return ConfirmDialogWidget(
          message: 'Anda yakin mengirim pengantar laboratorium ini?',
          onConfirm: () => Navigator.pop(context, 'kirim'),
          labelConfirm: 'Ya, Kirim',
        );
      },
      duration: const Duration(milliseconds: 500),
      animationType: DialogTransitionType.slideFromBottomFade,
    ).then((value) {
      if (value != null) {
        _dokumenPengantarLabBloc.idKunjunganSink.add(_data.id!);
        _dokumenPengantarLabBloc.getDokumenPengantarLab();
        _showStreamDokumenPengantarLab();
      }
    });
  }

  void _showStreamDokumenPengantarLab() {
    showAnimatedDialog(
      context: context,
      builder: (context) {
        return _streamDokumenPengantarLab(context);
      },
      duration: const Duration(milliseconds: 500),
      animationType: DialogTransitionType.slideFromBottomFade,
    ).then((value) {
      if (value != null) {
        var data = value as DokumenPengantarLab;
        _shareDokumenPengantarLab(data);
      }
    });
  }

  Future<void> _shareDokumenPengantarLab(DokumenPengantarLab data) async {
    await WhatsappShare.share(
      text:
          'Hai, ${data.pasien!.namaPasien}.\nDokumen ini adalah Pengantar Laboratorium',
      linkUrl: Uri.parse(data.linkDoc!).toString(),
      phone: '${data.pasien!.nomorTelepon}',
    );
  }

  @override
  void didUpdateWidget(covariant DetailTagihanLabWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.data != widget.data) {
      _loadListTindakanLab();
      setState(() {});
    }
  }

  @override
  void dispose() {
    _masterTindakanLabCreateBloc.dispose();
    _deleteTagihanTindakanLabBloc.dispose();
    _kunjunganTindakanLabSaveBloc.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return CardTagihanLab(
      title: 'Tindakan Laboratorium',
      buttonDetail: InkWell(
        onTap: _epengantar,
        child: const Padding(
          padding: EdgeInsets.symmetric(vertical: 4.0),
          child: Text(
            'E-Pengantar',
            style: TextStyle(color: Colors.blue, fontSize: 12.0),
          ),
        ),
      ),
      tiles: Column(
        children: ListTile.divideTiles(
                context: context,
                tiles: _data.tindakanLab!
                    .map(
                      (TindakanLab tindakanLab) => Column(
                        children: [
                          ListTile(
                            dense: true,
                            horizontalTitleGap: 0,
                            contentPadding: EdgeInsets.zero,
                            title: Text('${tindakanLab.tindakanLab}'),
                            trailing: Text(
                              _rupiah.format(tindakanLab.tarif),
                            ),
                          ),
                        ],
                      ),
                    )
                    .toList())
            .toList(),
      ),
      subTotal: Text(
        _rupiah.format(_data.totalTindakanLab! + _data.transportLab!),
        style: const TextStyle(fontWeight: FontWeight.w600),
      ),
    );
  }

  Widget _streamTindakanLab(BuildContext context, TindakanLab data) {
    return StreamBuilder<ApiResponse<MasterTindakanLabCreateModel>>(
      stream: _masterTindakanLabCreateBloc.masterTindakanLabCreateStream,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          switch (snapshot.data!.status) {
            case Status.loading:
              return SizedBox(
                height: SizeConfig.blockSizeVertical * 30,
                child: const LoadingKit(
                  color: kPrimaryColor,
                ),
              );
            case Status.error:
              return Center(
                child: ErrorResponse(
                  message: snapshot.data!.message,
                  onTap: () => Navigator.pop(context),
                ),
              );
            case Status.completed:
              return FormTindakanLabWidget(
                data: snapshot.data!.data!.data,
                selected: data.tindakanLabId,
                id: data.id,
              );
          }
        }
        return const SizedBox();
      },
    );
  }

  Widget _streamTindakanLabSave(BuildContext context) {
    return StreamBuilder<ApiResponse<ResponseKunjunganTindakanbLabSaveModel>>(
      stream: _kunjunganTindakanLabSaveBloc.kunjungaTindakanLabStream,
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
                onTap: () => Navigator.pop(context, snapshot.data!.data!.data!),
              );
          }
        }
        return const SizedBox();
      },
    );
  }

  Widget _formTransportasiLab(BuildContext context, TindakanLab data) {
    return Form(
      key: _formKey,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 18.0, vertical: 32.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text(
              'Transportasi Laboratorium',
              style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.w600),
            ),
            const SizedBox(
              height: 32.0,
            ),
            Input(
              controller: _transport,
              label: 'Transportasi',
              hint: 'Input biaya transportasi tindakan lab',
              maxLines: 1,
              validator: (val) {
                if (val!.isEmpty) {
                  return 'Input required';
                }
                return null;
              },
              keyType: TextInputType.number,
            ),
            const SizedBox(
              height: 32.0,
            ),
            ElevatedButton(
              onPressed: () => _simpan(data),
              style: ElevatedButton.styleFrom(
                backgroundColor: kPrimaryColor,
                minimumSize: const Size(double.infinity, 48),
              ),
              child: const Text('Simpan'),
            )
          ],
        ),
      ),
    );
  }

  Widget _streamTransportTindakanLab(BuildContext context) {
    return StreamBuilder<
        ApiResponse<ResponseTransportasiKunjunganTindakanLabModel>>(
      stream:
          _transportasiKunjunganTindakanLabBloc.transportasiTindakanLabStream,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          switch (snapshot.data!.status) {
            case Status.loading:
              return const LoadingKit();
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

  Widget _streamDokumenPengantarLab(BuildContext context) {
    return StreamBuilder<ApiResponse<ResponseDokumenPengantarLabModel>>(
      stream: _dokumenPengantarLabBloc.dokumenPengantarLabStream,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          switch (snapshot.data!.status) {
            case Status.loading:
              return const LoadingKit();
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

  Widget _modalPilihPegawai(BuildContext context) {
    return SizedBox(
      height: SizeConfig.blockSizeVertical * 70,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 16.0),
            child: Text(
              'Pengantar Laboratorium',
              style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),
            ),
          ),
          const Divider(
            height: 0,
          ),
          Flexible(
            child: DefaultTabController(
              length: _data.pegawai!.length,
              child: Column(
                children: [
                  TabBar(
                    labelColor: Colors.black,
                    isScrollable: true,
                    unselectedLabelColor: Colors.grey[400],
                    indicatorColor: kPrimaryColor,
                    tabs: _data.pegawai!
                        .map(
                          (pegawai) => Tab(
                            text: '${pegawai.nama}',
                          ),
                        )
                        .toList(),
                  ),
                  const Divider(
                    height: 0,
                  ),
                  Flexible(
                    child: TabBarView(
                      children: _data.pegawai!
                          .map(
                            (pegawai) => ListTindakanPengantarLab(
                              idKunjungan: _data.id!,
                              idPegawai: pegawai.id!,
                            ),
                          )
                          .toList(),
                    ),
                  )
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}

class FormTindakanLabWidget extends StatefulWidget {
  const FormTindakanLabWidget({
    super.key,
    this.data,
    this.selected,
    this.id,
  });

  final List<MasterTindakanLab>? data;
  final int? selected;
  final int? id;

  @override
  State<FormTindakanLabWidget> createState() => _FormTindakanLabWidgetState();
}

class _FormTindakanLabWidgetState extends State<FormTindakanLabWidget> {
  final _scrollCon = ScrollController();
  final _filter = TextEditingController();
  List<MasterTindakanLab> _data = [];
  int? _selected;
  MasterTindakanLab? _selectedTindakanLab;

  @override
  void initState() {
    super.initState();
    _data = widget.data!;
    _selected = widget.selected;
    _filter.addListener(_filterListener);
  }

  void _filterListener() {
    if (_filter.text.isNotEmpty) {
      _data = widget.data!
          .where((e) => e.namaTindakanLab!
              .toLowerCase()
              .contains(_filter.text.toLowerCase()))
          .toList();
    } else {
      _data = widget.data!;
    }
    setState(() {});
  }

  void _selectTindakan(MasterTindakanLab data) {
    setState(() {
      _selected = data.id;
      _selectedTindakanLab = data;
    });
  }

  void _updateKunjunganTindakanLab() {
    EditTindakanLabModel editTindakanLabModel = EditTindakanLabModel(
      id: widget.id,
      tindakanLab: _selectedTindakanLab,
    );
    Navigator.pop(context, editTindakanLabModel);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        const Padding(
          padding: EdgeInsets.only(left: 22.0, right: 22.0, top: 32.0),
          child: Text(
            'Edit Tindakan Laboratorium',
            style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.w600),
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 22.0, vertical: 12.0),
          child: SearchInputForm(
            hint: 'Pencarian nama tindakan lab',
            controller: _filter,
            suffixIcon: _filter.text.isEmpty
                ? null
                : CircleAvatar(
                    radius: 18,
                    backgroundColor: Colors.transparent,
                    foregroundColor: Colors.grey,
                    child: IconButton(
                      onPressed: () {
                        _filter.clear();
                      },
                      padding: EdgeInsets.zero,
                      icon: const Icon(Icons.close_rounded),
                    ),
                  ),
          ),
        ),
        if (_data.isEmpty)
          const Padding(
            padding: EdgeInsets.all(32.0),
            child: Center(
              child: ErrorResponse(
                message: 'Data tindakan tidak ditemukan',
                button: false,
              ),
            ),
          )
        else
          Flexible(
            child: ListView.separated(
              controller: _scrollCon,
              padding: const EdgeInsets.symmetric(vertical: 8.0),
              itemBuilder: (context, i) {
                var data = _data[i];
                return ListTile(
                  onTap: () => _selectTindakan(data),
                  contentPadding: const EdgeInsets.symmetric(horizontal: 22.0),
                  title: Text('${data.namaTindakanLab}'),
                  subtitle: Text('${data.mitra!.namaMitra}'),
                  trailing: _selected == data.id
                      ? const Icon(
                          Icons.check_circle_outline_rounded,
                          color: Colors.green,
                        )
                      : null,
                );
              },
              separatorBuilder: (context, i) => const Divider(
                height: 0.0,
              ),
              itemCount: _data.length,
            ),
          ),
        Padding(
          padding: const EdgeInsets.only(
              left: 22.0, right: 22.0, bottom: 18.0, top: 18),
          child: ElevatedButton(
            onPressed: _data.isEmpty ? null : _updateKunjunganTindakanLab,
            style: ElevatedButton.styleFrom(
              backgroundColor: kPrimaryColor,
              minimumSize: const Size(double.infinity, 45),
            ),
            child: const Text('Update Tindakan'),
          ),
        )
      ],
    );
  }
}

class ListTindakanPengantarLab extends StatefulWidget {
  const ListTindakanPengantarLab({
    super.key,
    required this.idPegawai,
    required this.idKunjungan,
  });

  final int idPegawai;
  final int idKunjungan;

  @override
  State<ListTindakanPengantarLab> createState() =>
      _ListTindakanPengantarLabState();
}

class _ListTindakanPengantarLabState extends State<ListTindakanPengantarLab> {
  final _dokumenPengantarLabBloc = DokumenPengantarLabBloc();
  @override
  void initState() {
    super.initState();
    _getListTindakan();
  }

  void _getListTindakan() {
    _dokumenPengantarLabBloc.idPegawaiSink.add(widget.idPegawai.toString());
    _dokumenPengantarLabBloc.idKunjunganSink.add(widget.idKunjungan);
    _dokumenPengantarLabBloc.getListTindakanLab();
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<ApiResponse<ResponseListTindakanLabPengantarModel>>(
      stream: _dokumenPengantarLabBloc.listTindakanLabStream,
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
                  _getListTindakan();
                  setState(() {});
                },
              );
            case Status.completed:
              return Column(
                children: [
                  Expanded(
                    child: ListView.separated(
                      padding: const EdgeInsets.symmetric(vertical: 12.0),
                      itemCount: snapshot.data!.data!.data!.length,
                      itemBuilder: (context, i) {
                        var tindakan = snapshot.data!.data!.data![i];
                        return ListTile(
                          contentPadding:
                              const EdgeInsets.symmetric(horizontal: 22.0),
                          title: Text('${tindakan.tindakan}'),
                        );
                      },
                      separatorBuilder: (context, i) => const Divider(
                        height: 0,
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(18),
                    child: ElevatedButton(
                      onPressed: () => Navigator.pop(context, widget.idPegawai),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: kPrimaryColor,
                        minimumSize: const Size(double.infinity, 45),
                      ),
                      child: const Text('Kirim E-pengantar'),
                    ),
                  ),
                ],
              );
          }
        }

        return const SizedBox();
      },
    );
  }
}

class EditTindakanLabModel {
  EditTindakanLabModel({
    this.id,
    this.tindakanLab,
  });

  final int? id;
  final MasterTindakanLab? tindakanLab;
}
