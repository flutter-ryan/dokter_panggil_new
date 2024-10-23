import 'dart:async';
import 'dart:io';

import 'package:dokter_panggil/src/blocs/cetak_stok_opname_bloc.dart';
import 'package:dokter_panggil/src/blocs/stok_opname_barang_save_bloc.dart';
import 'package:dokter_panggil/src/blocs/stok_opname_bloc.dart';
import 'package:dokter_panggil/src/models/cetak_stok_opname_model.dart';
import 'package:dokter_panggil/src/models/stok_opname_barang_model.dart';
import 'package:dokter_panggil/src/models/stok_opname_barang_save_model.dart';
import 'package:dokter_panggil/src/models/stok_opname_model.dart';
import 'package:dokter_panggil/src/models/stok_opname_save_model.dart';
import 'package:dokter_panggil/src/pages/components/confirm_dialog.dart';
import 'package:dokter_panggil/src/pages/components/error_dialog.dart';
import 'package:dokter_panggil/src/pages/components/error_response.dart';
import 'package:dokter_panggil/src/pages/components/loading_kit.dart';
import 'package:dokter_panggil/src/pages/components/search_input_form.dart';
import 'package:dokter_panggil/src/pages/components/success_dialog.dart';
import 'package:dokter_panggil/src/repositories/responseApi/api_response.dart';
import 'package:dokter_panggil/src/source/config.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:dokter_panggil/src/source/transition/animated_dialog.dart';
import 'package:url_launcher/url_launcher.dart';

class FormOpnameBarang extends StatefulWidget {
  const FormOpnameBarang({
    super.key,
    this.data,
    required this.bloc,
  });

  final StokOpname? data;
  final StokOpnameBloc bloc;

  @override
  State<FormOpnameBarang> createState() => _FormOpnameBarangState();
}

class _FormOpnameBarangState extends State<FormOpnameBarang> {
  final _stokOpnameBarangSaveBloc = StokOpnameBarangSaveBloc();
  final _cetakStokOpnameBloc = CetakStokOpnameBloc();
  final _filter = TextEditingController();
  final List<TextEditingController> _stok = [];
  final List<GlobalKey<FormState>> _formKey = [];
  Timer? timer;

  @override
  void initState() {
    super.initState();
    _filter.addListener(_filterListen);
    _loadStokOpnameBarang();
  }

  void _loadStokOpnameBarang() {
    _stokOpnameBarangSaveBloc.idStokOpnameSink.add(widget.data!.id!);
    _stokOpnameBarangSaveBloc.getStokOpnameBarang();
  }

  void _filterListen() {
    if (timer != null) {
      timer!.cancel();
    }
    timer = Timer.periodic(const Duration(milliseconds: 700), (timer) {
      _stokOpnameBarangSaveBloc.filterSink.add(_filter.text);
      _stokOpnameBarangSaveBloc.getStokOpnameBarang();
      timer.cancel();
      setState(() {});
    });
  }

  bool validateAndSave(int i) {
    var formData = _formKey[i].currentState;
    if (formData!.validate()) {
      return true;
    }
    return false;
  }

  void _simpanBarangStokOpname(int? idBarangStok, int i) {
    if (validateAndSave(i)) {
      SystemChannels.textInput.invokeMethod('TextInput.hide');
      FocusScope.of(context).requestFocus(FocusNode());
      _stokOpnameBarangSaveBloc.idStokBarangSink.add(idBarangStok!);
      _stokOpnameBarangSaveBloc.stokSink.add(_stok[i].text);
      _stokOpnameBarangSaveBloc.saveStokOpnameBarang();
      _showStreamSaveStokOpnameBarang(i);
    }
  }

  void _showStreamSaveStokOpnameBarang(int i) {
    showAnimatedDialog(
      context: context,
      builder: (context) {
        return _streamSaveStokOpnameBaran(context);
      },
      duration: const Duration(milliseconds: 500),
      animationType: DialogTransitionType.slideFromBottomFade,
    ).then((value) {
      if (value != null) {
        _stok[i].clear();
        setState(() {
          //
        });
      }
    });
  }

