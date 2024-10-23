import 'dart:async';
import 'dart:io';

import 'package:dokter_panggil/src/blocs/tindakan_edit_bloc.dart';
import 'package:dokter_panggil/src/blocs/tindakan_filter_bloc.dart';
import 'package:dokter_panggil/src/models/tindakan_edit_model.dart';
import 'package:dokter_panggil/src/models/tindakan_filter_model.dart';
import 'package:dokter_panggil/src/pages/components/confirm_dialog.dart';
import 'package:dokter_panggil/src/pages/components/detail_tindakan.dart';
import 'package:dokter_panggil/src/pages/components/error_response.dart';
import 'package:dokter_panggil/src/pages/components/error_dialog.dart';
import 'package:dokter_panggil/src/pages/components/loading_kit.dart';
import 'package:dokter_panggil/src/pages/components/search_input_form.dart';
import 'package:dokter_panggil/src/pages/components/success_dialog.dart';
import 'package:dokter_panggil/src/repositories/responseApi/api_response.dart';
import 'package:dokter_panggil/src/source/config.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:dokter_panggil/src/source/transition/animated_dialog.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl/intl.dart';

class LayananPecarianPage extends StatefulWidget {
  const LayananPecarianPage({Key? key}) : super(key: key);

  @override
  State<LayananPecarianPage> createState() => _LayananPecarianPageState();
}

class _LayananPecarianPageState extends State<LayananPecarianPage> {
  final TindakanFilterBloc _tindakanFilterBloc = TindakanFilterBloc();
  final _filterCon = TextEditingController();
  final _filterFocus = FocusNode();
  bool _isStream = false;
  bool _show = false;
  int? _id;
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _getFilter();
    _filterCon.addListener(_inputListener);
  }

  void _getFilter() {
    _tindakanFilterBloc.tindakanFilter();
  }

  void _inputListener() {
    _timer?.cancel();
    if (_filterCon.text.isNotEmpty) {
      _timer = Timer.periodic(const Duration(milliseconds: 500), (timer) {
        _tindakanFilterBloc.filterSink.add(_filterCon.text);
        _tindakanFilterBloc.tindakanFilter();
        setState(() {
          _isStream = true;
          _show = false;
        });
        _timer!.cancel();
      });
    } else {
      _filterCon.clear();
      _tindakanFilterBloc.filterSink.add(_filterCon.text);
      _getFilter();
      setState(() {
        _isStream = false;
        _show = false;
      });
    }
  }

  @override
  void dispose() {
    _filterCon.dispose();
    _filterFocus.dispose();
    _tindakanFilterBloc.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: const SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarBrightness: Brightness.light,
        statusBarIconBrightness: Brightness.dark,
        systemNavigationBarColor: Colors.white,
      ),
      child: Scaffold(
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: EdgeInsets.only(
                left: 2.0,
                right: 32.0,
                top: MediaQuery.of(context).padding.top + 18,
              ),
              child: Row(
                children: [
                  if (Platform.isAndroid)
                    IconButton(
                      onPressed: () => Navigator.pop(context),
                      icon: Icon(
                        Icons.arrow_back,
                        color: Colors.grey[600],
                      ),
                    )
                  else
                    IconButton(
                      onPressed: () => Navigator.pop(context),
                      icon: Icon(
                        Icons.arrow_back_ios,
                        color: Colors.grey[600],
                      ),
                    ),
                  const SizedBox(
                    width: 4.0,
                  ),
                  Expanded(
                    child: SearchInputForm(
                      controller: _filterCon,
                      focusNode: _filterFocus,
                      hint: 'Pencarian tindakan',
                      autofocus: true,
                      suffixIcon: _isStream
                          ? InkWell(
                              onTap: () {
                                _filterFocus.requestFocus(FocusNode());
                                _filterCon.clear();
                                setState(() {
                                  _isStream = false;
                                });
                              },
                              child: FaIcon(
                                FontAwesomeIcons.circleXmark,
                                size: 20,
                                color: Colors.grey[600],
                              ),
                            )
                          : null,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(
              height: 22.0,
            ),
            Expanded(
              child: _buildStreamFilter(),
            )
          ],
        ),
      ),
    );
  }

  Widget _buildStreamFilter() {
    if (_show) {
      return StreamEditTindakan(
        id: _id!,
        close: () {
          _filterCon.clear();
          _tindakanFilterBloc.filterSink.add(_filterCon.text);
          _getFilter();
          setState(() {
            _show = false;
            _isStream = false;
          });
        },
      );
    }
    return StreamBuilder<ApiResponse<ResponseTindakanFilterModel>>(
      stream: _tindakanFilterBloc.tindakanFilterStream,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          switch (snapshot.data!.status) {
            case Status.loading:
              return const Center(
                child: CircleAvatar(
                  radius: 22.0,
                  backgroundColor: Colors.transparent,
                  child: CircularProgressIndicator(),
                ),
              );
            case Status.error:
              return Center(
                child: Text(
                  snapshot.data!.message,
                  style: const TextStyle(
                    color: Colors.grey,
                  ),
                  textAlign: TextAlign.center,
                ),
              );
            case Status.completed:
              return ListView.builder(
                padding: const EdgeInsets.symmetric(horizontal: 12.0),
                itemCount: snapshot.data!.data!.tindakan!.length,
                itemBuilder: (context, i) {
                  var data = snapshot.data!.data!.tindakan![i];
                  return ListTile(
                    onTap: () {
                      FocusScope.of(context).requestFocus(FocusNode());
                      setState(() {
                        _show = true;
                        _id = data.id;
                      });
                    },
                    leading: const Icon(Icons.search),
                    title: Text('${data.namaTindakan}'),
                  );
                },
              );
          }
        }
        return const SizedBox();
      },
    );
  }
}

