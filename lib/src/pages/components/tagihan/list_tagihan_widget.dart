import 'dart:io';

import 'package:dokter_panggil/src/blocs/kwitansi_sementara_bloc.dart';
import 'package:dokter_panggil/src/blocs/master_biaya_admin_bloc.dart';
import 'package:dokter_panggil/src/blocs/master_biaya_admin_emr_bloc.dart';
import 'package:dokter_panggil/src/blocs/master_diskon_create_bloc.dart';
import 'package:dokter_panggil/src/models/kwitansi_sementara_model.dart';
import 'package:dokter_panggil/src/models/master_biaya_admin_emr_model.dart';
import 'package:dokter_panggil/src/models/master_biaya_admin_model.dart';
import 'package:dokter_panggil/src/models/master_diskon_create_model.dart';
import 'package:dokter_panggil/src/models/pasien_kunjungan_detail_model.dart';
import 'package:dokter_panggil/src/pages/components/close_button_widget.dart';
import 'package:dokter_panggil/src/pages/components/confirm_dialog.dart';
import 'package:dokter_panggil/src/pages/components/detail_tagihan.dart';
import 'package:dokter_panggil/src/pages/components/error_dialog.dart';
import 'package:dokter_panggil/src/pages/components/error_response.dart';
import 'package:dokter_panggil/src/pages/components/loading_kit.dart';
import 'package:dokter_panggil/src/pages/components/success_dialog.dart';
import 'package:dokter_panggil/src/pages/components/tagihan/list_biaya_admin_emr.dart';
import 'package:dokter_panggil/src/repositories/responseApi/api_response.dart';
import 'package:dokter_panggil/src/source/config.dart';
import 'package:dokter_panggil/src/source/size_config.dart';
import 'package:flutter/material.dart';
import 'package:dokter_panggil/src/source/transition/animated_dialog.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl/intl.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:url_launcher/url_launcher.dart';

class ListTagihanWidget extends StatefulWidget {
  const ListTagihanWidget({
    super.key,
    this.data,
    this.finalTagihan = false,
    this.type = 'create',
    this.isSummary = false,
  });

  final DetailKunjungan? data;
  final bool finalTagihan;
  final String type;
  final bool isSummary;

  @override
  State<ListTagihanWidget> createState() => _ListTagihanWidgetState();
}

class _ListTagihanWidgetState extends State<ListTagihanWidget> {
  final _masterBiayaAdminBloc = MasterBiayaAdminBloc();
  DetailKunjungan? _data;

  @override
  void initState() {
    super.initState();
    _data = widget.data;
    _masterBiayaAdminBloc.getMasterBiayaAdmin();
  }

  @override
  void didUpdateWidget(covariant ListTagihanWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.data!.transportResep != oldWidget.data!.transportResep) {
      setState(() {
        _data = widget.data;
      });
    }
  }

  @override
  void dispose() {
    _masterBiayaAdminBloc.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (!widget.finalTagihan) {
      return ListBiayaAdmin(
        dataKunjungan: _data,
        finalTagihan: widget.finalTagihan,
        type: widget.type,
      );
    }
    return StreamBuilder<ApiResponse<MasterBiayaAdminModel>>(
      stream: _masterBiayaAdminBloc.masterBiayaAdminStream,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          switch (snapshot.data!.status) {
            case Status.loading:
              return const SizedBox(
                width: double.infinity,
                child: Center(
                  child: LoadingKit(
                    color: kPrimaryColor,
                  ),
                ),
              );
            case Status.error:
              return Center(
                child: Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: ErrorResponse(
                    message: snapshot.data!.message,
                    onTap: () {
                      _masterBiayaAdminBloc.getMasterBiayaAdmin();
                      setState(() {});
                    },
                  ),
                ),
              );
            case Status.completed:
              return ListBiayaAdmin(
                dataKunjungan: _data,
                data: snapshot.data!.data!.data,
                finalTagihan: widget.finalTagihan,
                type: widget.type,
              );
          }
        }
        return const SizedBox();
      },
    );
  }
}