  void _cetakPdfStok() {
    _cetakStokOpnameBloc.idStokOpnameSink.add(widget.data!.id!);
    _cetakStokOpnameBloc.fromSink.add('${widget.data!.fromDate}');
    _cetakStokOpnameBloc.toSink.add('${widget.data!.toDate}');
    _cetakStokOpnameBloc.cetakStokOpname();
    _showStreamCetak();
  }

  void _showStreamCetak() {
    showAnimatedDialog(
      context: context,
      builder: (context) {
        return _streamCetakOpname(context);
      },
      animationType: DialogTransitionType.scale,
      duration: const Duration(milliseconds: 500),
    ).then((value) {
      if (value != null) {
        var data = value as CetakStokOpname;
        _downloadPdf(data);
      }
    });
  }

  void _downloadPdf(CetakStokOpname? data) async {
    final Uri url = Uri.parse('${data!.link}');
    if (await canLaunchUrl(url)) {
      if (Platform.isIOS) {
        await launchUrl(url, mode: LaunchMode.inAppBrowserView);
      } else if (Platform.isAndroid) {
        await launchUrl(url, mode: LaunchMode.platformDefault);
      }
    } else {
      throw Exception('Could not launch');
    }
  }

  void _finalStok() async {
    showAnimatedDialog(
      context: context,
      builder: (context) {
        return ConfirmDialogWidget(
          message: 'Anda yakin final stok opname?',
          labelConfirm: 'Ya, Final',
          onConfirm: () => Navigator.pop(context, 'confirm'),
        );
      },
      duration: const Duration(milliseconds: 500),
      animationType: DialogTransitionType.slideFromBottomFade,
    ).then((value) {
      if (value != null) {
        Future.delayed(const Duration(milliseconds: 500), () {
          widget.bloc.idStokOpnameSink.add(widget.data!.id!);
          widget.bloc.finalStokOpname();
          _showStreamFinal();
        });
      }
    });
  }

  void _showStreamFinal() {
    showAnimatedDialog(
      context: context,
      builder: (context) {
        return _streamFinal(context);
      },
      duration: const Duration(milliseconds: 500),
      animationType: DialogTransitionType.slideFromTopFade,
    ).then((value) {
      if (value != null) {
        WidgetsBinding.instance.addPostFrameCallback(
          (timeStamp) => Navigator.pop(context),
        );
      }
    });
  }