class StreamEditTindakan extends StatefulWidget {
  const StreamEditTindakan({
    Key? key,
    required this.id,
    this.close,
  }) : super(key: key);

  final int id;
  final VoidCallback? close;

  @override
  State<StreamEditTindakan> createState() => _StreamEditTindakanState();
}

class _StreamEditTindakanState extends State<StreamEditTindakan> {
  final TindakanEditBloc _tindakanEditBloc = TindakanEditBloc();
  final NumberFormat _rupiah =
      NumberFormat.currency(symbol: 'Rp. ', decimalDigits: 0, locale: 'id');

  @override
  void initState() {
    super.initState();
    _tindakanEditBloc.idSink.add(widget.id);
    _tindakanEditBloc.editTindakan();
  }

  void _hapus() {
    showAnimatedDialog(
      context: context,
      builder: (context) {
        return ConfirmDialogWidget(
          message: 'Anda yakin ingin menghapus data ini?',
          onConfirm: () => Navigator.pop(context, 'delete'),
        );
      },
      animationType: DialogTransitionType.slideFromBottomFade,
      duration: const Duration(milliseconds: 300),
    ).then((value) {
      if (value != null) {
        _tindakanEditBloc.deleteTindakan();
        Future.delayed(const Duration(milliseconds: 500), () {
          _showStreamDelete();
        });
      }
    });
  }

  void _showStreamDelete() {
    showAnimatedDialog(
      context: context,
      builder: (context) {
        return _buildStreamDelete(context);
      },
      animationType: DialogTransitionType.slideFromBottomFade,
      duration: const Duration(milliseconds: 500),
    ).then((value) {
      if (value != null) {
        Future.delayed(const Duration(milliseconds: 500), widget.close);
      }
    });
  }