class ListBiayaAdmin extends StatefulWidget {
  const ListBiayaAdmin({
    super.key,
    this.dataKunjungan,
    this.data,
    this.finalTagihan = false,
    this.type = 'create',
  });

  final DetailKunjungan? dataKunjungan;
  final List<MasterBiayaAdmin>? data;
  final bool finalTagihan;
  final String type;

  @override
  State<ListBiayaAdmin> createState() => _ListBiayaAdminState();
}

class _ListBiayaAdminState extends State<ListBiayaAdmin> {
  final _masterBiayaAdminEmrBloc = MasterBiayaAdminEmrBloc();
  final _kwitansiSementaraBloc = KwitansiSementaraBloc();
  final _noRupiah =
      NumberFormat.currency(symbol: '', locale: 'id', decimalDigits: 0);
  late DetailKunjungan _data;
  final List<BiayaAdminSelected> _selectedBiaya = [];
  int totalBiaya = 0;
  final List<bool> _checked = [];
  final List<MasterBiayaAdmin> _biaya = [];
  int? _diskon;
  double _totalDiskon = 0;
  String? _deskripsiDiskon;
  int _indexDisable = -1;

  @override
  void initState() {
    super.initState();
    if (widget.dataKunjungan!.isEmr == 1) _getBiayaLayananEmr();
    _data = widget.dataKunjungan!;
    if (widget.dataKunjungan!.isEmr == 0) {
      _initBiaya();
    }
  }

  void _getBiayaLayananEmr() {
    if (widget.dataKunjungan!.jenisKunjunganMr!.isRanap == 1) {
      _masterBiayaAdminEmrBloc.layananSink.add('homecare');
    } else if (widget.dataKunjungan!.jenisKunjunganMr!.isHomevisit == 1 ||
        widget.dataKunjungan!.jenisKunjunganMr!.isHomevisitPerawat == 1) {
      _masterBiayaAdminEmrBloc.layananSink.add('homevisit');
    } else if (widget.dataKunjungan!.jenisKunjunganMr!.isTelemedicine == 1) {
      _masterBiayaAdminEmrBloc.layananSink.add('telemedicine');
    }
    _masterBiayaAdminEmrBloc.biayaAdminEmr();
  }

  void _initBiaya() {
    widget.data!.asMap().forEach((key, data) {
      double persen = 0;
      if (data.persen == 1) {
        persen = (data.nilai! * _data.total!) / 100;
      }
      if (_data.biayaLayanan == 0) {
        _checked.add(true);
        _selectedBiaya.add(
          BiayaAdminSelected(
            id: data.id,
            deskripsi: data.deskripsi,
            nilai: data.persen == 1 ? persen.round() : data.nilai!,
          ),
        );
        _data.dataBiayaAdmin!.add(
          DataBiayaAdmin(
            id: data.id,
            kunjunganId: _data.id,
            deskripsi: data.deskripsi,
            nilai: data.persen == 1 ? persen.round() : data.nilai,
          ),
        );
      } else {
        if (_data.dataBiayaAdmin!
            .where((biaya) => biaya.deskripsi == data.deskripsi)
            .isNotEmpty) {
          _checked.add(true);
          _indexDisable = key;
        } else {
          _checked.add(false);
        }
      }
      _biaya.add(
        MasterBiayaAdmin(
          id: data.id,
          deskripsi: data.deskripsi,
          nilai: data.persen == 1 ? persen.round() : data.nilai,
          persen: data.persen,
        ),
      );
    });
    _selectedBiaya.asMap().forEach((key, value) {
      totalBiaya += value.nilai;
    });
  }

