import 'package:dokter_panggil/src/blocs/download_kwitansi_bloc.dart';
import 'package:dokter_panggil/src/blocs/kunjungan_final_bayar_bloc.dart';
import 'package:dokter_panggil/src/blocs/tranportasi_resep_racikan_bloc.dart';
import 'package:dokter_panggil/src/models/download_kwitansi_model.dart';
import 'package:dokter_panggil/src/models/kunjungan_final_model.dart';
import 'package:dokter_panggil/src/models/pasien_kunjungan_detail_model.dart';
import 'package:dokter_panggil/src/models/transportasi_resep_racikan_model.dart';
import 'package:dokter_panggil/src/pages/components/detail_biaya_lainnya_wigdet.dart';
import 'package:dokter_panggil/src/pages/components/detail_paket_widget.dart';
import 'package:dokter_panggil/src/pages/components/final_tagihan_page.dart';
import 'package:dokter_panggil/src/pages/components/pembayaran_uang_muka.dart';
import 'package:dokter_panggil/src/pages/components/tagihan/detail_bhp_widget.dart';
import 'package:dokter_panggil/src/pages/components/detail_identitas_widget.dart';
import 'package:dokter_panggil/src/pages/components/detail_petugas_widget.dart';
import 'package:dokter_panggil/src/pages/components/detail_tindakan_wigdet.dart';
import 'package:dokter_panggil/src/pages/components/error_dialog.dart';
import 'package:dokter_panggil/src/pages/components/input_form.dart';
import 'package:dokter_panggil/src/pages/components/loading_kit.dart';
import 'package:dokter_panggil/src/pages/components/success_dialog.dart';
import 'package:dokter_panggil/src/pages/components/tagihan/detail_obat_injeksi_widget.dart';
import 'package:dokter_panggil/src/pages/components/tagihan/detail_tagihan_racikan_widget.dart';
import 'package:dokter_panggil/src/pages/components/tagihan/detail_tagihan_resep_widget.dart';
import 'package:dokter_panggil/src/pages/components/tagihan/list_tagihan_widget.dart';
import 'package:dokter_panggil/src/pages/components/tagihan/new_detail_tagihan_lab_widget.dart';
import 'package:dokter_panggil/src/pages/components/tagihan/new_detail_tagihan_rad_widget.dart';
import 'package:dokter_panggil/src/repositories/responseApi/api_response.dart';
import 'package:dokter_panggil/src/source/config.dart';
import 'package:dokter_panggil/src/source/size_config.dart';
import 'package:dokter_panggil/src/source/transition/slide_bottom_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:dokter_panggil/src/source/transition/animated_dialog.dart';
import 'package:intl/intl.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:whatsapp_share2/whatsapp_share2.dart';

class DetailLayananWidget extends StatefulWidget {
  const DetailLayananWidget({
    Key? key,
    required this.id,
    required this.data,
    this.type = 'create',
    this.onReload,
    this.role,
  }) : super(key: key);

  final DetailKunjungan data;
  final int id;
  final String type;
  final VoidCallback? onReload;
  final int? role;

  @override
  State<DetailLayananWidget> createState() => _DetailLayananWidgetState();
}

class _DetailLayananWidgetState extends State<DetailLayananWidget> {
  final KunjunganFinalBayarBloc _kunjunganFinalBayarBloc =
      KunjunganFinalBayarBloc();
  final DownloadKwitansiBloc _downloadKwitansiBloc = DownloadKwitansiBloc();
  final NumberFormat _rupiah =
      NumberFormat.currency(symbol: 'Rp. ', locale: 'id', decimalDigits: 0);
  DetailKunjungan? _data;

  @override
  void initState() {
    super.initState();
    _data = widget.data;
  }

  void _detailTagihan(bool finalTagihan) {
    showMaterialModalBottomSheet(
      context: context,
      bounce: true,
      builder: (context) {
        return Container(
          constraints:
              BoxConstraints(maxHeight: SizeConfig.blockSizeVertical * 80),
          child: Padding(
            padding: const EdgeInsets.only(bottom: 28.0),
            child: ListTagihanWidget(
              data: _data,
              finalTagihan: finalTagihan,
              type: widget.type,
            ),
          ),
        );
      },
      duration: const Duration(milliseconds: 500),
    ).then((value) {
      if (value != null) {
        var data = value as DetailKunjungan;
        if (widget.type != 'view') {
          _bayarTagihan(data);
        } else {
          _kirimKwitansi();
        }
      }
    });
  }