  @override
  void dispose() {
    _tindakanEditBloc.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<ApiResponse<TindakanEditModel>>(
      stream: _tindakanEditBloc.tindakanEditStream,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          switch (snapshot.data!.status) {
            case Status.loading:
              return const Center(
                child: LoadingKit(
                  color: kPrimaryColor,
                ),
              );
            case Status.error:
              return ErrorResponse(
                message: snapshot.data!.message,
              );
            case Status.completed:
              return _tindakanEdit(snapshot.data!.data!.tindakan);
          }
        }
        return const SizedBox();
      },
    );
  }

  Widget _tindakanEdit(Tindakan? tindakan) {
    return ListView(
      padding: const EdgeInsets.symmetric(horizontal: 32.0, vertical: 12.0),
      children: [
        const Text(
          'Detail Tindakan',
          style: TextStyle(fontSize: 28.0, fontWeight: FontWeight.w600),
        ),
        const SizedBox(
          height: 42.0,
        ),
        DetailTindakan(
          title: 'Nama tindakan',
          subtitle: Text(
            '${tindakan!.namaTindakan}',
            style: const TextStyle(fontSize: 16.0),
          ),
        ),
        const SizedBox(
          height: 22.0,
        ),
        DetailTindakan(
          title: 'Tarif',
          subtitle: Text(
            _rupiah.format(tindakan.tarif),
            style: const TextStyle(fontSize: 16.0),
          ),
        ),
        const SizedBox(
          height: 22.0,
        ),
        DetailTindakan(
          title: 'Jasa dokter',
          subtitle: Text(
            _rupiah.format(tindakan.jasaDokter),
            style: const TextStyle(fontSize: 16.0),
          ),
        ),
        const SizedBox(
          height: 22.0,
        ),
        DetailTindakan(
          title: 'Jasa aplikasi',
          subtitle: Text(
            _rupiah.format(tindakan.jasaDokterPanggil),
            style: const TextStyle(fontSize: 16.0),
          ),
        ),
        const SizedBox(
          height: 22.0,
        ),
        DetailTindakan(
          title: 'Group tindakan',
          subtitle: tindakan.groupJabatan != null
              ? Text(
                  '${tindakan.groupJabatan}',
                  style: const TextStyle(fontSize: 16.0),
                )
              : const Text('-', style: TextStyle(fontSize: 16.0)),
        ),
        const SizedBox(
          height: 22.0,
        ),
        DetailTindakan(
          title: 'Pendukung tindakan',
          subtitle: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Wrap(
                crossAxisAlignment: WrapCrossAlignment.center,
                spacing: 12.0,
                children: [
                  if (tindakan.bayarLangsung == 1)
                    Icon(
                      Icons.check_rounded,
                      color: Colors.green[600],
                    )
                  else
                    const Icon(
                      Icons.close,
                      color: Colors.red,
                    ),
                  const Text(
                    'Bayar langsung',
                    style: TextStyle(fontSize: 16.0),
                  ),
                ],
              ),
              Wrap(
                crossAxisAlignment: WrapCrossAlignment.center,
                spacing: 12.0,
                children: [
                  if (tindakan.transportasi == 1)
                    Icon(
                      Icons.check_rounded,
                      color: Colors.green[600],
                    )
                  else
                    const Icon(
                      Icons.close,
                      color: Colors.red,
                    ),
                  const Text(
                    'Biaya transportasi',
                    style: TextStyle(fontSize: 16.0),
                  ),
                ],
              ),
              Wrap(
                crossAxisAlignment: WrapCrossAlignment.center,
                spacing: 12.0,
                children: [
                  if (tindakan.gojek == 1)
                    Icon(
                      Icons.check_rounded,
                      color: Colors.green[600],
                    )
                  else
                    const Icon(
                      Icons.close,
                      color: Colors.red,
                    ),
                  const Text(
                    'Biaya gojek',
                    style: TextStyle(fontSize: 16.0),
                  ),
                ],
              )
            ],
          ),
        ),
        const SizedBox(
          height: 62.0,
        ),
        Row(
          children: [
            Expanded(
              child: ElevatedButton.icon(
                onPressed: _hapus,
                icon: const Icon(Icons.delete_rounded),
                style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.red,
                    minimumSize: const Size.fromHeight(45)),
                label: const Text(
                  'Hapus',
                ),
              ),
            ),
            const SizedBox(
              width: 12.0,
            ),
            Expanded(
              child: ElevatedButton.icon(
                onPressed: () => Navigator.pop(context, tindakan),
                icon: const Icon(Icons.edit_note_rounded),
                style: ElevatedButton.styleFrom(
                  minimumSize: const Size.fromHeight(45),
                  backgroundColor: Colors.blue,
                ),
                label: const Text(
                  'Edit',
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildStreamDelete(BuildContext context) {
    return StreamBuilder<ApiResponse<TindakanEditModel>>(
        stream: _tindakanEditBloc.tindakanEditStream,
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
                  onTap: () => Navigator.pop(context, 'sukses'),
                );
            }
          }
          return const SizedBox();
        });
  }
}