  @override
  void dispose() {
    _filter.dispose();
    _stokOpnameBarangSaveBloc.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: const SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarBrightness: Brightness.dark,
        statusBarIconBrightness: Brightness.light,
        systemNavigationBarColor: Colors.white,
      ),
      child: Scaffold(
        body: Column(
          children: [
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(horizontal: 32.0),
              decoration: const BoxDecoration(color: kPrimaryColor, boxShadow: [
                BoxShadow(
                  color: Colors.black12,
                  blurRadius: 6.0,
                  offset: Offset(2.0, 1.0),
                )
              ]),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                    height: MediaQuery.of(context).padding.top + 18,
                  ),
                  Row(
                    children: [
                      const Expanded(
                        child: Text(
                          'Daftar Barang',
                          style: TextStyle(
                            fontSize: 28.0,
                            fontWeight: FontWeight.w600,
                            color: Colors.white,
                          ),
                        ),
                      ),
                      CircleAvatar(
                        radius: 22,
                        backgroundColor: Colors.transparent,
                        foregroundColor: Colors.white,
                        child: IconButton(
                          padding: EdgeInsets.zero,
                          onPressed: () => Navigator.pop(context),
                          icon: const Icon(Icons.close),
                        ),
                      )
                    ],
                  ),
                  const SizedBox(
                    height: 18.0,
                  ),
                  SearchInputForm(
                    controller: _filter,
                    hint: 'Pencarian barang',
                    suffixIcon: _filter.text.isNotEmpty
                        ? CircleAvatar(
                            radius: 15,
                            backgroundColor: Colors.grey[300],
                            child: IconButton(
                              padding: EdgeInsets.zero,
                              onPressed: () => _filter.clear(),
                              iconSize: 18,
                              color: Colors.black38,
                              icon: const Icon(Icons.close),
                            ),
                          )
                        : const SizedBox(),
                  ),
                  const SizedBox(
                    height: 22.0,
                  ),
                ],
              ),
            ),
            Expanded(
              child: _streamStokopnameBarang(context),
            ),
          ],
        ),
      ),
    );
  }

  Widget _streamFinal(BuildContext context) {
    return StreamBuilder<ApiResponse<StokOpnameSaveModel>>(
      stream: widget.bloc.stokOpnameFinalStream,
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
                onTap: () => Navigator.pop(context, 'success'),
              );
          }
        }
        return const SizedBox();
      },
    );
  }

  Widget _streamStokopnameBarang(BuildContext context) {
    return StreamBuilder<ApiResponse<StokOpnameBarangModel>>(
      stream: _stokOpnameBarangSaveBloc.stokOpnameBarangStream,
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
                  _stokOpnameBarangSaveBloc.getStokOpnameBarang();
                  setState(() {});
                },
              );
            case Status.completed:
              return Column(
                children: [
                  Expanded(
                    child: ListView.separated(
                      padding: const EdgeInsets.symmetric(
                          vertical: 32.0, horizontal: 22.0),
                      itemBuilder: (context, i) {
                        var barang = snapshot.data!.data!.data![i];
                        _formKey.add(GlobalKey<FormState>());
                        _stok.add(TextEditingController());
                        return Container(
                          padding: const EdgeInsets.all(18.0),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(12.0),
                            boxShadow: const [
                              BoxShadow(
                                color: Colors.black12,
                                blurRadius: 6,
                                offset: Offset(0.0, 3.0),
                              )
                            ],
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(
                                '${barang.barang!.namaBarang}',
                                style: const TextStyle(
                                    fontSize: 16.0,
                                    fontWeight: FontWeight.bold),
                              ),
                              const SizedBox(
                                height: 15.0,
                              ),
                              Row(
                                children: [
                                  Expanded(
                                    child: CardInfoBarangStokOpname(
                                      title: 'Stok awal',
                                      body: '${barang.stokAwal}',
                                    ),
                                  ),
                                  const SizedBox(
                                    width: 12.0,
                                  ),
                                  Expanded(
                                    child: CardInfoBarangStokOpname(
                                      title: 'Stok keluar',
                                      body: '${barang.stokKeluar}',
                                    ),
                                  ),
                                  const SizedBox(
                                    width: 12.0,
                                  ),
                                  Expanded(
                                    child: CardInfoBarangStokOpname(
                                      title: 'Stok akhir',
                                      body: '${barang.currentStock}',
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(
                                height: 12.0,
                              ),
                              Container(
                                padding: const EdgeInsets.all(12),
                                decoration: BoxDecoration(
                                  color: Colors.grey[50],
                                  borderRadius: BorderRadius.circular(8.0),
                                  border: Border.all(
                                      color: Colors.grey[300]!, width: 0.8),
                                ),
                                child: Row(
                                  children: [
                                    const Expanded(
                                      child: Text(
                                        'Stok opname',
                                        style: TextStyle(color: Colors.grey),
                                      ),
                                    ),
                                    Text(
                                      '${barang.stokAkhir}',
                                      style: const TextStyle(
                                          fontSize: 18.0,
                                          fontWeight: FontWeight.bold),
                                    )
                                  ],
                                ),
                              ),
                              const SizedBox(
                                height: 12.0,
                              ),
                              Row(
                                children: [
                                  Expanded(
                                    child: Form(
                                      key: _formKey[i],
                                      child: TextFormField(
                                        controller: _stok[i],
                                        decoration: InputDecoration(
                                          contentPadding:
                                              const EdgeInsets.symmetric(
                                                  horizontal: 12.0),
                                          hintText: 'Input stok opname',
                                          border: OutlineInputBorder(
                                            borderSide: BorderSide(
                                                color: Colors.grey[300]!),
                                          ),
                                          enabledBorder: OutlineInputBorder(
                                            borderSide: BorderSide(
                                                color: Colors.grey[300]!),
                                          ),
                                          hintStyle: TextStyle(
                                              color: Colors.grey[400]),
                                          suffixIcon: ElevatedButton(
                                            onPressed: () =>
                                                _simpanBarangStokOpname(
                                                    barang.id, i),
                                            style: ElevatedButton.styleFrom(
                                                backgroundColor: kPrimaryColor),
                                            child: const Text('Update'),
                                          ),
                                        ),
                                        validator: (value) {
                                          if (value!.isEmpty) {
                                            return 'Input required';
                                          }
                                          return null;
                                        },
                                        keyboardType: TextInputType.number,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        );
                      },
                      separatorBuilder: (context, i) => const SizedBox(
                        height: 18.0,
                      ),
                      itemCount: snapshot.data!.data!.data!.length,
                    ),
                  ),
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.symmetric(
                        horizontal: 22.0, vertical: 18),
                    decoration: const BoxDecoration(
                      color: Colors.white,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black12,
                          blurRadius: 4,
                          offset: Offset(0, -2.0),
                        )
                      ],
                    ),
                    child: SafeArea(
                      top: false,
                      child: widget.data!.isApproved == 1
                          ? ElevatedButton(
                              onPressed: () => _downloadPdf(widget.data!.file),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: kPrimaryColor,
                                minimumSize: const Size.fromHeight(45),
                              ),
                              child: const Text('Cetak Stok Opname'),
                            )
                          : Row(
                              children: [
                                Expanded(
                                  child: ElevatedButton(
                                    onPressed: _finalStok,
                                    style: ElevatedButton.styleFrom(
                                        minimumSize: const Size.fromHeight(45),
                                        backgroundColor: Colors.green),
                                    child: const Text('Final Stok'),
                                  ),
                                ),
                                const SizedBox(
                                  width: 12.0,
                                ),
                                Expanded(
                                  child: ElevatedButton(
                                    onPressed: _cetakPdfStok,
                                    style: ElevatedButton.styleFrom(
                                        minimumSize: const Size.fromHeight(45),
                                        backgroundColor: kPrimaryColor),
                                    child: const Text('Generate PDF'),
                                  ),
                                ),
                              ],
                            ),
                    ),
                  )
                ],
              );
          }
        }
        return const SizedBox();
      },
    );
  }

  Widget _streamSaveStokOpnameBaran(BuildContext context) {
    return StreamBuilder<ApiResponse<StokOpnameBarangSaveModel>>(
        stream: _stokOpnameBarangSaveBloc.stokOpnameBarangSaveStream,
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
                  onTap: () =>
                      Navigator.pop(context, snapshot.data!.data!.data),
                );
            }
          }
          return const SizedBox();
        });
  }

  Widget _streamCetakOpname(BuildContext context) {
    return StreamBuilder<ApiResponse<CetakStokOpnameModel>>(
        stream: _cetakStokOpnameBloc.cetakStokOpnameStream,
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
                  onTap: () =>
                      Navigator.pop(context, snapshot.data!.data!.data),
                );
            }
          }
          return const SizedBox();
        });
  }
}

class CardInfoBarangStokOpname extends StatelessWidget {
  const CardInfoBarangStokOpname({
    super.key,
    this.title,
    this.body,
  });

  final String? title;
  final String? body;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: Colors.grey[50],
        borderRadius: BorderRadius.circular(8.0),
        border: Border.all(color: Colors.grey[300]!, width: 0.8),
      ),
      child: Column(
        children: [
          Text(
            '$title',
            style: const TextStyle(fontSize: 12.0, color: Colors.grey),
          ),
          const SizedBox(
            height: 4.0,
          ),
          Text(
            '$body',
            style: const TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }
}