  void _finalTagihan(bool finalTagihan) {
    Navigator.push(
      context,
      SlideBottomRoute(
        page: FinalTagihanPage(
          data: _data,
          finalTagihan: finalTagihan,
          type: widget.type,
        ),
      ),
    ).then((value) {
      if (value != null) {
        var data = value as DetailKunjungan;
        if (widget.type != 'view') {
          _bayarTagihan(data);
        } else {
          _kirimKwitansi();
        }
      } else {
        widget.onReload!();
      }
    });
  }

  void _bayarTagihan(DetailKunjungan data) {
    SystemChannels.textInput.invokeMethod('TextInput.hide');
    FocusScope.of(context).unfocus();
    List<String> biaya = [];
    List<int> nilai = [];
    data.dataBiayaAdmin!.asMap().forEach((key, value) {
      biaya.add(value.deskripsi!);
      nilai.add(value.nilai!);
    });
    if (data.diskon != null) {
      _kunjunganFinalBayarBloc.idDiskonSink.add('${data.diskon!.diskonId}');
      _kunjunganFinalBayarBloc.totalDiskon.add('${data.diskon!.total}');
    }
    _kunjunganFinalBayarBloc.idSink.add(data.id!);
    _kunjunganFinalBayarBloc.biayaSink.add(biaya);
    _kunjunganFinalBayarBloc.nilaiSink.add(nilai);
    _kunjunganFinalBayarBloc.finalBayar();
    _showStreamFinalBayar();
  }

  void _showStreamFinalBayar() {
    showDialog(
      context: context,
      builder: (context) {
        return _buildStreamFinalBayar(context);
      },
    ).then((value) {
      if (value != null) {
        var data = value as KwitansiSimpan;
        HomeAction homeAction = HomeAction(
          type: 'final',
          data: data,
        );
        Navigator.pop(context, homeAction);
      }
    });
  }

  void _kwitansi() {
    Navigator.push(
      context,
      SlideBottomRoute(
        page: FinalTagihanPage(
          data: _data,
          finalTagihan: false,
          type: widget.type,
        ),
      ),
    ).then((value) {
      if (value != null) {
        _kirimKwitansi();
      }
    });
  }