  void _onSelectedBiaya(bool? val, MasterBiayaAdmin? biaya,
      List<MasterBiayaAdminEmr>? listAdminEmr) {
    totalBiaya = 0;
    double persen = 0;

    if (val == true && listAdminEmr != null) {
      for (final adminEmr in listAdminEmr) {
        if (adminEmr.persen == 1) {
          persen = (adminEmr.nilai! * _data.total!) / 100;
        }
        _selectedBiaya.add(
          BiayaAdminSelected(
            id: adminEmr.id,
            deskripsi: adminEmr.deskripsi,
            nilai: adminEmr.persen == 1 ? persen.round() : adminEmr.nilai!,
          ),
        );
        _data.dataBiayaAdmin!.add(
          DataBiayaAdmin(
            id: adminEmr.id,
            kunjunganId: _data.id,
            deskripsi: adminEmr.deskripsi,
            nilai: adminEmr.persen == 1 ? persen.round() : adminEmr.nilai!,
          ),
        );
      }
      _selectedBiaya.asMap().forEach((key, value) {
        totalBiaya += value.nilai;
      });
    }
    if (val == true && biaya != null) {
      if (biaya.persen == 1) {
        persen = (biaya.nilai! * _data.total!) / 100;
      }
      _selectedBiaya.add(
        BiayaAdminSelected(
          id: biaya.id,
          deskripsi: biaya.deskripsi,
          nilai: biaya.persen == 1 ? persen.round() : biaya.nilai!,
        ),
      );
      _data.dataBiayaAdmin!.add(
        DataBiayaAdmin(
          id: biaya.id,
          kunjunganId: _data.id,
          deskripsi: biaya.deskripsi,
          nilai: biaya.persen == 1 ? persen.round() : biaya.nilai,
        ),
      );
      _selectedBiaya.asMap().forEach((key, value) {
        totalBiaya += value.nilai;
      });
    }

    setState(() {});
  }

  void _showMasterDiskon() {
    showMaterialModalBottomSheet(
      context: context,
      builder: (context) {
        return ListDiskon(
          selected: _diskon,
        );
      },
      duration: const Duration(milliseconds: 500),
    ).then((value) {
      if (value != null) {
        var data = value as SelectedDiskon;
        if (data.selected) {
          setState(() {
            _diskon = data.data!.id;
            _deskripsiDiskon = data.data!.deskripsi;
            if (data.data!.isPersen == 1) {
              _totalDiskon = (data.data!.nilai * _data.total!) / 100;
            } else {
              _totalDiskon = data.data!.nilai.toDouble();
            }
            _data.diskon = Diskon(
              id: data.data!.id,
              kunjunganId: widget.dataKunjungan!.id,
              diskonId: data.data!.id,
              total: _totalDiskon.round(),
            );
          });
        } else {
          setState(() {
            _diskon = null;
            _deskripsiDiskon = null;
            _totalDiskon = 0;
            _data.diskon = null;
          });
        }
      }
    });
  }

  void _finalTagihan(DetailKunjungan data) {
    showAnimatedDialog(
      context: context,
      builder: (context) {
        return ConfirmDialogWidget(
          onConfirm: () => Navigator.pop(context, 'confirm'),
          message: 'Anda yakin untuk final tagihan ini?',
          labelConfirm: 'Ya, Final',
        );
      },
      animationType: DialogTransitionType.slideFromBottomFade,
      duration: const Duration(milliseconds: 500),
    ).then((value) {
      if (value != null) {
        Future.delayed(const Duration(milliseconds: 600), () {
          if (!mounted) return;
          Navigator.pop(context, _data);
        });
      }
    });
  }

  void _kirimInvoiceSementara() {
    _kwitansiSementaraBloc.idKunjungSink.add(widget.dataKunjungan!.id!);
    _kwitansiSementaraBloc.getKwitansiSementara();
    _showStreamKwitansiSementara();
  }

  void _showStreamKwitansiSementara() {
    showAnimatedDialog(
      context: context,
      builder: (context) => _streamKwitansiSementara(context),
      animationType: DialogTransitionType.slideFromBottomFade,
    ).then((value) {
      if (value != null) {
        final data = value as KwitansiSementara;
        Future.delayed(const Duration(milliseconds: 500), () {
          _share(data);
        });
      }
    });
  }