  void _kirimKwitansi() {
    _downloadKwitansiBloc.idSink.add(widget.id);
    _downloadKwitansiBloc.downloadKwitansi();
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return _buildStreamDownloadKwitansi();
      },
    ).then((value) async {
      if (value != null) {
        var data = value as DownloadKwitansiModel;
        _shareKwitansi(data);
      }
    });
  }

  void _uangMuka(int? id) {
    showBarModalBottomSheet(
      context: context,
      builder: (context) {
        return Padding(
          padding: EdgeInsets.only(
            left: 22.0,
            right: 22.0,
            top: 32.0,
            bottom: MediaQuery.of(context).viewInsets.bottom + 32.0,
          ),
          child: Container(
            constraints: const BoxConstraints(
              minHeight: 200.0,
            ),
            child: PembayaranUangMuka(
              id: id!,
              tindakan: widget.data.tindakan!,
            ),
          ),
        );
      },
    ).then((value) {
      if (value != null) {
        var data = value as DetailKunjungan;
        _shareDeposit(data);
        setState(() {
          _data = data;
        });
      }
    });
  }

  Future<void> _shareDeposit(DetailKunjungan data) async {
    await WhatsappShare.share(
      text:
          'Hai pasien ${data.pasien!.namaPasien}, Tap tautan dibawah untuk mengunduh kwitansi pembayaranmu',
      linkUrl: Uri.parse(data.urlDeposit!).toString(),
      phone: '${data.pasien!.nomorTelepon}',
    );
  }

  Future<void> _shareKwitansi(DownloadKwitansiModel data) async {
    await WhatsappShare.share(
      text:
          'Hai pasien ${data.data!.nama}, Tap tautan dibawah untuk mengunduh kwitansi pembayaranmu',
      linkUrl: Uri.parse(data.data!.url!).toString(),
      phone: '${data.data!.nomor}',
    );
  }

  @override
  void dispose() {
    _downloadKwitansiBloc.dispose();
    _kunjunganFinalBayarBloc.dispose();
    super.dispose();
  }

  @override
  void didUpdateWidget(covariant DetailLayananWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.data != widget.data) {
      setState(() {
        _data = widget.data;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
          child: RefreshIndicator(
            onRefresh: () async => widget.onReload!(),
            child: ListView(
              padding: const EdgeInsets.symmetric(vertical: 8.0),
              children: [
                DetailIdentitasWidget(
                  data: _data!,
                  id: widget.id,
                  type: widget.type,
                ),
                if (_data!.dokter!.isNotEmpty || _data!.perawat!.isNotEmpty)
                  DetailPetugasWidget(
                    data: _data!,
                    reload: (DetailKunjungan? data) =>
                        setState(() => _data = data),
                  ),
                DetailPaketWidget(
                  data: _data!,
                  type: widget.type,
                  reload: (DetailKunjungan? data) => setState(() {
                    _data = data;
                  }),
                ),
                if (_data!.tindakan!.isNotEmpty)
                  DetailTindakanWidget(
                    data: _data!,
                    subtotal: Text(
                      _rupiah.format(_data!.totalTindakan! +
                          _data!.transportTindakan! +
                          _data!.transportOjolTindakan!),
                      style: const TextStyle(
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    type: widget.type,
                    role: widget.role,
                    reload: (DetailKunjungan? data) => setState(() {
                      _data = data;
                    }),
                  ),
                if (_data!.bhp!.isNotEmpty)
                  DetailBhp(
                    data: _data!,
                    type: widget.type,
                    role: widget.role,
                    reload: (DetailKunjungan data) {
                      setState(() {
                        _data = data;
                      });
                    },
                  ),
                if (_data!.obatInjeksi!.isNotEmpty)
                  DetailObatInjeksiWidget(
                    data: _data!,
                    type: widget.type,
                    role: widget.role,
                    reload: (DetailKunjungan data) {
                      setState(() {
                        _data = data;
                      });
                    },
                  ),
                if (_data!.resep!.isNotEmpty)
                  DetailTagihanResepWidget(
                    data: _data!,
                    type: widget.type,
                    reload: (DetailKunjungan? data) {
                      setState(() {
                        _data = data;
                      });
                    },
                  ),
                if (_data!.resepRacikan!.isNotEmpty)
                  DetailTagihanRacikanWidget(
                    data: _data!,
                    type: widget.type,
                    reload: (DetailKunjungan data) {
                      setState(() {
                        _data = data;
                      });
                    },
                  ),
                if (_data!.tindakanLab!.isNotEmpty)
                  NewDetailTagihanLabWidget(
                    data: _data!,
                    type: widget.type,
                    reload: (DetailKunjungan data) {
                      setState(() {
                        _data = data;
                      });
                    },
                  ),
                if (_data!.tindakanRad!.isNotEmpty)
                  NewDetailTagihanRadWidget(
                    data: _data!,
                    type: widget.type,
                    reload: (DetailKunjungan data) {
                      setState(() {
                        _data = data;
                      });
                    },
                  ),
                DetailBiayaLainnyaWidget(
                  data: _data!,
                  type: widget.type,
                  reload: (DetailKunjungan? data) {
                    setState(() {
                      _data = data;
                    });
                  },
                ),
              ],
            ),
          ),
        ),
        Container(
          padding: const EdgeInsets.fromLTRB(18.0, 18.0, 18.0, 22.0),
          decoration: const BoxDecoration(color: Colors.white, boxShadow: [
            BoxShadow(
              color: Colors.black12,
              blurRadius: 6.0,
              offset: Offset(-2.0, 1.0),
            )
          ]),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Total Tagihan',
                    style: TextStyle(fontWeight: FontWeight.w600),
                  ),
                  InkWell(
                    onTap: () => _detailTagihan(false),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          _rupiah.format(
                            _data!.total!,
                          ),
                          style: const TextStyle(fontSize: 16.0),
                        ),
                        const SizedBox(
                          width: 4.0,
                        ),
                        Icon(
                          Icons.keyboard_arrow_up,
                          color: Colors.grey[600],
                        )
                      ],
                    ),
                  )
                ],
              ),
              if (_data!.status == 5)
                ElevatedButton(
                  onPressed: _kwitansi,
                  style:
                      ElevatedButton.styleFrom(backgroundColor: Colors.green),
                  child: const Text('Kirim Kwitansi'),
                )
              else if (_data!.status == 4)
                ElevatedButton(
                  onPressed: () => _uangMuka(_data!.id),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue,
                  ),
                  child: const Text('Konfirmasi Bayar'),
                )
              else
                ElevatedButton(
                  onPressed: () => _finalTagihan(true),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: kPrimaryColor,
                  ),
                  child: const Text('Final Tagihan'),
                ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildStreamDownloadKwitansi() {
    return StreamBuilder<ApiResponse<DownloadKwitansiModel>>(
      stream: _downloadKwitansiBloc.downloadKwitansiStream,
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
              );
            case Status.completed:
              Navigator.pop(context, snapshot.data!.data);
              return const SizedBox();
          }
        }
        return const SizedBox();
      },
    );
  }

  Widget _buildStreamFinalBayar(BuildContext context) {
    return StreamBuilder<ApiResponse<ResponseKunjunganFinalModel>>(
      stream: _kunjunganFinalBayarBloc.kunjunganFinalStream,
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
}

class TransportasiResepRacikan extends StatefulWidget {
  const TransportasiResepRacikan({
    Key? key,
    required this.data,
    this.reload,
    this.type = 'create',
  }) : super(key: key);

  final DetailKunjungan data;
  final Function(DetailKunjungan? data)? reload;
  final String type;

  @override
  State<TransportasiResepRacikan> createState() =>
      _TransportasiResepRacikanState();
}

class _TransportasiResepRacikanState extends State<TransportasiResepRacikan> {
  final TransportasiResepRacikanBloc _transportasiResepRacikanBloc =
      TransportasiResepRacikanBloc();
  final _rupiah =
      NumberFormat.currency(locale: 'id', symbol: 'Rp. ', decimalDigits: 0);
  final _formKey = GlobalKey<FormState>();
  final _biaya = TextEditingController();

  bool validateAndSave() {
    var formState = _formKey.currentState;
    if (formState!.validate()) {
      return true;
    }
    return false;
  }

  void _tambahTransport() {
    _biaya.text = '${widget.data.transportResepRacikan}';
    showBarModalBottomSheet(
      context: context,
      builder: (context) {
        return Padding(
          padding: EdgeInsets.only(
              bottom: MediaQuery.of(context).viewInsets.bottom + 22),
          child: _formTransportasi(),
        );
      },
    ).then((value) {
      if (value != null) {
        var data = value as DetailKunjungan;
        widget.reload!(data);
      }
    });
  }

  void _simpan() {
    if (validateAndSave()) {
      SystemChannels.textInput.invokeMethod('TextInput.hide');
      FocusScope.of(context).unfocus();
      _transportasiResepRacikanBloc.idKunjunganSink.add(widget.data.id!);
      _transportasiResepRacikanBloc.biayaSink.add(int.parse(_biaya.text));
      _transportasiResepRacikanBloc.saveTransportasiResepRacikan();
      _showStreamTransportasi();
    }
  }

  void _showStreamTransportasi() {
    showAnimatedDialog(
      context: context,
      builder: (context) {
        return _streamTransportResep();
      },
      animationType: DialogTransitionType.slideFromBottomFade,
      duration: const Duration(milliseconds: 500),
    ).then((value) {
      var data = value as DetailKunjungan;
      Future.delayed(const Duration(milliseconds: 300), () {
        Navigator.pop(context, data);
      });
    });
  }

  @override
  dispose() {
    super.dispose();
    _transportasiResepRacikanBloc.dispose();
    _biaya.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: widget.type != 'view' ? _tambahTransport : null,
      dense: true,
      contentPadding: EdgeInsets.zero,
      title: Row(
        children: [
          const Text('Transportasi'),
          const SizedBox(
            width: 8.0,
          ),
          if (widget.type != 'view')
            const Icon(
              Icons.edit_note_rounded,
              size: 22.0,
              color: Colors.blue,
            )
        ],
      ),
      trailing: Text(_rupiah.format(widget.data.transportResepRacikan)),
    );
  }

  Widget _formTransportasi() {
    return Form(
      key: _formKey,
      child: Padding(
        padding: const EdgeInsets.all(28.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text(
              'Transportasi Resep',
              style: TextStyle(fontSize: 20.0, fontWeight: FontWeight.w600),
            ),
            const SizedBox(
              height: 32.0,
            ),
            Input(
              controller: _biaya,
              label: 'Biaya Ojek Online',
              hint: 'Input biaya ojek online',
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
              height: 22.0,
            ),
            ElevatedButton(
              onPressed: _simpan,
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

  Widget _streamTransportResep() {
    return StreamBuilder<ApiResponse<ResponseTransportasiResepRacikanModel>>(
      stream: _transportasiResepRacikanBloc.transportasiResepRacikanStream,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          switch (snapshot.data!.status) {
            case Status.loading:
              return const LoadingKit();
            case Status.error:
              return ErrorDialog(
                message: snapshot.data!.message,
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

class HomeAction {
  HomeAction({
    this.type,
    this.data,
  });

  String? type;
  KwitansiSimpan? data;
}