  Future<void> _share(KwitansiSementara data) async {
    var text =
        'Hai pasien ${data.pasien == null ? '-' : data.pasien?.namaPasien}, Tap tautan dibawah untuk mengunduh kwitansi sementara pembayaranmu\n${Uri.parse(data.url!).toString()}';
    var whatsappURlAndroid =
        "whatsapp://send?phone=${data.pasien?.nomorTelepon}&text=$text";
    var whatsappURLIos =
        "https://wa.me/${data.pasien?.nomorTelepon}?text=${Uri.tryParse(text)}";
    if (Platform.isIOS) {
      if (await canLaunchUrl(Uri.parse(whatsappURLIos))) {
        await launchUrl(Uri.parse(whatsappURLIos));
      } else {
        Fluttertoast.showToast(
            msg: 'Whatsapp not installed', toastLength: Toast.LENGTH_LONG);
      }
    } else {
      if (await canLaunchUrl(Uri.parse(whatsappURlAndroid))) {
        await launchUrl(Uri.parse(whatsappURlAndroid));
      } else {
        Fluttertoast.showToast(
            msg: 'Whatsapp not installed', toastLength: Toast.LENGTH_LONG);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    double widthBox = 100;
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        if (widget.finalTagihan)
          Expanded(
            child: _detailFinalTagihan(context),
          )
        else
          Flexible(
            child: _detailFinalTagihan(context),
          ),
        if (widget.finalTagihan)
          Container(
            padding: const EdgeInsets.fromLTRB(22.0, 22, 22, 12),
            decoration: const BoxDecoration(color: Colors.white, boxShadow: [
              BoxShadow(
                color: Colors.black12,
                blurRadius: 12,
                offset: Offset(-2.0, -2.0),
              )
            ]),
            child: SafeArea(
              top: false,
              child: Row(
                children: [
                  Expanded(
                    child: Wrap(
                      spacing: 2,
                      direction: Axis.vertical,
                      children: [
                        const Text(
                          'Total Bayar',
                          style: TextStyle(fontSize: 13.0),
                        ),
                        Text(
                          'Rp. ${_noRupiah.format(_data.total! + totalBiaya - _totalDiskon)}',
                          style: const TextStyle(fontWeight: FontWeight.w600),
                        ),
                      ],
                    ),
                  ),
                  if (widget.finalTagihan)
                    ElevatedButton(
                      onPressed: () => _finalTagihan(_data),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: kPrimaryColor,
                        minimumSize: const Size(140, 42),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(32),
                        ),
                      ),
                      child: const Text('Final Tagihan'),
                    ),
                ],
              ),
            ),
          ),
        if (widget.type == 'view' || !widget.finalTagihan)
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 22.0),
            child: Detailtagihan(
              namaTagihan: widget.dataKunjungan!.isPaket
                  ? const Text(
                      'Total paket',
                      style:
                          TextStyle(fontWeight: FontWeight.w600, fontSize: 13),
                    )
                  : const Text(
                      'Total',
                      style:
                          TextStyle(fontWeight: FontWeight.w600, fontSize: 13),
                    ),
              tarifTagihan: SizedBox(
                width: widthBox,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'Rp. ',
                      style: TextStyle(
                          fontSize: 13.0, fontWeight: FontWeight.w600),
                    ),
                    Text(
                      _noRupiah.format(_data.total),
                      style: const TextStyle(
                          fontSize: 13.0, fontWeight: FontWeight.w600),
                    ),
                  ],
                ),
              ),
            ),
          ),
        if (widget.type == 'view')
          Padding(
            padding:
                const EdgeInsets.symmetric(vertical: 12.0, horizontal: 22.0),
            child: ElevatedButton(
              onPressed: () => Navigator.pop(context, _data),
              style: ElevatedButton.styleFrom(
                minimumSize: const Size(double.infinity, 45),
                backgroundColor: Colors.green,
              ),
              child: const Text('Kirim Kwitansi'),
            ),
          ),
        if (!widget.finalTagihan)
          Padding(
            padding: const EdgeInsets.all(18.0),
            child: ElevatedButton(
              onPressed: _kirimInvoiceSementara,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blueAccent,
                minimumSize: Size(double.infinity, 42),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(32),
                ),
              ),
              child: Text('Kirim Invoice Sementara'),
            ),
          )
      ],
    );
  }

  Widget _detailFinalTagihan(BuildContext context) {
    double widthBox = 100;
    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 22.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          const SizedBox(
            height: 22.0,
          ),
          Row(
            children: [
              if (widget.dataKunjungan!.isPaket)
                Expanded(
                  child: const Text(
                    'Ringkasan tagihan paket',
                    style:
                        TextStyle(fontWeight: FontWeight.w600, fontSize: 16.0),
                  ),
                )
              else
                Expanded(
                  child: const Text(
                    'Ringkasan tagihan',
                    style:
                        TextStyle(fontWeight: FontWeight.w600, fontSize: 16.0),
                  ),
                ),
              if (!widget.finalTagihan) CloseButtonWidget()
            ],
          ),
          const SizedBox(
            height: 22.0,
          ),
          if (_data.tindakan!.isNotEmpty)
            Detailtagihan(
              namaTagihan: const Text('Total Tindakan'),
              tarifTagihan: SizedBox(
                width: widthBox,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'Rp. ',
                      style: TextStyle(fontSize: 13.0),
                    ),
                    Text(
                      _noRupiah.format(_data.totalTindakan! +
                          _data.transportTindakan! +
                          _data.transportOjolTindakan!),
                      style: const TextStyle(fontSize: 13.0),
                    ),
                  ],
                ),
              ),
            ),
          if (_data.bhp!.isNotEmpty)
            Detailtagihan(
              namaTagihan: const Text('Total Barang habis pakai'),
              tarifTagihan: SizedBox(
                width: widthBox,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'Rp. ',
                      style: TextStyle(fontSize: 13.0),
                    ),
                    Text(
                      _noRupiah.format(_data.totalBhp),
                      style: const TextStyle(fontSize: 13.0),
                    ),
                  ],
                ),
              ),
            ),
          if (_data.obatInjeksi!.isNotEmpty || _data.obatInjeksiMr!.isNotEmpty)
            Detailtagihan(
              namaTagihan: const Text('Total Obat Injeksi'),
              tarifTagihan: SizedBox(
                width: widthBox,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'Rp. ',
                      style: TextStyle(fontSize: 13.0),
                    ),
                    Text(
                      _noRupiah.format(_data.totalObatInjeksi),
                      style: const TextStyle(fontSize: 13.0),
                    ),
                  ],
                ),
              ),
            ),
          if (_data.tagihanResep!.isNotEmpty)
            Detailtagihan(
              namaTagihan: const Text('Total Resep'),
              tarifTagihan: SizedBox(
                  width: widthBox,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'Rp. ',
                        style: TextStyle(fontSize: 13.0),
                      ),
                      Text(
                        _noRupiah
                            .format(_data.totalResep! + _data.transportResep!),
                        style: const TextStyle(fontSize: 13.0),
                      ),
                    ],
                  )),
            ),
          if (_data.tagihanResepRacikan!.isNotEmpty)
            Detailtagihan(
              namaTagihan: const Text('Total Resep Racikan'),
              tarifTagihan: SizedBox(
                width: widthBox,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'Rp. ',
                      style: TextStyle(fontSize: 13.0),
                    ),
                    Text(
                      _noRupiah.format(_data.totalResepRacikan! +
                          _data.transportResepRacikan!),
                      style: const TextStyle(fontSize: 13.0),
                    ),
                  ],
                ),
              ),
            ),
          if (_data.tagihanTindakanLab!.isNotEmpty)
            Detailtagihan(
              namaTagihan: const Text('Total Laboratorium'),
              tarifTagihan: SizedBox(
                  width: widthBox,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'Rp. ',
                        style: TextStyle(fontSize: 13.0),
                      ),
                      Text(
                        _noRupiah.format(
                            _data.totalTindakanLab! + _data.transportLab!),
                        style: const TextStyle(fontSize: 13.0),
                      ),
                    ],
                  )),
            ),
          if (_data.tagihanTindakanRad!.isNotEmpty)
            Detailtagihan(
              namaTagihan: const Text('Total Radiologi'),
              tarifTagihan: SizedBox(
                  width: widthBox,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'Rp. ',
                        style: TextStyle(fontSize: 13.0),
                      ),
                      Text(
                        _noRupiah.format(
                            _data.totalTindakanRad! + _data.transportRad!),
                        style: const TextStyle(fontSize: 13.0),
                      ),
                    ],
                  )),
            ),
          if (_data.biayaLain!.isNotEmpty)
            Detailtagihan(
              namaTagihan: const Text('Total Biaya Lain-lain'),
              tarifTagihan: SizedBox(
                  width: widthBox,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'Rp. ',
                        style: TextStyle(fontSize: 13.0),
                      ),
                      Text(
                        _noRupiah.format(_data.totalBiayaLain),
                        style: const TextStyle(fontSize: 13.0),
                      ),
                    ],
                  )),
            ),
          if (_data.isPaket) _listPaket(context, widthBox),
          _listBiayaAdmin(context),
          const Divider(
            color: Colors.grey,
          ),
          if (_data.diskon != null || widget.finalTagihan)
            Detailtagihan(
              namaTagihan: const Text(
                'Sub Total',
                style: TextStyle(fontWeight: FontWeight.w600),
              ),
              tarifTagihan: SizedBox(
                width: widthBox,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'Rp. ',
                      style: TextStyle(
                          fontSize: 13.0, fontWeight: FontWeight.w600),
                    ),
                    if (widget.finalTagihan)
                      Text(
                        _noRupiah.format(_data.subTotal! + _data.biayaLayanan!),
                        style: const TextStyle(
                            fontSize: 13.0, fontWeight: FontWeight.w600),
                      )
                    else
                      Text(
                        _noRupiah.format(_data.subTotal! + _data.biayaLayanan!),
                        style: const TextStyle(
                            fontSize: 13.0, fontWeight: FontWeight.w600),
                      )
                  ],
                ),
              ),
            ),
          if (widget.finalTagihan) _diskonLayanan(context),
          if (_data.deposit != 0)
            Detailtagihan(
              namaTagihan: const Text('Deposit'),
              tarifTagihan: SizedBox(
                width: widthBox,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'Rp. ',
                      style: TextStyle(fontSize: 13.0),
                    ),
                    Text(
                      _noRupiah.format(_data.deposit),
                      style: const TextStyle(fontSize: 13.0),
                    ),
                  ],
                ),
              ),
            ),
          if (_data.diskon != null && !widget.finalTagihan)
            Detailtagihan(
              namaTagihan: const Text('Diskon'),
              tarifTagihan: SizedBox(
                width: widthBox,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'Rp. ',
                      style: TextStyle(fontSize: 13.0),
                    ),
                    Text(
                      _noRupiah.format(_data.diskon!.total),
                      style: const TextStyle(fontSize: 13.0),
                    ),
                  ],
                ),
              ),
            ),
          const SizedBox(
            height: 18,
          )
        ],
      ),
    );
  }

  Widget _listBiayaAdminFinal(BuildContext context) {
    double widthBox = 100;
    if (_data.dataBiayaAdmin!.isEmpty) return const SizedBox();
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 12.0),
        const Divider(
          color: Colors.grey,
        ),
        const SizedBox(
          height: 12.0,
        ),
        const Text(
          'Biaya Admin',
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
        ),
        const SizedBox(
          height: 12.0,
        ),
        Column(
          children: _data.dataBiayaAdmin!
              .map(
                (biaya) => ListTile(
                  dense: true,
                  contentPadding: EdgeInsets.zero,
                  title: Row(
                    children: [
                      Expanded(
                        child: Text('${biaya.deskripsi}'),
                      ),
                      SizedBox(
                        width: widthBox,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text('Rp. '),
                            Text(_noRupiah.format(biaya.nilai)),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              )
              .toList(),
        ),
      ],
    );
  }

  Widget _listPaket(BuildContext context, double widthBox) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 12.0),
        const Divider(
          color: Colors.grey,
        ),
        const SizedBox(
          height: 12.0,
        ),
        const Text(
          'Paket',
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
        ),
        const SizedBox(
          height: 12.0,
        ),
        Detailtagihan(
          namaTagihan: Text('${_data.paket!.paket!.namaPaket}'),
          tarifTagihan: SizedBox(
            width: widthBox,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Rp. ',
                  style: TextStyle(fontSize: 13.0),
                ),
                Text(
                  _noRupiah.format(_data.paket!.paket!.harga),
                  style: const TextStyle(fontSize: 13.0),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _listBiayaAdmin(BuildContext context) {
    double widthBox = 100;
    if (!widget.finalTagihan) {
      return _listBiayaAdminFinal(context);
    }
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 12.0),
        const Divider(
          color: Colors.grey,
        ),
        const SizedBox(
          height: 12.0,
        ),
        const Text(
          'Biaya Admin',
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
        ),
        const SizedBox(
          height: 12.0,
        ),
        if (widget.dataKunjungan!.isEmr == 1)
          _streamBiayaAdminEmr(context)
        else
          Column(
            children: _biaya.map((e) {
              return CheckboxListTile(
                contentPadding: const EdgeInsets.symmetric(vertical: 4.0),
                value: _checked[_biaya.indexOf(e)],
                dense: true,
                onChanged: _biaya.indexOf(e) == _indexDisable
                    ? null
                    : (value) {
                        _onSelectedBiaya(value, e, null);
                        setState(() {
                          _checked[_biaya.indexOf(e)] = value!;
                        });
                      },
                selectedTileColor: Colors.green,
                title: Row(
                  children: [
                    Expanded(
                      child: Text('${e.deskripsi}'),
                    ),
                    SizedBox(
                      width: widthBox,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text('Rp. '),
                          Flexible(
                            child: Text(
                              _noRupiah.format(e.nilai),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                controlAffinity: ListTileControlAffinity.leading,
                activeColor: Colors.green,
              );
            }).toList(),
          ),
      ],
    );
  }

  Widget _diskonLayanan(BuildContext context) {
    double widthBox = 100;
    return Column(
      children: [
        Container(
          margin: const EdgeInsets.symmetric(vertical: 12.0),
          decoration: BoxDecoration(
            border: Border.all(color: kPrimaryColor.withAlpha(100), width: 0.5),
            borderRadius: BorderRadius.circular(12.0),
          ),
          child: ListTile(
            dense: true,
            onTap: _showMasterDiskon,
            leading: FaIcon(
              FontAwesomeIcons.percent,
              color: Colors.grey[500],
              size: 16,
            ),
            minLeadingWidth: 12.0,
            title: _deskripsiDiskon == null
                ? Text(
                    'Diskon layanan',
                    style: TextStyle(color: Colors.grey[600]),
                  )
                : Text(
                    '$_deskripsiDiskon',
                    style: const TextStyle(fontWeight: FontWeight.w600),
                  ),
            trailing: const Icon(Icons.keyboard_arrow_right_rounded,
                color: Colors.grey),
          ),
        ),
        if (_totalDiskon != 0)
          ListTile(
            dense: true,
            contentPadding: EdgeInsets.zero,
            title: const Text('Diskon'),
            trailing: SizedBox(
              width: widthBox,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Rp. ',
                    style: TextStyle(
                      fontSize: 13.0,
                    ),
                  ),
                  Flexible(
                    child: Text(
                      _noRupiah.format(_totalDiskon),
                      style: const TextStyle(
                        fontSize: 13.0,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
      ],
    );
  }

  Widget _streamKwitansiSementara(BuildContext context) {
    return StreamBuilder<ApiResponse<KwitansiSementaraModel>>(
      stream: _kwitansiSementaraBloc.kwitansiSementaraStream,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          switch (snapshot.data!.status) {
            case Status.loading:
              return LoadingKit();
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

  Widget _streamBiayaAdminEmr(BuildContext context) {
    return StreamBuilder<ApiResponse<MasterBiayaAdminEmrModel>>(
      stream: _masterBiayaAdminEmrBloc.biayaAdminEmrStream,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          switch (snapshot.data!.status) {
            case Status.loading:
              return SizedBox(
                height: 62,
                child: Center(
                  child: LoadingKit(
                    size: 32,
                    color: kPrimaryColor,
                  ),
                ),
              );
            case Status.error:
              return Padding(
                padding: EdgeInsets.all(22),
                child: Center(child: Text(snapshot.data!.message)),
              );
            case Status.completed:
              return ListBiayaAdminEmr(
                subtotal: _data.total,
                listBiaya: snapshot.data!.data!.data,
                onSelected: (List<MasterBiayaAdminEmr>? listBiayaEmr) =>
                    _onSelectedBiaya(true, null, listBiayaEmr),
              );
          }
        }
        return const SizedBox(
          height: 52,
        );
      },
    );
  }
}

class ListDiskon extends StatefulWidget {
  const ListDiskon({
    super.key,
    this.selected,
  });

  final int? selected;

  @override
  State<ListDiskon> createState() => _ListDiskonState();
}

class _ListDiskonState extends State<ListDiskon> {
  final _masterDiskonCreate = MasterDiskonCreateBloc();
  final _rupiah =
      NumberFormat.currency(symbol: 'Rp. ', decimalDigits: 0, locale: 'id');

  @override
  void initState() {
    super.initState();
    _masterDiskonCreate.getMasterDiskon();
  }

  void _selectedDiskon(MasterDiskon data) {
    Navigator.pop(
      context,
      SelectedDiskon(selected: true, data: data),
    );
  }

  void _removeDiskon() {
    Navigator.pop(
      context,
      SelectedDiskon(selected: false, data: null),
    );
  }

  @override
  void dispose() {
    _masterDiskonCreate.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return Container(
      constraints: BoxConstraints(
        maxHeight: SizeConfig.blockSizeVertical * 80,
      ),
      child: _streamMasterDiskon(context),
    );
  }

  Widget _streamMasterDiskon(BuildContext context) {
    return StreamBuilder<ApiResponse<ResponseMasterDiskonCreateModel>>(
      stream: _masterDiskonCreate.masterDiskonStream,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          switch (snapshot.data!.status) {
            case Status.loading:
              return const SizedBox(
                height: 300,
                child: Center(
                  child: LoadingKit(
                    color: kPrimaryColor,
                  ),
                ),
              );
            case Status.error:
              return ErrorResponse(
                message: snapshot.data!.message,
                button: true,
                onTap: () => Navigator.pop(context),
              );
            case Status.completed:
              return Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Flexible(
                    child: ListView.separated(
                      padding: const EdgeInsets.symmetric(
                          vertical: 12.0, horizontal: 12.0),
                      shrinkWrap: true,
                      itemBuilder: (context, i) {
                        var data = snapshot.data!.data!.data![i];
                        return ListTile(
                          onTap: () => _selectedDiskon(data),
                          title: Text(data.deskripsi),
                          subtitle: data.isPersen == 1
                              ? Text('${data.nilai}%')
                              : Text(
                                  _rupiah.format(data.nilai),
                                ),
                          trailing: widget.selected == data.id
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
                      itemCount: snapshot.data!.data!.data!.length,
                    ),
                  ),
                  if (widget.selected != null)
                    Padding(
                      padding: const EdgeInsets.fromLTRB(25.0, 0.0, 25.0, 25.0),
                      child: ElevatedButton(
                        onPressed: _removeDiskon,
                        style: ElevatedButton.styleFrom(
                          minimumSize: const Size(double.infinity, 45),
                          backgroundColor: kPrimaryColor,
                          elevation: 0.0,
                        ),
                        child: const Text('Hapus Diskon'),
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

class BiayaAdminSelected {
  BiayaAdminSelected({
    this.id,
    this.deskripsi,
    this.nilai = 0,
  });

  int? id;
  String? deskripsi;
  int nilai;
}

class SelectedDiskon {
  SelectedDiskon({
    this.selected = false,
    this.data,
  });

  bool selected;
  MasterDiskon? data;
}
